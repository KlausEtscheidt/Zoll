program XML2RST;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Generics.Collections,
  ActiveX,
  Xml.xmldom,
  Xml.XMLIntf,
  Xml.Win.msxmldom,
  Xml.XMLDoc,
  Settings in '..\lib\Tools\Settings.pas',
  Logger in '..\lib\Tools\Logger.pas',
  DelphiXMLBasics in 'DelphiXMLBasics.pas',
  DelphiXMLTop in 'DelphiXMLTop.pas';


var
  PublicOnly: Boolean;
  myXMLDoc: IXMLDocument;
  BaseDir,XmlDir,RstDir: String;
  Logger: TLogFile;

//-----------------------------------------------------------------------

//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
// Handler fuer devnotes
//--------------------------

//-----------------------------------------------------------------------
// handler für Code-Objekte
//-----------------------------------------------------------------------

procedure scan(VaterNode:IXMLNode);
var
  Node:IXMLNode;
  i:Integer;
begin
  Writeln(VaterNode.LocalName);
  if VaterNode.HasChildNodes then
    for i:=0 to VaterNode.ChildNodes.Count-1 do
    begin
      Node:=VaterNode.ChildNodes[i];
      Writeln('   ',Node.LocalName);
      scan(Node);
    end;
end;

procedure handleFile(XMLFilePath,RstFilePath:String);
var
  Path,Name:String;
  MyUnit:TUnit;
begin

    Logger:= TLogFile.Create;

    TNode.Logger:=Logger;

    Path:= ExtractFilePath(RstFilePath);
    Path:=Path.Substring(0,length(Path)-1);
    Name:= ExtractFileName(RstFilePath);
    Logger.OpenNew(Path,Name);

     myXMLDoc:= TXMLDocument.Create(nil);
//     myXMLDoc.DOMVendor := GetDOMVendor(SMSXML);
     myXMLDoc.LoadFromFile(XMLFilePath);
     myXMLDoc.Active:=True;
     MyUnit:=TUnit.Create(myXMLDoc.DocumentElement);

     Logger.Close;

end;

procedure main_test();
var
  UnitName:String;
begin
    BaseDir:= ExtractFileDir(Settings.ApplicationBaseDir);
    XmlDir:= BaseDir + '\doku\xml\';
    RstDir:= BaseDir + '\doku\source\software\zoll\';

//    TNode.ShowPublicOnly:=False;

  UnitName:='Auswerten';
  handleFile(xmldir+UnitName+'.xml',RstDir+UnitName+'.rst');

  UnitName:='ADOQuery';
//  handleFile(xmldir+UnitName+'.xml',RstDir+'lib\Datenbank\'+UnitName+'.rst');

//    handleFile(xmldir + 'PumpenDataSet.xml',RstDir+'PumpenDataSet.rst');
//    handleFile(xmldir + 'Stueckliste.xml',RstDir+'Stueckliste.rst');
//    handleFile(xmldir + 'Logger.xml',RstDir+'Logger.rst');
//     scan(myXMLDoc.DocumentElement);

end;


begin
  try
      CoInitialize(nil);
      TNode.ShowPublicOnly:=True;

      if ParamCount=0 then
      begin
        main_test;
        exit;
      end;

      if ParamCount<>4 then
        raise Exception.Create('Falsche Anzahl Parameter');

      var j:Integer;
      for j := 1 to ParamCount do
      begin
        writeln(ParamStr(j));
      end;

      if (ParamStr(1)='action') then
      begin
         TNode.ShowPublicOnly:=True;
         writeln('aaaaaaaaction');
         if (ParamStr(2)='WithPrivate') then
            TNode.ShowPublicOnly:=False;
         handleFile(ParamStr(3),ParamStr(4));
      end
      else
      begin
        //Nur loggen welche Files bearbeitet werden sollen
        BaseDir:= ExtractFileDir(Settings.ApplicationBaseDir);
        RstDir:= BaseDir + '\doku\source\';
        Logger:= TLogFile.Create;
        Logger.OpenAppend(RstDir,'pppppppppppppppfade.txt');
        for j := 1 to ParamCount do
        begin
          writeln(ParamStr(j));
          logger.log(ParamStr(j));
        end;

        logger.close;
      end;


  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
