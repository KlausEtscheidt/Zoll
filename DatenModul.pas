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
        (N: 'id_stu'; T:ftString; C:'zu Stu'),
        (N: 'PreisJeLME'; T:ftCurrency; C:''),
        (N: 'MengeTotal'; T:ftFloat; C:''),
        (N: 'faktlme_sme'; T:ftFloat; C:''),
        (N: 'faktlme_bme'; T:ftFloat; C:''),
        (N: 'faktbme_pme'; T:ftFloat; C:''),
        (N: 'netto_poswert'; T:ftCurrency; C:''),
        (N: 'pos_nr'; T:ftString; C:'Pos-Nr'),
        (N: 'stu_t_tg_nr'; T:ftString; C:'Teile-Nr'),
        (N: 'stu_oa'; T:ftInteger; C:''),
        (N: 'stu_unipps_typ'; T:ftString; C:''),
        (N: 'id_pos'; T:ftInteger; C:'Id Pos'),
        (N: 'besch_art'; T:ftInteger; C:''),
        (N: 'menge'; T:ftFloat; C:'Menge'),
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
        (N: 'vk_netto'; T:ftCurrency; C:'VK rabattiert'),
        (N: 'vk_brutto'; T:ftCurrency; C:'VK Liste'),
        (N: 'Ebene'; T:ftInteger; C:''),
        (N: 't_tg_nr'; T:ftString; C:'Teile-Nr'),
        (N: 'oa'; T:ftInteger; C:''),
        (N: 'unipps_typ'; T:ftString; C:''),
        (N: 'Bezeichnung'; T:ftString; C:''),
        (N: 'v_besch_art'; T:ftInteger; C:''),
        (N: 'praeferenzkennung'; T:ftInteger; C:''),
        (N: 'sme'; T:ftInteger; C:''),
        (N: 'lme'; T:ftInteger; C:''),
        (N: 'preis'; T:ftCurrency; C:''),
        (N: 'bestell_id'; T:ftInteger; C:''),
        (N: 'bestell_datum'; T:ftDate; C:''),
        (N: 'best_t_tg_nr'; T:ftString; C:''),
        (N: 'basis'; T:ftFloat; C:''),
        (N: 'pme'; T:ftInteger; C:''),
        (N: 'bme'; T:ftInteger; C:''),
        (N: 'we_menge'; T:ftFloat; C:''),
        (N: 'lieferant'; T:ftInteger; C:''),
        (N: 'kurzname'; T:ftString; C:''),
        (N: 'best_menge'; T:ftFloat; C:''),
        (N: 'AnteilNonEU'; T:ftFloat; C:''),
        (N: 'ZuKAPos'; T:ftInteger; C:'gehört zu')
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
    procedure BefuelleAusgabeTabelle(ZielDS :TWDataSet );overload;
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
uses Tools, main;

//---------------------------------------------------------------------------
///<summary>Befüllt ErgebnisFelderDict mit Info aus AlleErgebnisFelder</summary>
///<remarks>Mit den Daten werden beim Anlegen von DataSets die Feldeigenschaften
/// definiert. </remarks>
procedure TKaDataModule.DataModuleCreate(Sender: TObject);
//---------------------------------------------------------------------------
var I:Integer;
begin
  //Erzeuge Dict mit allen Informationen über alle Felder der Ergenistabelle
  //Hieraus können Teil-Tabellen erzeugt werden.
  ErgebnisFelderDict:= TWFeldTypenDict.Create;
  for I:=0 To length(AlleErgebnisFelder)-1 do
    //Lege kompletten Record in Dict ab, key ist der FeldName
    ErgebnisFelderDict.Add(AlleErgebnisFelder[I].N,AlleErgebnisFelder[I]);

  //Definiere Tabelle fuer Gesamtausgabe mit allen Feldern
  //der Stücklistenpos, der Teile und der Bestellungen
  //DefiniereGesamtErgebnisTabelle;
end;

//---------------------------------------------------------------------------
///<summary>Schreibt AusgabeDS in CSV-Datei </summary>
/// <param name="DateiPfad">Pfad ohne slash am Ende </param>
/// <param name="DateiName">Dateiname ohne slash am Anfang</param>
procedure TKaDataModule.AusgabeAlsCSV(DateiPfad,DateiName:String);
//---------------------------------------------------------------------------
var
  FileName:String;
begin
  //Verbinde BatchMoveDSReader mit Ausgabetabelle
  BatchMoveDSReader.DataSet:= AusgabeDS;
  //Verbinde BatchMove mit BatchMoveTextWriter als Ausgabmodul
  BatchMove.Writer:=BatchMoveTextWriter;
  //Setze Filenamen fuer BatchMoveTextWriter
  FileName:=DateiPfad+'\'+DateiName;
  BatchMoveTextWriter.FileName:=FileName;
  //File loeschen vor befüllen, da sosnt Datenmüll in Ausgabe
  if System.SysUtils.FileExists(FileName) then
      DeleteFile(FileName);
  //Transferiere Daten in CSV-Datei
  BatchMove.Execute;

end;

//---------------------------------------------------------------------------
///<summary>Überträgt Daten vom GesamtDatenset "ErgebnisDS" ins ZielDS
///</summary>
///<remarks>Die Feldeigenschaften werden dabei anhand der globalen
/// Festlegungen in AlleErgebnisFelder bzw dem daraus befüllten
/// ErgebnisFelderDict erneut definiert, da Batchmove diese ändert. </remarks>
procedure TKaDataModule.BefuelleAusgabeTabelle(ZielDS :TWDataSet );
//---------------------------------------------------------------------------
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
  //Setze Feldeigenschaften neu
  ZielDS.DefiniereFeldEigenschaften(ErgebnisFelderDict);
