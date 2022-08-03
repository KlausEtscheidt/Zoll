unit DatenModul;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient,
  FireDAC.Comp.BatchMove.DataSet, FireDAC.Stan.Intf, FireDAC.Comp.BatchMove,
  FireDAC.Comp.BatchMove.Text,
  Preiseingabe,PumpenDataSet;

  const
//    AlleAusgabeFelder: array [0..48] of TWFeldTypRecord =
    AlleErgebnisFelder: array [0..48] of TWFeldTypRecord =
     (
        (N: 'EbeneNice'; T:ftString; C:'Ebene'),
        (N: 'id_stu'; T:ftString; C:''),
        (N: 'PreisJeLME'; T:ftCurrency; C:''),
        (N: 'MengeTotal'; T:ftFloat; C:''),
        (N: 'faktlme_sme'; T:ftFloat; C:''),
        (N: 'faktlme_bme'; T:ftFloat; C:''),
        (N: 'faktbme_pme'; T:ftFloat; C:''),
        (N: 'netto_poswert'; T:ftCurrency; C:''),
        (N: 'pos_nr'; T:ftInteger; C:''),
        (N: 'stu_t_tg_nr'; T:ftString; C:''),
        (N: 'stu_oa'; T:ftInteger; C:''),
        (N: 'stu_unipps_typ'; T:ftString; C:''),
        (N: 'id_pos'; T:ftInteger; C:''),
        (N: 'besch_art'; T:ftInteger; C:''),
        (N: 'menge'; T:ftFloat; C:''),
        (N: 'FA_Nr'; T:ftString; C:''),
        (N: 'verurs_art'; T:ftInteger; C:''),
        (N: 'ueb_s_nr'; T:ftInteger; C:''),
        (N: 'ds'; T:ftInteger; C:''),
        (N: 'set_block'; T:ftInteger; C:''),
        (N: 'PosTyp'; T:ftString; C:''),
        (N: 'PreisEU'; T:ftCurrency; C:''),
        (N: 'PreisNonEU'; T:ftCurrency; C:''),
        (N: 'SummeEU'; T:ftCurrency; C:''),
        (N: 'SummeNonEU'; T:ftCurrency; C:''),
        (N: 'vk_netto'; T:ftCurrency; C:''),
        (N: 'vk_brutto'; T:ftCurrency; C:''),
        (N: 'Ebene'; T:ftInteger; C:''),
        (N: 't_tg_nr'; T:ftString; C:''),
        (N: 'oa'; T:ftInteger; C:''),
        (N: 'unipps_typ'; T:ftString; C:''),
        (N: 'Bezeichnung'; T:ftString; C:''),
        (N: 'v_besch_art'; T:ftInteger; C:''),
        (N: 'praeferenzkennung'; T:ftInteger; C:''),
        (N: 'sme'; T:ftInteger; C:''),
        (N: 'lme'; T:ftInteger; C:''),
        (N: 'preis'; T:ftCurrency; C:''),
        (N: 'bestell_id'; T:ftInteger; C:''),
        (N: 'bestell_datum'; T:ftString; C:''),
        (N: 'best_t_tg_nr'; T:ftString; C:''),
        (N: 'basis'; T:ftFloat; C:''),
        (N: 'pme'; T:ftInteger; C:''),
        (N: 'bme'; T:ftInteger; C:''),
        (N: 'we_menge'; T:ftFloat; C:''),
        (N: 'lieferant'; T:ftInteger; C:''),
        (N: 'kurzname'; T:ftString; C:''),
        (N: 'best_menge'; T:ftFloat; C:''),
        (N: 'AnteilNonEU'; T:ftFloat; C:''),
        (N: 'ZuKAPos'; T:ftInteger; C:'')
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
    ErgebnisFelderDict: TWFeldTypenDict;
    procedure DefiniereGesamtErgebnisDataSet;
    procedure BefuelleAusgabeTabelle(ZielDS :TClientDataSet );overload;
    procedure ErzeugeAusgabeKurzFuerDoku;
    procedure ErzeugeAusgabeTestumfang;
    procedure ErzeugeAusgabeVollFuerDebug;
    procedure ErzeugeAusgabeFuerPreisabfrage;
    procedure CopyFieldDefs;
    procedure FiltereSpalten();
    procedure AusgabeAlsCSV(DateiPfad,DateiName:String);
  end;

var
  KaDataModule: TKaDataModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}
uses Tools, main;

procedure TKaDataModule.DataModuleCreate(Sender: TObject);
var I:Integer;
begin
  //Erzeuge Dict mit allen Informationen �ber alle Felder der Ergenistabelle
  //Hieraus k�nnen Teil-Tabellen erzegt werden.
  ErgebnisFelderDict:= TWFeldTypenDict.Create;
  for I:=0 To length(AlleErgebnisFelder)-1 do
    //Lege kompletten Record in Dict ab, key ist der FeldName
    ErgebnisFelderDict.Add(AlleErgebnisFelder[I].N,AlleErgebnisFelder[I]);

  //Definiere Tabelle fuer Gesamtausgabe mit allen Feldern
  //der St�cklistenpos, der Teile und der Bestellungen
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

