unit ADOConnector;

interface

uses  System.SysUtils,  System.Classes, Data.Win.ADODB  ;

type
    TZADOConnector = class(TComponent)
      constructor Create(AOwner: TComponent);
      function ConnectToDB(AConnectStr : String; AProvider: String):TADOConnection;
      function ConnectToSQLite(PathTODBFile: String): TADOConnection;
      function ConnectToUNIPPS(): TADOConnection;
    private
      FConnection:TADOConnection;
      FTabellen: TStringList;
      function GetTabellen(): System.TArray<String>;
      function GetConnection(): TADOConnection;
    public
      verbunden: Boolean;
      Datenbank: String;   //nur Info
      Datenbankpfad: String; //nur Info
      property Connection: TADOConnection read GetConnection;
      property Tabellen: System.TArray<String> read GetTabellen;
    end;

implementation

constructor TZADOConnector.Create(AOwner: TComponent);
begin
  //Connection anlegen
  FConnection:=TADOConnection.Create(AOwner);
  //Ohne Login-Aufforderung (Kann vor Connect geändert werden)
  FConnection.LoginPrompt := False;

end;

function TZADOConnector.ConnectToSQLite(PathTODBFile: String): TADOConnection;
var
  ConnString, Provider :String;

  begin
  {zu Hause
    dbconn.ConnectionString :=
      'Provider=MSDASQL.1;Persist Security Info=False;' +
      'Extended Properties="DSN=zoll32;' +
      'Database=' + DbFilePath + ';'+
      'StepAPI=0;SyncPragma=NORMAL;NoTXN=0;Timeout=1000;ShortNames=0;' +
      'LongNames=0;NoCreat=0;NoWCHAR=0;FKSupport=0;' +
      'JournalMode=;OEMCP=0;LoadExt=;BigInt=0;JDConv=0;"';
 }
  ConnString :=
        'Provider=MSDASQL.1;Persist Security Info=False;' +
        'Data Source=SQLite3 Datasource;' +
        'Database=' + PathTODBFile + ';';
  Provider := 'MSDASQL.1';

  //verbinden
  try
    ConnectToDB(ConnString, Provider);
  except
    raise Exception.Create(
      'Konnte Datenbank >>' + PathTODBFile + '<< nicht öffen.' );
  end;

  Datenbank:='SQLite';   //nur Info
  Datenbankpfad:=PathTODBFile; //nur Info

  Result:=FConnection;
end;

function TZADOConnector.ConnectToUNIPPS(): TADOConnection;
var
  ConnString, Provider :String;

  begin
  ConnString :=
        'Provider=MSDASQL.1;Persist Security Info=False;' +
        'Data Source=unipps;';
  Provider := 'MSDASQL.1';

  //verbinden
  try
    ConnectToDB(ConnString, Provider);
  except
    raise Exception.Create('Konnte UNIPPS nicht öffen.' );
  end;

  Datenbank:='UNIPPS';   //nur Info
  Result:=FConnection;
end;

function TZADOConnector.ConnectToDB(AConnectStr: String; AProvider: String): TADOConnection;
var
  Tabellen: TStringList ;
  ErrMsg:String;
begin

  verbunden:=False;

  {
  dbconn.ConnectionString :=
        'Provider=MSDASQL.1;Persist Security Info=False;' +
        'Data Source=unipps;'

        'Provider=MSDASQL.1;Persist Security Info=False;' +
        'Data Source=SQLite3 Datasource;' +
        'Database=' + DbFilePath + ';';

  }
  FConnection.ConnectionString := AConnectStr;
  FConnection.Provider := AProvider;

  FConnection.Open;

  ErrMsg:='Konnte Datenbank nicht öffen.';

  if not (FConnection.State=[stOpen]) then
       raise Exception.Create('Fehler beim DB Connect');

  Tabellen:= TStringList.Create();
  FConnection.GetTableNames(Tabellen,False);

  if (Tabellen.Count=0) then
     raise Exception.Create('Fehler beim DB Connect')
  else
    FTabellen:=Tabellen;

  verbunden:=True;

  Result:=FConnection;

end;

function TZADOConnector.GetConnection(): TADOConnection;
begin
  Result:=FConnection
end;

function TZADOConnector.GetTabellen(): System.TArray<String>;
begin
  Result:=FTabellen.ToStringArray;
end;

end.
