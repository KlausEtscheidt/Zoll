unit mainfrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids,Settings,Import, Vcl.Menus, Vcl.ComCtrls, Vcl.Tabs,
  Vcl.TitleBarCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCGrids,
  Vcl.DBCtrls, LieferantenStatusFrame, LieferantenErklaerungenFrame, Tools,
  GesamtStatusFrame, TeileFrame;

type
  TmainForm = class(TForm)
    MainMenu1: TMainMenu;
    DateiMen: TMenuItem;
    DateiMenEnde: TMenuItem;
    UnippsMen: TMenuItem;
    UnippsMenEinlesen: TMenuItem;
    StatusBar1: TStatusBar;
    LieferantenMen: TMenuItem;
    LMenStatus: TMenuItem;
    LieferantenStatusFrm1: TLieferantenStatusFrm;
    LieferantenErklaerungenFrm1: TLieferantenErklaerungenFrm;
    UnippsMenAuswerten: TMenuItem;
    TeileMen: TMenuItem;
    TeileMenUebersicht: TMenuItem;
    StatusMen: TMenuItem;
    StatusMenAnzeigen: TMenuItem;
    GesamtStatusFrm1: TGesamtStatusFrm;
    TeileFrm1: TTeileFrm;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HideAllFrames;
    procedure UnippsMenEinlesenClick(Sender: TObject);
    procedure LMenStatusClick(Sender: TObject);
    procedure LMenErklaerClick(Sender: TObject);
    procedure LieferantenErklaerungenFrm1Button1Click(Sender: TObject);
    procedure UnippsMenAuswertenClick(Sender: TObject);
    procedure StatusMenAnzeigenClick(Sender: TObject);
    procedure TeileMenUebersichtClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  mainForm: TmainForm;

implementation

{$R *.dfm}

procedure TmainForm.HideAllFrames;
begin
    LieferantenStatusFrm1.Visible:=False;
    LieferantenErklaerungenFrm1.Visible:=False;
    GesamtStatusFrm1.Visible:=False;
    TeileFrm1.Visible:=False;
end;


procedure TmainForm.FormDestroy(Sender: TObject);
begin
  close;
end;

procedure TmainForm.FormShow(Sender: TObject);
begin
    Tools.init;
    //Aut. Start nur zu Entwicklungszwecken; Sonst über Menu starten
//    Import.BasisImport;
    LieferantenStatusFrm1.ShowFrame;
    LieferantenErklaerungenFrm1.HideFrame;
end;

procedure TmainForm.LieferantenErklaerungenFrm1Button1Click(Sender: TObject);
begin
  LieferantenErklaerungenFrm1.BackBtnClick(Sender);

end;

procedure TmainForm.LMenErklaerClick(Sender: TObject);
var
  Qry : TWQry;
  SQL: String;

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

procedure TmainForm.LMenStatusClick(Sender: TObject);
var
  SQL: String;
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
begin
  Import.BasisImport;
end;

end.
