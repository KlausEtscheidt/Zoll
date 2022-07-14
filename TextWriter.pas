unit TextWriter;

interface

uses System.SysUtils,  Config;

  type
    TZTextFile = class
      private
        Filename: string;
        LogFile: TextFile;
      public
        constructor Create(filename : String);
        destructor Destroy; override;
        procedure Open();
        procedure Close();
        procedure Log(msg: String);
        procedure ClearContent();
    end;

  var Log: TZTextFile;
  var ErrLog: TZTextFile;

implementation

destructor TZTextFile.Destroy;
begin
    inherited destroy;
    CloseFile (LogFile);
end;

constructor TZTextFile.Create(Filename : String);

begin

    AssignFile (LogFile, Filename);
    Open;

end;

procedure TZTextFile.Close();
begin
    CloseFile (LogFile);
end;

procedure TZTextFile.Open();
begin
    if FileExists (FileName) then
        Append (LogFile) // open existing file
    else
        Rewrite (LogFile); // create a new one
end;


procedure TZTextFile.ClearContent();
begin
    CloseFile (LogFile);
    Open;
end;

procedure TZTextFile.Log(msg: String);
begin

  try
    Writeln (LogFile, msg);
  Except
    CloseFile (LogFile);
  end;
end;

end.
