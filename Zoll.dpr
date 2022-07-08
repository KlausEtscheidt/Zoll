program Zoll;

uses
  Vcl.Forms,
  main in 'main.pas' {mainFrm},
  SQL in 'SQL.pas',
  Kundenauftraege in 'Kundenauftraege.pas',
  SQLite in 'SQLite.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TmainFrm, mainFrm);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
