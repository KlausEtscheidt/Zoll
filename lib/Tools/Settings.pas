unit Settings;

interface

uses System.SysUtils;
//System.IOUtils,Logger,
//ADOConnector, BaumQryUNIPPS, BaumQrySQLite;
//Vcl.Forms,  System.IOUtils, System.Classes, Logger


{$IFDEF HOME}
const LogDir: String =
    'C:\Users\Klaus Etscheidt\Documents\Embarcadero\Studio\Projekte\' +
    'zoll\data\output';
const SQLiteDBFileName: String =
    'C:\Users\Klaus Etscheidt\Documents\Embarcadero\Studio\Projekte\' +
                 'Zoll\data\db\zoll.sqlite';

{$ELSE}
const LogDir: String =
    'C:\Users\Etscheidt\Documents\Embarcadero\Studio\Projekte\' +
                   'Zoll\data\output';
const SQLiteDBFileName: String = 'C:\Users\Etscheidt\Documents\Embarcadero\' +
                 'Studio\Projekte\Zoll\data\db\zoll.sqlite';

{$ENDIF}

const MaxAnteilNonEU=40; //in %

procedure init();

var
  ApplicationBaseDir: String;
  GuiMode:Boolean;

implementation

procedure init();
begin
  ApplicationBaseDir:=ExtractFileDir(ParamStr(0));
  ApplicationBaseDir:=ExtractFileDir(ExtractFileDir(ApplicationBaseDir));
end;

initialization

init();

end.
