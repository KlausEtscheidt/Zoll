program LEKL;

uses
  Vcl.Forms,
  mainfrm in 'mainfrm.pas' {mainForm},
  Settings in 'Settings.pas',
  Import in 'Import.pas',
  Tools in 'Tools.pas',
  ADOConnector in '..\lib\Datenbank\ADOConnector.pas',
  ADOQuery in '..\lib\Datenbank\ADOQuery.pas',
  Logger in '..\lib\Tools\Logger.pas',
  QryAccess in 'QryAccess.pas',
  QrySQLite in 'QrySQLite.pas',
  QryUNIPPS in 'QryUNIPPS.pas',
  datenmodul in 'datenmodul.pas' {DataModule1: TDataModule},
  LieferantenErklaerungenFrame in 'LieferantenErklaerungenFrame.pas' {LieferantenErklaerungenFrm: TFrame},
  LieferantenStatusFrame in 'LieferantenStatusFrame.pas' {LieferantenStatusFrm: TFrame},
  LieferantenStatusDlg in 'LieferantenStatusDlg.pas' {LieferantenStatusDialog},
  TeileFrame in 'TeileFrame.pas' {TeileFrm: TFrame},
  GesamtStatusFrame in 'GesamtStatusFrame.pas' {GesamtStatusFrm: TFrame},
  LocalDbQuerys in 'LocalDbQuerys.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TmainForm, mainForm);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TLieferantenStatusDialog, LieferantenStatusDialog);
  Application.Run;
end.
