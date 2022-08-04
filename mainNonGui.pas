unit mainNonGui;

interface

uses  System.SysUtils, System.TimeSpan, Vcl.Controls, Vcl.Dialogs, Windows,
      Tests, Kundenauftrag,KundenauftragsPos,  Tools, ADOQuery ,  ADOConnector,
      BaumQrySQLite, BaumQryUNIPPS,DatenModul,Preiseingabe  ;

type
    EStuBaumMainExc = class(Exception);

procedure RunItGui;
procedure RunItKonsole;
procedure KaAuswerten(KaId:string);
procedure KaNurAuswerten(KaId:string);
function Preisabfrage(KA:TWKundenauftrag): Boolean;
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
    mainfrm.ActivityIndicator1.Animate:=True;
    //Lies Kundenauftrag mit seinen Positionen
    KA.liesKopfundPositionen;

    if not (Preisabfrage(KA)) then
      exit;

//    KaDataModule.ErgebnisDS.EmptyDataSet;
//    KaDataModule.ErgebnisDS.SaveToFile();

    KA.holeKinder;
    KA.SetzeEbenenUndMengen(0,1);
    KA.SummierePreise;

    KA.SammleAusgabeDaten;

    //
    KaDataModule.ErgebnisDS.SaveToFile(Tools.LogDir+'\Ergebnis.xml');
    mainfrm.ActivityIndicator1.Animate:=False;

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

// Abfrage der Preise fuer Neupumpen, da diese nicht im UNIPPS
function Preisabfrage(KA:TWKundenauftrag):Boolean;
var
  VkRabattiert: Double;
  IdPos,ZuPos:Integer;
  KaPos,VaterKaPos:TWKundenauftragsPos;
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

    //Preise ins Objekt schreiben
    PreisFrm.PreisDS.First;
    while not PreisFrm.PreisDS.Eof do
    begin
      VkRabattiert:=PreisFrm.PreisDS.FieldByName('vk_netto').AsFloat;
      IdPos:=PreisFrm.PreisDS.FieldByName('id_pos').AsInteger;
      //Hole KAPos aus Stueli des KA
      KaPos:=TWKundenauftragsPos(KA.Stueli[IdPos]);
      KaPos.VerkaufsPreisRabattiert:=VkRabattiert;
      Tools.Log.Log('VK: '+FloatToStr(VkRabattiert));
      Tools.Log.Flush;
      PreisFrm.PreisDS.next;
    end;

    //Positionen die zu anderen Positionen zaehlen sollen (z.B. Motoren) umhaengen
    PreisFrm.PreisDS.First;
    while not PreisFrm.PreisDS.Eof do
    begin
      ZuPos:=PreisFrm.PreisDS.FieldByName('ZuKAPos').AsInteger;
      if ZuPos<>0 then
      begin
        IdPos:=PreisFrm.PreisDS.FieldByName('id_pos').AsInteger;
        //Hole Vater-KAPos aus Stueli des KA
        VaterKaPos:=TWKundenauftragsPos(KA.Stueli[ZuPos]);
        //Hole Unter-KAPos aus Stueli des KA
        KaPos:=TWKundenauftragsPos(KA.Stueli[IdPos]);
        //Fuege Unter-Pos zu VAter-Stueli
        { TODO :
  Prüfe ob IdPos in der neuen STU eindeutig ist  Besser ID ab 1000
  in Stulie prüfen ob dise frei und evtl höhere liefern
  Wir sind hier erst auf der Ebene KA-Pos. Neu Pos kommen hinzu }
        VaterKaPos.Stueli.Add(IdPos,KaPos);
        //Entferne Unter-Pos aus KA-Stueli
        KA.Stueli.Remove(IdPos);
      end;
      PreisFrm.PreisDS.next;
    end;



end;

procedure ErgebnisAusgabe(KaId:String);
begin
  //Fülle Ausgabe-Tabelle mit vollem Umfang (z Debuggen)
  KaDataModule.ErzeugeAusgabeVollFuerDebug;
  //KaDataModule.AusgabeDS.Print; zum Test der Eigenschaften

  //Ausgabe als CSV
  KaDataModule.AusgabeAlsCSV(Tools.LogDir, KaId + '_Struktur.csv');

  //Fülle AusgabeDS mit Teilumfang zur Ausgabe der Doku der Kalkulation
  KaDataModule.ErzeugeAusgabeKurzFuerDoku;

  //Ausgabe als CSV
  KaDataModule.AusgabeAlsCSV(Tools.LogDir, KaId + '_Kalk.csv');

  //Daten anzeigen
  if Tools.GuiMode then
  begin
  KaDataModule.ErzeugeAusgabeVollFuerDebug;
    //Belege DataSource1 mit dem Default AusgabeDS
    mainfrm.DataSource1.DataSet:=KaDataModule.AusgabeDS;
    mainfrm.langBtn.Enabled:=True;
    mainfrm.kurzBtn.Enabled:=True;
    mainfrm.TestBtn.Enabled:=True;
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
