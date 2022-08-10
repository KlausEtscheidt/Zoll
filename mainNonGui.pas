unit mainNonGui;

interface

uses  System.SysUtils, System.TimeSpan, Vcl.Controls, Vcl.Dialogs, Windows,
      Tools, Settings, Tests,
      Kundenauftrag,KundenauftragsPos, ADOQuery , ADOConnector,
      BaumQrySQLite, BaumQryUNIPPS, DatenModul, Preiseingabe,
      DruckeTabelle  ;

type
    EStuBaumMainExc = class(Exception);

type
    TWZuordnung=record
      VaterPos:Integer;
      KindPos:Integer;
    end;
    TWZuordnungen=array of TWZuordnung;

function RunItGui:TWKundenauftrag;
procedure RunItKonsole;
function KaAuswerten(KaId:string):TWKundenauftrag;
procedure KaNurAuswerten(KaId:string);
function Preisabfrage(KA:TWKundenauftrag;var Zuordnungen:TWZuordnungen): Boolean;
procedure ZuordnungAendern(KA:TWKundenauftrag;Zuordnungen:TWZuordnungen);
procedure ErgebnisAusgabe(KaId:string);
procedure ErgebnisDrucken(KA:TWKundenauftrag);
procedure Check100;
procedure InitCopyUNI2SQLite;

implementation

uses main,DruckBlatt;

function GetUsername: String;
var
  Buffer: array[0..256] of Char; // UNLEN (= 256) +1 (definiert in Lmcons.h)
  Size: DWord;
begin
  Size := length(Buffer); // length stat SizeOf, da Anzahl in TChar und nicht BufferSize in Byte
   if not Windows.GetUserName(Buffer, Size) then
    RaiseLastOSError;
  SetString(Result, Buffer, Size - 1);

end;

/// <summary> Initialisiert den Kopiermodus von UNIPPS nach SQLite
/// </summary>
///<remarks>  Öffnet SQLite-Connection und übergibt diese
/// an die UNIPPS-Query.
///</remarks>
procedure InitCopyUNI2SQLite;
var
  dbSQLiteConn: TWADOConnector;
//  QryUNIPPS: TWBaumQryUNIPPS;

begin
{$IFNDEF SQLITE}
{$IFNDEF HOME}

  //SQLite-DB oeffnen  Pfad aus globaler Tools.SQLiteFile
  dbSQLiteConn:=TWADOConnector.Create(nil);
  dbSQLiteConn.ConnectToSQLite(Settings.SQLiteDBFileName);

  //Query fuer UNIPPS anlegen und Verbindung setzen
//  QryUNIPPS:=Tools.GetQuery;

  //Fuer Export nach SQLite
  //Flag und SQLite-Verbindung einmalig in Klassenvariable
  TWBaumQryUNIPPS.Export2SQLite:=True;
  TWBaumQryUNIPPS.SQLiteConnector:=dbSQLiteConn;
{$ENDIF}
{$ENDIF}

end;

/// <summary> Analysiert im Batchmodus eine VIelzahl von Aufträgen
/// </summary>
procedure Check100;
var
  QryUNIPPS: TWBaumQryUNIPPS;
  Sql:String;
  ka_id: string;
  I: Integer;
  StartRecord: Integer;
  LastRecord: Integer;

begin
{$IFNDEF SQLITE}
{$IFNDEF HOME}


  //Query fuer UNIPPS anlegen
  QryUNIPPS:=Tools.GetQuery;

  //Abfragen ueber flex. Query: 200 Kundenaufträeg
  sql := 'select first 401 ident_nr as ka_id from auftragkopf order by ka_id desc;';
  QryUNIPPS.RunSelectQuery(Sql);

  StartRecord :=200;
  LastRecord:=202;
  QryUNIPPS.MoveBy(StartRecord);
  for I:=StartRecord to LastRecord do
  begin
      try
        //Hole Id des Auftrags
        ka_id:=QryUNIPPS.FindField('ka_id').AsString;
        KaNurAuswerten(ka_id)

      except
        on E: Exception do
        begin
          Tools.ErrLog.Log(E.Message);
          Tools.ErrLog.Flush;
        end;
      end;

      QryUNIPPS.Next;
  end;

{$ENDIF}
{$ENDIF}
end;

//Nutzt aus TWKundenauftrag nur .liesKopfundPositionen und .holeKinder
//Alle Exceptions gekapselt fuer Batchlauf ohne Abbruch
procedure KaNurAuswerten(KaId:string);
var ka:TWKundenauftrag;
begin

    try
      writeln(KaId);
      Tools.Log.Log('------- Kundenauftrag: '+KaId);
      Tools.ErrLog.Log('------- Kundenauftrag: '+KaId);

      //Ka anlegen
      ka:=TWKundenauftrag.Create(KaId);

      //Daten lesen und nach SQLite kopieren
      ka.liesKopfundPositionen;
      ka.holeKinder;
    except
      on E: Exception do
      begin
        Tools.ErrLog.Log(E.Message);
        Tools.ErrLog.Flush;
        ka.Free;
      end;
    end;


end;

