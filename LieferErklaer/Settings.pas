unit Settings;

interface

uses System.SysUtils;

{$IFDEF HOME}
const LogDir: String =
    'C:\Users\Klaus Etscheidt\Documents\Embarcadero\Studio\Projekte\' +
                  'Zoll\LieferErklaer\db\output';
const SQLiteDBFileName: String =
    'C:\Users\Klaus Etscheidt\Documents\Embarcadero\Studio\Projekte\' +
                 'Zoll\LieferErklaer\db\lekl.db';

{$ELSE}
const LogDir: String =
    'C:\Users\Etscheidt\Documents\Embarcadero\Studio\Projekte\' +
                   'Zoll\LieferErklaer\db\output';
const SQLiteDBFileName: String =
    'C:\Users\Etscheidt\Documents\Embarcadero\Studio\Projekte\' +
                 'Zoll\LieferErklaer\db\lekl.db';
const AccessDBFileName: String =
    'V:\E-MAIL\Dr Etscheidt\Exportkontrolle u Zoll\Warenursprung\' +
                 'Lieferantenerklaerung\LieferErklaer.accdb';

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
