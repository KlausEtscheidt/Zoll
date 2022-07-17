program dbzugriff;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  ActiveX,
  DBQrySQLite in 'DBQrySQLite.pas',
  Tools in 'Tools.pas',
  Logger in 'Logger.pas',
  DBQryUNIPPS in 'DBQryUNIPPS.pas',
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
