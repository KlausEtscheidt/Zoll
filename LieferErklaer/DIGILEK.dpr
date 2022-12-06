program DIGILEK;

uses
  Vcl.Forms,
  mainfrm in 'units\mainfrm.pas' {mainForm},
  Import in 'units\Import.pas',
  Tools in 'units\Tools.pas',
  FDConnector in '..\lib\Datenbank\FDConnector.pas',
  FDQuery in '..\lib\Datenbank\FDQuery.pas',
  QryAccess in 'units\Queries\QryAccess.pas',
  QrySQLite in 'units\Queries\QrySQLite.pas',
  QryUNIPPS in 'units\Queries\QryUNIPPS.pas',
  LieferantenLEKL3AuswahlFrame in 'units\Frames\LieferantenLEKL3AuswahlFrame.pas' {LieferantenStatusFrm: TFrame},
  LieferantenStatusDlg in 'units\Dialoge\LieferantenStatusDlg.pas' {LieferantenStatusDialog},
  TeileStatusKontrolleFrame in 'units\Frames\TeileStatusKontrolleFrame.pas' {TeileStatusKontrolleFrm: TFrame},
  ExportFrame in 'units\Frames\ExportFrame.pas' {GesamtStatusFrm: TFrame},
  LeklTeileEingabeFrame in 'units\Frames\LeklTeileEingabeFrame.pas' {LieferantenErklaerungenFrm: TFrame},
  LeklAnfordernFrame in 'units\Frames\LeklAnfordernFrame.pas' {LieferantenErklAnfordernFrm: TFrame},
  Excel in 'units\Office\Excel.pas',
  Mailing in 'units\Office\Mailing.pas',
  TeileAnzeigenDlg in 'units\Dialoge\TeileAnzeigenDlg.pas' {TeileListeForm},
  Word in 'units\Office\Word.pas',
  LeklTeileEingabeDlg in 'units\Dialoge\LeklTeileEingabeDlg.pas' {LeklTeileEingabeDialog},
  ImportStatusInfoDlg in 'units\Dialoge\ImportStatusInfoDlg.pas' {ImportStatusDlg},
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
