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
    LieferantenStatusFrm1: TLieferantenStatusFrm;
    GesamtStatusFrm1: TGesamtStatusFrm;
    TeileFrm1: TTeileFrm;
    LieferantenErklAnfordernFrm1: TLieferantenErklAnfordernFrm;

    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HideAllFrames;
    procedure UnippsMenEinlesenClick(Sender: TObject);
    procedure LTeileMenStatusClick(Sender: TObject);
//    procedure LMenErklaerClick(Sender: TObject);
//    procedure LieferantenErklaerungenFrm1Button1Click(Sender: TObject);
    procedure UnippsMenAuswertenClick(Sender: TObject);
    procedure StatusMenAnzeigenClick(Sender: TObject);
    procedure TeileMenUebersichtClick(Sender: TObject);
    procedure LieferMenAdressenClick(Sender: TObject);
    procedure LieferMenErklaerAnfordernClick(Sender: TObject);
//    procedure LieferantenErklAnfordernFrm1FaxActionExecute(Sender: TObject);
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

uses Excel, Mailing;

procedure TmainForm.FormShow(Sender: TObject);
begin
    //Aut. Start nur zu Entwicklungszwecken; Sonst über Menu starten
//    Import.BasisImport;
//  LieferantenErklAnfordernFrm1.FaxActionExecute(Sender);
    StatusBarLeft('verbunden mit: ' + Tools.DbConnector.Datenbank);
    HideAllFrames;
    LieferantenErklAnfordernFrm1.ShowFrame;
//    LieferantenStatusFrm1.ShowFrame;
end;


procedure TmainForm.HideAllFrames;
begin
    LieferantenStatusFrm1.Visible:=False;
    GesamtStatusFrm1.Visible:=False;
    TeileFrm1.Visible:=False;
    LieferantenErklAnfordernFrm1.Visible:=False;
end;


procedure TmainForm.FormDestroy(Sender: TObject);
begin
  close;
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

//procedure TmainForm.LieferantenErklAnfordernFrm1FaxActionExecute(
//  Sender: TObject);
//begin
//  LieferantenErklAnfordernFrm1.FaxActionExecute(Sender);
//
//end;

//procedure TmainForm.LMenErklaerClick(Sender: TObject);
//begin
//    LieferantenStatusFrm1.HideFrame;
////    LieferantenErklaerungenFrm1.Visible := True;
//end;

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
       + 'Dieser Vorgang dauert ca 5 Minuten!'
       + #13 + #13
       + 'Er sollte und muss genau EINMAL im Jahr,' + #13
       + 'zu Beginn der Eingabe der Lieferantenerklärungen ausgeführt werden.'
       + #13 + #13 + 'Wollen Sie jetzt Daten aus UNIPPS einlesen ?';
  if MessageDlg(msg,mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
    TBasisImport.Create(False);

end;

//Setze Pfade, Verbinde zur Datenbank etc
//!! wird sogar noch vor Application.Initialize ausgeführt
//Hier eigentlich unnötig, da vorher die initialization der Unit Tools
//ausgeführt wird, die auch Tools.init aufruft
initialization
//  Tools.init;

end.
