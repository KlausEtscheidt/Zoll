program Zoll;

uses
  Vcl.Forms,
  Hauptfenster in 'Hauptfenster.pas' {mainFrm},
  Kundenauftrag in 'lib\UNIPPS\Kundenauftrag.pas',
  Zoll_TLB in 'Zoll_TLB.pas',
  FertigungsauftragsKopf in 'lib\UNIPPS\FertigungsauftragsKopf.pas',
  KundenauftragsPos in 'lib\UNIPPS\KundenauftragsPos.pas',
  FertigungsauftragsPos in 'lib\UNIPPS\FertigungsauftragsPos.pas',
  Stueckliste in 'lib\Stueli\Stueckliste.pas',
  TeilAlsStuPos in 'lib\UNIPPS\TeilAlsStuPos.pas',
  Logger in 'lib\Tools\Logger.pas',
  Settings in 'lib\Tools\Settings.pas' {Wkz: TDataModule},
  Bestellung in 'lib\UNIPPS\Bestellung.pas',
  Teil in 'lib\UNIPPS\Teil.pas',
  ADOConnector in 'lib\Datenbank\ADOConnector.pas',
  ADOQuery in 'lib\Datenbank\ADOQuery.pas',
  BaumQrySQLite in 'lib\Datenbank\BaumQrySQLite.pas',
  BaumQryUNIPPS in 'lib\Datenbank\BaumQryUNIPPS.pas',
  Auswerten in 'Auswerten.pas',
  UnippsStueliPos in 'lib\UNIPPS\UnippsStueliPos.pas',
  DatenModul in 'DatenModul.pas' {KaDataModule: TDataModule},
  PumpenDataSet in 'lib\Datenbank\PumpenDataSet.pas',
  Preiseingabe in 'Preiseingabe.pas' {PreisFrm},
  Tools in 'lib\Tools\Tools.pas',
  DruckBlatt in 'lib\Drucken\DruckBlatt.pas',
  DruckeTabelle in 'lib\Drucken\DruckeTabelle.pas',
  DruckeKalkulation in 'lib\Drucken\DruckeKalkulation.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TmainFrm, mainFrm);
  Application.CreateForm(TKaDataModule, KaDataModule);
  Application.CreateForm(TPreisFrm, PreisFrm);
  Application.Run;
end.

