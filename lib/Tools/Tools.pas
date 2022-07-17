unit Tools;

interface

uses Logger;
//Vcl.Forms, System.SysUtils, System.IOUtils, System.Classes, Logger


{$IFDEF TESTCASE}
const LogDir: String =
    'C:\Users\Klaus Etscheidt\Documents\Embarcadero\Studio\Projekte\'
    +'zoll\dies und das\testsoftware\logger';
{$ELSE}
const LogDir: String =
    'C:\Users\Klaus Etscheidt\Documents\Embarcadero\Studio\Projekte\'
    +'zoll\data\output';
{$ENDIF}



procedure init();

var
  Log: TLogFile;
  ErrLog: TLogFile;
  CSVKurz: TLogFile;
  CSVLang: TLogFile;

implementation

procedure init();
begin
  Log:=TLogFile.Create();
  ErrLog:=TLogFile.Create();
  CSVKurz:=TLogFile.Create();
  CSVLang:=TLogFile.Create();
end;


end.
