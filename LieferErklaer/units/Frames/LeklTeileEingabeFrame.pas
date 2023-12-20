unit LeklTeileEingabeFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB, Vcl.DBCtrls, Vcl.DBCGrids,
  Vcl.ExtCtrls, Data.Bind.EngExt, Vcl.Bind.DBEngExt, System.Rtti,
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
    PfkResetBtn: TButton;
    PfkSetBtn: TButton;
    Label2: TLabel;
    PfkOnCheckBox: TCheckBox;
    PfkOffCheckBox: TCheckBox;
    n_gefiltert: TLabel;
    procedure SortLTeileNrBtnClick(Sender: TObject);
    procedure SortLTNameBtnClick(Sender: TObject);
    procedure SortTeilenrBtnClick(Sender: TObject);
    procedure PFKChkBoxClick(Sender: TObject);
    procedure FilterTeileNrChange(Sender: TObject);
    procedure FilterTName1Change(Sender: TObject);
    procedure FilterLTeileNrChange(Sender: TObject);
    procedure FilterTName2Change(Sender: TObject);
    procedure FilterOffBtnClick(Sender: TObject);
    procedure PfkResetBtnClick(Sender: TObject);
    procedure PfkSetBtnClick(Sender: TObject);
    procedure PfkSet(NeuerWert:Integer);
    procedure PfkOnCheckBoxClick(Sender: TObject);
    procedure PfkOffCheckBoxClick(Sender: TObject);

  public
    LocalQry: TWQry;
    LErklaerungenTab: TADOTable;
    IdLieferant: Integer;
    DatenGeaendert:Boolean;
    procedure Init;
    procedure HideFrame();
    procedure FilterUpdate();

  end;

implementation

{$R *.dfm}

procedure TLieferantenErklaerungenFrm.Init;

begin
    LocalQry := Tools.GetQuery;
    LocalQry.HoleLErklaerungen(IdLieferant);
    FilterUpdate;
    DataSource1.DataSet := LocalQry;
    DatenGeaendert:=False;
end;

procedure TLieferantenErklaerungenFrm.SortLTeileNrBtnClick(Sender: TObject);
begin
{$IFDEF FIREDAC}
   LocalQry.IndexFieldNames  := 'LTeileNr';
{$ELSE}
   LocalQry.Sort := 'LTeileNr';
{$ENDIF}
end;

procedure TLieferantenErklaerungenFrm.SortTeilenrBtnClick(Sender: TObject);
begin
{$IFDEF FIREDAC}
   LocalQry.IndexFieldNames  := 'TeileNr';
{$ELSE}
   LocalQry.Sort := 'TeileNr';
{$ENDIF}
end;

procedure TLieferantenErklaerungenFrm.SortLTNameBtnClick(Sender: TObject);
begin
{$IFDEF FIREDAC}
   LocalQry.IndexFieldNames  := 'TName1;TName2';
{$ELSE}
   LocalQry.Sort := 'TName1,TName2';
{$ENDIF}
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
    //merken das Daten geaendert wurden
    DatenGeaendert:=True;
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
{$IFDEF FIREDAC}
    LocalQry.Refresh;
{$ELSE}
    LocalQry.Requery();
{$ENDIF}

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


// Löschen der Pfk aller Teile eines Lieferanten
procedure TLieferantenErklaerungenFrm.PfkResetBtnClick(Sender: TObject);
begin
  PfkSet(0);
end;

// Setzen der Pfk aller Teile eines Lieferanten
procedure TLieferantenErklaerungenFrm.PfkSetBtnClick(Sender: TObject);
begin
  PfkSet(-1);
end;

// Setzen oder löschen der Pfk aller Teile eines Lieferanten
procedure TLieferantenErklaerungenFrm.PfkSet(NeuerWert:Integer);
var
  UpdateQry,LocalQry2:TWQry;
  TeileNr:String;
begin
    //merken das Daten geaendert wurden
    DatenGeaendert:=True;

    LocalQry2:=Tools.GetQuery;
    UpdateQry:=Tools.GetQuery;
    LocalQry2.RunExecSQLQuery('BEGIN TRANSACTION');
    LocalQry.First;
    while not LocalQry.Eof do
    begin
      TeileNr:=LocalQry.FieldByName('TeileNr').AsString;
      UpdateQry.UpdateLPfkInLErklaerungen(IdLieferant,TeileNr,NeuerWert);
      LocalQry.Next;
    end;
    LocalQry2.RunExecSQLQuery('COMMIT');
{$IFDEF FIREDAC}
    LocalQry.Refresh;
{$ELSE}
    LocalQry.Requery();
{$ENDIF}
    LocalQry.First;

end;


procedure TLieferantenErklaerungenFrm.PfkOffCheckBoxClick(Sender: TObject);
begin
  if PfkOffCheckBox.Checked then
    begin
       PfkOnCheckBox.Checked:=False;
       PfkResetBtn.Enabled:=False;
       PfkSetBtn.Enabled:=False;
    end
  else
    begin
       PfkResetBtn.Enabled:=True;
       PfkSetBtn.Enabled:=True;
    end;
  FilterUpdate();
end;

procedure TLieferantenErklaerungenFrm.PfkOnCheckBoxClick(Sender: TObject);
begin
  if PfkOnCheckBox.Checked then
  begin
     PfkOffCheckBox.Checked:=False;
     PfkResetBtn.Enabled:=False;
     PfkSetBtn.Enabled:=False;
  end
  else
    begin
       PfkResetBtn.Enabled:=True;
       PfkSetBtn.Enabled:=True;
    end;
  FilterUpdate();
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
      FilterStr := FilterStr + 'LTeileNr Like ''%' + FilterLTeileNr.Text + '%''';
    end;

    if PfkOnCheckBox.Checked then
    begin
      if filtern then
        FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'LPfk=-1';
    end;

    if PfkOffCheckBox.Checked then
    begin
      if filtern then
        FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'LPfk=0';
    end;

    LocalQry.Filter := FilterStr;
    LocalQry.Filtered := filtern;
    n_gefiltert.Caption := Format('Anzahl gefiltert: %d',[LocalQry.RecordCount]);

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
