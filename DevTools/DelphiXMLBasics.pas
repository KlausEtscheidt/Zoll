unit DelphiXMLBasics;

interface

uses System.SysUtils,System.Generics.Collections,Xml.XMLIntf, Xml.XMLDoc, Logger;

type

  TParamDesc = TDictionary<String,String>;

  TNode = class
    private
      class var FLogger: TLogFile;
      class var FEinzug: Integer;
      class var FShowPublicOnly: Boolean;
    public
      Node: IXMLNode;
      Name:String;
      Typ:String;
      Visibility:String;
      LocalName:String;
      constructor Create(aNode: IXMLNode);
      class function FindChildNodeByName(aNode: IXMLNode; Name:String):IXMLNode;overload;
      function FindChildNodeByName(Name:String):IXMLNode;overload;
      class function GetAttribute(aNode: IXMLNode; AttribName:String):String;overload;
      function GetAttribute(AttribName:String):String; overload;
      function Format():String;
      function Frei():String;
      function IsPublic():Boolean;
      class property Logger: TLogFile read FLogger write FLogger;
      class property Einzug: Integer read FEinzug write FEinzug;
      class property ShowPublicOnly: Boolean read FShowPublicOnly write FShowPublicOnly;
  end;

  TDevNote = class(TNode)
    public
      hatDevNode:Boolean;
      Summary:String;
      Remarks:String;
      ParamDescription:TParamDesc;
//      RetValDescription:String;
      constructor Create(aNode: IXMLNode);
      procedure DruckeMehrzeilig(Text:String);
      procedure DruckeSummary(LineBefore:Boolean);
      procedure DruckeRemarks(LineBefore:Boolean);
  end;

  TOwnerOfMembers = class(TDevNote)
    public
      Klassen: TArray<TDevNote>;
      ProcOrFunc: TArray<TDevNote>;
//      Funktionen: TArray<TDevNote>;
      Felder: TArray<TDevNote>;
      Eigenschaften: TArray<TDevNote>;
      Variable: TArray<TDevNote>;
      Records: TArray<TDevNote>;
      Enums: TArray<TDevNote>;
      Arrays: TArray<TDevNote>;
      Elements: TArray<TDevNote>;

      constructor Create(aNode: IXMLNode);
      procedure DruckeMember;
      procedure DruckeTypen;
  end;

  TParam  = class(TDevNote)
    public
      DokString:String;
      constructor Create(aNode: IXMLNode);
      procedure Drucke;
  end;

  TParameters = class(TDevNote)
    public
      Liste: TList<TParam>;
      //hasRetVal wird bei der Funktionsanalyse gesetzt: Die Funktion hat
      //einen R�ckgabewert, dieser aber nicht unbedingt einen DokString
      hasRetVal:Boolean;
      ReturnTyp:String;
      RetValDokString:String;
      constructor Create(aNode: IXMLNode);
      function TextFuerDeklaration():String;
      procedure Drucke;
  end;

  //Unterelement in Enum-Typ-Beschreibung
  TElement = class(TDevNote)
    public
      constructor Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
//      procedure Drucke;
  end;


implementation

uses DelphiXMLTop;

//######################################################################
// Parameter
//######################################################################
constructor TParam.Create(aNode: IXMLNode);
begin
  inherited Create(aNode);
//  writeln('parameter Name: ',Name, ' Typ: ',Typ);
end;

procedure TParam.Drucke;
begin
//  if DokString<>'' then
//    Logger.Log(Frei + ':param ' + Typ + ' ' + Name + ': ' + DokString)
//  else
//    Logger.Log(Frei + ':param ' + Typ + ' ' + Name);
    Logger.Log(Frei + ':param ' + Typ + ' ' + Name + ': ' + DokString)
end;

constructor TParameters.Create(aNode: IXMLNode);
var
  param:TParam;
  i:Integer;
  ParamNode, Node:IXMLNode;

begin
     Liste:=TList<TParam>.Create();
     ParamNode := aNode.ChildNodes['parameters'];
     if ParamNode <> nil then
       if ParamNode.HasChildNodes then
       begin

         for i:=0 to ParamNode.ChildNodes.Count-1 do
         begin
           Node:= ParamNode.ChildNodes[i];
           if Node.LocalName='parameter' then
           begin
              param:=TParam.Create(Node);
              if param<>nil then
                Liste.Add(param);
           end;
         end;

         Node:= ParamNode.ChildNodes.FindNode('retval');
         hasRetVal:=False;
         if Node<>nil then
         begin
            ReturnTyp:=TNode.GetAttribute(Node, 'type');
            hasRetVal:=True;
//            writeln('Returns Typ: ',ReturnTyp);
         end;

       end;

