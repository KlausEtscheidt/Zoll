unit mainfrm;

interface

uses
  Vcl.HtmlHelpViewer,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids,Import, Vcl.Menus, Vcl.ComCtrls, Vcl.Tabs,
  Vcl.TitleBarCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCGrids,
  Vcl.DBCtrls, LeklTeileEingabeFrame, Tools,
  LieferantenLEKL3AuswahlFrame, LeklAnfordernFrame, TeileStatusKontrolleFrame,
  ExportFrame, WinApi, Vcl.Buttons;

type
  TmainForm = class(TForm)
    MainMenu1: TMainMenu;
    DateiMen: TMenuItem;
    DateiMenEnde: TMenuItem;
    UnippsMen: TMenuItem;
    UnippsMenEinlesen: TMenuItem;
    StatusBar1: TStatusBar;
    LieferantenMen: TMenuItem;
    LTeileMenStatus: TMenuItem;
    TeileMen: TMenuItem;
    TeileMenUebersicht: TMenuItem;
    ExportMen: TMenuItem;
    ExportMenErzeugen: TMenuItem;
    LieferMenErklaerAnfordern: TMenuItem;
    LieferMenAdressen: TMenuItem;
    Lekl3LieferantAuswahlFrm: TLieferantenStatusFrm;
    ExportFrm1: TGesamtStatusFrm;
    TeileStausKontrolleFrm: TTeileStatusKontrolleFrm;
    LieferantenErklAnfordernFrm1: TLieferantenErklAnfordernFrm;
    N1: TMenuItem;
    N2: TMenuItem;
    TestMen: TMenuItem;
    N300Tage1: TMenuItem;
    N0Tage1: TMenuItem;
    InfoMen: TMenuItem;
    VersMen: TMenuItem;
    Hilfe1: TMenuItem;

    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HideAllFrames;
    procedure UnippsMenEinlesenClick(Sender: TObject);
    procedure LTeileMenStatusClick(Sender: TObject);
    procedure UnippsMenAuswertenClick(Sender: TObject);
    procedure ExportMenErzeugenClick(Sender: TObject);
    procedure TeileMenUebersichtClick(Sender: TObject);
    procedure LieferMenAdressenClick(Sender: TObject);
    procedure LieferMenErklaerAnfordernClick(Sender: TObject);
    procedure N300Tage1Click(Sender: TObject);
    procedure N0Tage1Click(Sender: TObject);
    procedure VersMenClick(Sender: TObject);
    function FormHelp(Command: Word; Data: NativeInt;
      var CallHelp: Boolean): Boolean;
    procedure Hilfe1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
  end;

procedure StatusBarLeft(text:String);
procedure StatusBar(akt,max: Integer);

var
  mainForm: TmainForm;

implementation

{$R *.dfm}

uses Excel, Mailing, ImportStatusInfoDlg;

procedure TmainForm.FormShow(Sender: TObject);
begin
    caption:=caption + ' V' + GetCurrentVersion(2);
{$IFDEF RELEASE}
    TestMen.Visible:=False;
{$ENDIF}

    //Aut. Start nur zu Entwicklungszwecken; Sonst über Menu starten
//  ImportStatusDlg.Show;
//    Import.BasisImport;
    StatusBarLeft('verbunden mit: ' + Tools.DbConnector.Datenbank);
    HideAllFrames;
    LieferantenErklAnfordernFrm1.ShowFrame;
//    TeileStausKontrolleFrm.ShowFrame;
//    LieferantenStatusFrm1.ShowFrame;
end;

procedure TmainForm.HideAllFrames;
begin
    Lekl3LieferantAuswahlFrm.Visible:=False;
    ExportFrm1.Visible:=False;
    TeileStausKontrolleFrm.Visible:=False;
    LieferantenErklAnfordernFrm1.Visible:=False;
end;


procedure TmainForm.Hilfe1Click(Sender: TObject);
begin
  HelpFile := ExtractFilePath(Application.ExeName) + HelpFile;
  Application.HelpShowTableOfContents();
//  CallHelp :=  False; // True; - to execute the default OnHelp event handler

end;

procedure TmainForm.FormDestroy(Sender: TObject);
begin
  close;
end;

function TmainForm.FormHelp(Command: Word; Data: NativeInt;
  var CallHelp: Boolean): Boolean;
begin
  mainForm.StatusBar1.Panels[0].Text := 'f1';

end;

/// <summary>Ausgabe in linkes panel des Statusbar </summary>
procedure StatusBarLeft(text:String);
begin
  mainForm.StatusBar1.Panels[0].Text := text;
  mainForm.StatusBar1.Panels[1].Text := '';
  mainForm.StatusBar1.Update;
end;

/// <summary>Ausgabe in rechtes panel des Statusbar </summary>
procedure StatusBar(akt,max: Integer);
begin
   mainForm.StatusBar1.Panels[1].Text :=
          IntToStr(akt) + ' von ' + IntToStr(max);
   mainForm.StatusBar1.Update;
end;

procedure TmainForm.LieferMenAdressenClick(Sender: TObject);
begin
      Import.LieferantenAdressdatenAusUnipps;
end;

procedure TmainForm.LieferMenErklaerAnfordernClick(Sender: TObject);
begin
    HideAllFrames;
    LieferantenErklAnfordernFrm1.ShowFrame;
end;

procedure TmainForm.ExportMenErzeugenClick(Sender: TObject);
begin
    HideAllFrames;
    Import.Auswerten;
    ExportFrm1.Visible:=True;
    ExportFrm1.InitFrame;
end;

procedure TmainForm.TeileMenUebersichtClick(Sender: TObject);
begin
    HideAllFrames;
    TeileStausKontrolleFrm.ShowFrame;
end;

procedure TmainForm.LTeileMenStatusClick(Sender: TObject);
begin
    HideAllFrames;
    Lekl3LieferantAuswahlFrm.ShowFrame;
end;

procedure TmainForm.N0Tage1Click(Sender: TObject);
var
  LocalQry:TWQry;
begin
  LocalQry:=Tools.GetQuery;
  LocalQry.RunExecSQLQuery('Update ProgrammDaten Set Wert=0 '
                          + 'WHERE NAME = "Gueltigkeit_Lekl";');
end;

procedure TmainForm.N300Tage1Click(Sender: TObject);
var
  LocalQry:TWQry;
begin
  LocalQry:=Tools.GetQuery;
  LocalQry.RunExecSQLQuery('Update ProgrammDaten Set Wert=300 '
                          + 'WHERE NAME = "Gueltigkeit_Lekl";');
end;

procedure TmainForm.UnippsMenAuswertenClick(Sender: TObject);
begin
  Import.Auswerten;
end;

procedure TmainForm.UnippsMenEinlesenClick(Sender: TObject);
begin
  ImportStatusDlg.Show;
end;

procedure TmainForm.VersMenClick(Sender: TObject);
begin
  ShowMessage('DigiLek Digitale Lieferantenerklärung' + #13#13
              + 'Version ' + GetCurrentVersion(4)  )
end;

//Setze Pfade, Verbinde zur Datenbank etc
//!! wird sogar noch vor Application.Initialize ausgeführt
//Hier eigentlich unnötig, da vorher die initialization der Unit Tools
//ausgeführt wird, die auch Tools.init aufruft
initialization
//  Tools.init;

end.
