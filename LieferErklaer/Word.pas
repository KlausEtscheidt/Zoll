unit Word;

interface

uses System.SysUtils, Vcl.Dialogs, ComObj, Tools;

procedure   SendeFax();

var
  WordApp: OleVariant;

const
  WordFileName = '\db\Lieferanterklärung-Anschreiben Fax 2021.docx';

implementation

function StartWord(Visible:Boolean=True):Boolean;
begin
   try
      //get word OLE
      WordApp := GetActiveOleObject('Word.Application');
   except
     try
        //create Word OLE
        WordApp := CreateOleObject('Word.Application');
     except
         result:=False;
     end;

   end;

   result:=True;

   WordApp.Visible := Visible;
end;

procedure   SendeFax();
var
  WordDoc:OleVariant;
  Field:OleVariant;
  Textmarke:OleVariant;
  Range:OleVariant;
  name:string;
  nFields,i:Integer;

begin

   if not StartWord then
      raise Exception.Create('Word konnte nicht gestartet werden!');

//Neues Worddokument öffnen
WordDoc := WordApp.Documents.Open(Tools.ApplicationBaseDir+WordFileName);

//WordDoc.Select;
nFields:=WordApp.ActiveDocument.Bookmarks.Count;
//nFields:=WordApp.Selection.FormFields.Count;
nFields:=WordDoc.Bookmarks.Count;

//if WordApp.ActiveDocument.Bookmarks.Exists('test')=True Then
//  WordApp.ActiveDocument.Bookmarks.Exists('test').Range.Text := 'DeinText';
for i := 1 to nFields do
begin
  Textmarke:=WordDoc.Bookmarks.Item(i);
  name:=Textmarke.Name;
end;

name:='Adresse1';
if WordApp.ActiveDocument.Bookmarks.Exists(name)=True Then
  begin
      Range:=WordApp.ActiveDocument.Bookmarks.Item(name).Range;
      Range.Text := 'eineAdresse1';
      WordDoc.Bookmarks.Add(name,Range);
  end;

name:='Adresse2';
if WordApp.ActiveDocument.Bookmarks.Exists(name)=True Then
  begin
      Range:=WordApp.ActiveDocument.Bookmarks.Item(name).Range;
      Range.Text := 'feine Adr2';
      WordDoc.Bookmarks.Add(name,Range);
  end;

name:='Fax';
if WordApp.ActiveDocument.Bookmarks.Exists(name)=True Then
  begin
      Range:=WordApp.ActiveDocument.Bookmarks.Item(name).Range;
      Range.Text := '0815 12354667';
      WordDoc.Bookmarks.Add(name,Range);
  end;



//WordDoc.SaveAs(WordFileNameNew);
//WordDoc.Close
end;



end.
