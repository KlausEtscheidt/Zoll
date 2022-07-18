unit Tools;

interface

uses System.IOUtils,System.SysUtils,Logger;
//Vcl.Forms,  System.IOUtils, System.Classes, Logger


{$IFDEF TESTCASE}
const LogDir: String =
    'C:\Users\Klaus Etscheidt\Documents\Embarcadero\Studio\Projekte\'
    +'zoll\dies und das\testsoftware\logger';
{$ELSE}
const LogDir: String =
    'C:\Users\Klaus Etscheidt\Documents\Embarcadero\Studio\Projekte\'
    +'zoll\data\output';
{$ENDIF}


const SQLiteFile: String = 'C:\Users\Etscheidt\Documents\Embarcadero\' +
                 'Studio\Projekte\Zoll\data\db\zoll_neux.sqlite';

//const SQLiteFile: String = 'C:\Users\zoll.sqlite';

procedure init();

var
  Log: TLogFile;
  ErrLog: TLogFile;
  CSVKurz: TLogFile;
  CSVLang: TLogFile;
  ApplicationBaseDir: String;

implementation

procedure init();
begin
  Log:=TLogFile.Create();
  ErrLog:=TLogFile.Create();
  CSVKurz:=TLogFile.Create();
  CSVLang:=TLogFile.Create();
  ApplicationBaseDir:=ExtractFileDir(ParamStr(0));
  ApplicationBaseDir:=ExtractFileDir(ExtractFileDir(ApplicationBaseDir));
end;


end.
