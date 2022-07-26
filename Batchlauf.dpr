program Batchlauf;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  ActiveX,
  Tools in 'lib\Tools\Tools.pas',
  mainNonGui in 'mainNonGui.pas';

begin
var answer:string;
  try

    CoInitialize(nil);

    //Globals setzen und initialiseren
    Tools.Init;

    mainNonGui.check100;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  Writeln('Fertig');
  Readln(answer);
end.
