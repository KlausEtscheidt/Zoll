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
      Klassen: TList<TDevNote>;
      Prozeduren: TList<TDevNote>;
      Funktionen: TList<TDevNote>;
      Felder: TList<TDevNote>;
      Eigenschaften: TList<TDevNote>;
      Variable: TList<TDevNote>;
      constructor Create(aNode: IXMLNode);
      procedure DruckeMember;
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
      //einen Rückgabewert, dieser aber nicht unbedingt einen DokString
      hasRetVal:Boolean;
      ReturnTyp:String;
      RetValDokString:String;
      constructor Create(aNode: IXMLNode);
      function TextFuerDeklaration():String;
      procedure Drucke;
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
  RetValDesc:String;
begin

  for Param in Liste do
  begin
      Param.Drucke;
  end;

  if RetValDokString<>'' then
      Logger.Log(Frei + ':return: ' + RetValDokString);

  if hasRetVal then
     Logger.Log(Frei + ':rtype: ' + ReturnTyp);

end;


function TParameters.TextFuerDeklaration():String;
var
  Parameter:TParam;
  Text:String;
  I:Integer;
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
  Self.Klassen:=TList<TDevNote>.Create;
  Self.Prozeduren:=TList<TDevNote>.Create;
  Self.Funktionen:=TList<TDevNote>.Create;
  Self.Felder:=TList<TDevNote>.Create;
  Self.Eigenschaften:=TList<TDevNote>.Create;
  Self.Variable:=TList<TDevNote>.Create;
end;

procedure TOwnerOfMembers.DruckeMember;
var
  I:Integer;
  Prozedur:TProcedure;
  Funktion:TFunction;
  Feld:TField;
  Eigenschaft:TProperties;
  aVariable:TVar;
begin

  for I:=0 to Self.Prozeduren.Count-1 do
  begin
   Prozedur:= Self.Prozeduren[I] as TProcedure;
   Prozedur.Drucke;
  end;

  for I:=0 to Self.Funktionen.Count-1 do
  begin
   Funktion:= Self.Funktionen[I] as TFunction;
   Funktion.Drucke;
  end;

  for I:=0 to Self.Felder.Count-1 do
  begin
   Feld:= Self.Felder[I] as TField;
   Feld.Drucke;
  end;

  for I:=0 to Self.Eigenschaften.Count-1 do
  begin
   Eigenschaft:= Self.Eigenschaften[I] as TProperties;
   Eigenschaft.Drucke;
  end;

  for I:=0 to Self.Variable.Count-1 do
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
   //Fuer Sonderfälle, werten wir das Innere des xml selbst aus
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

   //Dann vorhandene Umbrüche entfernen bzw durch blanks ersetzen
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
  Result:=(visibAtt = 'public') or (visibAtt = '');
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
    //von Delphi fehlerhaft übersetzte Einträge ignorieren
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
var
  Text:String;
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
var
  Text:String;
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
begin
  charArray[0] := #13;
  charArray[1] := '|';
  strArray := Text.Split(charArray);
  for Zeile in strArray do
  begin
//    if Trim(Zeile)<>'' then
       Logger.Log(Frei + Trim(Zeile));
       Logger.Log('');
  end;
end;


end.
