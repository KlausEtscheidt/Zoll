unit Logger;

interface

uses
  System.SysUtils, System.Classes;

type
  TLogFile = class(TStreamWriter)
      private
        fullpath:string;
        procedure Open(filedir:string;filename:string;Append:Boolean);
      public
        procedure OpenAppend(filedir:string;filename:string);
        procedure OpenNew(filedir:string;filename:string);
        destructor Destroy(); override;
        procedure Log(msg: String);
    end;


implementation

procedure TLogFile.OpenAppend(filedir:string;filename:string);
begin
  Open(filedir,filename,True);
end;

procedure TLogFile.OpenNew(filedir:string;filename:string);
begin
  Open(filedir,filename,False);
end;

procedure TLogFile.Open(filedir:string;filename:string;Append:Boolean);
begin
  if not directoryexists (filedir) then
    raise Exception.Create('Logger: Verzeichnis ' + filedir + ' nicht gefunden');
  fullpath:= filedir + '\' + filename;

  try
    if Append then
      inherited Create(fullpath,True)
    else
      inherited Create(fullpath,False);
  except
    raise Exception.Create('Logger: Kann Datei ' + fullpath + ' nicht öffnen');

  end;

end;

procedure TLogFile.Log(msg: String);
begin

  try
    Writeline (msg);
  Except
    Close;
  end;
end;

destructor TLogFile.Destroy();
begin
  try
      Close;
  Except
        raise Exception.Create('Close Err');
  end;
end;


end.
