program XML2RST;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,System.Generics.Collections,
  ActiveX,
  Xml.xmldom,
  Xml.XMLIntf,
  Xml.Win.msxmldom,
  Xml.XMLDoc,
  Settings in '..\lib\Tools\Settings.pas',
  Logger in '..\lib\Tools\Logger.pas';

type

  TDevNotes = class
    private
//      class var FBreite: Integer;
      function Format(RohText:String):String;
    public
      Summary:String;
      Remarks:String;
      constructor Create(Node:IXMLNode);
      procedure WriteRst(LineBefore:Boolean);
      procedure WriteRstElement(Text:String);
//      class property Breite: Integer read FBreite write FBreite;
  end;

  TParameter = class
    public
      Typ:String;
      Name:String;
      constructor Create(Node: IXMLNode);
  end;

  TParameterListe = class
    private
      FParams: TList<TParameter>;
      function GetParameter(I:Integer):TParameter;
    public
      ReturnTyp:String;
      hasReturnTyp:Boolean;
      constructor Create(TopNode: IXMLNode);
      property Parameter[I:Integer]:TParameter read GetParameter;
      function Deklaration():String;
      function ReturnValueDesc():String;

  end;

var
  PublicOnly: Boolean;
  myXMLDoc: IXMLDocument;
  BaseDir,XmlDir,RstDir: String;
  Logger: TLogFile;
  Einzug:Integer;

//-----------------------------------------------------------------------
function Einziehen(Text:String):String;
begin
  Result:= StringOfChar(' ',Einzug)+Text;
end;

function TypeAttrib(Node:IXMLNode):String;
begin
  Result:= (Node.AttributeNodes['type'].NodeValue);
end;

function NameAttrib(Node:IXMLNode):String;
begin
  Result:= (Node.AttributeNodes['name'].NodeValue);
end;

function VisibelAttrib(Node:IXMLNode):String;
begin
  Result:= (Node.AttributeNodes['visibility'].NodeValue);
end;

function IsPublic(Node:IXMLNode):Boolean;
var IsPub:Boolean;
begin
  IsPub:=VisibelAttrib(Node) = 'public';
  Result:= IsPub;
end;

function Readable(Node:IXMLNode):Boolean;
begin
  Result:= Node.HasAttribute('read');
end;

function Writable(Node:IXMLNode):Boolean;
begin
  Result:= Node.HasAttribute('write');
end;

function Ahne(Node:IXMLNode):String;
var
  SubNode:IXMLNode;
begin
  SubNode:=Node.ChildNodes.FindNode('ancestor');
  Result:= NameAttrib(SubNode);
end;

//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
// Handler fuer devnotes
//-----------------------------------------------------------------------
constructor TDevNotes.Create(Node: IXMLNode);
var
  DevNode,Subnode:IXMLNode;
begin
  DevNode:=Node.ChildNodes.FindNode('devnotes');
  if DevNode<>nil then
  begin
    SubNode:=DevNode.ChildNodes.FindNode('summary');
    if SubNode<>nil then
    begin
        Summary:= Format(SubNode.text);
        Writeln('Summary: ',Summary);
    end;
    SubNode:=DevNode.ChildNodes.FindNode('remarks');
    if SubNode<>nil then
    begin
        Remarks:= Format(SubNode.text);
        Writeln('Remarks: ',Remarks);
    end;
  end;
end;

function TDevNotes.Format(RohText:String):String;
var
  Lpos:Integer;
begin
   RohText:=Trim(RohText);
   Lpos:=pos('  ', RohText);
   while Lpos>0 do
   begin
      RohText := StringReplace(RohText, '  ', ' ', [rfReplaceAll]);
      Lpos:=pos('  ', RohText);
   end;
   Result:=RohText;
end;

procedure TDevNotes.WriteRstElement(Text:String);
var
  Zeile:String;
  charArray : Array[0..1] of Char;
  strArray  : System.TArray<String>;
begin
  charArray[0] := #13;
  charArray[1] := #10;
  strArray := Text.Split(charArray);
  for Zeile in strArray do
    Logger.Log(Einziehen(Trim(Zeile)));
end;

procedure TDevNotes.WriteRst(LineBefore:Boolean);
begin
  if Summary<>'' then
  begin
    if LineBefore then
        Logger.Log('');
    WriteRstElement(Summary);
  end;
  if Remarks<>'' then
  begin
    Logger.Log('');
    WriteRstElement(Remarks);
  end;
end;

//-----------------------------------------------------------------------
// Handler fuer Parameter zu Code-Objekten
//-----------------------------------------------------------------------
constructor TParameter.Create(Node: IXMLNode);
begin
  Typ:=TypeAttrib(Node);
  Name:=NameAttrib(Node);
  writeln('parameter Name: ',Name, ' Typ: ',Typ);
