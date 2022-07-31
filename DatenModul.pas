unit DatenModul;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient,
  FireDAC.Comp.BatchMove.DataSet, FireDAC.Stan.Intf, FireDAC.Comp.BatchMove,
  FireDAC.Comp.BatchMove.Text,
  PumpenDataSet;

type
  TKaDataModule = class(TDataModule)
    StueliPosDS: TWDataSet;
    StueliPosDSid_stu: TStringField;
    StueliPosDSpos_nr: TIntegerField;
    StueliPosDSoa: TIntegerField;
    StueliPosDSbesch_art: TIntegerField;
    StueliPosDSmenge: TFloatField;
    StueliPosDSFA_Nr: TStringField;
    StueliPosDSid_pos: TIntegerField;
    StueliPosDSverurs_art: TIntegerField;
    StueliPosDSueb_s_nr: TIntegerField;
    StueliPosDSds: TIntegerField;
    StueliPosDSset_block: TIntegerField;
    StueliPosDSPosTyp: TStringField;
    TeilDS: TWDataSet;
    BestellungDS: TWDataSet;
    BestellungDSbestell_id: TIntegerField;
    BestellungDSbestell_datum: TDateTimeField;
    StueliPosDSstu_t_tg_nr: TStringField;
    StueliPosDSunipps_typ: TStringField;
    TeilDSBezeichnung: TStringField;
    TeilDSPreisJeLME: TFloatField;
    BestellungDSbest_t_tg_nr: TStringField;
    StueliPosDSPreisEU: TFloatField;
    StueliPosDSPreisNonEU: TFloatField;
    StueliPosDSSummeEU: TFloatField;
    StueliPosDSSummeNonEU: TFloatField;
    BestellungDSbasis: TFloatField;
    BestellungDSpme: TIntegerField;
    BestellungDSbme: TIntegerField;
    BestellungDSfaktlme_bme: TFloatField;
    BestellungDSfaktbme_pme: TFloatField;
    BestellungDSnetto_poswert: TFloatField;
    BestellungDSwe_menge: TFloatField;
    BestellungDSlieferant: TIntegerField;
    BestellungDSkurzname: TStringField;
    BestellungDSbest_menge: TFloatField;
    StueliPosDSvk_netto: TFloatField;
    StueliPosDSvk_brutto: TFloatField;
    StueliPosDSMengeTotal: TFloatField;
    StueliPosDSEbene: TIntegerField;
    StueliPosDSEbeneNice: TStringField;
    BatchMoveTextWriter: TFDBatchMoveTextWriter;
    BatchMoveDSReader: TFDBatchMoveDataSetReader;
    BatchMove: TFDBatchMove;
    BatchMoveDSWriter: TFDBatchMoveDataSetWriter;
    ErgebnisDS: TWDataSet;
    AusgabeDS: TWDataSet;
    ErgebnisDSid_stu: TStringField;
    ErgebnisDSpos_nr: TIntegerField;
    ErgebnisDSstu_t_tg_nr: TStringField;
    ErgebnisDSstu_oa: TIntegerField;
    ErgebnisDSstu_unipps_typ: TStringField;
    ErgebnisDSid_pos: TIntegerField;
    ErgebnisDSbesch_art: TIntegerField;
    ErgebnisDSmenge: TFloatField;
    ErgebnisDSFA_Nr: TStringField;
    ErgebnisDSverurs_art: TIntegerField;
    ErgebnisDSueb_s_nr: TIntegerField;
    ErgebnisDSds: TIntegerField;
    ErgebnisDSset_block: TIntegerField;
    ErgebnisDSPosTyp: TStringField;
    ErgebnisDSPreisEU: TFloatField;
    ErgebnisDSPreisNonEU: TFloatField;
    ErgebnisDSSummeEU: TFloatField;
    ErgebnisDSSummeNonEU: TFloatField;
    ErgebnisDSvk_netto: TFloatField;
    ErgebnisDSvk_brutto: TFloatField;
    ErgebnisDSMengeTotal: TFloatField;
    ErgebnisDSEbene: TIntegerField;
    ErgebnisDSEbeneNice: TStringField;
    ErgebnisDSt_tg_nr: TStringField;
    ErgebnisDSoa: TIntegerField;
    ErgebnisDSunipps_typ: TStringField;
    ErgebnisDSBezeichnung: TStringField;
    ErgebnisDSv_besch_art: TIntegerField;
    ErgebnisDSpraeferenzkennung: TIntegerField;
    ErgebnisDSsme: TIntegerField;
    ErgebnisDSfaktlme_sme: TFloatField;
    ErgebnisDSlme: TIntegerField;
    ErgebnisDSPreisJeLME: TFloatField;
    ErgebnisDSpreis: TFloatField;
    ErgebnisDSbestell_id: TIntegerField;
    ErgebnisDSbestell_datum: TDateTimeField;
    ErgebnisDSbest_t_tg_nr: TStringField;
    ErgebnisDSbasis: TFloatField;
    ErgebnisDSpme: TIntegerField;
    ErgebnisDSbme: TIntegerField;
    ErgebnisDSfaktlme_bme: TFloatField;
    ErgebnisDSfaktbme_pme: TFloatField;
    ErgebnisDSnetto_poswert: TFloatField;
    ErgebnisDSwe_menge: TFloatField;
    ErgebnisDSlieferant: TIntegerField;
    ErgebnisDSkurzname: TStringField;
    ErgebnisDSbest_menge: TFloatField;
    procedure DataModuleCreate(Sender: TObject);
    procedure StueliPosDSstu_t_tg_nrChange(Sender: TField);
  private
    { Private-Deklarationen }
    procedure BefuelleAusgabeTabelle;

  public
    procedure DefiniereGesamtErgebnisTabelle;
    procedure ErzeugeAusgabeKurzFuerDoku;
    procedure ErzeugeAusgabeTestumfang;
    procedure ErzeugeAusgabeVollFuerDebug;
    procedure AusgabeAlsCSV(DateiPfad:String);
  end;

