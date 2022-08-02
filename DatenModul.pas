unit DatenModul;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient,
  FireDAC.Comp.BatchMove.DataSet, FireDAC.Stan.Intf, FireDAC.Comp.BatchMove,
  FireDAC.Comp.BatchMove.Text,
  Preiseingabe,PumpenDataSet;

  const
//    AlleAusgabeFelder: array [0..48] of TWFeldTypRecord =
    AlleAusgabeFelder: array [0..2] of TWFeldTypRecord =
     (
//          (N: 'id_stu'; T:ftString; P:3; C:''),
          (N: 'PreisJeLME'; T:ftFloat; P:3; C:''),
          (N: 'MengeTotal'; T:ftFloat; P:3; C:''),
//          (N: 'faktlme_sme'; T:ftFloat; P:3; C:''),
//          (N: 'faktlme_bme'; T:ftFloat; P:3; C:''),
//          (N: 'faktbme_pme'; T:ftFloat; P:3; C:''),
//          (N: 'netto_poswert'; T:ftFloat; P:3; C:''),
//          (N: 'pos_nr'; T:ftInteger; P:3; C:''),
//          (N: 'stu_t_tg_nr'; T:ftString; P:3; C:''),
//          (N: 'stu_oa'; T:ftInteger; P:3; C:''),
//          (N: 'stu_unipps_typ'; T:ftString; P:3; C:''),
//          (N: 'id_pos'; T:ftInteger; P:3; C:''),
//          (N: 'besch_art'; T:ftInteger; P:3; C:''),
//          (N: 'menge'; T:ftFloat; P:3; C:''),
//          (N: 'FA_Nr'; T:ftString; P:3; C:''),
//          (N: 'verurs_art'; T:ftInteger; P:3; C:''),
//          (N: 'ueb_s_nr'; T:ftInteger; P:3; C:''),
//          (N: 'ds'; T:ftInteger; P:3; C:''),
//          (N: 'set_block'; T:ftInteger; P:3; C:''),
//          (N: 'PosTyp'; T:ftString; P:3; C:''),
//          (N: 'PreisEU'; T:ftCurrency; P:3; C:''),
//          (N: 'PreisNonEU'; T:ftCurrency; P:3; C:''),
//          (N: 'SummeEU'; T:ftCurrency; P:3; C:''),
//          (N: 'SummeNonEU'; T:ftCurrency; P:3; C:''),
//          (N: 'vk_netto'; T:ftCurrency; P:3; C:''),
//          (N: 'vk_brutto'; T:ftFloat; P:3; C:''),
//          (N: 'Ebene'; T:ftInteger; P:3; C:''),
//          (N: 'EbeneNice'; T:ftString; P:3; C:''),
//          (N: 't_tg_nr'; T:ftString; P:3; C:''),
//          (N: 'oa'; T:ftInteger; P:3; C:''),
//          (N: 'unipps_typ'; T:ftString; P:3; C:''),
//          (N: 'Bezeichnung'; T:ftString; P:3; C:''),
//          (N: 'v_besch_art'; T:ftInteger; P:3; C:''),
//          (N: 'praeferenzkennung'; T:ftInteger; P:3; C:''),
//          (N: 'sme'; T:ftInteger; P:3; C:''),
//          (N: 'lme'; T:ftInteger; P:3; C:''),
//          (N: 'preis'; T:ftFloat; P:3; C:''),
//          (N: 'bestell_id'; T:ftInteger; P:3; C:''),
//          (N: 'bestell_datum'; T:ftDateTime; P:3; C:''),
//          (N: 'best_t_tg_nr'; T:ftString; P:3; C:''),
//          (N: 'basis'; T:ftFloat; P:3; C:''),
//          (N: 'pme'; T:ftInteger; P:3; C:''),
//          (N: 'bme'; T:ftInteger; P:3; C:''),
//          (N: 'we_menge'; T:ftFloat; P:3; C:''),
//          (N: 'lieferant'; T:ftInteger; P:3; C:''),
//          (N: 'kurzname'; T:ftString; P:3; C:''),
//          (N: 'best_menge'; T:ftFloat; P:3; C:''),
//          (N: 'AnteilNonEU'; T:ftFloat; P:3; C:''),
          (N: 'ZuKAPos'; T:ftInteger; P:3; C:'')
     );

