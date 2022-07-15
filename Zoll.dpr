program Zoll;

uses
  Vcl.Forms,
  main in 'main.pas' {mainFrm},
  Kundenauftrag in 'Kundenauftrag.pas',
  DBQryUNIPPS in 'DBQryUNIPPS.pas',
  DBDatamodule in 'DBDatamodule.pas' {KombiDataModule: TDataModule},
  StuecklistenPosition in 'StuecklistenPosition.pas',
  KundenauftragsPos in 'KundenauftragsPos.pas',
  Teil in 'Teil.pas',
  Bestellung in 'Bestellung.pas',
  DBZugriff in 'DBZugriff.pas',
  DBQrySQLite in 'DBQrySQLite.pas',
  FertigungsauftragsPos in 'FertigungsauftragsPos.pas',
  FertigungsauftragsKopf in 'FertigungsauftragsKopf.pas',
  Exceptions in 'Exceptions.pas',
  xxTextWriter in 'xxTextWriter.pas',
  TeilAlsStuPos in 'TeilAlsStuPos.pas',
  Stueckliste in 'Stueckliste.pas',
  SQLiteConnect in 'SQLiteConnect.pas',
  Config in 'Config.pas',
  Output in 'Output.pas',
  Zoll_TLB in 'Zoll_TLB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TmainFrm, mainFrm);
  Application.CreateForm(TKombiDataModule, KombiDataModule);
  cfg_init;
  Application.Run;
end.
