unit Tools;

interface

uses
Data.Win.ADODB,
Settings, Logger, ADOConnector,QryAccess,QrySQLite ;


{$IFDEF HOME}
type
  TWQry = TWQrySQLite;

{$ELSE}

  {$IFDEF SQLITE}
  //nur fuer Tests auch im Office SQLITE statt Access nutzen
  type
    TWQry = TWQrySQLite;
  {$ELSE}
  type
    TWQry = TWQryAccess;
  {$ENDIF}

{$ENDIF}

procedure init();
function GetQuery() : TWQry;
function GetTable(Tablename : String) : TADOTable;

var
  Log: TLogFile;
  ErrLog: TLogFile;
  DbConnector:TWADOConnector;

implementation

procedure init();
begin
  Log:=TLogFile.Create();
  ErrLog:=TLogFile.Create();
  DbConnector:=TWADOConnector.Create(nil);
   {$IFDEF HOME}
   DbConnector.ConnectToSQLite(SQLiteDBFileName);
   {$ELSE}
      {$IFDEF SQLITE}
      //nur fuer Tests auch im Office SQLITE statt UNIPPS nutzen
         DbConnector.ConnectToSQLite(SQLiteDBFileName);
      {$ELSE}
         DbConnector.ConnectToUNIPPS();
      {$ENDIF}

  {$ENDIF}

end;

function GetQuery() : TWQry;
var
  Qry: TWQry;

begin
    //Query erzeugen
   Qry := TWQry.Create(nil);
   //Connector setzen
   Qry.Connector:=DbConnector;
   Result:= Qry;
end;

function GetTable(Tablename : String) : TADOTable;
var
  Tab: TADOTable;

begin
  //Query erzeugen
  Tab := TADOTable.Create(nil);
  Tab.TableDirect := True;
  Tab.TableName := Tablename;
  //Connector setzen
  Tab.Connection := DbConnector.Connection;
  Result:= Tab;
end;

end.
