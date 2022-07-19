program dbzugriff;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  ActiveX,
  BaumQrySQLite in 'BaumQrySQLite.pas',
  Tools in 'Tools.pas',
  Logger in 'Logger.pas',
  BaumQryUNIPPS in 'BaumQryUNIPPS.pas',
  tests in 'tests.pas',
  ADOConnector in 'ADOConnector.pas',
  ADOQuery in 'ADOQuery.pas';

begin
  var answer:string;
  try
    CoInitialize(nil);
    RunTests;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Writeln('Fertig');
  Readln(answer);
end.
