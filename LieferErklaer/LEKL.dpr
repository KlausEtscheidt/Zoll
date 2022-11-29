program LEKL;

uses
  Vcl.Forms,
  mainfrm in 'mainfrm.pas' {mainForm},
  Import in 'Import.pas',
  Tools in 'Tools.pas',
  ADOConnector in '..\lib\Datenbank\ADOConnector.pas',
  ADOQuery in '..\lib\Datenbank\ADOQuery.pas',
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
  Mailing in 'Mailing.pas',
  TeileAnzeigenDlg in 'TeileAnzeigenDlg.pas' {TeileListeForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TmainForm, mainForm);
  Application.CreateForm(TLieferantenStatusDialog, LieferantenStatusDialog);
  Application.CreateForm(TTeileListeForm, TeileListeForm);
  Application.Run;
end.