end;

//---------------------------------------------------------------------------
///<summary>Überträgt Daten vom GesamtDatenset ins Default-AusgabeDatenset
///"AusgabeDS" </summary>
procedure TKaDataModule.BefuelleAusgabeTabelle;
//---------------------------------------------------------------------------
begin
  Self.BefuelleAusgabeTabelle(Self.AusgabeDS);
end;

//---------------------------------------------------------------------------
///<summary>Definiert und belegt die Ausgabe-Tabelle
///mit großem Datenumfang (zu Debug-Zwecken).</summary>
procedure TKaDataModule.ErzeugeAusgabeVollFuerDebug;
//---------------------------------------------------------------------------
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
  AusgabeDS.DefiniereTabelle(ErgebnisFelderDict, Felder);
//  AusgabeDS.Print;  //ZUm Debuggen FeldEigenschaften drucken
  //Daten aus Gesamtergebnis uebernehmen und Feldeigenschaften festlegen
  BefuelleAusgabeTabelle;
  //Erlaube Schreiben fuer keine Felder
  AusgabeDS.DefiniereReadOnly;

end;


//---------------------------------------------------------------------------
///<summary>Definiert und belegt die Ausgabe-Tabelle
///für Testausgaben (Ubersichtlicher als Gesamtausgabe).</summary>
procedure TKaDataModule.ErzeugeAusgabeTestumfang;
//---------------------------------------------------------------------------
const
  Felder: TWFeldNamen =
            ['EbeneNice', 'MengeTotal', 'bestell_datum',
//            'PosTyp', 'id_stu','FA_Nr','id_pos','pos_nr',
            't_tg_nr', 'Bezeichnung',
//           'bestell_id','kurzname','PreisJeLME',
//           'PreisEU','PreisNonEU','SummeEU','SummeNonEU',
           'vk_netto'];
begin
  //Definiere die Spalten des Ausgabe-Datensets
  AusgabeDS.DefiniereTabelle(ErgebnisFelderDict, Felder);
  //Daten aus Gesamtergebnis uebernehmen und Feldeigenschaften festlegen
  BefuelleAusgabeTabelle;
  //Erlaube Schreiben fuer keine Felder
  AusgabeDS.DefiniereReadOnly;

end;

//---------------------------------------------------------------------------
///<summary>Definiert und belegt die Ausgabe-Tabelle
///für die offizielle Dokumentation (Kurzform) der Analyse.</summary>
procedure TKaDataModule.ErzeugeAusgabeKurzFuerDoku;
//---------------------------------------------------------------------------
const
  Felder: TWFeldNamen = ['EbeneNice','t_tg_nr', 'Bezeichnung','MengeTotal',
           'kurzname','PreisEU','PreisNonEU','SummeEU','SummeNonEU','vk_netto'];
begin
  //Definiere die Spalten des Ausgabe-Datensets
  AusgabeDS.DefiniereTabelle(ErgebnisFelderDict, Felder);
  //Daten aus Gesamtergebnis uebernehmen
  BefuelleAusgabeTabelle;
  //Erlaube Schreiben fuer keine Felder
  AusgabeDS.DefiniereReadOnly;
end;

//---------------------------------------------------------------------------
///<summary>Definiert und belegt die Ausgabe-Tabelle
///für die Abfrage von Preisen bei Neupumpen.</summary>
procedure TKaDataModule.ErzeugeAusgabeFuerPreisabfrage;
//---------------------------------------------------------------------------
const
  Felder: TWFeldNamen = ['id_pos','Menge', 'stu_t_tg_nr', 'Bezeichnung',
                            'vk_brutto', 'vk_netto', 'ZuKAPos'];
begin
  //Die Spalten für die Preisabfrage sind im Formular festgelegt
  //Ansonsten ueber naechste Zeile
//  PreisFrm.PreisDS.DefiniereTabelle(ErgebnisFelderDict, Felder);
    PreisFrm.PreisDS.Active:=False;
    PreisFrm.PreisDS.CreateDataSet;

  //Daten aus Gesamtergebnis uebernehmen und Feldeigenschaften festlegen
  BefuelleAusgabeTabelle(PreisFrm.PreisDS);
  //Erlaube Schreiben fuer die beiden Felder
  PreisFrm.PreisDS.DefiniereReadOnly(['vk_netto', 'ZuKAPos'])

end;

//---------------------------------------------------------------------------
///<summary>Definiere Tabelle fuer Gesamt-Ergebnis mit allen Feldern
///der Stücklistenpositionen, der Teile und der Bestellungen.</summary>
///<remarks>
/// Aus diesem Dataset entstehen alle Ausgaben über Teilmengen-Datasets.
/// Es muss einmalig mit dieser Funktion angelegt werden.
///</remarks>
procedure TKaDataModule.DefiniereGesamtErgebnisDataSet;
//---------------------------------------------------------------------------
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
  //ErgebnisFelderDict enthält alle Informationen über die Feldbeschaffenheit
  //FeldNamen die Liste aller Felder, die in angelegt werden (in dieser Reihenfolge)
//  ErgebnisDS:=TWDAtaSet.Create(Self);
  ErgebnisDS.DefiniereTabelle(ErgebnisFelderDict, FeldNamen);
end;

end.