//�bertr�gt GesamtDatenset in AusgabeDatenset
procedure TKaDataModule.BefuelleAusgabeTabelle;
begin
  Self.BefuelleAusgabeTabelle(Self.AusgabeDS);
end;

//Definiert und belegt die Ausgabe-Tabelle f�r den
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
  preis_n_eu	Summe_Eu	Summe_n_EU	LP je St�ck	KT_zu_LP
}
begin
  //Definiere die Spalten des Ausgabe-Datensets
  AusgabeDS:=TWDataSet.Create(Self);
  AusgabeDS.DefiniereTabelle(ErgebnisFelderDict, Felder);
  AusgabeDS.Print;
//  AusgabeDS.Data:=ErgebnisDS.Data;
  BefuelleAusgabeTabelle;
  AusgabeDS.Print;
  AusgabeDS.DefiniereFeldEigenschaften(ErgebnisFelderDict);
  AusgabeDS.Print;

end;


//Definiert und belegt die Ausgabe-Tabelle f�r Testausgaben
//(Ubersichtlicher als Gesamtausgabe)
procedure TKaDataModule.ErzeugeAusgabeTestumfang;
const
  Felder: TWFeldNamen =
            ['EbeneNice',
            'MengeTotal',
//            'PosTyp', 'id_stu','FA_Nr','id_pos','pos_nr',
//           't_tg_nr', 'Bezeichnung',
//           'bestell_id','kurzname','PreisJeLME',
//           'PreisEU','PreisNonEU','SummeEU','SummeNonEU',
           'vk_netto'];
begin
  AusgabeDS:=TWDataSet.Create(Self);
  //Definiere die Spalten des Ausgabe-Datensets
  AusgabeDS.DefiniereTabelle(ErgebnisFelderDict, Felder);
  BefuelleAusgabeTabelle;
  AusgabeDS.DefiniereFeldEigenschaften(ErgebnisFelderDict);
end;

//Definiert und belegt die Ausgabe-Tabelle f�r die offizielle Doku der Analyse
procedure TKaDataModule.ErzeugeAusgabeKurzFuerDoku;
const
  Felder: TWFeldNamen = ['EbeneNice','t_tg_nr', 'Bezeichnung','MengeTotal',
           'kurzname','PreisEU','PreisNonEU','SummeEU','SummeNonEU','vk_netto'];
begin
  //Definiere die Spalten des Ausgabe-Datensets
  AusgabeDS:=TWDataSet.Create(Self);
  AusgabeDS.DefiniereTabelle(ErgebnisFelderDict, Felder);
  BefuelleAusgabeTabelle;
  AusgabeDS.DefiniereFeldEigenschaften(ErgebnisFelderDict);
end;


//Definiert und belegt die Ausgabe-Tabelle f�r die offizielle Doku der Analyse
procedure TKaDataModule.ErzeugeAusgabeFuerPreisabfrage;
const
  Felder: TWFeldNamen = ['id_pos','Menge', 'stu_t_tg_nr', 'Bezeichnung',
                            'vk_brutto', 'vk_netto', 'ZuKAPos'];
begin
  //Definiere die Spalten des Ausgabe-Datensets
//  PreisFrm.PreisDS.DefiniereSubTabelle(ErgebnisDS, Felder);
  BefuelleAusgabeTabelle(PreisFrm.PreisDS);
end;

///<summary>Definiere Tabelle fuer Gesamtausgabe mit allen Feldern
///der St�cklistenpositionen, der Teile und der Bestellungen</summary>
procedure TKaDataModule.DefiniereGesamtErgebnisDataSet;
var
  FeldNamen:TWFeldNamen;
  I:Integer;

begin
   //Erzeuge Liste mit allen Feldnamen
   setlength(FeldNamen,length(AlleErgebnisFelder));
   for I:=0 To length(AlleErgebnisFelder)-1 do
   begin
      FeldNamen[I]:=AlleErgebnisFelder[I].N;
   end;
  //Definiere DataSet
  //ErgebnisFelderDict enth�lt alle Informationen �ber die Feldbeschaffenheit
  //FeldNamen die Liste aller Felder, die in angelegt werden (in dieser Reihenfolge)
  ErgebnisDS:=TWDAtaSet.Create(Self);
  ErgebnisDS.DefiniereTabelle(ErgebnisFelderDict, FeldNamen);
end;

procedure TKaDataModule.CopyFieldDefs;
var
i:Integer;
myFieldDef:TFieldDef;

begin
    for I := 0 to ErgebnisDS.FieldDefs.Count do
    begin
    end;

end;

procedure TKaDataModule.FiltereSpalten();
const
  Felder: TWFeldNamen = ['id_pos','Menge', 'stu_t_tg_nr', 'Bezeichnung',
                            'vk_brutto', 'vk_netto', 'ZuKAPos'];
begin
  ErgebnisDS.FiltereSpalten(Felder);

end;

end.
