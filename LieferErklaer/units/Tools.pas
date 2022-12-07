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
function GetConnection() : TWDBConnector;
function GetQuery(ForThread:Boolean=False) : TWQry;
function GetTable(Tablename : String;ForThread:Boolean=False) : TWTable;

var
  IsInitialized:Boolean;
  DbConnector:TWDBConnector;
  DbConnector2:TWDBConnector; //Fuer Thread-Abläufe
  ApplicationBaseDir: String;

const
  SQLiteDBFileName: String = '\db\lekl.db';
  AccessDBFileName: String = '\db\LieferErklaer.accdb';

implementation

//Liefert verbundene Connection zu einer Access- oder SQLite-Datenbank
function GetConnection() : TWDBConnector;
  var
    myConnector:TWDBConnector;
begin
    myConnector:= nil;
{$IFDEF FIREDAC}
    myConnector:=TWFDConnector.Create(nil);
    myConnector.LockingMode:='Normal'; //multiuser
//    myConnector.Synchronous:='Normal';  //multiuser
    myConnector.Synchronous:='Full';  //multiuser
{$ELSE}
    myConnector:=TWADOConnector.Create(nil);
{$ENDIF}

  try
    {$IFDEF SQLITE}
    //nur fuer Tests auch im Office SQLITE statt UNIPPS nutzen
       myConnector.ConnectToSQLite(ApplicationBaseDir+SQLiteDBFileName);
    {$ELSE}
       myConnector.ConnectToAccess(ApplicationBaseDir+AccessDBFileName);
    {$ENDIF}
  except
     on E: Exception do
    begin
       ShowMessage(E.Message);
       myConnector:=nil;
//       raise;
    end;

  end;

  Result:=myConnector;

end;

procedure init();

begin
  //Wir wollen das hier nur 1 mal ausführen
  if IsInitialized then
    exit;

   ApplicationBaseDir:=ExtractFileDir(ParamStr(0));
{$IFNDEF RELEASE}
  //2 Ebenen hoch, wenn kein Release-Build vorliegt
   ApplicationBaseDir:=ExtractFileDir(ExtractFileDir(ApplicationBaseDir));
{$ENDIF}

  //Globalen Connector fuer alle "normalen" Queries setzen
  DbConnector:=GetConnection();
  if not assigned(DbConnector) then
    exit;

  //Globalen Connector fuer alle Queries, die in einem eigenen Thread laufen
  DbConnector2:=GetConnection();
  if not assigned(DbConnector) then
    exit;

  IsInitialized:=True;

end;

function GetQuery(ForThread:Boolean=False) : TWQry;
var
  Qry: TWQry;
begin
    //Query erzeugen
   Qry := TWQry.Create(nil);
   //Connector setzen
   if ForThread then
     Qry.Connector:=DbConnector2
   else
     Qry.Connector:=DbConnector;
   Qry.GuiMode:=True;
   Result:= Qry;
end;

function GetTable(Tablename : String;ForThread:Boolean=False) : TWTable;
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
