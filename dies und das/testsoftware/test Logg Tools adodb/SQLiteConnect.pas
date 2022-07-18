unit SQLiteConnect;

interface

//uses  System.SysUtils,  Data.Win.ADODB, ADOConnect  ;
uses  System.Classes, System.SysUtils, ADOConnect  ;

type
    TZSQLiteConnection = class(TZTADOConnection)
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
  {zu Hause
    dbconn.ConnectionString :=
      'Provider=MSDASQL.1;Persist Security Info=False;' +
      'Extended Properties="DSN=zoll32;' +
      'Database=' + DbFilePath + ';'+
      'StepAPI=0;SyncPragma=NORMAL;NoTXN=0;Timeout=1000;ShortNames=0;' +
      'LongNames=0;NoCreat=0;NoWCHAR=0;FKSupport=0;' +
      'JournalMode=;OEMCP=0;LoadExt=;BigInt=0;JDConv=0;"';
 }
  ConnectionString :=
        'Provider=MSDASQL.1;Persist Security Info=False;' +
        'Data Source=SQLite3 Datasource;' +
        'Database=' + DbFilePath + ';';
  Provider := 'MSDASQL.1';
  //verbinden
  try
    inherited ConnectToDB(ConnectionString, Provider);
  except
    raise Exception.Create(
      'Konnte Datenbank >>' + DbFilePath + '<< nicht öffen.' );
  end;

end;


end.
