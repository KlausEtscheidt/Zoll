unit Logger;

interface

uses
  System.SysUtils, System.Classes;

type
  TLogFile = class(TComponent)
//  TLogFile = class(TStreamWriter)
      private
        FFileDir: String;
        FFileName: String;
        FFileExt: String;
        LogFile: TextFile;
        function FullPath():string;
      public
        opened: Boolean;
//        constructor Create();
        destructor Destroy(); override;
        procedure Open();
        procedure Flush();
        procedure Close();
        procedure Log(msg: String);
        procedure ClearContent();
      published
        property FileDir: String read FFileDir write FFileDir;
        property FileName: String read FFileName write FFileName;
        property FileExt: String read FFileExt write FFileExt;
    end;

procedure Register;

implementation

//constructor TLogFile.Create();
//begin
//  if not directoryexists (FFileDir) then
//    raise Exception.Create('Logger: Verzeichnis ' + FFileDir + ' nicht gefunden');
//   inherited Create(FullPath);
//end;

function TLogFile.FullPath():string;
begin
    FullPath:=  FFileDir+'\'+FFilename+'.'+FileExt;
end;

procedure TLogFile.Open();

begin

  if not directoryexists (FFileDir) then
    raise Exception.Create('Logger: Verzeichnis ' + FFileDir + ' nicht gefunden');

  try

    AssignFile (LogFile,FullPath);

    if FileExists (FullPath) then
    begin
      System.Append (LogFile); // open existing file
      opened:=True;
    end
    else
    begin
        System.Rewrite (LogFile); // create a new one
        opened:=True;
    end;

  except
    raise Exception.Create('File nicht gefunden');
  end;

end;


procedure TLogFile.Flush();
begin
  try
    System.Flush (LogFile);
  except
    raise Exception.Create('Flush Problem bei: ' + FullPath);
  end;
end;

procedure TLogFile.ClearContent();
begin
  try
    System.CloseFile (LogFile);
    Open;
  except
    raise Exception.Create('File nicht gefunden');
  end;
end;

procedure TLogFile.Log(msg: String);
begin

  try
    System.Writeln (LogFile, msg);
  Except
    System.CloseFile (LogFile);
  end;
end;

procedure TLogFile.Close();
begin
  try
    System.CloseFile (LogFile);
  Except
        raise Exception.Create('Close Err');
  end;
end;

destructor TLogFile.Destroy();
begin
//    inherited destroy;
  try
      System.CloseFile (LogFile);
  Except
//        raise Exception.Create('Close Err');
  end;
end;


procedure Register;
begin
  RegisterComponents('Samples', [TLogFile]);
end;

end.
