unit Excel;

interface
uses System.SysUtils, Vcl.Dialogs,ComObj;

procedure FirstTest();
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

procedure FirstTest();
var
  ExcelWorkbook:OleVariant;

begin

   if not StartExcel then
      raise Exception.Create('Excel konnte nicht gestartet werden!');

// Add a new Workbook, Neue Arbeitsmappe öffnen
  ExcelApp.Workbooks.Add(xlWBatWorkSheet);


  // Open a Workbook, Arbeitsmappe öffnen
//  ExcelWorkbook := ExcelApp.Workbooks.Open(ExcelFileName);

  ExcelApp.Cells[1, 1].Value := 'Mein Test';

ExcelApp.Workbooks.Close;
end;

end.
