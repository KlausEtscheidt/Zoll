unit LieferantenStatusDlg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.DBCtrls,
  Vcl.Mask, Data.DB, Data.Win.ADODB, Vcl.Grids, Vcl.DBGrids, Tools;

type
  TLieferantenStatusDialog = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    OKBtn: TButton;
    ESCBtn: TButton;
    DateTimePicker1: TDateTimePicker;
    DataSource1: TDataSource;
    StatusListBox: TDBLookupListBox;
    alterStatus: TLabel;
    procedure StatusListBoxClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    LocalQry: TWQry;

  end;

var
  LieferantenStatusDialog: TLieferantenStatusDialog;

implementation

{$R *.dfm}

uses mainfrm;

procedure TLieferantenStatusDialog.FormCreate(Sender: TObject);
var
  SQL : String;

begin
    Tools.init;
    LocalQry := Tools.GetQuery;
    LocalQry.HoleLieferantenStatusTxt;
    DataSource1.DataSet := LocalQry;

end;

procedure TLieferantenStatusDialog.StatusListBoxClick(Sender: TObject);
begin
  alterStatus.Caption
            := StatusListBox.SelectedItem;
end;

end.
