unit Init;

interface

uses
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

procedure start();
function GetQuery() : TWQry;

var
  Log: TLogFile;
  ErrLog: TLogFile;
  DbConnector:TWADOConnector;

implementation

procedure start();
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

end.
