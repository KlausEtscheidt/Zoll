unit Logger;

interface

uses
  System.SysUtils, System.Classes;

type

  /// <summary>Komfort-Funktionen zum Oeffnen von textfiles
  /// </summary>
  TLogFile = class(TStreamWriter)
      private
        fullpath:string;
        procedure Open(filedir:string;filename:string;Append:Boolean);
      public
        procedure OpenAppend(filedir:string;filename:string);
        ///<summary>Oeffnet neue leere Datei </summary>
        /// <param name="filedir">Pfad ohne slash am Ende </param>
        /// <param name="filename">Dateiname ohne slash am Anfang</param>
        procedure OpenNew(filedir:string;filename:string);
//        constructor Create(); override;
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
      inherited Create(fullpath,Append,TEncoding.UTF8);
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
