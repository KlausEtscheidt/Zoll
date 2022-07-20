unit xxTextWriter;

interface

uses System.SysUtils,  Config;

  type
    TWTextFile = class
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

  var Log: TWTextFile;
  var ErrLog: TWTextFile;

implementation

destructor TWTextFile.Destroy;
begin
    inherited destroy;
    CloseFile (LogFile);
end;

constructor TWTextFile.Create(Filename : String);

begin

    AssignFile (LogFile, Filename);
    Open;

end;

procedure TWTextFile.Close();
begin
    CloseFile (LogFile);
end;

procedure TWTextFile.Open();
begin
    if FileExists (FileName) then
        Append (LogFile) // open existing file
    else
        Rewrite (LogFile); // create a new one
end;


procedure TWTextFile.ClearContent();
begin
    CloseFile (LogFile);
    Open;
end;

procedure TWTextFile.Log(msg: String);
begin

  try
    Writeln (LogFile, msg);
  Except
    CloseFile (LogFile);
  end;
end;

end.
