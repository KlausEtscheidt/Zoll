unit Excel;

interface
uses System.SysUtils, Vcl.Dialogs, Tools, ComObj;

procedure LieferantenNachExcel(LocalQry: TWQry);
function StartExcel(Visible:Boolean=True):Boolean;

var
  ExcelApp: OleVariant;

const
  ExcelFileName = 'C:\Users\Etscheidt\Desktop\Ablauf.xlsx';
  // SheetType
  xlWorksheet = -4167;
  // WBATemplate
  xlWBATWorksheet = -4167;

implementation


function StartExcel(Visible:Boolean=True):Boolean;
begin
   try
      //create Excel OLE
      ExcelApp := CreateOleObject('Excel.Application');
   except
       result:=False;
   end;
   ExcelApp.Visible := Visible;
   result:=True;
end;

procedure LieferantenNachExcel(LocalQry: TWQry);
begin
  ShowMessage(IntToStr(LocalQry.RecordCount));
    while not  LocalQry.Eof do
    begin
        LocalQry.Next
    end;

end;

procedure xxExcel();
var
  ExcelWorkbook:OleVariant;

begin

   if not StartExcel then
      raise Exception.Create('Excel konnte nicht gestartet werden!');

// Add a new Workbook, Neue Arbeitsmappe �ffnen
  ExcelApp.Workbooks.Add(xlWBatWorkSheet);


  // Open a Workbook, Arbeitsmappe �ffnen
//  ExcelWorkbook := ExcelApp.Workbooks.Open(ExcelFileName);

  ExcelApp.Cells[1, 1].Value := 'Mein Test';

ExcelApp.Workbooks.Close;
end;

end.
