program Guidbtest;

uses
  Vcl.Forms,
  testfrm in 'testfrm.pas' {Form1},
  tests in 'tests.pas',
  Exceptions in '..\..\..\lib\Tools\Exceptions.pas',
  Logger in '..\..\..\lib\Tools\Logger.pas',
  Tools in '..\..\..\lib\Tools\Tools.pas',
  ADOConnector in '..\..\..\lib\Datenbank\ADOConnector.pas',
  ADOQuery in '..\..\..\lib\Datenbank\ADOQuery.pas',
  BaumQrySQLite in '..\..\..\lib\Datenbank\BaumQrySQLite.pas',
  BaumQryUNIPPS in '..\..\..\lib\Datenbank\BaumQryUNIPPS.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
