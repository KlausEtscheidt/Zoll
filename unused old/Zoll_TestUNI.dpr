program Zoll_TestUNI;

uses
  Vcl.Forms,
  main in 'main.pas' {mainFrm},
  DBQryUNIPPS in 'DBQryUNIPPS.pas',
  DBZugriff in 'DBZugriff.pas',
  DBDataModuleUnipps in 'DBDataModuleUnipps.pas' {DataModuleUnipps: TDataModule},
  Unit2 in 'Unit2.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TmainFrm, mainFrm);
  Application.CreateForm(TDataModuleUnipps, DataModuleUnipps);
  Application.Run;
end.
