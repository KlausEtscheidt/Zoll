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
  Exceptions in 'Exceptions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TmainFrm, mainFrm);
  Application.CreateForm(TKombiDataModule, KombiDataModule);
  Application.Run;
end.
