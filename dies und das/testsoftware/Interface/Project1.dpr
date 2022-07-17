program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Unit1 in 'Unit1.pas';

begin
  try
    TestIt;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
