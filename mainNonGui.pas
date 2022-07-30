unit mainNonGui;

interface

uses  System.SysUtils, Tests, Kundenauftrag,  Tools, ADOQuery ,  ADOConnector,
      BaumQrySQLite, BaumQryUNIPPS ;

type
    EStuBaumMainExc = class(Exception);

procedure RunItGui;
procedure RunItKonsole;
procedure KaAuswerten(ka_id:string);
procedure KaNurAuswerten(ka_id:string);
procedure Check100;
procedure InitCopyUNI2SQLite;

implementation

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
procedure KaAuswerten(ka_id:string);
var ka:TWKundenauftrag;
begin

  try

    //Globals setzen und initialiseren
    Tools.Init;

    //Ka anlegen
    ka:=TWKundenauftrag.Create(ka_id);

    //Logger oeffnen
    Tools.Log.OpenAppend(Tools.LogDir,'FullLog.txt');
    Tools.ErrLog.OpenAppend(Tools.logdir,'ErrLog.txt');

    //auswerten
    ka.auswerten;

    Tools.Log.Log('--------- Kundenauftrag: '+ka_id + ' fertig.');
    Tools.ErrLog.Log('--------- Kundenauftrag: '+ka_id + ' fertig.');

  finally

      //Logger schlie�en
      Tools.Log.Close;
      Tools.ErrLog.Close;
      ka.Free;

  end;

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

//  InitCopyUNI2SQLite;
  //Einige Einzelaufträge
//  KaNurAuswerten('142591'); //Error  Keine Positionen zum FA >616451< gefunden.
//  KaNurAuswerten('144729');
//  KaNurAuswerten('142567'); //2Pumpen
//  KaNurAuswerten('142302'); //Ersatz

  KaAuswerten('142567'); //2Pumpen

//  Check100;

  Tools.Log.Close;
  Tools.ErrLog.Close;

end;

///<summary> Einsprung fuer GUI Version fuer automatischen Testlauf
///</summary>
procedure RunItGui;
begin

//  mainNonGui.KaAuswerten('142591'); //Error
//  mainNonGui.KaAuswerten('144729');
  mainNonGui.KaAuswerten('142567'); //2Pumpen
//  Tests.Bestellung;
//  mainNonGui.KaAuswerten('144734');
//  mainNonGui.KaAuswerten('142302'); //Ersatz

end;


end.
