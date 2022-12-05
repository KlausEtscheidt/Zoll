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

{$IFDEF FIREDAC}
 type
    TWQry = TWQrySQLite;
    TWTable = TFDTable;
{$ELSE}
  type
    TWTable = TADOTable;
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
{$ENDIF}

procedure init();
function GetQuery() : TWQry;
function GetTable(Tablename : String) : TWTable;

var
//  Log: TLogFile;
//  ErrLog: TLogFile;
  IsInitialized:Boolean;
{$IFDEF FIREDAC}
  DbConnector:TWFDConnector;
{$ELSE}
  DbConnector:TWADOConnector;
{$ENDIF}

  ApplicationBaseDir: String;

const SQLiteDBFileName: String =
    '\db\lekl.db';
const AccessDBFileName: String =
    '\db\LieferErklaer.accdb';

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

//  Log:=TLogFile.Create();
//  ErrLog:=TLogFile.Create();
{$IFDEF FIREDAC}
  DbConnector:=TWFDConnector.Create(nil);
{$ELSE}
  DbConnector:=TWADOConnector.Create(nil);
{$ENDIF}
  try
   {$IFDEF HOME}
   DbConnector.ConnectToSQLite(ApplicationBaseDir+SQLiteDBFileName);
   {$ELSE}
      {$IFDEF SQLITE}
      //nur fuer Tests auch im Office SQLITE statt UNIPPS nutzen
         DbConnector.ConnectToSQLite(ApplicationBaseDir+SQLiteDBFileName);
      {$ELSE}
         DbConnector.ConnectToAccess(ApplicationBaseDir+AccessDBFileName);
      {$ENDIF}

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

{$IFDEF FIREDAC}
function GetTable(Tablename : String) : TWTable;
var
  Tab: TFDTable;

begin
  //Tabelle erzeugen
  Tab := TFDTable.Create(nil);
//  Tab.TableDirect := True;
  Tab.TableName := Tablename;
  //Connector setzen
  Tab.Connection := DbConnector.Connection;
  Result:= Tab;
end;
{$ELSE}
function GetTable(Tablename : String) : TWTable;
var
  Tab: TADOTable;

begin
  //Tabelle erzeugen
  Tab := TADOTable.Create(nil);
  Tab.TableDirect := True;
  Tab.TableName := Tablename;
  //Connector setzen
  Tab.Connection := DbConnector.Connection;
  Result:= Tab;
end;
{$ENDIF}


initialization

init();

end.
