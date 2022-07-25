program Batchlauf;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  ActiveX,
  Tools in 'lib\Tools\Tools.pas',
  ADOQuery in 'lib\Datenbank\ADOQuery.pas',
  ADOConnector in 'lib\Datenbank\ADOConnector.pas',
  BaumQrySQLite in 'lib\Datenbank\BaumQrySQLite.pas',
  BaumQryUNIPPS in 'lib\Datenbank\BaumQryUNIPPS.pas',
  Kundenauftrag in 'lib\UNIPPS\Kundenauftrag.pas';

procedure check100;
var
  dbSQLiteConn: TWADOConnector;
  QrySQLite: TWBaumQrySQLite;
  QryUNIPPS: TWBaumQryUNIPPS;
  gefunden:Boolean;
  Sql:String;
  ka_id: string;
  I: Integer;
  StartRecord: Integer;
  LastRecord: Integer;
  ka:TWKundenauftrag;

begin
  //Logger oeffnen
//  Tools.Log.OpenAppend(Tools.LogDir, 'FullLog.txt');
//  Tools.ErrLog.OpenAppend(Tools.logdir, 'ErrLog.txt');
  //Logger oeffnen
  Tools.Log.OpenNew(Tools.ApplicationBaseDir,'TestLog.txt');
  Tools.ErrLog.OpenNew(Tools.ApplicationBaseDir,'TestErrLog.txt');

  //SQLite-DB oeffnen  Pfad aus globaler Tools.SQLiteFile
  dbSQLiteConn:=TWADOConnector.Create(nil);
  dbSQLiteConn.ConnectToSQLite(Tools.SQLiteDBFileName);

  //Query fuer UNIPPS anlegen und Verbindung setzen
  QryUNIPPS:=Tools.GetQuery;

  //Fuer Export nach SQLite
  //Flag und SQLite-Verbindung einmalig in Klassenvariable
  QryUNIPPS.Export2SQLite:=True;
  QryUNIPPS.SQLiteConnector:=dbSQLiteConn;

  //Abfragen ueber flex. Query: 200 Kundenaufträeg
  sql := 'select first 401 ident_nr as ka_id from auftragkopf order by ka_id desc;';
  gefunden := QryUNIPPS.RunSelectQuery(Sql);

  StartRecord :=200;
  LastRecord:=400;
  QryUNIPPS.MoveBy(StartRecord);
  for I:=StartRecord to LastRecord do
  begin
      try
        //Hole Id des Auftrags
        ka_id:=QryUNIPPS.FindField('ka_id').AsString;
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
        end;
      end;

      Tools.Log.Log('--------- Kundenauftrag: '+ka_id + ' fertig.');
      Tools.ErrLog.Log('--------- Kundenauftrag: '+ka_id + ' fertig.');

      QryUNIPPS.Next;
  end;

  Tools.Log.Close;
  Tools.ErrLog.Close;

end;

begin
var answer:string;
  try

    CoInitialize(nil);

    //Globals setzen und initialiseren
    Tools.Init;

    check100;


  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  Writeln('Fertig');
  Readln(answer);
end.
