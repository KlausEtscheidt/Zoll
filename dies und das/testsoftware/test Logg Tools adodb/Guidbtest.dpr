program Guidbtest;

uses
  Vcl.Forms,
  testfrm in 'testfrm.pas' {Form1},
  tests in 'tests.pas',
  Logger in 'Logger.pas',
  Tools in 'Tools.pas',
  ADOConnect in 'ADOConnect.pas',
  SQLiteConnect in 'SQLiteConnect.pas',
  UNIPPSConnect in 'UNIPPSConnect.pas',
  UniToSQLite in 'UniToSQLite.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
