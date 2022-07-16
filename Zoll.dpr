program Zoll;

uses
  Vcl.Forms,
  main in 'main.pas' {mainFrm},
  Kundenauftrag in 'lib\UNIPPS\Kundenauftrag.pas',
  DBQryUNIPPS in 'lib\Datenbank\DBQryUNIPPS.pas',
  DBDatamodule in 'lib\Datenbank\DBDatamodule.pas' {KombiDataModule: TDataModule},
  DBZugriff in 'lib\Datenbank\DBZugriff.pas',
  DBQrySQLite in 'lib\Datenbank\DBQrySQLite.pas',
  Zoll_TLB in 'Zoll_TLB.pas',
  SQLiteConnect in 'lib\Datenbank\SQLiteConnect.pas',
  FertigungsauftragsKopf in 'lib\UNIPPS\FertigungsauftragsKopf.pas',
  KundenauftragsPos in 'lib\UNIPPS\KundenauftragsPos.pas',
  FertigungsauftragsPos in 'lib\UNIPPS\FertigungsauftragsPos.pas',
  Exceptions in 'lib\Tools\Exceptions.pas',
  Tools in 'lib\Tools\Tools.pas' {Wkz: TDataModule},
  Stueckliste in 'lib\Stueli\Stueckliste.pas',
  Bestellung in 'lib\UNIPPS\Bestellung.pas',
  StuecklistenPosition in 'lib\Stueli\StuecklistenPosition.pas',
  Teil in 'lib\UNIPPS\Teil.pas',
  TeilAlsStuPos in 'lib\UNIPPS\TeilAlsStuPos.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TmainFrm, mainFrm);
  Application.CreateForm(TKombiDataModule, KombiDataModule);
  Application.CreateForm(TWkz, Wkz);
  Application.Run;
end.
