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

type

  TUnit = class(TOwnerOfMembers)
    public
      constructor Create(aNode: IXMLNode);
      procedure handleMembers;
      procedure Drucke;
      procedure DruckeKlassen;
      procedure DruckeKopf;
  end;

  TKlasse = class(TOwnerOfMembers)
    public
      ErbtVon:String;
      constructor Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
      procedure handleMembers();
      procedure Drucke;
      procedure DruckeKopf;
      function IsException(aNode: IXMLNode):Boolean ;
  end;


var
//  PublicOnly: Boolean;
  myXMLDoc: IXMLDocument;
  BaseDir,XmlDir,RstDir: String;
  Logger: TLogFile;


//############################################################
// Unit
//############################################################
constructor TUnit.Create(aNode: IXMLNode);
//var
//  I:Integer;
//  SubNode: IXMLNode;

begin
  //XML-Knoten speichern und DevNotes lesen
  inherited Create(aNode);

   handleMembers;

   Drucke;

end;

procedure TUnit.handleMembers();
var
  MemberNode:IXMLNode;
  I:Integer;

begin

   if Self.Node.HasChildNodes then
      for I := 0 to Self.Node.ChildNodes.Count-1 do
      begin
        MemberNode:=Self.Node.ChildNodes[I];
        if MemberNode.LocalName='class' then
          TKlasse.Create(Self,MemberNode)
        else if MemberNode.LocalName='procedure' then
          TProcedure.Create(Self,MemberNode)
        else if MemberNode.LocalName='function' then
          TFunction.Create(Self,MemberNode)
        else if MemberNode.LocalName='field' then
          TField.Create(Self,MemberNode)
        else if MemberNode.LocalName='variable' then
          TVar.Create(Self,MemberNode)
        else if MemberNode.LocalName='property' then
          TProperties.Create(Self,MemberNode)
        else if MemberNode.LocalName='devnotes' then
        else if MemberNode.LocalName='struct' then
          TStruct.Create(Self,MemberNode)
        else if MemberNode.LocalName='array' then
          TArray.Create(Self,MemberNode)
//        else if MemberNode.LocalName='const' then
        else if MemberNode.LocalName='enum' then
          TEnum.Create(Self,MemberNode)
//        else if MemberNode.LocalName='constructor' then
//        else if MemberNode.LocalName='exception' then
        else
          begin
            Writeln('#####################################################');
            Writeln('TUnit.handleMembers ' + MemberNode.LocalName + ' unbekannt');
            Writeln('#####################################################');
          end;
      end;

end;

procedure TUnit.Drucke;
begin
  DruckeKopf;
  Einzug:=Einzug-3;
  DruckeTypen;
  DruckeKlassen;
  DruckeMember;
end;

procedure TUnit.DruckeKlassen;
var
  I:Integer;
  Klasse:TKlasse;
begin
  for I:=0 to length(Klassen)-1 do
  begin
   Klasse:= Self.Klassen[I] as TKlasse;
   Klasse.Drucke;
  end;

end;

procedure TUnit.DruckeKopf;
begin
   Writeln('Unit: ',Name);
   //Titel des RST-Dokumentes mit "=" unterstrichen
   Einzug:=0;
   Logger.Log(Name);
   Logger.Log(StringOfChar('=', length(Name)));
   // Die remarks dürfen nicht unter dem Namespace stehen
   // Deshalb ausgabe als Normaler Text vorher
   if Remarks<>'' then
      DruckeRemarks(True);

   //Ausgabe des Unit-Namens als Namespace
   Logger.Log('');
   Logger.Log('.. py:module:: '+Name);
   //Kurzbeschreibung des Namespace als synopsis
   Einzug:=3;
   if Summary<>'' then
      Logger.Log(Frei+':synopsis: '+Summary);
end;
//---------------- Ende Unit ----------------------

//############################################################
// Klasse
//############################################################
constructor TKlasse.Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
var
  SubNode:IXMLNode;
begin
  //XML-Knoten speichern und DevNotes lesen
  inherited Create(aNode);
  //In übergeordnete Liste eintragen
//  Parent.Klassen.Add(Self);
  setlength(Parent.Klassen,length(Parent.Klassen)+1);
  Parent.Klassen[High(Parent.Klassen)]:=Self;
//  writeln('============= Klasse: '+Name+' ==============');
  SubNode:=Self.FindChildNodeByName('ancestor');
  if Subnode<>nil then
    ErbtVon:=TNode.GetAttribute(Subnode,'name')
  else
    ErbtVon:='';

  handleMembers;

end;

procedure TKlasse.handleMembers();
var
  MemberNode,MembersNode:IXMLNode;
  I:Integer;
begin
   MembersNode:=Self.FindChildNodeByName('members');

   if MembersNode<>nil then
     if MembersNode.HasChildNodes then
        for I := 0 to MembersNode.ChildNodes.Count-1 do
        begin
          MemberNode:=MembersNode.ChildNodes[I];
          if MemberNode.LocalName='procedure' then
            TProcedure.Create(Self,MemberNode)
          else if MemberNode.LocalName='function' then
            TFunction.Create(Self,MemberNode)
          else if MemberNode.LocalName='field' then
            TField.Create(Self,MemberNode)
          else if MemberNode.LocalName='variable' then
            TVar.Create(Self,MemberNode)
          else if MemberNode.LocalName='property' then
            TProperties.Create(Self,MemberNode)
          else if MemberNode.LocalName='devnotes' then
          else if MemberNode.LocalName='class' then
          else if MemberNode.LocalName='constructor' then
          else if MemberNode.LocalName='destructor' then
          else if MemberNode.LocalName='exception' then
          else
            begin
              Writeln('#####################################################');
              Writeln('TKlasse.handleMembers ' + MemberNode.LocalName + ' unbekannt');
              Writeln('#####################################################');
            end;
        end;
end;


procedure TKlasse.Drucke;
begin
  DruckeKopf;
  Einzug:=Einzug+3;
  DruckeSummary(False);
  DruckeRemarks(True);
  DruckeTypen;
//  Logger.Log('');
  DruckeMember;
end;

procedure TKlasse.DruckeKopf;
begin

  Writeln('Klasse: ',Name ,'(',ErbtVon,')');

  Logger.Log('');
  if IsException(Self.Node) then
  begin
    Logger.Log('.. py:exception:: '  +  Name + '(' + ErbtVon + ')');
    exit;
  end;
  Logger.Log('.. py:class:: ' + Name + '(' + ErbtVon + ')');

end;

function TKlasse.IsException(aNode: IXMLNode):Boolean ;
var
  SubNode:IXMLNode;
  BasisKlasse:String;
begin
  SubNode:= TNode.FindChildNodeByName(aNode,'ancestor');
  if Subnode<>nil then
    begin
      BasisKlasse:=TNode.GetAttribute(Subnode,'name');
      if BasisKlasse='Exception' then
          Result:=True
      else
        Result:=IsException(SubNode);
    end
  else
    Result:=False;

end;
//---------------- Ende Klasse ----------------------

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

//---------------- Handle File ----------------------

procedure handleFile(XMLFilePath,RstFilePath:String);
var
  Path,Name:String;
//  MyUnit:TUnit;
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
     TUnit.Create(myXMLDoc.DocumentElement);

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
//  handleFile(xmldir+UnitName+'.xml',RstDir+UnitName+'.rst');

//  UnitName:='ADOConnector';
  UnitName:='PumpenDataSet';
  handleFile(xmldir+UnitName+'.xml',RstDir+'lib\Datenbank\'+UnitName+'.rst');

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