///<summary> Startet eine Komplettanalyse ueber TWKundenauftrag.auswerten
///<summary>
function KaAuswerten(KaId:string):TWKundenauftrag;
var
  KA:TWKundenauftrag;
  startzeit,endzeit: Int64;
  delta:Double;
  msg:String;
  //Zuordnungen von KA-Pos (z.B Motoren) zu übergeordneten KA-Pos
  Zuordnungen:TWZuordnungen;

begin

  try

  Tools.Init;
  Settings.GuiMode:=True;

  //Logger oeffnen
  Tools.Log.OpenNew(Settings.ApplicationBaseDir,'data\output\Log.txt');
  Tools.ErrLog.OpenNew(Settings.ApplicationBaseDir,'data\output\ErrLog.txt');

  mainfrm.langBtn.Enabled:=False;
  mainfrm.TestBtn.Enabled:=False;
  mainfrm.kurzBtn.Enabled:=False;

    //Einmalig die Felder der Gesamt-Tabelle anlegen
    //Könnte irgendwo passieren, aber erst nachdem  !!!! Datenmodul völlig "created"
    //DAS OnCreate Ereignis ist anscheinend zu früh
    KaDataModule.DefiniereGesamtErgebnisDataSet;

    //Kundenauftrag anlegen
    ka:=TWKundenauftrag.Create(KaId);

    startzeit:= GetTickCount;
    msg:='Starte Auswertung fuer: ' + KaId + ' um ' + DateTimeToStr(startzeit);
    Tools.Log.Log(msg);
    Tools.ErrLog.Log(msg);
    mainfrm.ActivityIndicator1.Animate:=True;
    //Lies Kundenauftrag mit seinen Positionen
    KA.liesKopfundPositionen;

    Tools.Log.Trennzeile('-',80);
    Tools.Log.Log('Hole Kinder zu KA-Pos');
    Tools.Log.Trennzeile('-',80);
    //Hole VK zu Neupumpen
//    if not (Preisabfrage(KA,Zuordnungen)) then
//      exit;

//    KaDataModule.ErgebnisDS.EmptyDataSet;
//    KaDataModule.ErgebnisDS.SaveToFile();

    KA.holeKinder;

    ZuordnungAendern(KA,Zuordnungen);

    KA.SetzeEbenenUndMengen(0,1);
    KA.SummierePreise;

    KA.SammleAusgabeDaten;

    //
    KaDataModule.ErgebnisDS.SaveToFile(Settings.LogDir+'\Ergebnis.xml');
    mainfrm.ActivityIndicator1.Animate:=False;

    ErgebnisAusgabe(KaId);

    endzeit:=  GetTickCount;
    delta:=TTimeSpan.FromTicks(endzeit-startzeit).TotalMilliSeconds;

    msg:=Format('Auswertung fuer KA %s in %4.3f mSek beendet.' +
        #10 + '%d Datensaetze gefunden.',
        [KaId, delta,KaDataModule.ErgebnisDS.RecordCount]);
    ShowMessage(msg);

  finally
    mainfrm.langBtn.Enabled:=True;
    mainfrm.kurzBtn.Enabled:=True;
    mainfrm.TestBtn.Enabled:=True;

    Tools.Log.Close;
    Tools.ErrLog.Close;
    Result:=KA;

  end;

end;

// Abfrage der Preise fuer Neupumpen, da diese nicht im UNIPPS
function Preisabfrage(KA:TWKundenauftrag;var Zuordnungen:TWZuordnungen): Boolean;
var
  VkRabattiert: Double;
  I,IdPos,ZuPos:Integer;
  KaPos,VaterKaPos:TWKundenauftragsPos;
  Zuordnung:TWZuordnung;

begin

    //Daten einsammeln; bis hier nur Kundenauftrag mit Positionen
    KA.SammleAusgabeDaten;

    //User fragen
    KaDataModule.ErzeugeAusgabeFuerPreisabfrage;
    PreisFrm.DataSource1.DataSet:=PreisFrm.PreisDS;

    if not (PreisFrm.ShowModal=mrOK) then
    begin
      Result:=False;
      exit;
    end;

    //Preise ins Objekt schreiben und Zuordnungsliste erstellen
    PreisFrm.PreisDS.First;
    while not PreisFrm.PreisDS.Eof do
    begin
      VkRabattiert:=PreisFrm.PreisDS.FieldByName('vk_netto').AsFloat;
      IdPos:=PreisFrm.PreisDS.FieldByName('id_pos').AsInteger;
      //Hole KAPos aus Stueli des KA
      KaPos:=TWKundenauftragsPos(KA.Stueli[IdPos]);
      //VK eintragen
      KaPos.VerkaufsPreisRabattiert:=VkRabattiert;

      ZuPos:=PreisFrm.PreisDS.FieldByName('ZuKAPos').AsInteger;
      if ZuPos<>0 then
      begin
        I:=length(Zuordnungen);
        setlength(Zuordnungen,I+1);
        Zuordnung.VaterPos:=ZuPos;
        Zuordnung.KindPos:=IdPos;
        Zuordnungen[I]:=Zuordnung;
      end;

      PreisFrm.PreisDS.next;
    end;

    Result:=True;

