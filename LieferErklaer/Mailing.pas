unit Mailing;

interface

uses System.SysUtils, Vcl.Dialogs,ComObj;

function ConnectToOutlook():Boolean;
procedure SendeMailAn(Empfaenger:String);

var
  OLApp: OleVariant;

const
  olMailItem = 0;
  olByValue = 1;
  olFolderInbox = 6; //Posteingang
  olFolderDrafts = 16; //Entwürfe

implementation

function ConnectToOutlook():Boolean;
begin
   try
      //create Excel OLE
      OLApp := GetActiveOleObject('Outlook.Application');
   except
     try
        //create Excel OLE
        OLApp := CreateOleObject('Outlook.Application');
     except
         result:=False;
     end;

   end;

   result:=True;

end;

procedure SendeMailAn(Empfaenger:String);
var
  MailItem,MailMusterItem, NameSpace,OLFolder: OLEVariant;
  i,Jahr:Integer;
  FolderName,Subject:String;
  gefunden:Boolean;

begin

  Jahr:=CurrentYear()+1;

   if not ConnectToOutlook then
      raise Exception.Create('Es konnte nicht zu Outlook verbunden werden!');

  NameSpace := OLApp.GetNameSpace('MAPI');
  //Hole Obersten Ordner des Users über Vater des Posteingangs
  OLFolder:=NameSpace.GetDefaultFolder(olFolderInbox).Parent;
  FolderName:=OLFolder.Name;
  //Hole Unterordner
  gefunden:=False;
  for i := 1 to OLFolder.Folders.Count do
  begin
    FolderName:=OLFolder.Folders.Item[i].Name;
    if FolderName= 'Muster f Lieferantenerklärung' then
    begin
      OLFolder:=OLFolder.Folders.Item[i];
      gefunden:=True;
      break;
    end;

  end;
  if not gefunden then
    raise Exception.Create('Keinen Ordner "Muster f Lieferantenerklärung" '
               + 'in Outlook gefunden!');

  for i := 1 to OLFolder.Items.Count do
  begin
    MailMusterItem:=OLFolder.Items.Item[i];
    Subject:=MailMusterItem.Subject;
    if Copy(Subject, 1, 21) = 'Lieferanten-Erklärung' then
    begin
      gefunden:=True;
      break;
    end;

  end;
  if not gefunden then
    raise Exception.Create('Keine Muster-Mail im Outlook-Ordner ' + #13
               + '"Muster f Lieferantenerklärung" gefunden!' + #13
               + 'Der Betreff muss mit "Lieferanten-Erklärung" beginnen.');

  try
    MailItem := OLApp.CreateItem(olMailItem);
    MailItem.BCC := 'Dr.K.Etscheidt@wernert.de';
    MailItem.Recipients.Add('Klaus.Etscheidt@gmail.com');    MailItem.Recipients.Add(Empfaenger);    MailItem.Subject := MailMusterItem.Subject;    MailItem.Body    := MailMusterItem.Body;
    //    MailItem.Send;
    MailItem.Display; //zeigt nur an
  finally
//    myAttachments := VarNull;
    OLApp    := VarNull;
  end;
end;

end.
