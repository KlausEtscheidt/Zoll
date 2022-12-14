unit Word;

interface

uses Vcl.Forms, Vcl.Controls, Vcl.Dialogs,
     System.Variants, System.SysUtils,
     ComObj, Tools, Data.DB;

function SendeFax(DatensatzFelder:TFields): Boolean;
function IsWordFileOpen(DocPath:String):Boolean;

var
  WordApp: OleVariant;

const
  WordFileName = '\Vorlagen\Fax_Muster.docx';
  WindowStateNormal = 0;
  WindowStateMax = 1;
  WindowStateMin = 2;
  wdDoNotSaveChanges = 0;
  wdPromptToSaveChanges = -2;
  wdSaveChanges = -1;

implementation

uses mainfrm;

function StartWord(Visible:Boolean=True):OleVariant;
var
  App: OleVariant;
begin
   try
      //get word OLE
      App := GetActiveOleObject('Word.Application');
   except
     try
        //create Word OLE
        App := CreateOleObject('Word.Application');
     except
        on err: Exception do
        begin
          App:=Null;
          raise Exception.Create('Word konnte nicht gestartet werden!');
        end;
     end;

   end;
   App.Visible := Visible;
   Result:=App;
end;

function IsWordFileOpen(DocPath:String):Boolean;
var
  i,count:Integer;
  doc :OleVariant;
  name:String;
  begin
    result:=False;
    try
      count := WordApp.Documents.Count;
      for i := 1 to count do
        begin
          doc:= WordApp.Documents.Item[i];
          name:=doc.FullName;
          if name=DocPath then
            begin
              result:=True;
              break;
            end;
        end;
    except
      on err: Exception do
        begin
          raise;
       end;
    end;
end;

function OeffneWordDatei(DocPath:String):OleVariant;
  begin
    try
      Result := WordApp.Documents.Open(DocPath);
    except
      on err: Exception do
        begin
          Result := Null;
          raise Exception.Create('Dokument' + #13 +DocPath + #13 +
                                          ' konnte nicht geöffnet werden!');
       end;
    end;
end;

function SaveNCloseDlg(WordDoc:OleVariant):Boolean;
var
  msg:string;
begin

  msg:= 'Ist das Dokument korrekt ?' + #13 + #13
      + 'Wenn ja, wird es gespeichert und gedruckt.'  + #13 + #13
      + 'Das Anfragedatum wird in der Datenbank vermerkt.';
  if MessageDlg(msg,mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
    begin
//      WordDoc.Save;
      WordDoc.PrintOut;
      WordDoc.Close(wdSaveChanges);
      Result:=True;
    end
  else
    begin
      WordDoc.Close(wdDoNotSaveChanges);
      Result:=False;
    end;

end;

procedure ErsetzeTextmarkenInhalt(WordDoc:OleVariant;NameMarke,Text:string);
var
  Range:OleVariant;

begin

  if WordApp.ActiveDocument.Bookmarks.Exists(NameMarke)=True Then
    begin
        Range:=WordApp.ActiveDocument.Bookmarks.Item(NameMarke).Range;
        Range.Text := Text;
        WordDoc.Bookmarks.Add(NameMarke,Range);
    end
  else
    raise Exception.Create('Textmarke ' + NameMarke + ' nicht gefunden!');
end;

function SendeFax(DatensatzFelder:TFields):Boolean;
var
  WordDoc:OleVariant;
  DatumStr:String;
  SaveAsName:string;
  AlteBreite:Integer;
  Erfolg: Boolean;
  zuHaenden, Anrede, Name :String;

begin

  Erfolg:=False;

  //Fensterbreite merken
  AlteBreite:=mainfrm.mainForm.width;


  if DatensatzFelder.FieldByName('telefax').AsString = '' then
    raise Exception.Create('Keine Faxnummer für diesen Lieferantenvorhanden.');

  try
    //mit Word verbinden
    WordApp:= StartWord(False);
    WordApp.DisplayAlerts:=0;

    //Worddokument öffnen
    WordDoc:=OeffneWordDatei(Tools.ApplicationBaseDir + '\Vorlagen\'
                             + Tools.Faxvorlage);

    //Worddokument umbenennen
    DatumStr:=FormatDateTime('yyyy',Now);
    SaveAsName := Tools.ApplicationBaseDir + '\Brief_u_Fax\'
                + DatensatzFelder.FieldByName('LKurzname').AsString
                + '_Fax_' + DatumStr + '.docx';
    WordDoc.SaveAs(SaveAsName);

    //Dokument aendern
    DatumStr:=FormatDateTime('dd.mm.yyyy',Now);
    with DatensatzFelder do
      begin
        //Gibt es einen speziellen Ansprechpartner dieseer Firma für Lekl im UNIPPS
        if FieldByName('hat_LEKL_Ansprechp').AsString='-1' then
          begin
            Anrede := FieldByName('Anrede').AsString;
            Name := FieldByName('Nachname').AsString;

            if Anrede='Herr' then
              begin
                 Anrede := 'Sehr geehrter Herr ' + Name;
                 zuHaenden := 'Herrn ' + Name;
              end
            else if Anrede='Frau' then
              begin
                 Anrede := 'Sehr geehrte Frau ' + Name;
                 zuHaenden := 'Frau ' + Name;
              end
            else if Anrede='' then
              begin
                 Anrede := 'Sehr geehrte Damen und Herren';
                 zuHaenden := 'Abt. Verkauf';
              end
          end
        else
          begin
             Anrede := 'Sehr geehrte Damen und Herren';
             zuHaenden := 'Abt. Verkauf';
          end;

        //Ersetze Inhalt der Textmarke Adresse1 durch Inhalt des Felds name1
        ErsetzeTextmarkenInhalt(WordDoc,'Adresse1',FieldByName('name1').AsString);
        ErsetzeTextmarkenInhalt(WordDoc,'Adresse2',FieldByName('name2').AsString);
        ErsetzeTextmarkenInhalt(WordDoc,'Fax',FieldByName('telefax').AsString);
        ErsetzeTextmarkenInhalt(WordDoc,'SendeDatum',DatumStr);
        ErsetzeTextmarkenInhalt(WordDoc,'Anrede', Anrede);
        ErsetzeTextmarkenInhalt(WordDoc,'zuHaenden',zuHaenden);
      end;

    //Word in Vordergrund holen, Delphi klein machen
  //  Application.Minimize;
    mainfrm.mainForm.width:=10;

    WordApp.Visible := True;
    WordApp.Activate;
    WordApp.WindowState:=WindowStateMin;
    WordApp.WindowState:=WindowStateNormal;
  //  Sleep(500);

    //Dokument prüfen
      Erfolg:= SaveNCloseDlg(WordDoc);

    //Word nach hinten, Delphi vor
  //  Sleep(500);
    WordApp.Activate;
    WordApp.WindowState:=WindowStateNormal;
    WordApp.WindowState:=WindowStateMin;
  finally

    try
      //Schließen falls nicht geschehen
      if IsWordFileOpen(SaveAsName) then
        WordDoc.Close(wdDoNotSaveChanges);
    finally
        mainfrm.mainForm.width:=AlteBreite;
    end;
    mainfrm.mainForm.width:=AlteBreite;
  end;

  Result:=Erfolg;
end;

end.
