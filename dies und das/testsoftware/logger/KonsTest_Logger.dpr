program KonsTest_Logger;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,Tools;

begin
  try
    Tools.init();
    Log.OpenNew(Tools.LogDir, 'testlog.txt');
    Log.Log('111111 konsole 111111111');
    Log.Close;
    Log.OpenAppend(Tools.LogDir, 'testlog.txt');
    Log.Log('111122222222211111111111');
    Log.Log('1111113333333111111111');
    Log.Close;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
