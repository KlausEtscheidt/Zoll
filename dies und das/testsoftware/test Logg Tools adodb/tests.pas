unit tests;

interface

uses SysUtils, Tools, Logger, Data.DB,
      ADOConnector, BaumQryUNIPPS, BaumQrySQLite;
//      UNIPPSConnect, BaumQryUNIPPS, SQLiteConnect, BaumQrySQLite;

procedure RunTests();
procedure Uni2SQLite();
procedure TestTest();

implementation

procedure RunTests();
begin
  Uni2SQLite;
end;

procedure Uni2SQLite();
//kopiert von UNIPPS nach SQLite
var
  dbSQLiteConn,dbUniConn: TZADOConnector;
  QrySQLite: TZBaumQrySQLite;
  QryUNIPPS: TZBaumQryUNIPPS;
  gefunden:Boolean;

begin
  //Globale Var init
  Tools.Init;
  //Logger oeffnen
  Tools.Log.OpenNew(Tools.ApplicationBaseDir,'FullLog.txt');

  //DB-Verbindungen anlegen und DB's öffnen
  dbUniConn:=TZADOConnector.Create(nil);
  dbUniConn.ConnectToUNIPPS();
  //DB oeffnen  Pfad aus globaler Tools.SQLiteFile
  dbSQLiteConn:=TZADOConnector.Create(nil);
  dbSQLiteConn.ConnectToSQLite(Tools.SQLiteDBFileName);

  //Query fuer UNIPPS anlegen und Verbindung setzen
  QryUNIPPS:=TZBaumQryUNIPPS.Create(nil);
  QryUNIPPS.Connector:=dbUniConn;
  //Fuer Export nach SQLite
  //Flag und SQLite-Verbindung einmalig in Klassenvariable
  QryUNIPPS.Export2SQLite:=True;
  QryUNIPPS.SQLiteConnector:=dbSQLiteConn;
  //Abfragen
  gefunden := QryUNIPPS.SucheKundenRabatt('1120840');

end;

procedure TestTest();

var
  dbSQLiteConn,dbSQLiteConn2,dbUniConn: TZADOConnector;
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

  dbUniConn:=TZADOConnector.Create(nil);
  dbUniConn.ConnectToUNIPPS();
  //DB oeffnen  Pfad aus globaler Tools.SQLiteFile
  dbSQLiteConn:=TZADOConnector.Create(nil);
  dbSQLiteConn.ConnectToSQLite(Tools.SQLiteDBFileName);
//  dbSQLiteConn2:=TZADOConnector.Create(nil);
//  var path2:='C:\Users\Klaus Etscheidt\Documents\Embarcadero\' +
//                 'Studio\Projekte\Zoll\data\db\zoll.sqlite';
//  dbSQLiteConn2.ConnectToSQLite(path2);
  var Tabs:TArray<String>;
  Tabs:=dbUniConn.Tabellen;
{
  // Query anlegen
  QrySQLite:=TZBaumQrySQLite.Create(nil);
  // einmalig DB-Verbindung setzen (wird als Klassenvariable gemerkt)
  QrySQLite.Connector:=dbSQLiteConn;

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
 }

  QryUNIPPS:=TZBaumQryUNIPPS.Create(nil);
  QryUNIPPS.Connector:=dbUniConn;
  //Fuer Export nach SQLite einmalig in Klassenvar
  QryUNIPPS.Export2SQLite:=True;
  QryUNIPPS.SQLiteConnector:=dbSQLiteConn;
  //Abfragen
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
