unit Preiseingabe;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.StdCtrls, PumpenDataSet;
type
  myGrid=class(TDBGrid);

type
  TPreisFrm = class(TForm)
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    PreisDS: TWDataSet;
    procedure FormShow(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DBGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  PreisFrm: TPreisFrm;

implementation

{$R *.dfm}

procedure TPreisFrm.DBGrid1CellClick(Column: TColumn);
begin
//    //PreisFrm.DBGrid1.DataSource.DataSet.Last;
//    PreisFrm.DBGrid1.SetFocus;
////    PreisFrm.DBGrid1.FocusCell(6, 1, True);
//    Self.DBGrid1.SelectedIndex := Column;
//    row:=  myGrid(Self.DBGrid1).row;
//    Self.DBGrid1.DataSource.DataSet.MoveBy(Cell.Y - Row);
    PreisFrm.DBGrid1.EditorMode := True;

end;


procedure TPreisFrm.DBGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Cell: TGridCoord;
  Row:Integer;
begin
//  PreisFrm.DBGrid1.SetFocus;
//
//  Cell := Self.DBGrid1.MouseCoord(X, Y);
//  Self.DBGrid1.SelectedIndex := Cell.X;
//  row:=  myGrid(Self.DBGrid1).row;
//  Self.DBGrid1.DataSource.DataSet.MoveBy(Cell.Y - Row);

end;

procedure TPreisFrm.DBGrid1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  Cell: TGridCoord;
  Row:Integer;
begin
  Cell := Self.DBGrid1.MouseCoord(X, Y);
  if (Cell.x>4) then
    begin
      Self.DBGrid1.SelectedIndex := Cell.X;
      row:=  myGrid(Self.DBGrid1).row;
      if Y> Self.DBGrid1.Height-25 then
        row:=row-1;
      Self.DBGrid1.DataSource.DataSet.MoveBy(Cell.Y - Row);
    end;

end;

procedure TPreisFrm.FormShow(Sender: TObject);
begin
//    PreisFrm.DBGrid1.DataSource.DataSet.Last;
    PreisFrm.DBGrid1.SetFocus;
////    PreisFrm.DBGrid1.FocusCell(6, 1, True);
    PreisFrm.DBGrid1.SelectedIndex:=6;
    PreisFrm.DBGrid1.EditorMode := True;
//    PreisFrm.DBGrid1.DataSource.DataSet.Last;
end;

end.
