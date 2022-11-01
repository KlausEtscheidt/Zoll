unit LieferantenErklaerungenFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB, Vcl.DBCtrls, Vcl.DBCGrids,
  datenmodul, Vcl.ExtCtrls, Data.Bind.EngExt, Vcl.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Vcl.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope, Tools, System.ImageList, Vcl.ImgList;

type
  TLieferantenErklaerungenFrm = class(TFrame)
    DBCtrlGrid1: TDBCtrlGrid;
    PFKChkBox: TDBCheckBox;
    TeileNr: TDBText;
    TName1: TDBText;
    TName2: TDBText;
    LTeileNr: TDBText;
    DataSource1: TDataSource;
    BackBtn: TButton;
    Label1: TLabel;
    LKurznameLbl: TLabel;
    IdLieferantLbl: TLabel;
    SortLTeileNrBtn: TButton;
    SortTeilenrBtn: TButton;
    SortLTNameBtn: TButton;
    LabelSort: TLabel;
    LabelFiltern: TLabel;
    FilterTeileNr: TEdit;
    FilterTName1: TEdit;
    FilterLTeileNr: TEdit;
    FilterTName2: TEdit;
    FilterOffBtn: TButton;
    ImageList1: TImageList;
    procedure BackBtnClick(Sender: TObject);
    procedure SortLTeileNrBtnClick(Sender: TObject);
    procedure SortLTNameBtnClick(Sender: TObject);
    procedure SortTeilenrBtnClick(Sender: TObject);
    procedure PFKChkBoxClick(Sender: TObject);
    procedure FilterTeileNrChange(Sender: TObject);
    procedure FilterTName1Change(Sender: TObject);
    procedure FilterLTeileNrChange(Sender: TObject);
    procedure FilterTName2Change(Sender: TObject);
    procedure FilterOffBtnClick(Sender: TObject);
  private
    { Private-Deklarationen }
    OldFrame: TFrame;
  public
    LocalQry: TWQry;
    LErklaerungenTab: TADOTable;
    IdLieferant: Integer;
    procedure ShowFrame(myOldFrame: TFrame);
    procedure HideFrame();
    procedure FilterUpdate();

  end;

implementation

{$R *.dfm}

procedure TLieferantenErklaerungenFrm.ShowFrame(myOldFrame: TFrame);
var
  SQL : String;

begin
    OldFrame := myOldFrame;
    LocalQry := Tools.GetQuery;
    LocalQry.HoleLErklaerungen(IdLieferant);
    DataSource1.DataSet := LocalQry;

    //langsam Update-Query ist schneller
//    LErklaerungenTab := Tools.GetTable('LErklaerungen');
//    LErklaerungenTab.Open;

    Self.Visible := True;
end;

procedure TLieferantenErklaerungenFrm.SortLTeileNrBtnClick(Sender: TObject);
begin
   LocalQry.Sort := 'LTeileNr';
end;

procedure TLieferantenErklaerungenFrm.SortTeilenrBtnClick(Sender: TObject);
begin
   LocalQry.Sort := 'TeileNr';
end;

procedure TLieferantenErklaerungenFrm.SortLTNameBtnClick(Sender: TObject);
begin
   LocalQry.Sort := 'TName1,TName1';
end;

procedure TLieferantenErklaerungenFrm.BackBtnClick(Sender: TObject);
begin
    Self.HideFrame;
    OldFrame.Visible := True;
end;

procedure TLieferantenErklaerungenFrm.HideFrame();
begin
  if assigned(LocalQry) then
    LocalQry.Close;
  Self.Visible := False;
end;

///<summary> Uebertragen des PFK-Flags in die Datenbank</summary>
///<remarks>
/// Durch den left-Join geht dies nicht direkt in der LocalQry
/// Die Daten werden in die Tabelle LErklaerungen eingetragen
/// Das Formular merkt sich aber, das Daten ge�ndert wurden,
/// was wiederum zu Problemen f�hrt.
/// Nach dem Auslesen der Daten aus dem Formular,
/// wird dieses daher von der Datenquelle getrennt.
/// Nach dem Abspeichern der Daten in der Tabelle,
/// erhaelt LocalQry durch ein Requery die aktuellen Daten
/// und wird wieder mit dem Formular verbunden.
/// LocalQry und Formular werden wieder auf den ge�nderten Record positionert.
///</remarks>
procedure TLieferantenErklaerungenFrm.PFKChkBoxClick(Sender: TObject);
var
  UpdateQry:TWQry;
  BM:TBookmark;
  TeileNr:String;
  Pfk,PanelIndex:Integer;

