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
  //Top-Knoten hat keine IdStu,IdPos=1;Menge=1.
  inherited Create(nil, 'KA','',1,1);
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
  SetzeEbenen(0);
  CSV_volle_Ausgabe;
  CSV_kurze_Ausgabe;


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
  meineFelder: TWFilter = ['EbeneNice','PosTyp', 'id_stu','FA_Nr',
      'id_pos','ueb_s_nr','ds', 'pos_nr','verurs_art', 't_tg_nr',
      'oa','Bezeichnung', 'unipps_typ','besch_art',
      'urspr_land', 'ausl_u_land', 'praeferenzkennung','menge', 'sme',
      'faktlme_sme', 'lme'];
      {T_lme ; Ebene ; ds ; t_tg_nr ; set_block ; typ ; id_pos ; T_oa ;
      ueb_s_nr ; EbeneNice ; pos_nr ; oa ; T_unipps_typ ; T_faktlme_sme ;
       T_praeferenzkennung ; Bezeichnung ; PosTyp ; T_besch_art ;
        T_t_tg_nr ; id_stu ; T_sme ;
        EbeneNice ; pos_nr ; FA_Nr ; oa ; t_tg_nr ; verurs_art ;
        PosTyp ; menge ; id_stu ;
excel
        Ebene	Typ	zu Teil	FA	id_pos	ueb_s_nr	ds	pos_nr
        	verurs_art	t_tg_nr	oa	Bezchng	typ	v_besch_art
          urspr_land	ausl_u_land	praeferenzkennung	menge	sme
          faktlme_sme	lme	bestell_id	bestell_datum	preis	basis	pme	bme
          	faktlme_bme	faktbme_pme	id_lief	lieferant	pos_menge	preis_eu
            	preis_n_eu	Summe_Eu	Summe_n_EU	LP je Stück	KT_zu_LP

         }
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
    KAPos := TWKundenauftragsPos.Create(Self, KAQry, Rabatt);
    Tools.Log.Log('--------- KA-Pos -----------');
    Tools.Log.Log(KAPos.ToStr);

    //neue Pos in St�ckliste aufnehmen
//    Stueli.Add(KAPos.PosData['pos_nr'], KAPos);
    Stueli.Add(KAPos.KaPosIdPos, KAPos);
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
var StueliPosKey: Integer;
var keyArray: System.TArray<Integer>;
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
  TArray.Sort<Integer>(keyArray);

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
