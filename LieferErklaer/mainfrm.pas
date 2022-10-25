unit mainfrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids,Settings,Import, Vcl.Menus, Vcl.ComCtrls, Vcl.Tabs,
  Vcl.TitleBarCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCGrids,
  Vcl.DBCtrls, LieferantenStatusFrame, LieferantenErklaerungenFrame, Init;

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
    LMenErklaer: TMenuItem;
    LieferantenStatusFrm1: TLieferantenStatusFrm;
    LieferantenErklaerungenFrm1: TLieferantenErklaerungenFrm;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure UnippsMenEinlesenClick(Sender: TObject);
    procedure LMenStatusClick(Sender: TObject);
    procedure LMenErklaerClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  mainForm: TmainForm;

implementation

{$R *.dfm}


procedure TmainForm.FormDestroy(Sender: TObject);
begin
  close;
end;

procedure TmainForm.FormShow(Sender: TObject);
begin
//  Import.BasisImportFromUNIPPS;
    Init.Start;
    LieferantenStatusFrm1.InitFrame;
    LieferantenStatusFrm1.Visible := True;
    LieferantenErklaerungenFrm1.Visible := False;
end;

procedure TmainForm.LMenErklaerClick(Sender: TObject);
var
  Qry : TWQry;
  SQL: String;

begin
    LieferantenStatusFrm1.Visible := False;
    LieferantenErklaerungenFrm1.Visible := True;
end;

procedure TmainForm.LMenStatusClick(Sender: TObject);
var
  SQL: String;
begin
    LieferantenStatusFrm1.Visible := True;
    LieferantenErklaerungenFrm1.Visible := False;
end;

procedure TmainForm.UnippsMenEinlesenClick(Sender: TObject);
begin
  Import.BasisImport;
end;

end.
