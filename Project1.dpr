program Project1;

uses
  Vcl.Forms,
  Kundenauftraege in 'Kundenauftraege.pas',
  main in 'main.pas' {mainFrm},
  SQLiteConnect in 'SQLiteConnect.pas',
  Unit1 in 'Unit1.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TmainFrm, mainFrm);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
