unit SQLiteConnect;

interface

  uses System.Classes,FireDAC.Phys.SQLite ,FireDAC.Stan.Def ,FireDAC.Comp.Client,
        DBQrySQLite;

  type
    TZDbConnector = class
      dbconn : TFDConnection;
      constructor Create();
      function getQuery():TFDQuery;
      function ExecSql(AQry:TFDQuery; sql:string):Boolean;
    protected
    end;

implementation


constructor TZDbConnector.Create();

//var driver:TFDPhysSQLiteDriverLink;

begin

  dbconn:=TFDConnection.Create(nil);

  dbconn.Close;
  // create temporary connection definition
  with dbconn.Params do begin
    Clear;
    Add('DriverID=SQLite');
    Add('Database=C:\Users\KlausEtscheidt\Documents\Embarcadero\Studio\' +
        'Projekte\zoll\db\zoll.sqlite');
    Add('LockingMode=Normal');
  end;
  dbconn.LoginPrompt := False;
  dbconn.Open;
end;

//Liefert eine TFDQuery die über diese TFDConnection mit einer Datenbank verbunden ist
function TZDbConnector.getQuery():TFDQuery;
var aQry: TFDQuery;
begin
  aQry:= TFDQuery.Create(nil);
  aQry.Connection:=dbconn;
  Result := aQry;
end;

function TZDbConnector.ExecSql(AQry:TFDQuery; sql:string):Boolean;
begin
  AQry.Open(sql);
  Result:= True;
end;

end.
