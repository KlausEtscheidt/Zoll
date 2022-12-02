unit ImportStatusInfoDlg;

interface

uses WinApi.Windows, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Import,
  Vcl.Grids;

type
  TImportStatusDlg = class(TForm)
    Memo1: TMemo;
    GridPanel1: TGridPanel;
    ImportBtn: TButton;
    ESCButton: TButton;
    StatusPanel: TPanel;
    Label1: TLabel;
    StringGrid1: TStringGrid;
    procedure ImportBtnClick(Sender: TObject);
    procedure ESCButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    actVal,maxVal:Integer //für x Records von y gelesen Anzeige
  end;

var
  ImportStatusDlg: TImportStatusDlg;

implementation

{$R *.dfm}

procedure TImportStatusDlg.ESCButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TImportStatusDlg.FormShow(Sender: TObject);
begin
  Memo1.Visible:=True;
  StatusPanel.Visible:=False;
end;

procedure TImportStatusDlg.ImportBtnClick(Sender: TObject);
var
  col,row:Integer;

begin
  Memo1.Visible:=False;
  StatusPanel.Visible:=True;
  StringGrid1.ColWidths[0] := 60;
  StringGrid1.ColWidths[1] := 120;
  Label1.Font.Charset := SYMBOL_CHARSET;
  Label1.Caption :=  #252     ;
      StringGrid1.Canvas.Font.Color := clRed;
  for row := 0 to 7 do
    begin
      StringGrid1.Cells[0,row]:='Schritt ' + IntToStr(row+1) + ':';
      StringGrid1.Cells[2,row] := 'OK';
//      StringGrid1.Canvas.Font.Color := clBlack;
    end;
  StringGrid1.Cells[1,0]:='Bestellungen lesen';
  TBasisImport.Create(False);
end;

end.

