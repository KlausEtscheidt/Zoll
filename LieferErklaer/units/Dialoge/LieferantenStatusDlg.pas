unit LieferantenStatusDlg;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.DateUtils,System.SysUtils, System.Variants, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Graphics, Vcl.DBCtrls, Vcl.Mask, Vcl.Grids, Vcl.DBGrids,
  Data.DB, Data.Win.ADODB, Tools;

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
    GiltNeuBtn: TButton;
    procedure StatusListBoxClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GiltNeuBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  public
    LocalQry: TWQry;
    procedure ValidateDateTime;
  end;

var
  LieferantenStatusDialog: TLieferantenStatusDialog;

implementation

{$R *.dfm}

uses mainfrm;

procedure TLieferantenStatusDialog.FormCloseQuery(Sender: TObject;
                             var CanClose: Boolean);
var
  RestTage:Integer;
  SenderComp:TComponent;

const
  msg = 'Die Restgültigkeit beträgt weniger als 100 Tage.' + #13
      + 'Soll das wirklich so übernommen werden ?';
begin

  if ModalResult=mrCancel then begin
    CanClose := true;
    exit;
  end;

  //Wenn Lekl abgegeben, Restgültigkeit prüfen
  if (StatusListBox.KeyValue=2) or (StatusListBox.KeyValue=3) then
  begin
    RestTage:=DaysBetween(Now, DateTimePicker1.DateTime);
    if RestTage<100 then
      if Application.MessageBox(msg,'Frage',MB_YESNO)=IDNO then
        CanClose:=False;
  end
  else
    CanClose:=True;
end;

procedure TLieferantenStatusDialog.FormCreate(Sender: TObject);
begin
    LocalQry := Tools.GetQuery;
    if not LocalQry.Connected then
      raise Exception.Create('Keine Verbindung zur Datenbank!');
//      exit;

    //Lieferanten-Status-Daten aus Datenbank in DataSource für Formular
    LocalQry.HoleLieferantenStatusTxt;
    DataSource1.DataSet := LocalQry;
end;

procedure TLieferantenStatusDialog.GiltNeuBtnClick(Sender: TObject);
begin
  DateTimePicker1.DateTime := IncYear(DateTimePicker1.DateTime,1);
  GiltNeuBtn.Enabled := False;
  GiltNeuBtn.Visible := False;
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
  OK:= (StatusListBox.KeyValue=2) or (StatusListBox.KeyValue=3);
  DateTimePicker1.Enabled:= OK;
  DateTimePicker1.Visible:= OK;
  GiltNeuBtn.Enabled := OK;
  GiltNeuBtn.Visible := OK;
end;

end.
