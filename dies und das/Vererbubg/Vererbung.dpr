program Vererbung;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Unit1 in 'Unit1.pas',
  Unit2 in 'Unit2.pas',
  Unit3 in 'Unit3.pas';

begin
  try
    { TODO -oUser -cConsole Main : Code hier einfügen }
    testrun3;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
