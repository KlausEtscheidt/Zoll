unit ADOConnect;

interface

uses  System.SysUtils,  System.Classes, Data.Win.ADODB  ;

type
    TZTADOConnection = class(TADOConnection)
      constructor Create(AOwner: TComponent);
      function ConnectToDB(AConnectStr : String; AProvider: String):TADOConnection;
    private
      FTabellen: TStringList;
      function GetTabellen(): System.TArray<String>;
    public
      dbconn:TADOConnection;
       verbunden: Boolean;
      property Tabellen: System.TArray<String> read GetTabellen;
    end;

implementation

constructor TZTADOConnection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TZTADOConnection.GetTabellen(): System.TArray<String>;
begin
  Result:=FTabellen.ToStringArray;
end;

function TZTADOConnection.ConnectToDB(AConnectStr: String; AProvider: String): TADOConnection;
var
  Tabellen: TStringList ;
  ErrMsg:String;
begin

  verbunden:=False;

  dbconn:=TADOConnection.Create(nil);

  dbconn.LoginPrompt := False;

  dbconn.ConnectionString :=  AConnectStr;
  {
  dbconn.ConnectionString :=
        'Provider=MSDASQL.1;Persist Security Info=False;' +
        'Data Source=unipps;'

        'Provider=MSDASQL.1;Persist Security Info=False;' +
        'Data Source=SQLite3 Datasource;' +
        'Database=' + DbFilePath + ';';

  }
  dbconn.Provider := AProvider;

  dbconn.Open;

//  ErrMsg:='Konnte Datenbank >>' + DbFilePath + '<< nicht öffen.';
  ErrMsg:='Konnte Datenbank nicht öffen.';

  if not (dbconn.State=[stOpen]) then
       raise Exception.Create(ErrMsg + 'dbconn.State' );

  Tabellen:= TStringList .Create();
  try
    dbconn.GetTableNames(Tabellen,False);
  except
     raise Exception.Create(ErrMsg);
  end;

  if (Tabellen.Count=0) then
     raise Exception.Create(ErrMsg)
  else
    FTabellen:=Tabellen;

  verbunden:=True;

  Result:=dbconn;

end;

end.
