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
    procedure auswerten;
    procedure liesKopfundPositionen;
    procedure holeKinder;
    procedure SammleAusgabeDaten;
    procedure Ausgabe;
  end;

implementation

uses main;

constructor TWKundenauftrag.Create(new_ka_id: String);
begin
  //Top-Knoten hat keine IdStu,IdPos=1;Menge=1.
  inherited Create(nil, 'KA','',1,1);
  ka_id := new_ka_id;
end;

procedure TWKundenauftrag.auswerten();
var
  startzeit,endzeit: Int64;
  delta:Double;
  msg:String;

begin
  startzeit:= GetTickCount;
  Tools.Log.Log('Starte Auswertung fuer: ' + ka_id +
              ' um ' + DateTimeToStr(startzeit));
  liesKopfundPositionen;
  holeKinder;
  SetzeEbenenUndMengen(0,1);
  SummierePreise;

  SammleAusgabeDaten;
  Ausgabe;

  endzeit:=  GetTickCount;
  delta:=TTimeSpan.FromTicks(endzeit-startzeit).TotalMilliSeconds;
  msg:=Format('Auswertung fuer KA %s in %4.3f mSek beendet.',[ka_id, delta]);
  ShowMessage(msg);

  Tools.Log.Log(msg);

end;


procedure TWKundenauftrag.SammleAusgabeDaten;
begin
  //Einmalig DataSet fuer Gesamtausgabe mit allen Feldern
  //der Stücklistenpos, der Teile und der Bestellungen definieren
  KaDataModule.DefiniereGesamtErgebnisTabelle;

  //Sammle rekursiv alle Daten ein
  InGesamtTabelle(KaDataModule.ErgebnisDS, True);

  if Tools.GuiMode then
  begin
    mainfrm.langBtn.Enabled:=True;
    mainfrm.langBtn.Enabled:=True;
  end;

end;

procedure TWKundenauftrag.Ausgabe;
begin
  //Fülle Tabelle mit vollem Umfang (z Debuggen)
  KaDataModule.ErzeugeAusgabeVollFuerDebug;
  //Ausgabe als CSV
  KaDataModule.AusgabeAlsCSV(Tools.LogDir+ '\'+ka_id + '_Struktur.csv');

  //Fülle Tabelle mit Teilumfang zur Ausgabe der Doku der Kalkulation
  KaDataModule.ErzeugeAusgabeKurzFuerDoku;
  //Ausgabe als CSV
  KaDataModule.AusgabeAlsCSV(Tools.LogDir+ '\'+ka_id + '_Kalk.csv');

  //Daten anzeigen
  if Tools.GuiMode then
    mainfrm.DataSource1.DataSet:=KaDataModule.AusgabeDS;

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
  Rabatt:=0;

  if gefunden then
  begin
    // Daten aus dem Auftragskopf
    komm_nr := trim(KAQry.FieldByName('klassifiz').AsString);
    kunden_id := KAQry.FieldByName('kunde').AsInteger;

    // Abfrage des Rabattes zu diesem Kunden
    RabattQry := Tools.getQuery;
    RabattQry.SucheKundenRabatt(inttostr(kunden_id));
    { TODO :
      Else-Zweig bearbeiten
      SQL muss auf aktuelles Datum filtern }
    if RabattQry.n_records = 1 then
      Rabatt := RabattQry.FieldByName('zu_ab_proz').AsFloat / 100
    else
      Rabatt := 0;
  end;

  //Positionen beabeiten
  while not KAQry.Eof do
  begin
    //KundenauftragsPos erzeugen; �bertrage relevante Daten aus Qry in Felder
    KAPos := TWKundenauftragsPos.Create(Self, KAQry, Rabatt);
    Tools.Log.Log('--------- KA-Pos -----------');
    Tools.Log.Log(KAPos.ToStr);

    //neue Pos in St�ckliste aufnehmen
//    Stueli.Add(KAPos.PosData['pos_nr'], KAPos);
    Stueli.Add(KAPos.KaPosIdPos, KAPos);
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
  for StueliPosKey in SortedKeys do
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
    alteEndKnotenListe.WriteToLog;

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
