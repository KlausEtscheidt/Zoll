unit LieferantenStatusFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.Win.ADODB, Data.DB,
  Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids,datenmodul,
  LieferantenStatusDlg, Init, Vcl.Mask;

type
  TLieferantenStatusFrm = class(TFrame)
    DataSource1: TDataSource;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    FilterKurzname: TEdit;
    GroupBox2: TGroupBox;
    DBGrid1: TDBGrid;
    FilterName: TEdit;
    Label1: TLabel;
    GroupBox3: TGroupBox;
    DBText2: TDBText;
    Label8: TLabel;
    Label7: TLabel;
    Label6: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    DBText4: TDBText;
    DBText3: TDBText;
    DBText1: TDBText;
    LKurznameTxt: TDBText;
    IDLieferantTxt: TDBText;
    StatusBtn: TButton;
    TeileBtn: TButton;
    StandEdit: TDBEdit;
    procedure FilterNameChange(Sender: TObject);
    procedure FilterKurznameChange(Sender: TObject);
    procedure TeileBtnClick(Sender: TObject);
    procedure StatusBtnClick(Sender: TObject);
    procedure InitFrame();

  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    LocalQry: TWQry;
  end;


implementation

{$R *.dfm}

uses mainfrm;

procedure TLieferantenStatusFrm.InitFrame();
var
  SQL : String;

begin
    LocalQry := Init.GetQuery;
    SQL := 'select *,Status from lieferanten '
         + 'join LieferantenStatus '
         + 'on LieferantenStatus.id=lieferanten.lekl '
         + 'order by LKurzname;';
    LocalQry.RunSelectQuery(SQL);
    DataSource1.DataSet := LocalQry;
end;


procedure TLieferantenStatusFrm.FilterNameChange(Sender: TObject);
begin
  if length(FilterName.Text)>0 then
  begin
    FilterKurzname.Text := '';
    LocalQry.Filtered :=True;
    LocalQry.Filter := 'LName1 Like ''%' + FilterName.Text + '%''';
  end
  else
    LocalQry.Filtered :=False;

end;

procedure TLieferantenStatusFrm.StatusBtnClick(Sender: TObject);
var
  SQL: String;
  LiefId: String;
  Stand: String;
  Qry:TWQry;

begin
   LieferantenStatusDialog.alterStatus.Caption
            := LocalQry.FieldByName('Status').AsString;
   LieferantenStatusDialog.DateTimePicker1.DateTime
            := LocalQry.FieldByName('gilt_bis').AsDateTime;
   LiefId := LocalQry.FieldByName('IdLieferant').AsString;
   if (LieferantenStatusDialog.ShowModal=mrOK) then
    begin
//      ADOQuery1.Active:=False;
//      LocalQry.Close;
      Stand := DateToStr(LieferantenStatusDialog.DateTimePicker1.DateTime);
      LocalQry.Edit;
      StandEdit.Field.Value:=
              LieferantenStatusDialog.DateTimePicker1.DateTime;
      //      Qry := Init.GetQuery;
//      SQL := 'Update Lieferanten set stand="' + Stand
//          + '" where IdLieferant=' + LiefId +';' ;
//      Qry.RunExecSQLQuery(SQL);
//      LocalQry.FieldByName('Stand').Value :=
//        LieferantenStatusDialog.DateTimePicker1.DateTime;
      LocalQry.Post;
    end;


end;

procedure TLieferantenStatusFrm.TeileBtnClick(Sender: TObject);
begin
    mainForm.LieferantenStatusFrm1.Visible := False;
    mainForm.LieferantenErklaerungenFrm1.Visible := True;

end;

procedure TLieferantenStatusFrm.FilterKurznameChange(Sender: TObject);
begin
  if length(FilterKurzname.Text)>0 then
  begin
    FilterName.Text := '';
    LocalQry.Filtered :=True;
    LocalQry.Filter := 'LKurzname Like ''%' + FilterKurzname.Text + '%''';
  end
  else
    LocalQry.Filtered :=False;

end;


end.
