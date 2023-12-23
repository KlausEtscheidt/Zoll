unit Excel;

interface
uses System.SysUtils, Vcl.Dialogs, Tools, ComObj,
     System.Variants;

procedure LieferantenNachExcel(LocalQry: TWQry);
function StartExcel(Visible:Boolean=True):OleVariant;

var
  ExcelApp: OleVariant;

const
  ExcelFileName = 'C:\Users\Etscheidt\Desktop\Ablauf.xlsx';
  // SheetType
  xlWorksheet = -4167;
  // WBATemplate
  xlWBATWorksheet = -4167;

implementation


function StartExcel(Visible:Boolean=True):OleVariant;
var
   App: OleVariant;
begin
     try
        //get word OLE
        App := GetActiveOleObject('Excel.Application');
     except
       try
          //create Word OLE
          App := CreateOleObject('Excel.Application');
       except
          on err: Exception do
          begin
            App:=Null;
            raise Exception.Create('Excel konnte nicht gestartet werden!');
          end;
       end;

     end;
     App.Visible := Visible;
     Result:=App;

end;

procedure LieferantenNachExcel(LocalQry: TWQry);
var
  Row,Col:Integer;
begin
//  ShowMessage(IntToStr(LocalQry.RecordCount));
  ExcelApp:=StartExcel;
//   if not StartExcel then
//      raise Exception.Create('Excel konnte nicht gestartet werden!');

  // Add a new Workbook, Neue Arbeitsmappe �ffnen
  ExcelApp.Workbooks.Add(xlWBatWorkSheet);

  for col := 1 to LocalQry.FieldCount do
    ExcelApp.Cells[1,col].Value := LocalQry.Fields[col-1].FieldName;

  Row:=2;

  while not LocalQry.Eof do
  begin
    for col := 1 to LocalQry.FieldCount do
    begin
      ExcelApp.Cells[Row,col].Value := LocalQry.Fields[col-1].AsString;
    end;
    Row:=Row+1;
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
