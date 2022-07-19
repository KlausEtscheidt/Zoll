unit SQLiteConnect;

interface

//uses  System.SysUtils,  Data.Win.ADODB, ADOConnect  ;
uses  System.Classes, System.SysUtils, ADOConnector  ;

type
    TZSQLiteConnection = class(TZTADOConnector)
      constructor Create(AOwner: TComponent; DbFilePath: String);
    end;

implementation

constructor TZSQLiteConnection.Create(AOwner: TComponent; DbFilePath: String);
var
  ConnectionString:String;
  Provider:String;
begin
  inherited Create(AOwner);
  //Setze Eigenschaften vor dem Verbinden
  //verbinden
  try
    inherited ConnectToDB(ConnectionString, Provider);
  except
    raise Exception.Create(
      'Konnte Datenbank >>' + DbFilePath + '<< nicht öffen.' );
  end;

end;


end.
