unit UNIPPSConnect;

interface

//uses  System.SysUtils,  Data.Win.ADODB, ADOConnect  ;
uses  System.Classes, System.SysUtils, ADOConnect  ;

type
    TZUNIPPSConnection = class(TZTADOConnection)
      constructor Create(AOwner: TComponent);
    end;

implementation

constructor TZUNIPPSConnection.Create(AOwner: TComponent);
var
  ConnectionString:String;
  Provider:String;
begin
  inherited Create(AOwner);
  //Setze Eigenschaften vor dem Verbinden
  ConnectionString :=
        'Provider=MSDASQL.1;Persist Security Info=False;' +
        'Data Source=unipps;';
  Provider := 'MSDASQL.1';
  //verbinden
  try
    inherited ConnectToDB(ConnectionString, Provider);
  except
    raise Exception.Create(
      'Konnte UNIPPS nicht öffen.' );
  end;

end;


end.
