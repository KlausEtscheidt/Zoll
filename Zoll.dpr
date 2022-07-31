program Zoll;

uses
  Vcl.Forms,
  main in 'main.pas' {mainFrm},
  Kundenauftrag in 'lib\UNIPPS\Kundenauftrag.pas',
  Zoll_TLB in 'Zoll_TLB.pas',
  FertigungsauftragsKopf in 'lib\UNIPPS\FertigungsauftragsKopf.pas',
  KundenauftragsPos in 'lib\UNIPPS\KundenauftragsPos.pas',
  FertigungsauftragsPos in 'lib\UNIPPS\FertigungsauftragsPos.pas',
  Exceptions in 'lib\Tools\Exceptions.pas',
  Stueckliste in 'lib\Stueli\Stueckliste.pas',
  TeilAlsStuPos in 'lib\UNIPPS\TeilAlsStuPos.pas',
  Logger in 'lib\Tools\Logger.pas',
  Tools in 'lib\Tools\Tools.pas' {Wkz: TDataModule},
  Bestellung in 'lib\UNIPPS\Bestellung.pas',
  Teil in 'lib\UNIPPS\Teil.pas',
  ADOConnector in 'lib\Datenbank\ADOConnector.pas',
  ADOQuery in 'lib\Datenbank\ADOQuery.pas',
  BaumQrySQLite in 'lib\Datenbank\BaumQrySQLite.pas',
  BaumQryUNIPPS in 'lib\Datenbank\BaumQryUNIPPS.pas',
  mainNonGui in 'mainNonGui.pas',
  UnippsStueliPos in 'lib\UNIPPS\UnippsStueliPos.pas',
  Tests in 'Tests.pas',
  AusgabenFactory in 'AusgabenFactory.pas',
  DatenModul in 'DatenModul.pas' {KaDataModule: TDataModule},
  PumpenDataSet in 'lib\Datenbank\PumpenDataSet.pas',
  StueliEigenschaften in 'lib\Stueli\StueliEigenschaften.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TmainFrm, mainFrm);
  Application.CreateForm(TKaDataModule, KaDataModule);
  Application.Run;
end.
