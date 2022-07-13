unit Logger;

interface

uses System.SysUtils, Vcl.Forms;

  type
    TZLogger = class
      private
        Filename: string;
        LogFile: TextFile;
      public
        constructor Create;
        destructor Destroy; override;
        procedure Open();
        procedure Close();
        procedure Log(msg: String);
        procedure ClearContent();
    end;

var
  Log : TZLogger;

implementation

destructor TZLogger.Destroy;
begin
    inherited destroy;
    CloseFile (LogFile);
end;

constructor TZLogger.Create;

begin
    // prepares log file
    //Filename := ChangeFileExt (Application.Exename, '.log');

    Filename := ChangeFileExt ('C:\Users\Etscheidt\Documents\Embarcadero\Studio\Projekte\test.txt', '.log');
    //Filename := ChangeFileExt ('C:\Users\Klaus Etscheidt\Documents\Embarcadero\Studio\Projekte\test.txt', '.log');
    AssignFile (LogFile, Filename);
    Open;

end;

procedure TZLogger.Close();
begin
    CloseFile (LogFile);
end;

procedure TZLogger.Open();
begin
    if FileExists (FileName) then
        //CloseFile (LogFile);
        Append (LogFile) // open existing file
    else
        Rewrite (LogFile); // create a new one
end;


procedure TZLogger.ClearContent();
begin
    CloseFile (LogFile);
    Open;
end;

procedure TZLogger.Log(msg: String);
begin

  try
    Writeln (LogFile, msg);
  Except
    // close the file
    CloseFile (LogFile);
  end;
end;

end.