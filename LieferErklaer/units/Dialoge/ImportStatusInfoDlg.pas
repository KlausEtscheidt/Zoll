unit ImportStatusInfoDlg;

interface

uses WinApi.Windows, System.SysUtils, System.Classes,
  DateUtils,
  Vcl.Graphics, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Grids, Vcl.ExtCtrls,
  Import;

type
  TImportStatusDlg = class(TForm)
    Memo1: TMemo;
    StatusPanel: TPanel;
    StringGrid1: TStringGrid;
    Panel1: TPanel;
    actRecordLbl: TLabel;
    ImportBtn: TButton;
    ESCButton: TButton;
    procedure ImportBtnClick(Sender: TObject);
    procedure ESCButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    Start:TDateTime;
    procedure AnzeigeNeuerImportSchritt(SchrittNr:Integer;
                                                 SchrittBenennung:String);
    procedure AnzeigeEndeImportSchritt(SchrittNr:Integer);
    procedure AnzeigeRecordsGelesen(aktRecord,maxRecord:Integer);
    procedure SetRecordLabelCaption(text:String);
    procedure ImportEnde;
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
  ESCButton.Caption:='Abbruch';
  ImportBtn.Visible:=True;

end;

procedure TImportStatusDlg.AnzeigeNeuerImportSchritt(SchrittNr:Integer;
                                                      SchrittBenennung:String);
begin
  StringGrid1.Cells[1,SchrittNr-1]:=SchrittBenennung;
end;

procedure TImportStatusDlg.AnzeigeEndeImportSchritt(SchrittNr:Integer);
begin
  StringGrid1.Cells[2,SchrittNr-1]:='OK';
end;

procedure TImportStatusDlg.AnzeigeRecordsGelesen(aktRecord,maxRecord:Integer);
begin
  actRecordLbl.Caption:=
             Format('%5d von %5d Datensätzen gelesen',[aktRecord, maxRecord]);
end;

procedure TImportStatusDlg.SetRecordLabelCaption(text:String);
begin
  actRecordLbl.Caption:= text;
end;


procedure TImportStatusDlg.ImportEnde;
var
  Minuten:Double;
begin
  Minuten:=MinuteSpan(Start,Now);
  actRecordLbl.Caption:=
             (Format('Auswertung fertig in %3.1f Minuten',[Minuten]) );
end;

procedure TImportStatusDlg.ImportBtnClick(Sender: TObject);
var
  col,row:Integer;

begin
  Start:=Now;
  ESCButton.Caption:='Schließen';
  ImportBtn.Visible:=False;
  Memo1.Visible:=False;
  StatusPanel.Visible:=True;
  StringGrid1.ColWidths[0] := 60;
  StringGrid1.ColWidths[1] := 200;
//  Label1.Font.Charset := SYMBOL_CHARSET;
//  Label1.Caption :=  #252     ;
  for row := 0 to 8 do
    begin
      StringGrid1.Cells[0,row]:='Schritt ' + IntToStr(row+1) + ':';
      StringGrid1.Cells[1,row]:='';
      StringGrid1.Cells[2,row]:='';
//      StringGrid1.Cells[2,row] := 'OK';
//      StringGrid1.Canvas.Font.Color := clBlack;
    end;

  //Unipps Daten in eigenem Thread lesen
  TBasisImport.Create(False);
end;

end.

