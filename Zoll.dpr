program Zoll;

uses
  Vcl.Forms,
  main in 'main.pas' {mainFrm},
  Kundenauftraege in 'Kundenauftraege.pas',
  DBQry in 'DBQry.pas',
  DBConnect in 'DBConnect.pas',
  SQLite in 'SQLite.pas' {SQLiteDataModule: TDataModule},
  StuecklistenPosition in 'StuecklistenPosition.pas',
  KundenauftragsPos in 'KundenauftragsPos.pas',
  Teil in 'Teil.pas',
  Bestellung in 'Bestellung.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TmainFrm, mainFrm);
  Application.CreateForm(TSQLiteDataModule, SQLiteDataModule);
  Application.Run;
end.
