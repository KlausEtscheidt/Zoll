unit tests;

interface

uses SysUtils, Tools, Logger, Data.DB,
      ADOQuery,ADOConnector, BaumQryUNIPPS, BaumQrySQLite;

//      UNIPPSConnect, BaumQryUNIPPS, SQLiteConnect, BaumQrySQLite;

procedure RunTests();
procedure Uni2SQLite();
procedure Unipps();
procedure TestTest();

implementation

uses testfrm;

procedure RunTests();
begin
  //Uni2SQLite;
  Unipps;
end;

procedure Unipps();
  var  KAQry: TZUNIPPSQry;
  var gefunden: Boolean;
  var Feldnamen,Feldwerte: System.TArray<String>;
  var FeldNamenTxt,FeldWerteTxt: String;
begin
   Tools.Init;
  //Logger oeffnen
  Tools.Log.OpenNew(Tools.ApplicationBaseDir,'TestLog.txt');

   KAQry := Tools.getQuery;
   //  131645	144211	142302	142567	142573
   if KAQry.IsConnected then
       gefunden := KAQry.SucheKundenAuftragspositionen('142302');
//   Form1.DataSource1.DataSet:=KaQry;
//   Form1.DataSource1.Enabled := true;
   Feldnamen:=KAQry.GetFieldNames();
   Feldwerte:=KAQry.GetFieldValues();
   Tools.Log.Log(KAQry.GetFieldNamesAsText);
   while not KAQry.Eof do
   begin
      Tools.Log.Log(KAQry.GetFieldValuesAsText);
      KAQry.Next;
   end;
   Tools.Log.Close;
end;

procedure Uni2SQLite();
//kopiert von UNIPPS nach SQLite
var
  dbSQLiteConn,dbUniConn: TZADOConnector;
  QrySQLite: TZBaumQrySQLite;
  QryUNIPPS: TZBaumQryUNIPPS;
  QryADO,QryADO2: TZADOQuery;
  gefunden:Boolean;
  Sql:String;

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
  //Abfragen ueber vordefinierte
  gefunden := QryUNIPPS.SucheKundenRabatt('1120840');

  //Abfragen ueber Standard
  QryADO:=TZADOQuery.Create(nil);
  QryADO.Connector:=dbUniConn;

    Sql:= 'SELECT first 200  astuelipos.ident_nr1 AS id_stu, astuelipos.ident_nr2 as id_pos, '
      + 'astuelipos.ueb_s_nr, astuelipos.ds, astuelipos.set_block, '
      + 'astuelipos.pos_nr, astuelipos.t_tg_nr, astuelipos.oa, '
      + 'astuelipos.typ, astuelipos.menge '
      + 'FROM astuelipos;';

     sql := 'select first 200 auftragpos.ident_nr1 as id_stu, auftragpos.ident_nr2 as id_pos, '
    +  ' auftragkopf.kunde, auftragpos.besch_art, '
    +  ' auftragkopf.klassifiz, auftragpos.pos as pos_nr, auftragpos.t_tg_nr, '
    +  'auftragpos.oa, auftragpos.typ, auftragpos.menge, auftragpos.preis '
    +  'from auftragkopf INNER JOIN auftragpos ON auftragkopf.ident_nr = auftragpos.ident_nr1; '  ;

  gefunden := QryADO.RunSelectQuery(Sql);
  QryADO2:=TZADOQuery.Create(nil);
  QryADO2.Connector:=dbSQLiteConn;
  while not QryADO.eof do
  begin
//      QryADO2.InsertFields('astuelipos',QryADO.Fields);
      QryADO2.InsertFields('auftragkopf',QryADO.Fields);
      QryADO.Next;
  end;


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
