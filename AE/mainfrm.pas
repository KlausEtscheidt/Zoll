unit mainfrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls,
  System.DateUtils;

type
  TErsatzAE = array[1..3] of Double;

type
  Tmainform = class(TForm)
    MainMenu1: TMainMenu;
    DateiMen: TMenuItem;
    EndeMen: TMenuItem;
    Label1: TLabel;
    JahrRBtn: TRadioButton;
    MonatRBtn: TRadioButton;
    Label2: TLabel;
    MonatEdit: TEdit;
    JahrEdit: TEdit;
    MonatLabel: TLabel;
    Label4: TLabel;
    AuswertenBtn: TButton;
    EndeBtn: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    InlandLabel: TLabel;
    EUAuslandLabel: TLabel;
    NEUAuslandLabel: TLabel;
    procedure EndeMenClick(Sender: TObject);
    procedure MonatRBtnClick(Sender: TObject);
    procedure JahrRBtnClick(Sender: TObject);
    procedure EndeBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MonatEditExit(Sender: TObject);
    procedure JahrEditExit(Sender: TObject);
    procedure AuswertenBtnClick(Sender: TObject);
    procedure JahrEditMouseLeave(Sender: TObject);
    procedure MonatEditMouseLeave(Sender: TObject);
    procedure JahrEditChange(Sender: TObject);
    procedure MonatEditChange(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure UmfangGeaendert;
    function PruefeMonatseingabe:Integer;
    function PruefeJahreseingabe:Integer;
    procedure SetzeStartwertJahr;
    procedure SetzeStartwertMonat;
    procedure AEWerteRuecksetzen;

  end;

function HoleErsatzAE(Monat, Jahr:Integer):TErsatzAE;

var
  mainform: Tmainform;

implementation

{$R *.dfm}

procedure Tmainform.UmfangGeaendert;
begin
    MonatEdit.Visible:=MonatRBtn.Checked;
    MonatLabel.Visible:=MonatRBtn.Checked;
end;

procedure Tmainform.AuswertenBtnClick(Sender: TObject);
var
  Monat,Jahr:Integer;
  AE:TErsatzAE;
begin
  Monat:=0;
  Jahr := PruefeJahreseingabe;
  if MonatRBtn.Checked then
  begin
    Monat:= PruefeMonatseingabe;
  end;

  AE:=HoleErsatzAE(Monat, Jahr);
  InlandLabel.Caption:= Format('%8.2f €',[AE[1]]);
  EUAuslandLabel.Caption:= Format('%8.2f €',[AE[2]]);
  NEUAuslandLabel.Caption:= Format('%8.2f €',[AE[3]]);

end;

function HoleErsatzAE(Monat, Jahr:Integer):TErsatzAE;
var
  minDate,maxDate:String;
  maxMonat,maxJahr:Integer;
  AE:TErsatzAE;
begin

  if Monat=0 then
      //Jahresauswertung
      begin
        Monat:=1;
        maxMonat:=1;
        maxJahr:=Jahr+1;
      end
  else
  if Monat=12 then
      //Monatsauswertung mit Jahresüberlauf
      begin
          maxMonat:=1;
          maxJahr:=Jahr+1;
      end
  else
      //Monatsauswertung ohne Jahresüberlauf
      begin
          maxMonat:=Monat+1;
          maxJahr:=Jahr;
      end;

  minDate:=Format('01.%.2d.%d',[Monat,Jahr]);
  maxDate:=Format('01.%.2d.%d',[maxMonat,maxJahr]);

  AE[1]:=12.34;
  AE[2]:=45.45;
  AE[3]:=1234567.89;
  result:=AE;

end;

procedure Tmainform.EndeBtnClick(Sender: TObject);
begin
  close;
end;

procedure Tmainform.EndeMenClick(Sender: TObject);
begin
   close;
end;

procedure Tmainform.SetzeStartwertMonat;
begin
     MonatEdit.Text:=IntToStr(MonthOfTheYear(Today));
end;

procedure Tmainform.SetzeStartwertJahr;
begin
     JahrEdit.Text:=IntToStr(CurrentYear());
end;

procedure Tmainform.FormShow(Sender: TObject);
begin
  SetzeStartwertMonat;
  SetzeStartwertJahr;
end;

procedure Tmainform.JahrRBtnClick(Sender: TObject);
begin
    MonatRBtn.Checked:=Not JahrRBtn.Checked;
    UmfangGeaendert;
end;

function Tmainform.PruefeJahreseingabe:Integer;
var
  Jahr,maxJahr:Integer;
  istJahr:Boolean;
begin
  maxJahr:=CurrentYear();
  istJahr:=False;
  if TryStrToInt(JahrEdit.Text, Jahr) then
    if (Jahr>=1990) and (Jahr<=maxJahr) then
      istJahr:=True;
  if Not istJahr then
    begin
      ShowMessage('Nur Zahlen von 1990 bis ' + IntToStr(maxJahr) + ' erlaubt!');
      SetzeStartwertJahr;
//      AuswertenBtn.Enabled:=False;
      result:=-1;
    end
  else
    result:=Jahr;
end;

procedure Tmainform.AEWerteRuecksetzen();
begin
  InlandLabel.Caption:= '0 €';
  EUAuslandLabel.Caption:=  '0 €';
  NEUAuslandLabel.Caption:=  '0 €';
end;

procedure Tmainform.JahrEditChange(Sender: TObject);
begin
    AEWerteRuecksetzen;
end;

procedure Tmainform.JahrEditExit(Sender: TObject);
begin
  PruefeJahreseingabe;
end;


procedure Tmainform.JahrEditMouseLeave(Sender: TObject);
begin
  PruefeJahreseingabe;
end;

function Tmainform.PruefeMonatseingabe:Integer;
var
  Monat:Integer;
  istMonat:Boolean;
begin
  istMonat:=False;
  if TryStrToInt(MonatEdit.Text, Monat) then
    if (monat>=1) and (monat<=12) then
      istMonat:=True;
  if Not istMonat then
    begin
      ShowMessage('Nur Zahlen von 1 bis 12 erlaubt!');
      SetzeStartwertMonat;
//      AuswertenBtn.Enabled:=False;
      result:=-1;
    end
  else
    result:=Monat;

end;

procedure Tmainform.MonatEditChange(Sender: TObject);
begin
  AEWerteRuecksetzen;
end;

procedure Tmainform.MonatEditExit(Sender: TObject);
begin
    PruefeMonatseingabe;
end;

procedure Tmainform.MonatEditMouseLeave(Sender: TObject);
begin
    PruefeMonatseingabe;
end;

procedure Tmainform.MonatRBtnClick(Sender: TObject);
begin
    JahrRBtn.Checked:=Not MonatRBtn.Checked;
    UmfangGeaendert;
end;

end.
