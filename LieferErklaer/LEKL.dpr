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
  LieferantenLEKL3AuswahlFrame in 'LieferantenLEKL3AuswahlFrame.pas' {LieferantenStatusFrm: TFrame},
  LieferantenStatusDlg in 'LieferantenStatusDlg.pas' {LieferantenStatusDialog},
  TeileFrame in 'TeileFrame.pas' {TeileFrm: TFrame},
  GesamtStatusFrame in 'GesamtStatusFrame.pas' {GesamtStatusFrm: TFrame},
  LeklTeileEingabeFrame in 'LeklTeileEingabeFrame.pas' {LieferantenErklaerungenFrm: TFrame},
  LeklAnfordernFrame in 'LeklAnfordernFrame.pas' {LieferantenErklAnfordernFrm: TFrame},
  Excel in 'Excel.pas',
  Mailing in 'Mailing.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TmainForm, mainForm);
  Application.CreateForm(TLieferantenStatusDialog, LieferantenStatusDialog);
  Application.Run;
end.