end;

procedure TParameters.Drucke;
var
  Param: TParam;
//  RetValDesc:String;
begin

  for Param in Liste do
  begin
      Param.Drucke;
  end;

  if RetValDokString<>'' then
      Logger.Log(Frei + ':return: ' + RetValDokString);

//  if hasRetVal then
//     Logger.Log(Frei + ':rtype: ' + ReturnTyp);

end;


function TParameters.TextFuerDeklaration():String;
var
  Parameter:TParam;
  Text:String;
//  I:Integer;
begin
  Text:='';
  if Liste.Count>0 then
  begin
    Text:='(';
    for Parameter in Liste do
    begin
      Text:=Text+Parameter.Name + ' ' + Parameter.Typ + '; '
    end;
    Text:=Text.SubString(0,length(Text)-2)+')';
  end;
  if Self.hasRetVal then
    Text := Text + ': ' + Self.ReturnTyp;
  Result:=Text;

end;

//######################################################################
// TOwnerOfMembers
//######################################################################
constructor TOwnerOfMembers.Create(aNode: IXMLNode);
begin
  inherited Create(aNode);
  //Listen erzeugen
  Self.Klassen:=TArray<TDevNote>.Create();
  Self.ProcOrFunc:=TArray<TDevNote>.Create();
  Self.Felder:=TArray<TDevNote>.Create();
  Self.Eigenschaften:=TArray<TDevNote>.Create();
  Self.Variable:=TArray<TDevNote>.Create();
  Self.Records:=TArray<TDevNote>.Create();
  Self.Enums:=TArray<TDevNote>.Create();
  Self.Arrays:=TArray<TDevNote>.Create();
  Self.Elements:=TArray<TDevNote>.Create();

end;

procedure TOwnerOfMembers.DruckeTypen;
var
  I:Integer;
  aStruct: TStruct;
  aEnum:   TEnum;
  aArray:  TArray;
begin

  //Records
  for I:=0 to length(Records)-1 do
  begin
   aStruct:= Self.Records[I] as TStruct;
   aStruct.Drucke;
  end;

  //Enums
  for I:=0 to length(Enums)-1 do
  begin
   aEnum:= Self.Enums[I] as TEnum;
   aEnum.Drucke;
  end;

  //Arrays
  for I:=0 to length(Arrays)-1 do
  begin
   aArray:= Self.Arrays[I] as TArray;
   aArray.Drucke;
  end;


end;

procedure TOwnerOfMembers.DruckeMember;
var
  I:Integer;
  Feld:TField;
  Prozedur:TProcedure;
  Funktion:TFunction;
  Eigenschaft:TProperties;
  aVariable:TVar;
begin

  for I:=0 to length(Felder)-1 do
  begin
   Feld:= Self.Felder[I] as TField;
   Feld.Drucke;
  end;

  for I:=0 to length(Self.ProcOrFunc)-1 do
  begin
    if Self.ProcOrFunc[I].Classname='TProcedure' then
    begin
       Prozedur:= Self.ProcOrFunc[I] as TProcedure;
       Prozedur.Drucke;
    end
    else
    begin
       Funktion:= Self.ProcOrFunc[I] as TFunction;
       Funktion.Drucke;
    end;
  end;

  for I:=0 to length(Eigenschaften)-1 do
  begin
   Eigenschaft:= Self.Eigenschaften[I] as TProperties;
   Eigenschaft.Drucke;
  end;

  for I:=0 to length(Variable)-1 do
  begin
   aVariable:= Self.Variable[I] as TVar;
   aVariable.Drucke;
  end;

end;


//######################################################################
// TDevNote
//######################################################################
constructor TNode.Create(aNode: IXMLNode);
begin
  Self.Node:=aNode;
  Self.Name:=Self.GetAttribute('name');
  Self.Typ:=Self.GetAttribute('type');
  Self.Visibility:=Self.GetAttribute('visibility');
  Self.LocalName:=aNode.LocalName;
end;

class function TNode.FindChildNodeByName(aNode: IXMLNode; Name:String):IXMLNode;
begin
  Result:= aNode.ChildNodes.FindNode(Name);
end;

function TNode.FindChildNodeByName(Name:String):IXMLNode;
begin
  Result:= Self.Node.ChildNodes.FindNode(Name);
end;

function TNode.GetAttribute(AttribName:String):String;
begin
  if Self.Node.HasAttribute(AttribName) then
    Result:=Self.Node.AttributeNodes[AttribName].NodeValue
  else
    Result:='';
end;

class function TNode.GetAttribute(aNode: IXMLNode; AttribName:String):String;
begin
  if aNode.HasAttribute(AttribName) then
    Result:=aNode.AttributeNodes[AttribName].NodeValue
  else
    Result:='';
