unit SQLiteConnect;

interface

  uses System.Classes,FireDAC.Phys.SQLite ,FireDAC.Stan.Def ,FireDAC.Comp.Client,
        DBQrySQLite;

  type
    TZDbConnector = class
      dbconn : TFDConnection;
      mQry: TFDQuery;
      constructor Create();
      function getQuery():TFDQuery;
      function Exec(sql:string):Boolean;
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
    Add('Database=C:\Users\Etscheidt\Documents\Embarcadero\Studio\Projekte\Zoll\db\zoll.sqlite');
    Add('LockingMode=Normal');
  end;
  dbconn.LoginPrompt := False;
  dbconn.Open;
  getQuery;
end;

//Liefert eine TFDQuery die über diese TFDConnection mit einer Datenbank verbunden ist
function TZDbConnector.getQuery():TFDQuery;
var aQry: TFDQuery;
begin
  aQry:= TFDQuery.Create(nil);
  aQry.Connection:=dbconn;
  mQry:=aQry;
  Result := aQry;
end;

function TZDbConnector.Exec(sql:string):Boolean;
var n_records:Integer;
begin
  mQry.Open(sql);
  n_records:=mQry.RowsAffected;
  Result:= True;
end;

end.
