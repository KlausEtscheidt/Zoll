unit Kundenauftrag;

interface

uses Vcl.Forms, Vcl.Dialogs, System.SysUtils, System.Classes,
        System.Generics.Collections, System.TimeSpan, Windows,
        KundenauftragsPos, Stueckliste, UnippsStueliPos, Tools;

type
  TWKundenauftrag = class(TWUniStueliPos)
  private
    procedure CSV_volle_Ausgabe();
    procedure CSV_kurze_Ausgabe();
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

constructor TWKundenauftrag.Create(new_ka_id: String);
begin
  inherited Create('KA');
  ka_id := new_ka_id;
end;

procedure TWKundenauftrag.auswerten();
var
  startzeit,zzeit,endzeit: Int64;
  delta:Double;
  msg:String;

begin
  startzeit:= GetTickCount;
  Tools.Log.Log('Starte Auswertung fuer: ' + ka_id +
              ' um ' + DateTimeToStr(startzeit));
  liesKopfundPositionen;
  holeKinder;
  CSV_volle_Ausgabe;


  endzeit:=  GetTickCount;
  delta:=TTimeSpan.FromTicks(endzeit-startzeit).TotalMilliSeconds;
  msg:=Format('Auswertung fuer KA %s in %4.3f mSek beendet.',[ka_id, delta]);
  ShowMessage(msg);

  Tools.Log.Log(msg);

end;

procedure TWKundenauftrag.CSV_kurze_Ausgabe();
const trenn = ' ; ' ;
  meineFelder: TWFilter = ['id_stu','pos_nr','t_tg_nr','Bezeichnung'];
begin
  Tools.CSVKurz.OpenNew(Tools.LogDir, ka_id + '_Kalk.txt');
  ToTextFile(Tools.CSVKurz, meineFelder);
  Tools.CSVLang.Close;
end;

procedure TWKundenauftrag.CSV_volle_Ausgabe();
const trenn = ' ; ' ;
  meineFelder: TWFilter = ['id_stu','pos_nr','PosTyp','t_tg_nr','Bezeichnung'];
begin
  Tools.CSVLang.OpenNew(Tools.LogDir, ka_id + '_Struktur.txt');
  ToTextFile(Tools.CSVLang, meineFelder);
  Tools.CSVLang.Close;
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
    raise Exception.Create('KA '+ka_id + ' nicht gefunden.');
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
    KAPos := TWKundenauftragsPos.Create(KAQry, Rabatt);
    Tools.Log.Log('--------- KA-Pos -----------');
    Tools.Log.Log(KAPos.ToStr);

    //neue Pos in St�ckliste aufnehmen
    Stueli.Add(KAPos.PosData['pos_nr'], KAPos);
    var kaposhatteil,stuposhattteil:boolean;
    var stupos:TWStueliPos;
    kaposhatteil:=KAPos.hatTeil;
    stupos:=Stueli[KAPos.PosData['pos_nr']].AsType<TWStueliPos>;
    stuposhattteil:=stupos.hatTeil;
    KAQry.next;
  end;

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
var StueliPosKey: String;
var keyArray: System.TArray<System.string>;
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
  keyArray:=Stueli.Keys.ToArray;
  TArray.Sort<String>(keyArray);

  //Loop �ber alle Pos des Kundenauftrages
  for StueliPosKey in keyArray do
  begin
    KaPos:= Stueli[StueliPosKey].AsType<TWKundenauftragsPos>;

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


end;


end.
