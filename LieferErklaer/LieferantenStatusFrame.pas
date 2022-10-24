unit LieferantenStatusFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.Win.ADODB, Data.DB,
  Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids,datenmodul;

type
  TLieferantenStatusFrm = class(TFrame)
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
    ADOConnection1: TADOConnection;
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
    procedure FilterNameChange(Sender: TObject);
    procedure FilterKurznameChange(Sender: TObject);
    procedure TeileBtnClick(Sender: TObject);

  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

implementation

{$R *.dfm}

uses mainfrm;


procedure TLieferantenStatusFrm.FilterNameChange(Sender: TObject);
begin
  if length(FilterName.Text)>0 then
  begin
    FilterKurzname.Text := '';
    ADOQuery1.Filtered :=True;
    ADOQuery1.Filter := 'LName1 Like ''%' + FilterName.Text + '%''';
  end
  else
    ADOQuery1.Filtered :=False;

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
    ADOQuery1.Filtered :=True;
    ADOQuery1.Filter := 'LKurzname Like ''%' + FilterKurzname.Text + '%''';
  end
  else
    ADOQuery1.Filtered :=False;

end;


end.
