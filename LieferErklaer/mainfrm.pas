unit mainfrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids,Settings,Import, Vcl.Menus, Vcl.ComCtrls, Vcl.Tabs,
  Vcl.TitleBarCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCGrids,
  Vcl.DBCtrls, LeklTeileEingabeFrame, Tools,
  GesamtStatusFrame, TeileFrame,
  LieferantenLEKL3AuswahlFrame, LeklAnfordernFrame;

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
    UnippsMenAuswerten: TMenuItem;
    TeileMen: TMenuItem;
    TeileMenUebersicht: TMenuItem;
    StatusMen: TMenuItem;
    StatusMenAnzeigen: TMenuItem;
    LieferMenErklaerAnfordern: TMenuItem;
    LieferMenAdressen: TMenuItem;
    LieferantenErklaerungenFrm1: TLieferantenErklaerungenFrm;
    LieferantenStatusFrm1: TLieferantenStatusFrm;
    GesamtStatusFrm1: TGesamtStatusFrm;
    TeileFrm1: TTeileFrm;
    LieferantenErklAnfordernFrm1: TLieferantenErklAnfordernFrm;

    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HideAllFrames;
    procedure UnippsMenEinlesenClick(Sender: TObject);
    procedure LTeileMenStatusClick(Sender: TObject);
    procedure LMenErklaerClick(Sender: TObject);
    procedure LieferantenErklaerungenFrm1Button1Click(Sender: TObject);
    procedure UnippsMenAuswertenClick(Sender: TObject);
    procedure StatusMenAnzeigenClick(Sender: TObject);
    procedure TeileMenUebersichtClick(Sender: TObject);
    procedure LieferMenAdressenClick(Sender: TObject);
    procedure LieferMenErklaerAnfordernClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  mainForm: TmainForm;

implementation

{$R *.dfm}

uses Excel, Mailing;

procedure TmainForm.FormShow(Sender: TObject);
begin
    //Aut. Start nur zu Entwicklungszwecken; Sonst über Menu starten
//    Import.BasisImport;
    HideAllFrames;
    LieferantenErklAnfordernFrm1.ShowFrame;
//    LieferantenStatusFrm1.ShowFrame;
end;


procedure TmainForm.HideAllFrames;
begin
    LieferantenStatusFrm1.Visible:=False;
    LieferantenErklaerungenFrm1.Visible:=False;
    GesamtStatusFrm1.Visible:=False;
    TeileFrm1.Visible:=False;
    LieferantenErklAnfordernFrm1.Visible:=False;
end;


procedure TmainForm.FormDestroy(Sender: TObject);
begin
  close;
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

procedure TmainForm.LieferantenErklaerungenFrm1Button1Click(Sender: TObject);
begin
  LieferantenErklaerungenFrm1.BackBtnClick(Sender);

end;

procedure TmainForm.LMenErklaerClick(Sender: TObject);
begin
    LieferantenStatusFrm1.HideFrame;
    LieferantenErklaerungenFrm1.Visible := True;
end;

procedure TmainForm.StatusMenAnzeigenClick(Sender: TObject);
begin
    HideAllFrames;
    GesamtStatusFrm1.Visible:=True;
    GesamtStatusFrm1.InitFrame;
end;

procedure TmainForm.TeileMenUebersichtClick(Sender: TObject);
begin
    HideAllFrames;
    TeileFrm1.Visible:=True;
end;

procedure TmainForm.LTeileMenStatusClick(Sender: TObject);
begin
    HideAllFrames;
    LieferantenStatusFrm1.ShowFrame;
    LieferantenErklaerungenFrm1.HideFrame;
end;

procedure TmainForm.UnippsMenAuswertenClick(Sender: TObject);
begin
  Import.Auswerten;
end;

procedure TmainForm.UnippsMenEinlesenClick(Sender: TObject);
var
  msg:String;

begin
  msg := 'Achtung: ' + #13 + #13
       + 'Dieser Vorgang dauert ca 10 Minuten!'
       + #13 + #13
       + 'Er sollte und muss genau EINMAL im Jahr,' + #13
       + 'zu Beginn der Eingabe der Lieferantenerklärungen ausgeführt werden.'
       + #13 + #13 + 'Wollen Sie jetzt Daten aus UNIPPS einlesen ?';
  if MessageDlg(msg,mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
    Import.BasisImport;

end;

//Setze Pfade, Verbinde zur Datenbank etc
//!! wird sogar noch vor Application.Initialize ausgeführt
initialization
  Tools.init;

end.
