program DIGILEK;

uses
  Vcl.Forms,
  mainfrm in 'mainfrm.pas' {mainForm},
  Import in 'Import.pas',
  Tools in 'Tools.pas',
  FDConnector in '..\lib\Datenbank\FDConnector.pas',
  FDQuery in '..\lib\Datenbank\FDQuery.pas',
  QryAccess in 'QryAccess.pas',
  QrySQLite in 'QrySQLite.pas',
  QryUNIPPS in 'QryUNIPPS.pas',
  LieferantenLEKL3AuswahlFrame in 'LieferantenLEKL3AuswahlFrame.pas' {LieferantenStatusFrm: TFrame},
  LieferantenStatusDlg in 'LieferantenStatusDlg.pas' {LieferantenStatusDialog},
  TeileStatusKontrolleFrame in 'TeileStatusKontrolleFrame.pas' {TeileStatusKontrolleFrm: TFrame},
  ExportFrame in 'ExportFrame.pas' {GesamtStatusFrm: TFrame},
  LeklTeileEingabeFrame in 'LeklTeileEingabeFrame.pas' {LieferantenErklaerungenFrm: TFrame},
  LeklAnfordernFrame in 'LeklAnfordernFrame.pas' {LieferantenErklAnfordernFrm: TFrame},
  Excel in 'Excel.pas',
  Mailing in 'Mailing.pas',
  TeileAnzeigenDlg in 'TeileAnzeigenDlg.pas' {TeileListeForm},
  Word in 'Word.pas',
  LeklTeileEingabeDlg in 'LeklTeileEingabeDlg.pas' {LeklTeileEingabeDialog},
  ImportStatusInfoDlg in 'ImportStatusInfoDlg.pas' {ImportStatusDlg},
  ADOConnector in '..\lib\Datenbank\ADOConnector.pas',
  ADOQuery in '..\lib\Datenbank\ADOQuery.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TmainForm, mainForm);
  Application.CreateForm(TLieferantenStatusDialog, LieferantenStatusDialog);
  Application.CreateForm(TTeileListeForm, TeileListeForm);
  Application.CreateForm(TLeklTeileEingabeDialog, LeklTeileEingabeDialog);
  Application.CreateForm(TImportStatusDlg, ImportStatusDlg);
  Application.Run;
end.
