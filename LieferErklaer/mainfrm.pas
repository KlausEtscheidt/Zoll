unit mainfrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids,Settings,Import, Vcl.Menus, Vcl.ComCtrls, Vcl.Tabs,
  Vcl.TitleBarCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, LieferantenFrm, Vcl.DBCGrids,
  Vcl.DBCtrls;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Datei1: TMenuItem;
    Ende1: TMenuItem;
    Unipps1: TMenuItem;
    UnippsEinlesen: TMenuItem;
    StatusBar1: TStatusBar;
    PageContol1: TPageControl;
    LieferantenTab: TTabSheet;
    StatusTab: TTabSheet;
    LieferantenFrame: TLieferanten;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure UnippsEinlesenClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.FormDestroy(Sender: TObject);
begin
  close;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
//  Import.BasisImportFromUNIPPS;
end;

procedure TForm1.UnippsEinlesenClick(Sender: TObject);
begin
  Import.BasisImportFromUNIPPS;
end;

end.
