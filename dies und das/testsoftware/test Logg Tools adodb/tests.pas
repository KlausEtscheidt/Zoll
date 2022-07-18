unit tests;

interface

uses SysUtils, Tools, Logger, Data.DB,
      UNIPPSConnect, BaumQryUNIPPS, SQLiteConnect, BaumQrySQLite;

procedure RunTests();

implementation

procedure RunTests();

var
  dbSQLiteConn: TZSQLiteConnection;
  dbUniConn: TZUNIPPSConnection;
  QrySQLite: TZBaumQrySQLite;
  QryUNIPPS: TZBaumQryUNIPPS;
  gefunden:Boolean;
  field:TField;
  text:String;

begin

  //Globale Var init
  Tools.Init;
  //Logger oeffnen
  Tools.Log.OpenNew(Tools.ApplicationBaseDir,'FullLog.txt');

  //DB oeffnen  Pfad aus globaler Tools.SQLiteFile
  dbUniConn:=TZUNIPPSConnection.Create(nil);
  dbSQLiteConn:=TZSQLiteConnection.Create(nil, Tools.SQLiteFile);

  // Query anlegen
  QrySQLite:=TZBaumQrySQLite.Create(nil);
  // einmalig DB-Verbindung setzen (wird als Klassenvariable gemerkt)
  QrySQLite.dbconn:=dbSQLiteConn.dbconn;

  //Abfragen
  gefunden := QrySQLite.SucheKundenRabatt('1120840');

  Tools.Log.WriteLine('Test-Lauf vom '+DateTimeToStr(Now));
  while not QrySQLite.Eof do
  begin
      text:='';
      for field in QrySQLite.Fields do
      begin
          text:=text + field.FieldName +': ' + field.AsString + '; ';
      end;
      Tools.Log.WriteLine(text);
      QrySQLite.Next;
      Tools.Log.WriteLine(QrySQLite.FieldByName('datum_von').AsString);
  end;
  Tools.Log.Close;


  QryUNIPPS:=TZBaumQryUNIPPS.Create(nil);
  QryUNIPPS.dbconn:=dbUniConn.dbconn;
  gefunden := QryUNIPPS.SucheKundenRabatt('1120840');

  Tools.Log.WriteLine('Test-Lauf vom '+DateTimeToStr(Now));
  while not QryUNIPPS.Eof do
  begin
      text:='';
      for field in QryUNIPPS.Fields do
      begin
          text:=text + field.FieldName +': ' + field.AsString + '; ';
      end;
      Tools.Log.WriteLine(text);
      QryUNIPPS.Next;
      Tools.Log.WriteLine(QryUNIPPS.FieldByName('datum_von').AsString);
  end;


Tools.Log.Close;

end;


end.
