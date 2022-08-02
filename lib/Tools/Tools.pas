unit Tools;

interface

uses System.IOUtils,System.SysUtils,Logger,
ADOConnector, BaumQryUNIPPS, BaumQrySQLite;
//Vcl.Forms,  System.IOUtils, System.Classes, Logger


{$IFDEF HOME}
const LogDir: String =
    'C:\Users\Klaus Etscheidt\Documents\Embarcadero\Studio\Projekte\' +
    'zoll\data\output';
const SQLiteDBFileName: String =
    'C:\Users\Klaus Etscheidt\Documents\Embarcadero\Studio\Projekte\' +
                 'Zoll\data\db\zoll.sqlite';
type
  TWUNIPPSQry = TWBaumQrySQLite;

{$ELSE}
const LogDir: String =
    'C:\Users\Etscheidt\Documents\Embarcadero\Studio\Projekte\' +
                   'Zoll\data\output';
const SQLiteDBFileName: String = 'C:\Users\Etscheidt\Documents\Embarcadero\' +
                 'Studio\Projekte\Zoll\data\db\zoll.sqlite';

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
  ApplicationBaseDir: String;
  DbConnector:TWADOConnector;
  GuiMode:Boolean;

implementation

procedure init();
begin
  Log:=TLogFile.Create();
  ErrLog:=TLogFile.Create();
  CSVKurz:=TLogFile.Create();
  CSVLang:=TLogFile.Create();
  ApplicationBaseDir:=ExtractFileDir(ParamStr(0));
  ApplicationBaseDir:=ExtractFileDir(ExtractFileDir(ApplicationBaseDir));
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
   //Connector in Klassenvariable
   UNIPPSQry.Connector:=DbConnector;
   Result:= UNIPPSQry;
end;

end.