end;

constructor TParameterListe.Create(TopNode: IXMLNode);

var
  param:TParameter;
  i:Integer;
  Node:IXMLNode;

begin
     FParams:=TList<TParameter>.Create();
     TopNode:=TopNode.ChildNodes['parameters'];
     if TopNode<> nil then
       if TopNode.HasChildNodes then
       begin

         for i:=0 to TopNode.ChildNodes.Count-1 do
         begin
           Node:= TopNode.ChildNodes[i];
           if Node.LocalName='parameter' then
           begin
              param:=TParameter.Create(Node);
              if param<>nil then
                FParams.Add(param);
           end;
         end;

         Node:= TopNode.ChildNodes.FindNode('retval');
         hasReturnTyp:=False;
         if Node<>nil then
         begin
            ReturnTyp:=TypeAttrib(Node);
            hasReturnTyp:=True;
            writeln('Returns Typ: ',ReturnTyp);
         end;

       end;

end;

function TParameterListe.GetParameter(I:Integer):TParameter;
begin
  Result:=FParams[I];
end;

function TParameterListe.ReturnValueDesc():String;
begin
   Result:='';
   if ReturnTyp<>'' then
      Result:=':rtype: ' + ReturnTyp;
end;

function TParameterListe.Deklaration():String;
var
  Parameter:TParameter;
  Text:String;
  I:Integer;
begin
  if FParams.Count=0 then
    exit;
  Text:='(';
  for Parameter in FParams do
  begin
    Text:=Text+Parameter.Name + ' ' + Parameter.Typ + '; '
  end;
  Text:=Text.SubString(0,length(Text)-2)+')';
  if Self.hasReturnTyp then
    Text := Text + ': ' + Self.ReturnTyp;
  Result:=Text;
end;


//-----------------------------------------------------------------------
// handler für Code-Objekte
//-----------------------------------------------------------------------

procedure handleProcedure(Node:IXMLNode);
var
  DevNotes:TDevNotes;
  Parameter:TParameterListe;
  Text: String;
