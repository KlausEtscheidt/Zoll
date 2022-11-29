unit LieferantenLEKL3AuswahlFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.DateUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.Win.ADODB, Data.DB,
  Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids,datenmodul,
  LieferantenStatusDlg, Tools, Vcl.Mask, System.ImageList, Vcl.ImgList,
  Vcl.Buttons, System.Actions, Vcl.ActnList, Vcl.ExtCtrls;

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
    Label8: TLabel;
    LKurznameTxt: TDBText;
    IDLieferantTxt: TDBText;
    TeileBtn: TButton;
    Label10: TLabel;
    Label11: TLabel;
    FilterAusBtn: TButton;
    ImageList1: TImageList;
    LeklUpdatedChkBox: TCheckBox;
    ActionList1: TActionList;
    FilterUpdateAction: TAction;
    Panel1: TPanel;
    Label3: TLabel;
    Label7: TLabel;
    Label4: TLabel;
    Panel2: TPanel;
    giltBisDBText: TDBText;
    DatumStatusDBText: TDBText;
    DatumTeileDBText: TDBText;
    UnbearbeiteteCheckBox: TCheckBox;
    Panel3: TPanel;
    Label6: TLabel;
    DBText1: TDBText;
    DBText2: TDBText;
    procedure TeileBtnClick(Sender: TObject);
    procedure ShowFrame();
    procedure HideFrame();
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure FilterAusBtnClick(Sender: TObject);
    procedure LeklUpdatedChkBoxClick(Sender: TObject);
    procedure FilterUpdateActionExecute(Sender: TObject);

  private
    //Wieviele Tage muss die Lieferantenerklärung mindestens noch gelten
    minRestGueltigkeit:String;
    //Ab wievielen Tagen gilt ein Status als veraltet (Eingabe vom Vorjahr)
    veraltet:String;
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
    //Ab wievielen Tagen gilt ein Status als veraltet (Eingabe vom Vorjahr)
    veraltet:=LocalQry.LiesProgrammDatenWert('veraltet');
    //Lies alle Lieferanten mit Erklärungs "einige Teile"
    LocalQry.HoleLieferantenFuerTeileEingabe(minRestGueltigkeit);
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

    if UnbearbeiteteCheckBox.State = cbChecked then
    begin
      filtern := True;
      FilterStr := FilterStr + 'AlterStandTeile >'+ veraltet ;
    end;

    //Die LEKL wurde aktuell (vor weniger als veraltet Tagen )eingelesen
    if LeklUpdatedChkBox.State = cbChecked then
    begin
      if filtern then
        FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'AlterStand <' + veraltet ;
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

procedure TLieferantenStatusFrm.LeklUpdatedChkBoxClick(Sender: TObject);
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