end;

procedure ZuordnungAendern(KA:TWKundenauftrag;Zuordnungen:TWZuordnungen);
var
  I,IdPos:Integer;
  KindKaPos,VaterKaPos:TWKundenauftragsPos;
  Zuordnung:TWZuordnung;

begin

    //Positionen die zu anderen Positionen zaehlen sollen (z.B. Motoren) umhaengen
    for I := 0 to length(Zuordnungen)-1 do
    begin
      Zuordnung:=Zuordnungen[I];
        //Hole Vater-KAPos aus Stueli des KA
        VaterKaPos:=TWKundenauftragsPos(KA.Stueli[Zuordnung.VaterPos]);
        //Hole Unter-KAPos aus Stueli des KA
        KindKaPos:=TWKundenauftragsPos(KA.Stueli[Zuordnung.KindPos]);
        VaterKaPos.StueliTakePosFrom(KindKaPos);
    end;

end;

procedure ErgebnisDrucken(KA:TWKundenauftrag);
var
  Ausgabe:TWDataSetPrinter;
  Index:Integer;
  txt:String;
begin

  Ausgabe:=TWDataSetPrinter.Create(nil,'Microsoft Print to PDF',
                                            KaDataModule.AusgabeDS);
  Ausgabe.Tabelle.Ausrichtung[3]:=d;
  Ausgabe.Tabelle.NachkommaStellen[3]:=2;

  Ausgabe.Kopfzeile.TextLinks:='Präferenzkalkulation';
  Ausgabe.Dokumentenkopf.TextLinks:='Präferenzkalkulation';
  Ausgabe.Kopfzeile.TextMitte:=  'Auftragsnr: ' + KA.KaId;
  Ausgabe.Dokumentenkopf.TextMitte:=  'Auftragsnr: ' + KA.KaId;
  DateTimeToString(txt, 'dd.mm.yy hh:mm', System.SysUtils.Now);
  Ausgabe.Kopfzeile.TextRechts:=txt;
  Ausgabe.Fusszeile.TextLinks:=GetUsername;


  try
  Ausgabe.Drucken();
  finally
    if Ausgabe.Drucker.Printing then
      Ausgabe.Drucker.EndDoc;
  end;


end;

procedure ErgebnisAusgabe(KaId:String);
begin

  //Fülle Ausgabe-Tabelle mit vollem Umfang (z Debuggen)
  KaDataModule.ErzeugeAusgabeVollFuerDebug;
  //KaDataModule.AusgabeDS.Print; zum Test der Eigenschaften

  //Ausgabe als CSV
  KaDataModule.AusgabeAlsCSV(Settings.LogDir, KaId + '_Struktur.csv');

  //Fülle AusgabeDS mit Teilumfang zur Ausgabe der Doku der Kalkulation
  KaDataModule.ErzeugeAusgabeKurzFuerDoku;
//  KaDataModule.AusgabeDS.SaveToFile(Settings.LogDir+'\AusgabeKurz.xml');

  //Ausgabe als CSV
  KaDataModule.AusgabeAlsCSV(Settings.LogDir, KaId + '_Kalk.csv');

  //Daten anzeigen
  if Settings.GuiMode then
  begin
  KaDataModule.ErzeugeAusgabeVollFuerDebug;
    //Belege DataSource1 mit dem Default AusgabeDS
    mainfrm.DataSource1.DataSet:=KaDataModule.AusgabeDS;
  end;

end;

///<summary> Einsprung fuer Konsolen-Version </summary>
///<remarks> Was hier steht, wird automatisch ausgeführt.
///Ablaufänderungen also hier vornehmen.
///</remarks>
procedure RunItKonsole;
begin

  //Logger oeffnen
  Tools.Log.OpenNew(Settings.ApplicationBaseDir,'data\output\BatchLog.txt');
  Tools.ErrLog.OpenNew(Settings.ApplicationBaseDir,'data\output\BatchErrLog.txt');

  InitCopyUNI2SQLite;
  //Einige Einzelaufträge
//  KaNurAuswerten('142591'); //Error  Keine Positionen zum FA >616451< gefunden.
//  KaNurAuswerten('144729');
KaNurAuswerten('142567'); //2Pumpen
//  KaNurAuswerten('142302'); //Ersatz
//  KaNurAuswerten('144734');   //Fehler
//  KaNurAuswerten('142120');   //Fehler


//  Check100;

  Tools.Log.Close;
  Tools.ErrLog.Close;

end;


///<summary> Einsprung fuer GUI Version fuer automatischen Testlauf
///</summary>
function RunItGui:TWKundenauftrag;
begin

//test;
//  mainNonGui.KaAuswerten('142302'); //Ersatz
//  Result:= mainNonGui.KaAuswerten('144729');
  Result:= mainNonGui.KaAuswerten('144927');
//  Result:= mainNonGui.KaAuswerten('142567'); //2Pumpen
//  Tests.Bestellung;
//  mainNonGui.KaAuswerten('144734'); //Error
//  mainNonGui.KaAuswerten('142591'); //Error

end;


end.
