unit Logger;

interface

uses
  System.SysUtils, System.Classes;

type
  TLogFile = class(TComponent)
      private
        FFileDir: String;
        FFilename: String;
        LogFile: TextFile;
        FullPath:string;
      public
        opened: Boolean;
        destructor Destroy(); override;
//        constructor Create;
        procedure Init();
        procedure Open();
        procedure Close();
        procedure Log(msg: String);
        procedure ClearContent();
      published
        property FileDir: String read FFileDir write FFileDir;
        property Filename: String read FFilename write FFilename;

    end;

  var Log: TLogFile;
  var ErrLog: TLogFile;


procedure Register;

implementation

//constructor TLogFile.Create;
//begin
//  //inherited Create(Self);
//  Init;
//  opened:=False;
//end;

procedure TLogFile.Init();

begin
  FullPath:=  FFileDir+'\'+FFilename;
  AssignFile (LogFile,FullPath);
end;

procedure TLogFile.Open();

begin
    if FileExists (FullPath) then
    begin
      Append (LogFile); // open existing file
      opened:=True;
    end
    else
    begin
        Rewrite (LogFile); // create a new one
        opened:=True;
    end;
end;


procedure TLogFile.ClearContent();
begin
    CloseFile (LogFile);
    Open;
end;

procedure TLogFile.Log(msg: String);
begin

  try
    Writeln (LogFile, msg);
  Except
    CloseFile (LogFile);
  end;
end;

procedure TLogFile.Close();
begin
  try
    CloseFile (LogFile);
  Except
  end;
end;

destructor TLogFile.Destroy();
begin
    inherited destroy;
    CloseFile (LogFile);
end;


procedure Register;
begin
  RegisterComponents('Samples', [TLogFile]);
end;

end.
