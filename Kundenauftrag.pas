unit Kundenauftrag;

interface

uses Vcl.Forms, System.SysUtils, System.Classes, System.Generics.Collections,
  KundenauftragsPos, Stueckliste, StuecklistenPosition, DBZugriff,Logger ;

type
  TZKundenauftrag = class(TZStueliPos)
  private
  protected
    { protected declarations }
  public
    ka_id: String;
    komm_nr: String;
    kunden_id: Integer;
    constructor Create(new_ka_id: String);
    procedure liesKopfundPositionen;
    procedure holeKinder;
    procedure auswerten;
  end;

implementation

constructor TZKundenauftrag.Create(new_ka_id: String);
begin
  inherited Create('KA');
  ka_id := new_ka_id;
end;

procedure TZKundenauftrag.auswerten();
begin
  mainFrm.Log.Log('Starte Auswertung fuer: ' + ka_id);
  TZStueliPos.InitTextFile(string(ka_id));
  liesKopfundPositionen;
  holeKinder;
  ToTextFile;
  Log.Log('Auswertung fuer: ' + ka_id + ' beendet.');
end;

procedure TZKundenauftrag.liesKopfundPositionen();

var
  gefunden: Boolean;
  Rabatt: Double;
  KAPos: TZKundenauftragsPos;
  KAQry, RabattQry: TZQry;

begin

  // Abfrage zum Lesen des Kundenauftrags und seiner Positionen
  KAQry := DBConn.getQuery;
  gefunden := KAQry.SucheKundenAuftragspositionen(ka_id);
  if not gefunden then
    raise Exception.Create('KA '+ka_id + ' nicht gefunden.');
  Rabatt:=0;

  if gefunden then
  begin
    // Daten aus dem Auftragskopf
    komm_nr := trim(KAQry.FieldByName('klassifiz').AsString);
    kunden_id := KAQry.FieldByName('kunde').AsInteger;

    // Abfrage des Rabattes zu diesem Kunden
    RabattQry := DBConn.getQuery;
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
    //KundenauftragsPos erzeugen; übertrage relevante Daten aus Qry in Felder
    KAPos := TZKundenauftragsPos.Create(KAQry, Rabatt);
    Log.Log('--------- KA-Pos -----------');
    Log.Log(KAPos.ToStr);

    //neue Pos in Stückliste aufnehmen
    Stueli.Add(KAPos.PosData['pos_nr'], KAPos);
    KAQry.next;
  end;

end;


//Schrittweise Suche aller untergeordneten Elemente
procedure TZKundenauftrag.holeKinder();
{Bei jedem Schritt werden alle Knoten, fuer die in der bisherigen Suche
 noch keine Kinder gefunden wurden, in der Liste EndKnoten abgelegt,
 sofern es keine Kaufteile sind.
 Im naechsten Schritt werden, dann Kinder fuer die Knoten aus EndKnoten gesucht
 Die Suche wird so lange wiederholt, bis EndKnoten leer bleibt.
 Die untersten Knoten müssen dann alle Kaufteil sein.
}
var StueliPos: TZStueliPos;
var StueliPosKey: String;
var keyArray: System.TArray<System.string>;
var KaPos: TZKundenauftragsPos;
var alteEndKnotenListe: TZEndKnotenListe;
var EndKnoten: TZValue;
var txt:String;

begin
  //Schritt 1 nur ueber Kommissions-FA suchen. Diese haben Prio 1.
  //Fuer alle Pos, die kein Kaufteil sind, rekursiv in der UNIPPS-Tabelle ASTUELIPOS nach Kindern suchen
  //Alle Kinder, die in ASTUELIPOS selbst keine Kinder mehr haben werden in der Liste EndKnoten vermerkt
  //---------------------------------------------------------------------------------------------

  //Liste fuer "Kinderlose" erzeugen:
  EndKnotenListe:=TZEndKnotenListe.Create;
  alteEndKnotenListe:=TZEndKnotenListe.Create;

  //Unsortierte Zugriffs-Keys in sortiertes Array wandeln
  keyArray:=Stueli.Keys.ToArray;
  TArray.Sort<String>(keyArray);

  //Loop über alle Pos des Kundenauftrages
  for StueliPosKey in keyArray do
  begin
    KaPos:= Stueli[StueliPosKey].AsType<TZKundenauftragsPos>;

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
    //Bisherige Endknoten müssten Serien- und Fremd-Fertigungsteile sein
    for EndKnoten in alteEndKnotenListe do
    begin
      StueliPos:= EndKnoten.AsType<TZStueliPos>;
      Log.Log('------Suche fuer Endknoten ----------');
      txt:=StueliPos.ToStr;
      Log.Log(txt);
      StueliPos.holeKindervonEndKnoten;
    end;

  end;


end;


end.