type
  TKaDataModule = class(TDataModule)
    BatchMoveTextWriter: TFDBatchMoveTextWriter;
    BatchMoveDSReader: TFDBatchMoveDataSetReader;
    BatchMove: TFDBatchMove;
    BatchMoveDSWriter: TFDBatchMoveDataSetWriter;
    ErgebnisDS: TWDataSet;
    AusgabeDS: TWDataSet;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure BefuelleAusgabeTabelle;overload;

  public
    procedure DefiniereGesamtErgebnisDataSet;
    procedure BefuelleAusgabeTabelle(ZielDS :TClientDataSet );overload;
    procedure ErzeugeAusgabeKurzFuerDoku;
    procedure ErzeugeAusgabeTestumfang;
    procedure ErzeugeAusgabeVollFuerDebug;
    procedure ErzeugeAusgabeFuerPreisabfrage;
    procedure AusgabeAlsCSV(DateiPfad,DateiName:String);
  end;

var
  KaDataModule: TKaDataModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}
uses Tools;

procedure TKaDataModule.DataModuleCreate(Sender: TObject);
begin
  //Definiere Tabelle fuer Gesamtausgabe mit allen Feldern
  //der Stücklistenpos, der Teile und der Bestellungen
//  DefiniereGesamtErgebnisTabelle;
end;


//Schreibt AusgabeDatenset in CSV-Datei
procedure TKaDataModule.AusgabeAlsCSV(DateiPfad,DateiName:String);
begin
  //Verbinde BatchMoveDSReader mit Ausgabetabelle
  BatchMoveDSReader.DataSet:= AusgabeDS;
  //Verbinde BatchMove mit BatchMoveTextWriter als Ausgabmodul
  BatchMove.Writer:=BatchMoveTextWriter;
  //Setze Filenamen fuer BatchMoveTextWriter
  BatchMoveTextWriter.FileName:=DateiPfad+'\'+DateiName;
  //Transferiere Daten in CSV-Datei
  BatchMove.Execute;

end;

procedure TKaDataModule.BefuelleAusgabeTabelle(ZielDS :TClientDataSet );
begin
  BatchMove.LogFileName:= LogDir +'\BatchMoveLog.txt';

  //Verbinde BatchMoveDSReader mit GesamtTabelle
  BatchMoveDSReader.DataSet:= ErgebnisDS;
  //Verbinde BatchMoveDSWriter mit AusgabeTabelle
  BatchMoveDSWriter.DataSet:= ZielDS;
  //Verbinde BatchMove mit BatchMoveDSWriter als Ausgabmodul
  BatchMove.Writer:=BatchMoveDSWriter;
  //Transferiere Daten in Ausgabetabelle
  BatchMove.Execute;

end;

//Überträgt GesamtDatenset in AusgabeDatenset
procedure TKaDataModule.BefuelleAusgabeTabelle;
begin
  Self.BefuelleAusgabeTabelle(Self.AusgabeDS);
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
    'PreisNonEU','SummeEU','SummeNonEU','vk_netto','AnteilNonEU','ZuKAPos'];
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
  AusgabeDS.FileName:=Tools.LogDir+'\AusgabeVoll.xml';
  BefuelleAusgabeTabelle;
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
  AusgabeDS.FileName:=Tools.LogDir+'\AusgabeTest.xml';
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
  AusgabeDS.FileName:=Tools.LogDir+'\AusgabeKurz.xml';
  BefuelleAusgabeTabelle;
end;


//Definiert und belegt die Ausgabe-Tabelle für die offizielle Doku der Analyse
procedure TKaDataModule.ErzeugeAusgabeFuerPreisabfrage;
const
  Felder: TWFeldNamen = ['id_pos','Menge', 'stu_t_tg_nr', 'Bezeichnung',
                            'vk_brutto', 'vk_netto', 'ZuKAPos'];
begin
  //Definiere die Spalten des Ausgabe-Datensets
//  PreisFrm.PreisDS.DefiniereSubTabelle(ErgebnisDS, Felder);
  BefuelleAusgabeTabelle(PreisFrm.PreisDS);
end;


//Definiere Tabelle fuer Gesamtausgabe mit allen Feldern
//der Stücklistenpositionen, der Teile und der Bestellungen
procedure TKaDataModule.DefiniereGesamtErgebnisDataSet;
begin
//  Self.ErgebnisDS.DefiniereTabelle(SElf.StueliPosDS,True,False);
//  ErgebnisDS.DefiniereTabelle(TeilDS,False,False);
//  ErgebnisDS.DefiniereTabelle(BestellungDS,False,True);
//  ErgebnisDS.FileName:= LogDir +'\Erg.xml';
//  ErgebnisDS.Active:=True;
  ErgebnisDS.DefiniereTabelle(AlleAusgabeFelder);
  ErgebnisDS.Fields.Count;
//  Datenmodul.KaDataModule.ErgebnisDS.CreateDataSet;
end;

end.
