unit Tools;

interface

uses
System.SysUtils,  System.Classes, Vcl.Dialogs,
Data.Win.ADODB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
FDConnector,ADOConnector,QryAccess,QrySQLite ;

  type
{$IFDEF FIREDAC}
    TWDBConnector = TWFDConnector;
    TWTable = TFDTable;
{$ELSE}
    TWDBConnector = TWADOConnector;
    TWTable = TADOTable;
{$ENDIF}

  type
{$IFDEF SQLITE}
    TWQry = TWQrySQLite;
{$ELSE}
    TWQry = TWQryAccess;
{$ENDIF}

procedure init();
function GetQuery() : TWQry;
function GetTable(Tablename : String) : TWTable;

var
//  Log: TLogFile;
//  ErrLog: TLogFile;
  IsInitialized:Boolean;
  DbConnector:TWDBConnector;
  ApplicationBaseDir: String;

const
  SQLiteDBFileName: String = '\db\lekl.db';
  AccessDBFileName: String = '\db\LieferErklaer.accdb';

implementation

procedure init();
begin
  //Wir wollen das hier nur 1 mal ausführen
  if IsInitialized then
    exit;
  IsInitialized:=True;

   ApplicationBaseDir:=ExtractFileDir(ParamStr(0));
{$IFNDEF RELEASE}
  //2 Ebenen hoch, wenn kein Release-Build vorliegt
   ApplicationBaseDir:=ExtractFileDir(ExtractFileDir(ApplicationBaseDir));
{$ENDIF}

{$IFDEF FIREDAC}
    DbConnector:=TWFDConnector.Create(nil);
    DbConnector.LockingMode:='Normal'; //multiuser
//    DbConnector.Synchronous:='Normal';  //multiuser
    DbConnector.Synchronous:='Full';  //multiuser
{$ELSE}
    DbConnector:=TWADOConnector.Create(nil);
{$ENDIF}
//DbConnector.Create(nil);

  try
    {$IFDEF SQLITE}
    //nur fuer Tests auch im Office SQLITE statt UNIPPS nutzen
       DbConnector.ConnectToSQLite(ApplicationBaseDir+SQLiteDBFileName);
    {$ELSE}
       DbConnector.ConnectToAccess(ApplicationBaseDir+AccessDBFileName);
    {$ENDIF}
  except
     on E: Exception do
    begin
       ShowMessage(E.Message);
//       raise;
    end;

  end;

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

function GetTable(Tablename : String) : TWTable;
var
  Tab: TWTable;

begin
  //Tabelle erzeugen
  Tab := TWTable.Create(nil);
{$IFNDEF FIREDAC}
  Tab.TableDirect := True;
{$ENDIF}
  Tab.TableName := Tablename;
  //Connector setzen
  Tab.Connection := DbConnector.Connection;
  Result:= Tab;
end;

initialization

init();

end.
