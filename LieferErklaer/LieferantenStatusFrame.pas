unit LieferantenStatusFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.DateUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.Win.ADODB, Data.DB,
  Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids,datenmodul,
  LieferantenStatusDlg, Tools, Vcl.Mask, System.ImageList, Vcl.ImgList,
  Vcl.Buttons, System.Actions, Vcl.ActnList;

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
    Status: TDBText;
    DBText1: TDBText;
    LKurznameTxt: TDBText;
    IDLieferantTxt: TDBText;
    TeileBtn: TButton;
    Label3: TLabel;
    DBText3: TDBText;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    FilterAusBtn: TButton;
    ImageList1: TImageList;
    OffeneChkBox: TCheckBox;
    ActionList1: TActionList;
    FilterUpdateAction: TAction;
    procedure TeileBtnClick(Sender: TObject);
    procedure ShowFrame();
    procedure HideFrame();
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure FilterAusBtnClick(Sender: TObject);
    procedure OffeneChkBoxClick(Sender: TObject);
    procedure FilterUpdateActionExecute(Sender: TObject);

  private
    //Wieviele Tage muss die Lieferantenerklärung mindestens noch gelten
    minRestGueltigkeit:String;
    LocalQry: TWQry;
  public
  end;


implementation

{$R *.dfm}

uses mainfrm;

procedure TLieferantenStatusFrm.ShowFrame();
begin
    LocalQry := Tools.GetQuery;
    //Wieviele Tage muss die Lieferantenerklärung mindestens noch gelten
    minRestGueltigkeit:=LocalQry.LiesProgrammDatenWert('Gueltigkeit_Lekl');
    LocalQry.HoleLieferantenMitStatusTxt;
    DataSource1.DataSet := LocalQry;
    FilterUpdateActionExecute(nil);
    Self.Visible := True;
end;

procedure TLieferantenStatusFrm.HideFrame();
begin
  if assigned(LocalQry) then
    LocalQry.Close;
  Self.Visible := False;
end;

procedure TLieferantenStatusFrm.TeileBtnClick(Sender: TObject);
begin
    mainForm.LieferantenErklaerungenFrm1.IdLieferant
      :=  LocalQry.FieldByName('IdLieferant').AsInteger;
    mainForm.LieferantenErklaerungenFrm1.IdLieferantLbl.Caption
      := IntToStr(mainForm.LieferantenErklaerungenFrm1.IdLieferant);
    mainForm.LieferantenErklaerungenFrm1.LKurznameLbl.Caption
      :=  LocalQry.FieldByName('LKurzname').AsString;

    mainForm.LieferantenStatusFrm1.Visible := False;
    mainForm.LieferantenErklaerungenFrm1.ShowFrame(
                                    mainForm.LieferantenStatusFrm1);

end;

procedure TLieferantenStatusFrm.DataSource1DataChange(Sender: TObject;
  Field: TField);
begin
    // Bei LEKL-Status "einige Teile" Dateneingabe f�r Teile erm�glichen
    if LocalQry.FieldByName('lekl').AsInteger =3 then
      TeileBtn.Visible:=True
    else
      TeileBtn.Visible:=False;

end;

procedure TLieferantenStatusFrm.FilterUpdateActionExecute(Sender: TObject);
var
  FilterStr : String;
  filtern : Boolean;
begin

    filtern := False;
    FilterStr := '';

    if OffeneChkBox.State = cbChecked then
    begin
      filtern := True;
      FilterStr := FilterStr + 'letzteEingabeVorTagen >200' ;
    end;

    if length(FilterName.Text)>0 then
    begin
      if filtern then
        FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'LName1 Like ''%' + FilterName.Text + '%''';
    end;

    if length(FilterKurzname.Text)>0 then
    begin
      if filtern then
        FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'LKurzname Like ''' + FilterKurzname.Text + '%''';
    end;

    LocalQry.Filter := FilterStr;
    LocalQry.Filtered := filtern;

    GroupBox2.Caption:= 'gefiltert '
                   + IntToStr(LocalQry.RecordCount) + ' Lieferanten';
end;

procedure TLieferantenStatusFrm.OffeneChkBoxClick(Sender: TObject);
begin
    FilterUpdateActionExecute(Sender);
end;

procedure TLieferantenStatusFrm.FilterAusBtnClick(Sender: TObject);
begin
  FilterKurzname.Text := '';
  FilterName.Text := '';
  FilterUpdateActionExecute(Sender);
end;


end.
