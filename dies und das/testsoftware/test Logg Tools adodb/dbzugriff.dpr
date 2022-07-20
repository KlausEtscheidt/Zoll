program dbzugriff;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  ActiveX,
  tests in 'tests.pas',
  Logger in '..\..\..\lib\Tools\Logger.pas',
  Tools in '..\..\..\lib\Tools\Tools.pas',
  ADOConnector in '..\..\..\lib\Datenbank\ADOConnector.pas',
  ADOQuery in '..\..\..\lib\Datenbank\ADOQuery.pas',
  BaumQrySQLite in '..\..\..\lib\Datenbank\BaumQrySQLite.pas',
  BaumQryUNIPPS in '..\..\..\lib\Datenbank\BaumQryUNIPPS.pas';

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
