program XML2RST;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,ActiveX,
//  Xml.adomxmldom,
  Xml.xmldom, Xml.XMLIntf,
//  Xml.omnixmldom,
  Xml.Win.msxmldom,
  Xml.XMLDoc;

const
   XmlFilePath: String='C:\Users\Etscheidt\Documents\Embarcadero\Studio\Projekte\Zoll\doku\xml\';

var
myXMLDoc: IXMLDocument;
Node:IXMLNode;
myXmlFile: String;
PublicOnly: Boolean;

//-----------------------------------------------------------------------
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
procedure handleRemarks(Node:IXMLNode);
var
  SubNode:IXMLNode;
begin
  SubNode:=Node.ChildNodes.FindNode('remarks');
  if SubNode<>nil then
      Writeln('Remarks: ',SubNode.text);
end;


procedure handleSummary(Node:IXMLNode);
var
  SubNode:IXMLNode;
begin
  SubNode:=Node.ChildNodes.FindNode('summary');
  if SubNode<>nil then
      Writeln('Summary: ',SubNode.text);
end;

procedure handleDevNotes(Node:IXMLNode);
var
  SubNode:IXMLNode;
begin
  SubNode:=Node.ChildNodes.FindNode('devnotes');
  if SubNode<>nil then
  begin
     handleSummary(Subnode);
     handleRemarks(Subnode);
  end;
end;

//-----------------------------------------------------------------------
// Handler fuer Parameter zu Code-Objekten
//-----------------------------------------------------------------------
procedure handleParameters(TopNode:IXMLNode;ZuCodeArt:String);
var
  Node:IXMLNode;
  i:Integer;
  Name:String;
  Typ:String;
begin
     TopNode:=TopNode.ChildNodes['parameters'];
     if TopNode<> nil then
       if TopNode.HasChildNodes then
       begin

         for i:=0 to TopNode.ChildNodes.Count-1 do
         begin
           Node:= TopNode.ChildNodes[i];
           if Node.LocalName='parameter' then
           begin
              Typ:=TypeAttrib(Node);
              Name:=NameAttrib(Node);
              writeln('parameter Name: ',Name, ' Typ: ',Typ);
           end;
         end;
         if ZuCodeArt='function' then
         begin
            Node:= TopNode.ChildNodes['retval'];
            Typ:=TypeAttrib(Node);
            writeln('Returns Typ: ',Typ);
         end;

       end;
end;


//-----------------------------------------------------------------------
// handler für Code-Objekte
//-----------------------------------------------------------------------

procedure handleProcedure(Node:IXMLNode);
begin
  Writeln(#10,'Proc: ',VisibelAttrib(Node),' ',NameAttrib(Node));
  if PublicOnly then
    if (Not IsPublic(Node)) then
      exit;
  handleDevNotes(Node);
  handleParameters(Node,'procedure');
end;

procedure handleFunction(Node:IXMLNode);
begin
  Writeln(#10,'Func: ',VisibelAttrib(Node),' ',NameAttrib(Node));
  if PublicOnly then
    if (Not IsPublic(Node)) then
      exit;
  handleDevNotes(Node);
  handleParameters(Node,'function');
end;

procedure handleVariable(Node:IXMLNode);
begin
  Writeln(#10,'Var: ',NameAttrib(Node),' ',TypeAttrib(Node));
  handleDevNotes(Node);
end;

procedure handleField(Node:IXMLNode);
begin
  Writeln(#10,'Field: ',VisibelAttrib(Node),' ',NameAttrib(Node));
  if PublicOnly then
    if (Not IsPublic(Node)) then
      exit;
  handleDevNotes(Node);
end;

procedure handleProperty(Node:IXMLNode);
var text:String;
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
  handleDevNotes(Node);
end;



procedure handleNonClassMembers(TopNode:IXMLNode;NodeTyp:String;public:Boolean);
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
             if Node.LocalName = 'procedure' then
                handleProcedure(Node)
             else if Node.LocalName = 'function' then
                handleFunction(Node)
             else if Node.LocalName = 'variable' then
                handleVariable(Node)
             else if Node.LocalName = 'field' then
                handleField(Node)
             else if Node.LocalName = 'property' then
                handleProperty(Node)
             else
                raise Exception.Create(Node.LocalName + 'nicht implementiert');
       end;
     end;
end;

procedure handleClassMembers(ClassNode:IXMLNode;NodeTyp:String;public:Boolean);
var
  SubNode,Node:IXMLNode;
  i:Integer;
  Childs:IXMLNodeList;
begin
   Node:=ClassNode.ChildNodes.FindNode('members');
   if Node<>nil then
     if Node.HasChildNodes then
       handleNonClassMembers(Node,NodeTyp,public)
end;

procedure handleClass(ClassNode:IXMLNode);
begin
  Writeln(#10,'============================================');
  Writeln('Klasse: ',NameAttrib(ClassNode),'(',Ahne(ClassNode),')');
  handleDevNotes(ClassNode);
  handleClassMembers(ClassNode,'procedure',PublicOnly);
  handleClassMembers(ClassNode,'function',PublicOnly);
  handleClassMembers(ClassNode,'variable',PublicOnly);
  handleClassMembers(ClassNode,'field',PublicOnly);
  handleClassMembers(ClassNode,'property',PublicOnly);
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
begin
     Writeln('Unit: ',NameAttrib(TopNode));
     handleDevNotes(TopNode);
     handleClasses(TopNode);
      Writeln('============================================');
     Writeln('Suche globale Member-----------');
     handleNonClassMembers(TopNode,'procedure',PublicOnly);
     handleNonClassMembers(TopNode,'function',PublicOnly);
     handleNonClassMembers(TopNode,'variable',PublicOnly);
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

       handleFile(XmlFilePath + 'ADOQuery.xml');
       handleFile(XmlFilePath + 'Auswerten.xml');
//     scan(myXMLDoc.DocumentElement);

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
