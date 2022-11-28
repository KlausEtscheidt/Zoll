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
    Label3: TLabel;
    KommentarEdit: TEdit;
    procedure StatusListBoxClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    LocalQry: TWQry;
    procedure ValidateDateTime;
  end;

var
  LieferantenStatusDialog: TLieferantenStatusDialog;

implementation

{$R *.dfm}

uses mainfrm;

procedure TLieferantenStatusDialog.FormCreate(Sender: TObject);
begin
    LocalQry := Tools.GetQuery;
    //Lieferanten-Status-Daten aus Datenbank in DataSource für Formular
    LocalQry.HoleLieferantenStatusTxt;
    DataSource1.DataSet := LocalQry;
end;

procedure TLieferantenStatusDialog.StatusListBoxClick(Sender: TObject);
begin
  alterStatus.Caption
            := StatusListBox.SelectedItem;
  ValidateDateTime;
end;

//Zeiteingabe nur bei Auswahl 'alle Teile' oder 'einige Teile'
procedure TLieferantenStatusDialog.ValidateDateTime;
var
  OK:Boolean;
begin
  OK:= StatusListBox.KeyValue>1;
  DateTimePicker1.Enabled:= OK;
  DateTimePicker1.Visible:= OK;
end;

end.