begin
  Writeln(#10,'Proc: ',VisibelAttrib(Node),' ',NameAttrib(Node));
  if PublicOnly then
    if (Not IsPublic(Node)) then
      exit;

  Logger.Log('');
  Parameter:=TParameterListe.Create(Node);
  Text:='.. py:method:: ' + NameAttrib(Node)+ ' '
                                              + Parameter.Deklaration + ';';
  Logger.Log(Einziehen(Text));
  Einzug:=Einzug+3;
  DevNotes:=TDevNotes.Create(Node);
  DevNotes.WriteRst(True);
  Einzug:=Einzug-3;
end;

procedure handleFunction(Node:IXMLNode);
var
  DevNotes:TDevNotes;
  Parameter:TParameterListe;
  Text: String;
begin
  Writeln(#10,'Func: ',VisibelAttrib(Node),' ',NameAttrib(Node));
  if PublicOnly then
    if (Not IsPublic(Node)) then
      exit;

  Logger.Log('');
  Parameter:=TParameterListe.Create(Node);
  Text:='.. py:function:: ' + NameAttrib(Node)+ ' '
                                              + Parameter.Deklaration + ';';
  Logger.Log(Einziehen(Text));
  Einzug:=Einzug+3;
  DevNotes:=TDevNotes.Create(Node);
  DevNotes.WriteRst(True);
  if Parameter.hasReturnTyp then
    Logger.Log('');
    Logger.Log(Einziehen(Parameter.ReturnValueDesc));
  Einzug:=Einzug-3;
end;

procedure handleVariable(Node:IXMLNode);
var
  DevNotes:TDevNotes;
begin
  Writeln(#10,'Var: ',NameAttrib(Node),' ',TypeAttrib(Node));
  TDevNotes.Create(Node);
end;

procedure handleField(Node:IXMLNode);
var
  DevNotes:TDevNotes;
begin
  Writeln(#10,'Field: ',VisibelAttrib(Node),' ',NameAttrib(Node));
  if PublicOnly then
    if (Not IsPublic(Node)) then
      exit;
  Logger.Log('');
  Logger.Log(Einziehen('.. py:attribute:: ' + NameAttrib(Node)));
  Einzug:=Einzug+3;
  DevNotes:=TDevNotes.Create(Node);
  DevNotes.WriteRst(True);
  Einzug:=Einzug-3;
end;

procedure handleProperty(Node:IXMLNode);
var
  text:String;
  DevNotes:TDevNotes;
begin
  Writeln(#10,'Property: ',VisibelAttrib(Node),' ',NameAttrib(Node));
  if PublicOnly then
    if (Not IsPublic(Node)) then
      exit;
  if Readable(Node) then
    text:=' lesen ';
  if Writable(Node) then
    text:=text+' schreiben';
  Writeln('Typ ',TypeAttrib(Node),text);
  Einzug:=Einzug+3;
  DevNotes:=TDevNotes.Create(Node);
  DevNotes.WriteRst(True);
  Einzug:=Einzug-3;
end;


procedure handleNonClassMembers(TopNode:IXMLNode;NodeTyp:String);
var
  Node:IXMLNode;
  i:Integer;
begin
     if TopNode.HasChildNodes then
     begin
       for i:=0 to TopNode.ChildNodes.Count-1 do
       begin
          Node:= TopNode.ChildNodes[i];
//          Writeln('Typ: ',Node.LocalName);
          if Node.LocalName=NodeTyp then
             if Node.LocalName = 'field' then
                handleField(Node)
             else if Node.LocalName = 'procedure' then
                handleProcedure(Node)
             else if Node.LocalName = 'function' then
                handleFunction(Node)
             else if Node.LocalName = 'variable' then
                handleVariable(Node)
             else if Node.LocalName = 'property' then
                handleProperty(Node)
             else
                raise Exception.Create(Node.LocalName + 'nicht implementiert');
       end;
     end;
end;

procedure handleClassMembers(ClassNode:IXMLNode;NodeTyp:String);
var
  SubNode,Node:IXMLNode;
  i:Integer;
  Childs:IXMLNodeList;
begin
   Node:=ClassNode.ChildNodes.FindNode('members');
   if Node<>nil then
     if Node.HasChildNodes then
       handleNonClassMembers(Node,NodeTyp)
end;

procedure handleClass(ClassNode:IXMLNode);
var
  DevNotes:TDevNotes;
  Name:String;
begin
  Writeln(#10,'============================================');
  Name:=NameAttrib(ClassNode);
  Writeln('Klasse: ',Name ,'(',Ahne(ClassNode),')');
  Logger.Log('');
  Logger.Log('.. py:class:: ' + Name);
  DevNotes:=TDevNotes.Create(ClassNode);
  DevNotes.WriteRst(True);
  handleClassMembers(ClassNode,'procedure');
  handleClassMembers(ClassNode,'function');
  handleClassMembers(ClassNode,'variable');
  handleClassMembers(ClassNode,'field');
  handleClassMembers(ClassNode,'property');
end;

procedure handleClasses(TopNode:IXMLNode);
var
  Node:IXMLNode;
  i:Integer;
begin
     for i:=0 to TopNode.ChildNodes.Count-1 do
     begin
        Node:= TopNode.ChildNodes[i];
        if Node.LocalName='class' then
          handleClass(Node);
     end;
end;

procedure handleUnit(TopNode:IXMLNode);
var
  Node:IXMLNode;
  i:Integer;
  Childs:IXMLNodeList;
  Name:String;
  DevNotes:TDevNotes;
begin
     Name:=NameAttrib(TopNode);
     Writeln('Unit: ',Name);
     Einzug:=0;
     Logger.Log(NameAttrib(TopNode));
     Logger.Log(StringOfChar('=', length(Name)));
     Logger.Log('.. py:module:: '+Name);
     Einzug:=3;
     DevNotes:=TDevNotes.Create(TopNode);
     if DevNotes.Summary<>'' then
     begin
//        Logger.Log('');
        Logger.Log(Einziehen(':synopsis: '+DevNotes.Summary));
     end;

     handleClasses(TopNode);
     Writeln('============================================');
     Writeln('Suche globale Member-----------');
     handleNonClassMembers(TopNode,'procedure');
     handleNonClassMembers(TopNode,'function');
     handleNonClassMembers(TopNode,'variable');
end;

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

procedure handleFile(FilePath:String);
begin
     myXMLDoc:= TXMLDocument.Create(nil);
//     myXMLDoc.DOMVendor := GetDOMVendor(SMSXML);
     myXMLDoc.LoadFromFile(FilePath);
     myXMLDoc.Active:=True;
     PublicOnly:=False;
     handleUnit(myXMLDoc.DocumentElement);
end;

begin
  try
      CoInitialize(nil);
      BaseDir:= ExtractFileDir(Settings.ApplicationBaseDir);
      XmlDir:= BaseDir + '\doku\xml\';
      RstDir:= BaseDir + '\doku\source\';

      Logger:= TLogFile.Create;

      Logger.OpenNew(RstDir,'ADOQuery.rst');
      handleFile(xmldir  + 'ADOQuery.xml');
      Logger.Close;
      Logger.OpenNew(RstDir,'Auswerten.rst');
      handleFile(xmldir + 'Auswerten.xml');
      Logger.Close;
      Logger.OpenNew(RstDir,'Logger.rst');
      handleFile(xmldir + 'Logger.xml');
      Logger.Close;
//     scan(myXMLDoc.DocumentElement);

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
