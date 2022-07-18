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
  tests in 'tests.pas';

begin

  try
    CoInitialize(nil);
    RunTests;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
