program LEKL;

uses
  Vcl.Forms,
  mainfrm in 'mainfrm.pas' {Form1},
  Settings in 'Settings.pas',
  Import in 'Import.pas',
  Init in 'Init.pas',
  ADOConnector in '..\lib\Datenbank\ADOConnector.pas',
  ADOQuery in '..\lib\Datenbank\ADOQuery.pas',
  Logger in '..\lib\Tools\Logger.pas',
  QryAccess in 'QryAccess.pas',
  QrySQLite in 'QrySQLite.pas',
  QryUNIPPS in 'QryUNIPPS.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
