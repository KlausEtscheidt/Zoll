type

  TParameter = class
    public
      Typ:String;
      Name:String;
      DokString:String;
      constructor Create(Node: IXMLNode);
  end;

  TParameterListe = class
    private
      FParams: TList<TParameter>;
      function GetParameter(I:Integer):TParameter;
      function GetCount():Integer;
    public
      ReturnTyp:String;
      hasReturnTyp:Boolean;
      constructor Create(TopNode: IXMLNode);
      function Deklaration():String;
      function ReturnValueDesc():String;
      property Parameter[I:Integer]:TParameter read GetParameter;
      property count:Integer read GetCount;
  end;

  TDevNotes = class
    private
      FParamListe:TParameterListe; //Parameter aus Function
      FDevNode:IXMLNode;
    public
      Summary:String;
      Remarks:String;
      ReturnValueDescription:String;
      hatParamDoku:Boolean;
//      constructor Create(Node:IXMLNode);
      procedure WriteRst(LineBefore:Boolean);
      procedure WriteRstElement(Text:String);
      procedure handleParameterDevNotes(FuncParameter:TParameterListe);
      procedure WriteRstParamDoku(LineBefore:Boolean);
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
//--------------------------

//Suche die Parameter aus einer Funktion zu den Parametern aus
//den DevNotes
procedure TDevNotes.handleParameterDevNotes(FuncParameter:TParameterListe);
var
  SubNode:IXMLNode;
  Name,DokText:String;
  I,J:Integer;
  Parameter:TParameter;
begin

   if FDevNode=nil then exit;
   //Übergeordnetes Modul hat keine Parameter
   if FuncParameter.count=0 then exit;

  //Parameter aus der Function oder procedure übernehmen
  FParamListe:=FuncParameter;
  hatParamDoku:=True;

   for I:=0 to FDevNode.ChildNodes.Count-1 do
   begin
     SubNode:= FDevNode.ChildNodes[i];
     if SubNode.LocalName='param' then
     begin
        Name:=NameAttrib(SubNode);
        DokText:=SubNode.Text;
        //Suche diesen param in der Liste aus der Function/procedure
        for J:=0 To FuncParameter.count-1 do
        begin
          Parameter:=FuncParameter.Parameter[J];
//          if Parameter.Name=Name then
//            Parameter.DokString:=FormatEinzeilig(DokText);
        end;
     end;
   end;


end;

// Gibt ein DevNotes-Element aus
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

// Gibt wichtige DevNotes-Elemente (Summary,Remarks) aus
procedure TDevNotes.WriteRst(LineBefore:Boolean);
var
  Text:String;
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

// Gibt die Parameter-Doku aus
procedure TDevNotes.WriteRstParamDoku(LineBefore:Boolean);
var
  Text:String;
  Parameter:TParameter;
  I:Integer;

begin

  if not hatParamDoku then exit;

  Parameter:=FParamListe.Parameter[0];
  Text:=Einziehen(':param ' + Parameter.Typ + ' ' + Parameter.Name +': ' +
                                         Parameter.DokString);
  for I:=1 To FParamListe.count-1 do
  begin
    Parameter:=FParamListe.Parameter[I];
    Text:=Text + #10+ Einziehen(':param ' + Parameter.Typ + ' ' + Parameter.Name +': ' +
                                           Parameter.DokString);
  end;

  if Text<>'' then
  begin
    if LineBefore then
        Logger.Log('');
    Logger.Log(Text);
  end;

  if ReturnValueDescription<>'' then
  begin
      Text:=Einziehen(':return: ' + ReturnValueDescription);
      Logger.Log(Text);
  end;

  if FParamListe.hasReturnTyp then
    Logger.Log(Einziehen(FParamListe.ReturnValueDesc));

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

function TParameterListe.GetCount():Integer;
begin
   Result:=FParams.Count;
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

//Erzeugt String mit Parametern, wie in einer Funktionsdeklaration
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
                                              + Parameter.Deklaration +';' ;
  Logger.Log(Einziehen(Text));
  Einzug:=Einzug+3;
//  DevNotes:=TDevNotes.Create(Node);
//  DevNotes.handleParameterDevNotes(Parameter);
//  DevNotes.WriteRst(True);
//  DevNotes.WriteRstParamDoku(True);
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
                                              + Parameter.Deklaration +';'  ;
  Logger.Log(Einziehen(Text));
  Einzug:=Einzug+3;
//  DevNotes:=TDevNotes.Create(Node);
//  DevNotes.handleParameterDevNotes(Parameter);
//  DevNotes.WriteRst(True);
//  DevNotes.WriteRstParamDoku(True);
  Einzug:=Einzug-3;
end;

procedure handleVariable(Node:IXMLNode);
var
  DevNotes:TDevNotes;
begin
  Writeln(#10,'Var: ',NameAttrib(Node),' ',TypeAttrib(Node));
//  TDevNotes.Create(Node);
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
//  DevNotes:=TDevNotes.Create(Node);
//  DevNotes.WriteRst(True);
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
//  DevNotes:=TDevNotes.Create(Node);
//  DevNotes.WriteRst(True);
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
  AhneStr:String;
begin
  Writeln(#10,'============================================');
  Name:=NameAttrib(ClassNode);
  AhneStr:=Ahne(ClassNode);
  Writeln('Klasse: ',Name ,'(',AhneStr,')');

  Logger.Log('');
  if (AhneStr='Exception') or (Name.Substring(0,1)='E') then
  begin
    Logger.Log('.. py:exception:: '  +  Name + '(' + AhneStr + ')');
    exit;
  end;
  Logger.Log('.. py:class:: ' + Name + '(' + AhneStr + ')');
//  DevNotes:=TDevNotes.Create(ClassNode);
//  DevNotes.WriteRst(True);
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
//     DevNotes:=TDevNotes.Create(TopNode);
     if DevNotes.Summary<>'' then
     begin
//        Logger.Log('');
        Logger.Log(Einziehen(':synopsis: '+DevNotes.Summary));
     end;

     handleClasses(TopNode);
     Writeln('============================================');
     Writeln('Suche globale Member-----------');
     Einzug:=0;
     handleNonClassMembers(TopNode,'procedure');
     handleNonClassMembers(TopNode,'function');
     handleNonClassMembers(TopNode,'variable');
end;
