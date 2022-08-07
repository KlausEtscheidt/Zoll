program Batchlauf;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  ActiveX,
  mainNonGui in 'mainNonGui.pas',
  Logger in 'lib\Tools\Logger.pas',
  ADOConnector in 'lib\Datenbank\ADOConnector.pas',
  ADOQuery in 'lib\Datenbank\ADOQuery.pas',
  BaumQrySQLite in 'lib\Datenbank\BaumQrySQLite.pas',
  BaumQryUNIPPS in 'lib\Datenbank\BaumQryUNIPPS.pas',
  PumpenDataSet in 'lib\Datenbank\PumpenDataSet.pas',
  Bestellung in 'lib\UNIPPS\Bestellung.pas',
  FertigungsauftragsKopf in 'lib\UNIPPS\FertigungsauftragsKopf.pas',
  FertigungsauftragsPos in 'lib\UNIPPS\FertigungsauftragsPos.pas',
  Kundenauftrag in 'lib\UNIPPS\Kundenauftrag.pas',
  KundenauftragsPos in 'lib\UNIPPS\KundenauftragsPos.pas',
  Teil in 'lib\UNIPPS\Teil.pas',
  TeilAlsStuPos in 'lib\UNIPPS\TeilAlsStuPos.pas',
  Stueckliste in 'lib\Stueli\Stueckliste.pas',
  UnippsStueliPos in 'lib\UNIPPS\UnippsStueliPos.pas',
  Settings in 'lib\Tools\Settings.pas',
  Exceptions in 'lib\Tools\Exceptions.pas',
  DatenModul in 'DatenModul.pas' {KaDataModule: TDataModule},
  Tools in 'lib\Tools\Tools.pas';

begin
var answer:string;
  try

    CoInitialize(nil);

    //Datenmodul initialiseren
    DatenModul.KaDataModule := TKaDataModule.Create(nil);

    //Globals setzen und initialiseren
    Tools.Init;
    Settings.GuiMode:=False;


    mainNonGui.RunItKonsole;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  Writeln('Fertig');
  Readln(answer);
end.
