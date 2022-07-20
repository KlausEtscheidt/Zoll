unit DBConnect;

interface

  uses System.Classes,FireDAC.Phys.SQLite ,FireDAC.Stan.Def ,FireDAC.Comp.Client,
        DBQry;

  type
    TZDbConnector = class
      dbconn : TFDConnection;
      constructor Create(AOwner: TComponent);
      function getQuery():TZQry;
    protected
      myowner: TComponent;
    end;

implementation


constructor TZDbConnector.Create(AOwner: TComponent);

//var driver:TFDPhysSQLiteDriverLink;

begin
  myowner:=AOwner;

//  driver:=TFDPhysSQLiteDriverLink.Create(AOwner);
//  driver.DriverID := 'SQLite';

  dbconn:=TFDConnection.Create(AOwner);

  dbconn.Close;
  // create temporary connection definition
  with dbconn.Params do begin
    Clear;
    Add('DriverID=SQLite');
    Add('Database=C:\Users\Klaus Etscheidt\Documents\Embarcadero\Studio\' +
        'Projekte\zoll\zoll.sqlite');
    Add('LockingMode=Normal');
  end;
  dbconn.LoginPrompt := False;
  dbconn.Open;
end;

//Liefert eine TFDQuery die �ber diese TFDConnection mit einer Datenbank verbunden ist
function TZDbConnector.getQuery():TZQry;
begin
    getQuery:=TZQry.Create(myowner,dbconn);
end;

end.