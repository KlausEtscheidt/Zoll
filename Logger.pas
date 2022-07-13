unit Logger;

interface

uses System.SysUtils, Vcl.Forms;

  type
    TZLogger = class
      private
        LogFile: TextFile;
      public
        constructor Create;
        destructor Destroy; override;
        procedure Log(msg: String);
    end;

implementation

destructor TZLogger.Destroy;
begin
    inherited destroy;
    CloseFile (LogFile);
end;

constructor TZLogger.Create;
var
  Filename: string;
begin
    // prepares log file
    Filename := ChangeFileExt (Application.Exename, '.log');
    AssignFile (LogFile, Filename);
    if FileExists (FileName) then
        Append (LogFile) // open existing file
    else
        Rewrite (LogFile); // create a new one
end;

procedure TZLogger.Log(msg: String);
begin
  try
    // write to the file and show error
    Writeln (LogFile, msg);
  finally
    // close the file
    CloseFile (LogFile);
  end;
end;

end.