var
  KaDataModule: TKaDataModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}


procedure TKaDataModule.DataModuleCreate(Sender: TObject);
begin
  //Definiere Tabelle fuer Gesamtausgabe mit allen Feldern
  //der Stücklistenpos, der Teile und der Bestellungen
//  DefiniereGesamtErgebnisTabelle;
end;


//Schreibt AusgabeDatenset in CSV-Datei
procedure TKaDataModule.AusgabeAlsCSV(DateiPfad:String);
begin
  //Verbinde BatchMoveDSReader mit Ausgabetabelle
  BatchMoveDSReader.DataSet:= AusgabeDS;
  //Verbinde BatchMove mit BatchMoveTextWriter als Ausgabmodul
  BatchMove.Writer:=BatchMoveTextWriter;
  //Setze Filenamen fuer BatchMoveTextWriter
  BatchMoveTextWriter.FileName:=DateiPfad;
  //Transferiere Daten in CSV-Datei
  BatchMove.Execute;

end;

//Überträgt GesamtDatenset in AusgabeDatenset
procedure TKaDataModule.BefuelleAusgabeTabelle;
begin
  //Verbinde BatchMoveDSReader mit GesamtTabelle
  BatchMoveDSReader.DataSet:= ErgebnisDS;
  //Verbinde BatchMoveDSWriter mit AusgabeTabelle
  BatchMoveDSWriter.DataSet:= AusgabeDS;
  //Verbinde BatchMove mit BatchMoveDSWriter als Ausgabmodul
  BatchMove.Writer:=BatchMoveDSWriter;
  //Transferiere Daten in Ausgabetabelle
  BatchMove.Execute;
end;

//Definiert und belegt die Ausgabe-Tabelle für den
// vollen Datenumfang zu Debug-Zwecken
procedure TKaDataModule.ErzeugeAusgabeVollFuerDebug;
const
  Felder: TWFeldNamen = ['EbeneNice','PosTyp', 'id_stu','FA_Nr','id_pos',
    'ueb_s_nr','ds', 'pos_nr','verurs_art','t_tg_nr','oa','Bezeichnung',
    'unipps_typ','besch_art','praeferenzkennung','menge','sme','faktlme_sme',
    'lme','bestell_id','bestell_datum','preis','basis','pme','bme',
    'faktlme_bme','faktbme_pme', 'lieferant','kurzname','MengeTotal','PreisEU',
    'PreisNonEU','SummeEU','SummeNonEU','vk_netto'];
{excel
  Ebene	Typ	zu Teil	FA	id_pos	ueb_s_nr	ds	pos_nr verurs_art  t_tg_nr
  oa	Bezchng	typ	v_besch_art urspr_land ausl_u_land praeferenzkennung
  menge	sme faktlme_sme	lme	bestell_id	bestell_datum	preis basis	pme	bme
  faktlme_bme	faktbme_pme	id_lief lieferant	pos_menge	preis_eu
  preis_n_eu	Summe_Eu	Summe_n_EU	LP je Stück	KT_zu_LP
}
begin
  //Definiere die Spalten des Ausgabe-Datensets
  AusgabeDS.DefiniereSubTabelle(ErgebnisDS, Felder);
  BefuelleAusgabeTabelle;
end;

procedure TKaDataModule.StueliPosDSstu_t_tg_nrChange(Sender: TField);
begin

end;

//Definiert und belegt die Ausgabe-Tabelle für Testausgaben
//(Ubersichtlicher als Gesamtausgabe)
procedure TKaDataModule.ErzeugeAusgabeTestumfang;
const
  Felder: TWFeldNamen =
            ['EbeneNice','PosTyp', 'id_stu','FA_Nr','id_pos','pos_nr',
           't_tg_nr', 'Bezeichnung','MengeTotal',
           'bestell_id','kurzname','PreisJeLME',
           'PreisEU','PreisNonEU','SummeEU','SummeNonEU','vk_netto'];
begin
  //Definiere die Spalten des Ausgabe-Datensets
  AusgabeDS.DefiniereSubTabelle(ErgebnisDS, Felder);
  BefuelleAusgabeTabelle;
end;



//Definiert und belegt die Ausgabe-Tabelle für die offizielle Doku der Analyse
procedure TKaDataModule.ErzeugeAusgabeKurzFuerDoku;
const
  Felder: TWFeldNamen = ['EbeneNice','t_tg_nr', 'Bezeichnung','MengeTotal',
           'kurzname','PreisEU','PreisNonEU','SummeEU','SummeNonEU','vk_netto'];
begin
  //Definiere die Spalten des Ausgabe-Datensets
  AusgabeDS.DefiniereSubTabelle(ErgebnisDS, Felder);
  BefuelleAusgabeTabelle;
end;

//Definiere Tabelle fuer Gesamtausgabe mit allen Feldern
//der Stücklistenpositionen, der Teile und der Bestellungen
procedure TKaDataModule.DefiniereGesamtErgebnisTabelle;
begin
//  Self.ErgebnisDS.DefiniereTabelle(SElf.StueliPosDS,True,False);
//  ErgebnisDS.DefiniereTabelle(TeilDS,False,False);
//  ErgebnisDS.DefiniereTabelle(BestellungDS,False,True);
  ErgebnisDS.CreateDataSet;
end;

end.