begin
    // akt. Datensatz merken
    BM := LocalQry.GetBookmark;

    // TeileNr aus Basis-Abfrage
    TeileNr := LocalQry.FieldByName('TeileNr').AsString;
//    Pfk := LocalQry.FieldByName('LPfk').AsInteger;

    //Pfk aus Formular
    if PFKChkBox.Checked then
        Pfk:=-1
    else
        Pfk:=0;

    // Anzeige-Position des aktuellen Datensatzes im Panel merken
    PanelIndex:=DBCtrlGrid1.PanelIndex;

    // Formular von der Abfrage trennen
    DataSource1.DataSet := nil;

//    LErklaerungenTab.Locate('IdLieferant;TeileNr',VarArrayOf([LiefId,TeileNr]),[]);
//    LErklaerungenTab.Edit;
//    LErklaerungenTab.FieldByName('LPfk').AsInteger:=Pfk;
//    LErklaerungenTab.Post;

    // --- Update-Abfrage �bernimmt Daten in LErklaerungen-Tabelle
    UpdateQry := Tools.GetQuery;
    UpdateQry.UpdateLPfkInLErklaerungen(IdLieferant, TeileNr, Pfk);

    // Basis-Abfrage erneuern, um aktuelle Daten anzuzeigen
    LocalQry.Requery();

    // Zurueck auf alten Datensatz
    LocalQry.GotoBookmark(BM);

    // Formular wieder mit Abfrage verbinden
    DataSource1.DataSet := LocalQry;

    // Positioniere auf "PanelIndex" Datens�tze vorher,
    // um die alte Position im Anzeige-Panel wieder herzustellen.
    // DBCtrlGrid1 setzt den aktiven Record (hoffentlich) immer auf Position 0
    // Der mit MoveBy aktivierte Record wird also an erster Pos dargestellt
    // Der ge�nderte Record erhalt die alte Pos "PanelIndex"
    LocalQry.MoveBy(-PanelIndex) ;

//    DBCtrlGrid1.PanelIndex:=0;

end;

procedure TLieferantenErklaerungenFrm.FilterUpdate();
var
  FilterStr : String;
  filtern : Boolean;
begin

    filtern := False;
    FilterStr := '';

    if length(FilterTeileNr.Text)>0 then
    begin
      FilterStr := 'TeileNr Like ''' + FilterTeileNr.Text + '%''';
      filtern := True;
    end;

    if length(FilterTName1.Text)>0 then
    begin
      if filtern then
        FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'TName1 Like ''%' + FilterTName1.Text + '%''';
    end;

    if length(FilterTName2.Text)>0 then
    begin
      if filtern then
        FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'TName2 Like ''%' + FilterTName2.Text + '%''';
    end;

    if length(FilterLTeileNr.Text)>0 then
    begin
      if filtern then
        FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'LTeileNr Like ''' + FilterLTeileNr.Text + '%''';
    end;

    LocalQry.Filter := FilterStr;
    LocalQry.Filtered := filtern;

end;

procedure TLieferantenErklaerungenFrm.FilterOffBtnClick(Sender: TObject);
begin
 FilterTeileNr.Text := '';
 FilterTName1.Text := '';
 FilterTName2.Text := '';
 FilterLTeileNr.Text := '';
 FilterUpdate;
end;

procedure TLieferantenErklaerungenFrm.FilterLTeileNrChange(Sender: TObject);
begin
  FilterUpdate();
end;

procedure TLieferantenErklaerungenFrm.FilterTeileNrChange(Sender: TObject);
begin
  FilterUpdate();
end;

procedure TLieferantenErklaerungenFrm.FilterTName1Change(Sender: TObject);
begin
  FilterUpdate();
end;

procedure TLieferantenErklaerungenFrm.FilterTName2Change(Sender: TObject);
begin
  FilterUpdate();
end;

end.
