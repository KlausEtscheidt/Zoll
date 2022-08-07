program DruckTest;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DruckBlatt in '..\lib\Tools\DruckBlatt.pas',
  PumpenDataSet in '..\lib\Datenbank\PumpenDataSet.pas',
  DatenModul in '..\DatenModul.pas' {KaDataModule: TDataModule},
  Logger in '..\lib\Tools\Logger.pas',
  Preiseingabe in '..\Preiseingabe.pas' {PreisFrm},
  Settings in '..\lib\Tools\Settings.pas',
  Drucken in '..\lib\Tools\Drucken.pas';

begin
  try
//      CoInitialize(nil);

    //Datenmodul initialiseren
    DatenModul.KaDataModule := TKaDataModule.Create(nil);
    Drucken.test1;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