end;


// Entfernt mehrfache Leerzeichen aus einem DevNotes-String
function TNode.Format(): String;
var
  RohText:String;
  Lpos,Rpos:Integer;

begin
   RohText:=Self.Node.xml;
   //Fuer Sonderf�lle, werten wir das Innere des xml selbst aus
   Rpos:=pos('</'+Self.LocalName, RohText);
   RohText:=RohText.Substring(0,Rpos-1);
   Lpos:=pos('>', RohText);
   //Mehrfach Leerzeichen entfernen
   RohText:=RohText.Substring(Lpos);
   RohText:=Trim(RohText);
   Lpos:=pos('  ', RohText);
   while Lpos>0 do
   begin
      RohText := StringReplace(RohText, '  ', ' ', [rfReplaceAll]);
      Lpos:=pos('  ', RohText);
   end;

   //Dann vorhandene Umbr�che entfernen bzw durch blanks ersetzen
   RohText:= StringReplace(RohText,#$A,'',[rfReplaceAll]);
   RohText:= StringReplace(RohText,#13,'',[rfReplaceAll]);
   //Falls doppelte Blanks enstanden sind
   RohText := StringReplace(RohText, '  ', ' ', [rfReplaceAll]);

   Result:=RohText;

end;

function TNode.Frei():String;
begin
  Result:= StringOfChar(' ',Einzug);
end;

function TNode.IsPublic():Boolean;
var visibAtt:String;
begin
  visibAtt:=GetAttribute('visibility');
  Result:=(visibAtt = 'public') or (visibAtt = 'published') or (visibAtt = '');
end;


//######################################################################
// TDevNote
//######################################################################
constructor TDevNote.Create(aNode: IXMLNode);

var
  DevNode:IXMLNode;
  Subnode:TNode;
  I:Integer;

begin
  inherited Create(aNode);
  ParamDescription:=TDictionary<String,String>.Create;

  hatDevNode:=False;

  DevNode:=aNode.ChildNodes.FindNode('devnotes');
  if DevNode=nil then
    exit;

  for i:=0 to DevNode.ChildNodes.Count-1 do
  begin

    SubNode:=TNode.Create(DevNode.ChildNodes[I]);

    if SubNode.LocalName='' then
    //von Delphi fehlerhaft �bersetzte Eintr�ge ignorieren
    else if SubNode.LocalName='summary' then
        Summary:= SubNode.Format
    else if SubNode.LocalName='remarks' then
        Remarks:= SubNode.Format
    else if SubNode.LocalName='param' then
        ParamDescription.Add(SubNode.Name, SubNode.Format)
    else if SubNode.LocalName='returns' then
        ParamDescription.Add('returns', SubNode.Format)
    else
    begin
      Writeln('#####################################################');
      Writeln('DevNote.Ceate ' + SubNode.LocalName + ' unbekannt');
      Writeln(DevNode.xml);
      Writeln('#####################################################');
    end;

  end;

end;

// Gibt Summary aus
procedure TDevNote.DruckeSummary(LineBefore:Boolean);
//var
//  Text:String;
begin
  if Summary<>'' then
  begin
    if LineBefore then
        Logger.Log('');
    DruckeMehrzeilig(Summary);
  end;

end;

// Gibt Remarks aus
procedure TDevNote.DruckeRemarks(LineBefore:Boolean);
//var
//  Text:String;
begin
  if Remarks<>'' then
  begin
    Logger.Log('');
    DruckeMehrzeilig(Remarks);
  end;

end;

// Gibt ein mehrzeiliges DevNotes-Element aus
procedure TDevNote.DruckeMehrzeilig(Text:String);
var
  Zeile:String;
  charArray : Array[0..1] of Char;
  strArray  : System.TArray<String>;
  I: Integer;
begin
  charArray[0] := #13;
  charArray[1] := '|';
  strArray := Text.Split(charArray);
  for I:=0 to length(strArray)-1 do
  begin
      if I>0 then
         Logger.Log('');
      Zeile:=strArray[I];
      Logger.Log(Frei + Trim(Zeile));
//      Logger.Log(Frei + Zeile);

  end;
end;
//---------------- Ende DevNote ----------------------

//############################################################
// TElement (Unterelement in typ record
//############################################################
constructor TElement.Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
begin
  //XML-Knoten speichern und DevNotes lesen
  inherited Create(aNode);
  //In �bergeordnete Liste eintragen
  setlength(Parent.Elements ,length(Parent.Elements)+1);
  Parent.Elements[High(Parent.Elements)]:=Self;
end;
//---------------- Ende Element ----------------------

end.