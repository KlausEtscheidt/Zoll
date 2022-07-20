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
                 'Zoll\data\db\zoll_neu.sqlite';
type
  TZUNIPPSQry = TZBaumQrySQLite;

{$ELSE}
const LogDir: String =
    'C:\Users\Klaus Etscheidt\Documents\Embarcadero\Studio\Projekte\'
    +'zoll\data\output';
const SQLiteDBFileName: String = 'C:\Users\Etscheidt\Documents\Embarcadero\' +
                 'Studio\Projekte\Zoll\data\db\zoll_neu.sqlite';

type
  TZUNIPPSQry = TZBaumQryUNIPPS;

{$ENDIF}

procedure init();
function GetQuery() : TZUNIPPSQry;

var
  Log: TLogFile;
  ErrLog: TLogFile;
  CSVKurz: TLogFile;
  CSVLang: TLogFile;
  ApplicationBaseDir: String;
  DbConnector:TZADOConnector;

implementation

procedure init();
begin
  Log:=TLogFile.Create();
  ErrLog:=TLogFile.Create();
  CSVKurz:=TLogFile.Create();
  CSVLang:=TLogFile.Create();
  ApplicationBaseDir:=ExtractFileDir(ParamStr(0));
  ApplicationBaseDir:=ExtractFileDir(ExtractFileDir(ApplicationBaseDir));
   DbConnector:=TZADOConnector.Create(nil);
   {$IFDEF HOME}
   DbConnector.ConnectToSQLite(SQLiteDBFileName);
   {$ELSE}
   DbConnector.ConnectToUNIPPS();
  {$ENDIF}


end;

function GetQuery() : TZUNIPPSQry;
var
  UNIPPSQry: TZUNIPPSQry;

begin
    //Query erzeugen
   UNIPPSQry := TZUNIPPSQry.Create(nil);
   //Connector in Klassenvariable
   UNIPPSQry.Connector:=DbConnector;
   Result:= UNIPPSQry;
end;

end.
