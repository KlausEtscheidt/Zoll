unit DatenModul;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient,
  FireDAC.Comp.BatchMove.DataSet, FireDAC.Stan.Intf, FireDAC.Comp.BatchMove,
  FireDAC.Comp.BatchMove.Text,
  Settings, PumpenDataSet;
  //Preiseingabe,

  const
//    AlleAusgabeFelder: array [0..48] of TWFeldTypRecord =
    AlleErgebnisFelder: array [0..49] of TWFeldTypRecord =
     (
      (N: 'EbeneNice'; T:ftString; C:'Ebene'; W:15; J:l),
      (N: 'id_stu'; T:ftString; C:'zu Stu'; W:10; J:l),
      (N: 'PreisJeLME'; T:ftCurrency; C:''; W:10; J:l),
      (N: 'MengeTotal'; T:ftFloat; C:''; W:10; J:l),
      (N: 'faktlme_sme'; T:ftFloat; C:''; W:10; J:l),
      (N: 'faktlme_bme'; T:ftFloat; C:''; W:10; J:l),
      (N: 'faktbme_pme'; T:ftFloat; C:''; W:10; J:l),
      (N: 'netto_poswert'; T:ftCurrency; C:''; W:10; J:l),
      (N: 'pos_nr'; T:ftString; C:'Pos-Nr'; W:5; J:r),
      (N: 'stu_t_tg_nr'; T:ftString; C:'Teile-Nr'; W:10; J:l),
      (N: 'stu_oa'; T:ftInteger; C:''; W:10; J:l),
      (N: 'stu_unipps_typ'; T:ftString; C:''; W:10; J:l),
      (N: 'id_pos'; T:ftInteger; C:'Id Pos'; W:5; J:c),
      (N: 'besch_art'; T:ftInteger; C:''; W:10; J:l),
      (N: 'menge'; T:ftFloat; C:'Menge'; W:10; J:l),
      (N: 'FA_Nr'; T:ftString; C:''; W:8; J:l),
      (N: 'verurs_art'; T:ftInteger; C:''; W:10; J:l),
      (N: 'ueb_s_nr'; T:ftInteger; C:''; W:10; J:l),
      (N: 'ds'; T:ftInteger; C:''; W:3; J:c),
      (N: 'set_block'; T:ftInteger; C:''; W:10; J:l),
      (N: 'PosTyp'; T:ftString; C:''; W:10; J:l),
      (N: 'PreisEU'; T:ftCurrency; C:''; W:10; J:r),
      (N: 'PreisNonEU'; T:ftCurrency; C:''; W:10; J:r),
      (N: 'SummeEU'; T:ftCurrency; C:''; W:10; J:r),
      (N: 'SummeNonEU'; T:ftCurrency; C:''; W:10; J:r),
      (N: 'vk_netto'; T:ftCurrency; C:'VK rabattiert'; W:10; J:r),
      (N: 'vk_brutto'; T:ftCurrency; C:'VK Liste'; W:10; J:r),
      (N: 'Ebene'; T:ftInteger; C:''; W:10; J:l),
      (N: 't_tg_nr'; T:ftString; C:'Teile-Nr'; W:25; J:l),
      (N: 'oa'; T:ftInteger; C:''; W:10; J:l),
      (N: 'unipps_typ'; T:ftString; C:''; W:10; J:l),
      (N: 'Bezeichnung'; T:ftString; C:''; W:25; J:l),
      (N: 'v_besch_art'; T:ftInteger; C:''; W:10; J:l),
      (N: 'praeferenzkennung'; T:ftInteger; C:''; W:10; J:l),
      (N: 'sme'; T:ftInteger; C:''; W:10; J:l),
      (N: 'lme'; T:ftInteger; C:''; W:10; J:l),
      (N: 'preis'; T:ftCurrency; C:''; W:10; J:l),
      (N: 'bestell_id'; T:ftInteger; C:''; W:10; J:l),
      (N: 'bestell_datum'; T:ftDate; C:''; W:10; J:l),
      (N: 'best_t_tg_nr'; T:ftString; C:''; W:10; J:l),
      (N: 'basis'; T:ftFloat; C:''; W:10; J:l),
      (N: 'pme'; T:ftInteger; C:''; W:10; J:l),
      (N: 'bme'; T:ftInteger; C:''; W:10; J:l),
      (N: 'we_menge'; T:ftFloat; C:''; W:10; J:l),
      (N: 'lieferant'; T:ftInteger; C:''; W:10; J:l),
      (N: 'kurzname'; T:ftString; C:'Lieferant'; W:10; J:l),
      (N: 'best_menge'; T:ftFloat; C:''; W:10; J:l),
      (N: 'AnteilNonEU'; T:ftFloat; C:'% Non EU'; W:10; J:c),
      (N: 'PraefResult'; T:ftString; C:'OK'; W:5; J:c),
      (N: 'ZuKAPos'; T:ftInteger; C:'gehört zu'; W:10; J:l)
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
    procedure ErzeugeAusgabeVollFuerDebug;
    procedure ErzeugeAusgabeFuerPreisabfrage(PreisDS:TWDAtaSet);
    procedure AusgabeAlsCSV(DateiPfad,DateiName:String);
  end;

var
  KaDataModule: TKaDataModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}
//uses Tools, main;

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
  AusgabeDS.SetzeSchreibmodus;

end;

//---------------------------------------------------------------------------
///<summary>Definiert und belegt die Ausgabe-Tabelle
///für die offizielle Dokumentation (Kurzform) der Analyse.</summary>
procedure TKaDataModule.ErzeugeAusgabeKurzFuerDoku;
//---------------------------------------------------------------------------
const
  Felder: TWFeldNamen = ['EbeneNice','t_tg_nr', 'Bezeichnung','MengeTotal',
           'kurzname','PreisEU','PreisNonEU','SummeEU','SummeNonEU',
           'vk_netto','AnteilNonEU','PraefResult'];
begin
  //Definiere die Spalten des Ausgabe-Datensets
  AusgabeDS.DefiniereTabelle(ErgebnisFelderDict, Felder);
  //Daten aus Gesamtergebnis uebernehmen
  BefuelleAusgabeTabelle;
  //Erlaube Schreiben fuer keine Felder
  AusgabeDS.SetzeSchreibmodus;
end;

//---------------------------------------------------------------------------
///<summary>Definiert und belegt die Ausgabe-Tabelle
///für die Abfrage von Preisen bei Neupumpen.</summary>
procedure TKaDataModule.ErzeugeAusgabeFuerPreisabfrage(PreisDS:TWDAtaSet);
//---------------------------------------------------------------------------
const
  Felder: TWFeldNamen = ['id_pos','Menge', 'stu_t_tg_nr', 'Bezeichnung',
                            'vk_brutto', 'vk_netto', 'ZuKAPos'];
begin
  //Die Spalten für die Preisabfrage sind im Formular festgelegt
  //Ansonsten ueber naechste Zeile
//  PreisFrm.PreisDS.DefiniereTabelle(ErgebnisFelderDict, Felder);
    PreisDS.Active:=False;
    PreisDS.CreateDataSet;

  //Daten aus Gesamtergebnis uebernehmen und Feldeigenschaften festlegen
  BefuelleAusgabeTabelle(PreisDS);
  //Erlaube Schreiben fuer die beiden Felder
  PreisDS.SetzeSchreibmodus(['vk_netto', 'ZuKAPos'])

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
