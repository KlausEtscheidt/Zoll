unit Mailing;

interface

uses Vcl.Forms, Vcl.Controls, Vcl.Dialogs,
     System.Variants, System.SysUtils,
     ComObj,Data.DB, Tools;

function ConnectToOutlook():OLEVariant;
function SendeMailAn(DatensatzFelder:TFields): Boolean;

var
  OLApp: OleVariant;

const
  olMailItem = 0;
  olByValue = 1;
  olFolderInbox = 6; //Posteingang
  olFolderDrafts = 16; //Entw�rfe
  olDiscard=1; //Close ohne Save
  WindowStateNormal = 0;
  WindowStateMax = 1;
  WindowStateMin = 2;


implementation

uses mainfrm;

function ConnectToOutlook():OLEVariant;
var
  App: OleVariant;

begin
   try
      //get Outlook OLE
      App := GetActiveOleObject('Outlook.Application');
   except
     try
        //create Outlook OLE
        App := CreateOleObject('Outlook.Application');
     except
          App:=Null;
          raise Exception.Create('Konnte nicht mit Outlook verbinden.');
     end;

   end;

   result:=App;

end;

//SUche Ordner
function OutlookSucheOrdner(OrdnerName:String):OLEVariant;
var
  NameSpace,OLFolder: OLEVariant;
  FolderName:String;
  gefunden:Boolean;
  var i:Integer;

begin

  //Oberster Knoten des USERS
  NameSpace := OLApp.GetNameSpace('MAPI');

  //Hole Obersten Ordner des Users �ber Vater des Posteingangs
  OLFolder:=NameSpace.GetDefaultFolder(olFolderInbox).Parent;
  FolderName:=OLFolder.Name;

  //Hole Unterordner
  gefunden:=False;
  Result:=Null;

  for i := 1 to OLFolder.Folders.Count do
  begin
    FolderName:=OLFolder.Folders.Item[i].Name;
    if FolderName= OrdnerName then
    begin
      OLFolder:=OLFolder.Folders.Item[i];
      gefunden:=True;
      break;
    end;

  end;

  if not gefunden then
    raise Exception.Create('Keinen Ordner ' + OrdnerName
               + ' in Outlook gefunden!')
  else
    Result:=OLFolder;

end;

function SucheAttachmentInMail(MailItem: OLEVariant):OLEVariant;
var
  i:Integer;
begin
  Result:= Null;
  i := MailItem.Attachments.Count;
  if i=1 then
    Result:= MailItem.Attachments.Item[1]
  else
      Result:= Null;
//  for i := 1 to MailItem.Attachements.Count do
//  begin

end;

function OutlookSucheMailOrdnerBetreff(OLFolder: OLEVariant;
                                                  Betreff:string):OLEVariant;
 var
   MailItem:OLEVariant;
   i:Integer;
   Subject:String;
   gefunden:Boolean;

 begin
  Result:=Null;
  gefunden:=False;
  for i := 1 to OLFolder.Items.Count do
  begin
    MailItem:=OLFolder.Items.Item[i];
    Subject:=MailItem.Subject;
    if Pos(Betreff, Subject) = 1 then
    begin
      gefunden:=True;
      break;
    end;

  end;
  if not gefunden then
    raise Exception.Create('Keine Muster-Mail im Outlook-Ordner ' + #13
               + '"Muster f Lieferantenerkl�rung" gefunden!' + #13
               + 'Der Betreff muss mit "Lieferanten-Erkl�rung" beginnen.')
  else
    Result:=MailItem;
 end;

function MailingOK(MailItem: OLEVariant):Boolean;
var
  msg:string;
begin

  msg:= 'Ist die mail korrekt ?' + #13 + #13
      + 'Wenn ja, wird sie versendet und ' + #13 + #13
      + 'das Anfragedatum in der Datenbank vermerkt.';
  if MessageDlg(msg,mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
    begin
      MailItem.Send;
      Result:=True;
    end
  else
    begin
      MailItem.Close(olDiscard);
      Result:=False;
    end;

end;

//Ersetze die Standard-Anrede im mail-Body mit "Anrede"
function BodyMitAnrede(Body,Anrede:String):String;
var
  myPos:integer;
begin
   //Suche "Sehr geehrte Damen und Herren"
   myPos:=Pos('Sehr geehrte Damen und Herren', Body);
   if myPos=0 then
       raise Exception.Create('Muster-Mail muss mit ' + #13
               + '"Sehr geehrte Damen und Herren" beginnen!');

   Result:=Anrede + Copy(Body,30);

end;

function SendeMailAn(DatensatzFelder:TFields):Boolean;

var
  MailItem,MailMusterItem,MusterAttachment, OLFolder: OLEVariant;
  Anrede,Name,Empfaenger:string;
  AlteBreite:Integer;
  OK:Boolean;

begin

  Anrede := DatensatzFelder.FieldByName('Anrede').AsString;
  Name := DatensatzFelder.FieldByName('Nachname').AsString;

  if Anrede='Herr' then
     Anrede := 'Sehr geehrter Herr ' + Name
  else if Anrede='Frau' then
     Anrede := 'Sehr geehrte Frau ' + Name
  else if Anrede='' then
     Anrede := 'Sehr geehrte Damen und Herren';

  //Verbinde mit Outlook
//  if OLApp=Null then
    OLApp:=ConnectToOutlook ;
//  if OLApp=VarNull then
//    raise Exception.Create('Konnte nicht zu Outlook verbinden.');

  //Suche Ordner 'Muster f Lieferantenerkl�rung'
  OLFolder:=OutlookSucheOrdner('Muster f Lieferantenerkl�rung');

  //Suche mail nach Ordner und Betreff
  MailMusterItem:=
         OutlookSucheMailOrdnerBetreff(OLFolder, 'Lieferanten-Erkl�rung');

  try
    MailItem := OLApp.CreateItem(olMailItem);
//    MailItem.BCC := 'Dr.K.Etscheidt@wernert.de';
{$IFDEF DEBUG}
    MailItem.Recipients.Add('Dr.K.Etscheidt@wernert.de');
{$ELSE}
    Empfaenger:=DatensatzFelder.FieldByName('email').AsString;
    MailItem.Recipients.Add(Empfaenger);
{$ENDIF}
    MailItem.Subject := MailMusterItem.Subject;
    //Ersetze die Standard-Anrede im mail-Body mit "Anrede"
    MailItem.Body    := BodyMitAnrede(MailMusterItem.Body,Anrede);
    MailItem.Attachments.Add(Tools.ApplicationBaseDir
                                    + '\Vorlagen\LLE Formular.pdf');
    MailItem.Display; //zeigt nur an

    //Outlook in Vordergrund holen, Delphi klein machen
    AlteBreite:=mainfrm.mainForm.width;
    mainfrm.mainForm.width:=10;
    OLApp.ActiveWindow.WindowState:=WindowStateNormal;
    OLApp.ActiveWindow.WindowState:=WindowStateMin;

    //Nachfragen ob Mail ok
    OK:=MailingOK(MailItem);

    OLApp.ActiveWindow.WindowState:=WindowStateNormal;
    OLApp.ActiveWindow.WindowState:=WindowStateMin;
    mainfrm.mainForm.width:=AlteBreite;

    Result:=OK;

  finally
    sleep(300);
    OLApp    := VarNull;
  end;

end;

end.

initialization
 OLApp    := Null;
