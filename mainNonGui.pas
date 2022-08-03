unit mainNonGui;

interface

uses  System.SysUtils, System.TimeSpan, Vcl.Controls, Vcl.Dialogs, Windows,
      Tests, Kundenauftrag,  Tools, ADOQuery ,  ADOConnector,
      BaumQrySQLite, BaumQryUNIPPS,DatenModul,Preiseingabe  ;

type
    EStuBaumMainExc = class(Exception);

procedure RunItGui;
procedure RunItKonsole;
procedure KaAuswerten(KaId:string);
procedure KaNurAuswerten(ka_id:string);
procedure ErgebnisAusgabe(KaId:string);
procedure Check100;
procedure InitCopyUNI2SQLite;
procedure test;

implementation

uses main;

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
  dbSQLiteConn.ConnectToSQLite(Tools.SQLiteDBFileName);

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
procedure KaNurAuswerten(ka_id:string);
var ka:TWKundenauftrag;
begin

    try
      writeln(ka_id);
      Tools.Log.Log('------- Kundenauftrag: '+ka_id);
      Tools.ErrLog.Log('------- Kundenauftrag: '+ka_id);

      //Ka anlegen
      ka:=TWKundenauftrag.Create(ka_id);

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
//Nutzt  TWKundenauftrag.auswerten fuer vollen Ablauf
procedure KaAuswerten(KaId:string);
var
  KA:TWKundenauftrag;
  startzeit,endzeit: Int64;
  delta:Double;
  msg:String;

begin

  try

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

    //Lies Kundenauftrag mit seinen Positionen
    KA.liesKopfundPositionen;

    //Daten einsammeln; bis hier nur Kundenauftrag mit Positionen
    KA.SammleAusgabeDaten;

    //Abfrage der Preise fuer Neupumpen, da diese nicht im UNIPPS
//    PreisFrm.PreisDS.CreateDataSet;
//    KaDataModule.ErzeugeAusgabeFuerPreisabfrage;
//    PreisFrm.DataSource1.DataSet:=PreisFrm.PreisDS;
//
//    if not (PreisFrm.ShowModal=mrOK) then
//      exit;

//    KaDataModule.ErgebnisDS.EmptyDataSet;
//    KaDataModule.ErgebnisDS.SaveToFile();

    KA.holeKinder;
    KA.SetzeEbenenUndMengen(0,1);
    KA.SummierePreise;

    KA.SammleAusgabeDaten;

    //
    KaDataModule.ErgebnisDS.SaveToFile(Tools.LogDir+'\Ergxx.xml');

    ErgebnisAusgabe(KaId);

    endzeit:=  GetTickCount;
    delta:=TTimeSpan.FromTicks(endzeit-startzeit).TotalMilliSeconds;

    msg:=Format('---------------Auswertung fuer KA %s in %4.3f mSek beendet.' +
        '%d Datensaetze gefunden.',
        [KaId, delta,KaDataModule.ErgebnisDS.RecordCount]);
//    ShowMessage(msg);

    Tools.Log.Log(msg);
    Tools.ErrLog.Log(msg);


  finally

      ka.Free;

  end;

end;

procedure ErgebnisAusgabe(KaId:String);
begin
  //Fülle Ausgabe-Tabelle mit vollem Umfang (z Debuggen)
  KaDataModule.ErzeugeAusgabeVollFuerDebug;
  KaDataModule.AusgabeDS.Print;

  //Ausgabe als CSV
  KaDataModule.AusgabeAlsCSV(Tools.LogDir, KaId + '_Struktur.csv');

  //Fülle Tabelle mit Teilumfang zur Ausgabe der Doku der Kalkulation
  KaDataModule.ErzeugeAusgabeKurzFuerDoku;

  //Ausgabe als CSV
  KaDataModule.AusgabeAlsCSV(Tools.LogDir, KaId + '_Kalk.csv');

  //Daten anzeigen
  if Tools.GuiMode then
  begin
    KaDataModule.ErzeugeAusgabeVollFuerDebug;
    mainfrm.DataSource1.DataSet:=KaDataModule.AusgabeDS;
    mainfrm.langBtn.Enabled:=True;
    mainfrm.langBtn.Enabled:=True;
  end;


end;


procedure test;
var KA:TWKundenauftrag;
begin
    //Ka anlegen
    ka:=TWKundenauftrag.Create('142302');
    KaDataModule.ErgebnisDS.FileName:='';
    KaDataModule.DefiniereGesamtErgebnisDataSet;
    KaDataModule.ErgebnisDS.Active:=True;
    KaDataModule.ErgebnisDS.EmptyDataSet;
    KaDataModule.ErgebnisDS.Append;
    KaDataModule.ErgebnisDS.AddData('PreisJeLME',123.345678) ;
    KaDataModule.ErgebnisDS.SaveToFile(Tools.LogDir+'\Ergxx2.xml');
    ErgebnisAusgabe('142302');
end;

///<summary> Einsprung fuer Konsolen-Version </summary>
///<remarks> Was hier steht, wird automatisch ausgeführt.
///Ablaufänderungen also hier vornehmen.
///</remarks>
procedure RunItKonsole;
begin

  //Logger oeffnen
  Tools.Log.OpenNew(Tools.ApplicationBaseDir,'data\output\BatchLog.txt');
  Tools.ErrLog.OpenNew(Tools.ApplicationBaseDir,'data\output\BatchErrLog.txt');

  InitCopyUNI2SQLite;
  //Einige Einzelaufträge
//  KaNurAuswerten('142591'); //Error  Keine Positionen zum FA >616451< gefunden.
//  KaNurAuswerten('144729');
//  KaNurAuswerten('142567'); //2Pumpen
//  KaNurAuswerten('142302'); //Ersatz
//  KaNurAuswerten('144734');   //Fehler
  KaNurAuswerten('142120');   //Fehler


//  Check100;

  Tools.Log.Close;
  Tools.ErrLog.Close;

end;


///<summary> Einsprung fuer GUI Version fuer automatischen Testlauf
///</summary>
procedure RunItGui;
begin

//test;
  mainNonGui.KaAuswerten('142302'); //Ersatz
//  mainNonGui.KaAuswerten('144729');
//  mainNonGui.KaAuswerten('142567'); //2Pumpen
//  Tests.Bestellung;
//  mainNonGui.KaAuswerten('144734'); //Error
//  mainNonGui.KaAuswerten('142591'); //Error

end;


end.
