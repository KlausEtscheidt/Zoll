unit SQLiteConnector;

interface

  uses System.Classes,
//  FireDAC.Phys.SQLite ,FireDAC.Stan.Def,
//        FireDAC.Stan.Param,FireDAC.Dapt,FireDAC.Stan.Async,
//        FireDAC.Comp.Client,StrUtils,
        DBQrySQLite, Data.DB, Data.Win.ADODB;

  type
//    object ADOConn: TADOConnection;
//    Connected := True;
//    ConnectionString :=
//      'Provider=MSDASQL.1;Persist Security Info=False;Extended Properti' +
//      'es="DSN=zoll32;Database=C:\Users\zoll.sqlite;StepAPI=0;SyncPragm' +
//      'a=NORMAL;NoTXN=0;Timeout=1000;ShortNames=0;LongNames=0;NoCreat=0' +
//      ';NoWCHAR=0;FKSupport=0;JournalMode=;OEMCP=0;LoadExt=;BigInt=0;JD' +
//      'Conv=0;"';
//    LoginPrompt := False;
//    Left := 480;
//    Top := 24;
//  end;

    TZDbConnector = class
      dbconn : TADOConnection;
      mQry: TADOQuery;
      constructor Create();
    protected
    end;


implementation


constructor TZDbConnector.Create();

//var driver:TFDPhysSQLiteDriverLink;

begin

//    dbconn:=ADOConn;
  dbconn:=TADOConnection.Create(nil);

//  dbconn.Close;
  dbconn.LoginPrompt := False;

  dbconn.ConnectionString :=
      'Provider=MSDASQL.1;Persist Security Info=False;Extended Properti' +
      'es="DSN=zoll32;Database=C:\Users\zoll.sqlite;StepAPI=0;SyncPragm' +
      'a=NORMAL;NoTXN=0;Timeout=1000;ShortNames=0;LongNames=0;NoCreat=0' +
      ';NoWCHAR=0;FKSupport=0;JournalMode=;OEMCP=0;LoadExt=;BigInt=0;JD' +
      'Conv=0;"';
  dbconn.ConnectOptions := coAsyncConnect;
  dbconn.Provider := 'MSDASQL.1';
  dbconn.Open;
end;

end.
