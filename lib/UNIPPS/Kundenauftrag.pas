unit Kundenauftrag;

interface

uses Vcl.Forms, Vcl.Dialogs, System.SysUtils, System.Classes,
        System.Generics.Collections, System.TimeSpan, Windows,
        KundenauftragsPos, Stueckliste, Bestellung,
        PumpenDataSet, UnippsStueliPos, Tools, Datenmodul;

type
  TWKundenauftrag = class(TWUniStueliPos)
  private
  public
    ka_id: String;
    komm_nr: String;
    kunden_id: Integer;
    constructor Create(new_ka_id: String);
    procedure liesKopfundPositionen;
    procedure holeKinder;
    procedure SammleAusgabeDaten;
  end;

implementation

constructor TWKundenauftrag.Create(new_ka_id: String);
begin
  //Top-Knoten hat keine IdStu,IdPos=1;Menge=1.
  inherited Create(nil, 'KA','',1,1);
  ka_id := new_ka_id;
end;

procedure TWKundenauftrag.SammleAusgabeDaten;
begin

  //Erst mal leeren
  KaDataModule.ErgebnisDS.EmptyDataSet;

  //Oeffnen
  KaDataModule.ErgebnisDS.Active:=True;

  //Sammle rekursiv alle Daten ein
  StrukturInErgebnisTabelle(KaDataModule.ErgebnisDS, True);

end;

procedure TWKundenauftrag.liesKopfundPositionen();

var
  gefunden: Boolean;
  Rabatt: Double;
  KAPos: TWKundenauftragsPos;
  KAQry, RabattQry: TWUNIPPSQry;

begin

  // Abfrage zum Lesen des Kundenauftrags und seiner Positionen
  KAQry := Tools.getQuery;
  gefunden := KAQry.SucheKundenAuftragspositionen(ka_id);

  if not gefunden then
    raise Exception.Create('Keine Positionen zu KA '+ka_id + ' gefunden.');

  // Daten aus dem Auftragskopf
  komm_nr := trim(KAQry.FieldByName('klassifiz').AsString);
  kunden_id := KAQry.FieldByName('kunde').AsInteger;

  // Abfrage des Rabattes zu diesem Kunden
  // SQL muss mit Datum aus allen Rabatten den gueltigen filtern
  RabattQry := Tools.getQuery;
  RabattQry.SucheKundenRabatt(inttostr(kunden_id));

  //Sollte nie vorkommen, wenn Abfrage stimmt => Abbruch
  if RabattQry.n_records > 1 then
    raise Exception.Create('Fuer Kunden-Id ' + IntToStr(kunden_id) +
                         ' wurde mehr als ein Rabatt gefunden.');

  Rabatt:=0;
  if RabattQry.n_records = 1 then
    Rabatt := RabattQry.FieldByName('zu_ab_proz').AsFloat / 100;


  //Positionen beabeiten
  while not KAQry.Eof do
  begin
    //KundenauftragsPos erzeugen; �bertrage relevante Daten aus Qry in Felder
    KAPos := TWKundenauftragsPos.Create(Self, KAQry, Rabatt);
    Tools.Log.Log('--------- KA-Pos -----------');
    Tools.Log.Log(KAPos.ToStr);

    //neue Pos in St�ckliste aufnehmen
//    Stueli.Add(KAPos.PosData['pos_nr'], KAPos);
//    Stueli.Add(KAPos.KaPosIdPos, KAPos);
    StueliAdd(KAPos);
    KAQry.next;
  end;
  KAQry.Free;
end;


//Schrittweise Suche aller untergeordneten Elemente
procedure TWKundenauftrag.holeKinder();
{Bei jedem Schritt werden alle Knoten, fuer die in der bisherigen Suche
 noch keine Kinder gefunden wurden, in der Liste EndKnoten abgelegt,
 sofern es keine Kaufteile sind.
 Im naechsten Schritt werden, dann Kinder fuer die Knoten aus EndKnoten gesucht
 Die Suche wird so lange wiederholt, bis EndKnoten leer bleibt.
 Die untersten Knoten m�ssen dann alle Kaufteil sein.
}
var StueliPos: TWUniStueliPos;
var StueliPosKey: Integer;
//var keyArray: System.TArray<Integer>;
var KaPos: TWKundenauftragsPos;
var alteEndKnotenListe: TWEndKnotenListe;
var EndKnoten: TWValue;
var txt:String;

begin
  //Schritt 1 nur ueber Kommissions-FA suchen. Diese haben Prio 1.
  //Fuer alle Pos, die kein Kaufteil sind, rekursiv in der UNIPPS-Tabelle ASTUELIPOS nach Kindern suchen
  //Alle Kinder, die in ASTUELIPOS selbst keine Kinder mehr haben werden in der Liste EndKnoten vermerkt
  //---------------------------------------------------------------------------------------------

  //Liste fuer "Kinderlose" erzeugen:
  EndKnotenListe:=TWEndKnotenListe.Create;
  alteEndKnotenListe:=TWEndKnotenListe.Create;

  //Unsortierte Zugriffs-Keys in sortiertes Array wandeln
//    keyArray:=Stueli.Keys.ToArray;
//    TArray.Sort<Integer>(keyArray);

  //Loop �ber alle Pos des Kundenauftrages
  for StueliPosKey in StueliKeys do
  begin
//      KaPos:= Stueli[StueliPosKey].AsType<TWKundenauftragsPos>;
    KaPos:= Stueli[StueliPosKey] As TWKundenauftragsPos;

    //Fuer Kaufteile muss nicht weiter gesucht werden
    if not KaPos.Teil.istKaufteil then
      //Falls ein Komm-Fa zur Pos vorhanden, werden dessen Kinder aus
      //Unipps-Tabelle ASTUELIPOS geholt
      //Falls kein Komm-Fa zur Pos vorhanden, landet der Knoten in EndKnoten
      KaPos.holeKinderAusASTUELIPOS;

  end;


  // Weitere Schritte wiederholen, bis EndKnoten leer
  //-----------------------------------------------------------------

  while EndKnotenListe.Count>0 do
  begin
    //Liste kopieren und leeren
    alteEndKnotenListe.Clear;
    alteEndKnotenListe.AddRange(EndKnotenListe);
    EndKnotenListe.Clear;
    txt:=alteEndKnotenListe.ToStr();
    Tools.Log.Log(txt);

    //Suche weiter
    //Bisherige Endknoten m�ssten Serien- und Fremd-Fertigungsteile sein
    for EndKnoten in alteEndKnotenListe do
    begin
      StueliPos:= EndKnoten.AsType<TWUniStueliPos>;
      Tools.Log.Log('------Suche fuer Endknoten ----------');
      txt:=StueliPos.ToStr;
      Tools.Log.Log(txt);
      StueliPos.holeKindervonEndKnoten;
    end;

  end;

  EndKnotenListe.Free;
  alteEndKnotenListe.Free;

end;


end.
