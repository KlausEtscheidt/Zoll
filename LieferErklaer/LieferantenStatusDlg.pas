unit LieferantenStatusDlg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.DBCtrls,
  Vcl.Mask, Data.DB, Data.Win.ADODB, Vcl.Grids, Vcl.DBGrids;

type
  TLieferantenStatusDialog = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    OKBtn: TButton;
    ESCBtn: TButton;
    DateTimePicker1: TDateTimePicker;
    LStatusDQuelle: TDataSource;
    ADOQuery3: TADOQuery;
    ADOQuery3Id: TIntegerField;
    ADOQuery3Status: TStringField;
    ADOConnection1: TADOConnection;
    StatusListBox: TDBLookupListBox;
    alterStatus: TLabel;
    procedure StatusListBoxClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  LieferantenStatusDialog: TLieferantenStatusDialog;

implementation

{$R *.dfm}

uses mainfrm;

procedure TLieferantenStatusDialog.StatusListBoxClick(Sender: TObject);
begin
  alterStatus.Caption
            := StatusListBox.SelectedItem;
end;

end.
