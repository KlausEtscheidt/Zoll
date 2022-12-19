unit TeileStatusKontrolleFrame;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.DBCtrls,
  Vcl.DBCGrids,
//  Data.Win.ADODB,
  Tools, Data.DB, System.ImageList, Vcl.ImgList, Vcl.ExtCtrls, System.Actions,
  Vcl.ActnList, Import;

type
  TTeileStatusKontrolleFrm = class(TFrame)
    TeileDataSource: TDataSource;
    ImageList1: TImageList;
    Panel1: TPanel;
    FilterTName1: TEdit;
    FilterTeileNr: TEdit;
    FilterOffBtn: TButton;
    LabelFiltern: TLabel;
    Panel3: TPanel;
    DBCtrlGrid1: TDBCtrlGrid;
    TeileNr: TDBText;
    TName1: TDBText;
    Panel2: TPanel;
    DBCtrlGrid2: TDBCtrlGrid;
    LKurznameDBText: TDBText;
    LName1DBText: TDBText;
    LPfkDBText: TDBText;
    LieferantenDataSource: TDataSource;
    Pfk: TDBText;
    PfkOnCheckBox: TCheckBox;
    PfkOffCheckBox: TCheckBox;
    Lekl: TDBText;
    TeileNrLabel: TLabel;
    BenennungLabel: TLabel;
    PfkLabel: TLabel;
    LKNameLabel: TLabel;
    LNameLabel: TLabel;
    StatusLabel: TLabel;
    LPfkLabel: TLabel;
    giltDBText: TDBText;
    Label1: TLabel;
    procedure TeileDataSourceDataChange(Sender: TObject; Field: TField);
    procedure FilterTeileNrChange(Sender: TObject);
    procedure FilterTName1Change(Sender: TObject);
    procedure FilterOffBtnClick(Sender: TObject);
    procedure PfkOnCheckBoxClick(Sender: TObject);
    procedure PfkOffCheckBox2Click(Sender: TObject);
  private
    LocalQry: TWQry;
    LocalSubQry: TWQry;
    Initialized:Boolean;

  public
    procedure ShowFrame;
    procedure FilterUpdate();
  end;

implementation

{$R *.dfm}

{ TTeileFrm }

procedure TTeileStatusKontrolleFrm.TeileDataSourceDataChange(Sender: TObject;
  Field: TField);
begin
    if not Initialized then
      exit;
    LocalSubQry.HoleLieferantenZuTeil(TeileNr.Caption);
end;


procedure TTeileStatusKontrolleFrm.FilterUpdate();
var
  FilterStr : String;
  filtern : Boolean;
begin

    filtern := False;
    FilterStr := '';

    if length(FilterTeileNr.Text)>0 then
    begin
      FilterStr := 'TeileNr Like ''%' + FilterTeileNr.Text + '%''';
      filtern := True;
    end;

    if length(FilterTName1.Text)>0 then
    begin
      if filtern then
        FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'TName1 Like ''%' + FilterTName1.Text + '%''';
    end;

    if PfkOnCheckBox.Checked then
    begin
      if filtern then
        FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'Pfk=1';
    end;

    if PfkOffCheckBox.Checked then
    begin
      if filtern then
        FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'Pfk=0';
    end;

    LocalQry.Filter := FilterStr;
    LocalQry.Filtered := filtern;

end;

procedure TTeileStatusKontrolleFrm.PfkOffCheckBox2Click(Sender: TObject);
begin
  if PfkOffCheckBox.Checked then
     PfkOnCheckBox.Checked:=False;
  FilterUpdate();
end;

procedure TTeileStatusKontrolleFrm.PfkOnCheckBoxClick(Sender: TObject);
begin
  if PfkOnCheckBox.Checked then
     PfkOffCheckBox.Checked:=False;
  FilterUpdate();
end;

procedure TTeileStatusKontrolleFrm.FilterOffBtnClick(Sender: TObject);
begin
 FilterTeileNr.Text := '';
 FilterTName1.Text := '';
 FilterUpdate;
end;

procedure TTeileStatusKontrolleFrm.FilterTeileNrChange(Sender: TObject);
begin
    FilterUpdate();
end;

procedure TTeileStatusKontrolleFrm.FilterTName1Change(Sender: TObject);
begin
    FilterUpdate();
end;

procedure TTeileStatusKontrolleFrm.ShowFrame;
begin
    Import.Auswerten;
    Initialized:=False;
    LocalQry := Tools.GetQuery;
    LocalQry.RunSelectQuery('SELECT TeileNr, TName1, Abs(Pfk) As Pfk FROM Teile;')  ;
    FilterUpdate();
    TeileDataSource.DataSet := LocalQry;
    LocalSubQry := Tools.GetQuery;
    LocalSubQry.HoleLieferantenZuTeil(TeileNr.Caption);
    LieferantenDataSource.DataSet := LocalSubQry;
    Initialized:=True;
    Self.Visible := True;
end;

end.
