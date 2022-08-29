unit Tools;

interface

uses
Settings, Logger,
ADOConnector, BaumQryUNIPPS, BaumQrySQLite;


{$IFDEF HOME}
type
  TWUNIPPSQry = TWBaumQrySQLite;

{$ELSE}

  {$IFDEF SQLITE}
  //nur fuer Tests auch im Office SQLITE statt UNIPPS nutzen
  type
    TWUNIPPSQry = TWBaumQrySQLite;
  {$ELSE}
  type
    TWUNIPPSQry = TWBaumQryUNIPPS;
  {$ENDIF}

{$ENDIF}

procedure init();
function GetQuery() : TWUNIPPSQry;

var
  Log: TLogFile;
  ErrLog: TLogFile;
  CSVKurz: TLogFile;
  CSVLang: TLogFile;
  DbConnector:TWADOConnector;

implementation

procedure init();
begin
  Log:=TLogFile.Create();
  ErrLog:=TLogFile.Create();
  CSVKurz:=TLogFile.Create();
  CSVLang:=TLogFile.Create();
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

function GetQuery() : TWUNIPPSQry;
var
  UNIPPSQry: TWUNIPPSQry;

begin
    //Query erzeugen
   UNIPPSQry := TWUNIPPSQry.Create(nil);
   //Connector setzen
   UNIPPSQry.Connector:=DbConnector;
   Result:= UNIPPSQry;
end;

end.
