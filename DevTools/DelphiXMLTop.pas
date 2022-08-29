unit DelphiXMLTop;

interface

uses SysUtils,System.Generics.Collections,Xml.XMLIntf,Xml.XMLDoc,Logger,DelphiXMLBasics;

type

  TProcedure = class(TDevNote)
    public
      ParameterListe: TParameters;
      constructor Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
      procedure Drucke;
  end;

  TFunction = class(TDevNote)
    public
      ParameterListe: TParameters;
      constructor Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
      procedure Drucke;
  end;

  //Member in Unit oder Klasse oder Unterlement eines Records (Struct)
  TField = class(TDevNote)
    public
      constructor Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
      procedure Drucke;
  end;

  TVar = class(TDevNote)
    public
      constructor Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
      procedure Drucke;
  end;

  TProperties = class(TDevNote)
    public
      Readabel:Boolean;
      Writeabel:Boolean;
      constructor Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
      procedure Drucke;
  end;

  //Beschreibung eines records
  TStruct = class(TOwnerOfMembers)
    public
      constructor Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
      procedure Drucke;
  end;

  //Beschreibung eines Aufzählungstyps
  TEnum = class(TOwnerOfMembers)
    public
      constructor Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
      procedure Drucke;
  end;

  //Beschreibung eines Array.Typs
  TArray = class(TOwnerOfMembers)
    public
      constructor Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
      procedure Drucke;
  end;

implementation

//############################################################
// Procedure
//############################################################
constructor TProcedure.Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
var
//  SubNode:IXMLNode;
  Param: TParam;
begin
  // XML-Knoten speichern und DevNotes lesen
  inherited Create(aNode);

  // In übergeordnete Liste eintragen
//  Parent.Prozeduren.Add(Self);
  setlength(Parent.ProcOrFunc,length(Parent.ProcOrFunc)+1);
  Parent.ProcOrFunc[High(Parent.ProcOrFunc)]:=Self;

  ParameterListe:=TParameters.Create(Node);

  //Parameterbeschreibungen aus DEvNotes in Liste übernehmen
  for Param in ParameterListe.Liste do
  begin
      if ParamDescription.ContainsKey(Param.Name) then
        Param.DokString:=ParamDescription[Param.Name];
  end;

end;

procedure TProcedure.Drucke;
var
  ParamDesc:String;
begin
  if ShowPublicOnly then
    if (Not IsPublic) then
      exit;

  writeln('------------ Prozedur ' + Name + ' -----------');
  Logger.Log('');
  ParamDesc:= ParameterListe.TextFuerDeklaration;
  if ParamDesc<>'' then
      Logger.Log(Frei+'.. py:method:: ' + Name + ' ' + ParamDesc + ';')
  else
      Logger.Log(Frei+'.. py:method:: ' + Name + ';');

  Einzug:=Einzug+3;
  DruckeSummary(False);
  DruckeRemarks(True);
  Logger.Log('');
  ParameterListe.Drucke;
  Einzug:=Einzug-3;

end;
//---------------- Ende Procedure ----------------------

//############################################################
// Function
//############################################################
constructor TFunction.Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
var
//  SubNode:IXMLNode;
  Param: TParam;
begin
  //XML-Knoten speichern und DevNotes lesen
  inherited Create(aNode);

  //In übergeordnete Liste eintragen
//  Parent.Funktionen.Add(Self);
  setlength(Parent.ProcOrFunc,length(Parent.ProcOrFunc)+1);
  Parent.ProcOrFunc[High(Parent.ProcOrFunc)]:=Self;

  ParameterListe:=TParameters.Create(Node);

  //Parameterbeschreibungen aus DEvNotes in Liste übernehmen
  for Param in ParameterListe.Liste do
  begin
      if ParamDescription.ContainsKey(Param.Name) then
        Param.DokString:=ParamDescription[Param.Name];
  end;
  if ParamDescription.ContainsKey('returns') then
    ParameterListe.RetValDokString:=ParamDescription['returns'];

end;

procedure TFunction.Drucke;
var
  ParamDesc:String;
begin
  if ShowPublicOnly then
    if (Not IsPublic) then
      exit;

  Writeln('-------------Funktion: ' +  Name + '-------------------');

  Logger.Log('');

  ParamDesc:= ParameterListe.TextFuerDeklaration;
  if ParamDesc<>'' then
      Logger.Log(Frei+'.. py:function:: ' + Name + ' ' + ParamDesc + ';')
  else
      Logger.Log(Frei+'.. py:function:: ' + Name + ';');

  Einzug:=Einzug+3;
  DruckeSummary(False);
  DruckeRemarks(True);
  Logger.Log('');
  ParameterListe.Drucke;
  Einzug:=Einzug-3;


end;
//---------------- Ende Function ----------------------

//############################################################
// Feld
//############################################################
constructor TField.Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
//var
//  SubNode:IXMLNode;
begin
  //XML-Knoten speichern und DevNotes lesen
  inherited Create(aNode);
  //In übergeordnete Liste eintragen
  setlength(Parent.Felder,length(Parent.Felder)+1);
  Parent.Felder[High(Parent.Felder)]:=Self;
end;

procedure TField.Drucke;
begin
  if ShowPublicOnly then
    if (Not IsPublic) then
      exit;

  Logger.Log('');
  Logger.Log(Frei+'.. py:attribute:: ' + Name);
  Einzug:=Einzug+3;
  DruckeSummary(False);
  DruckeRemarks(True);
  Logger.Log('');
  Logger.Log(Frei+':type: ' + Self.Typ);
  Einzug:=Einzug-3;
  Writeln(#10,'Field: ',Name);

end;
//---------------- Ende Feld ----------------------


//############################################################
// Variable
//############################################################
constructor TVar.Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
//var
//  SubNode:IXMLNode;
begin
  //XML-Knoten speichern und DevNotes lesen
  inherited Create(aNode);
  //In übergeordnete Liste eintragen
  setlength(Parent.Variable,length(Parent.Variable)+1);
  Parent.Variable[High(Parent.Variable)]:=Self;
end;

procedure TVar.Drucke;
begin
  if ShowPublicOnly then
    if (Not IsPublic) then
      exit;

  Logger.Log('');
  Logger.Log(Frei+'.. py:property:: ' + Name);
  Einzug:=Einzug+3;
  DruckeSummary(False);
  DruckeRemarks(True);
  Logger.Log('');
  Logger.Log(Frei+':type: ' + Self.Typ);
  Einzug:=Einzug-3;

  Writeln(#10,'Var: ',Name);

end;
//---------------- Ende Variable ----------------------

//############################################################
// Eigenschaften
//############################################################
constructor TProperties.Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
//var
//  SubNode:IXMLNode;
begin
  //XML-Knoten speichern und DevNotes lesen
  inherited Create(aNode);
  //In übergeordnete Liste eintragen
  setlength(Parent.Eigenschaften,length(Parent.Eigenschaften)+1);
  Parent.Eigenschaften[High(Parent.Eigenschaften)]:=Self;

  Readabel:= aNode.HasAttribute('read');
  Writeabel:= aNode.HasAttribute('write');

end;

procedure TProperties.Drucke;
//var
//  Text:String;
begin
  if ShowPublicOnly then
    if (Not IsPublic) then
      exit;

  Logger.Log('');
  Logger.Log(Frei+'.. py:property:: ' + Name);
  Einzug:=Einzug+3;
  DruckeSummary(False);
  DruckeRemarks(True);
  Logger.Log('');
  Logger.Log(Frei+'type: ' + Self.Typ);
  Einzug:=Einzug-3;
  Writeln(#10,'Property: ',Name);


end;
//---------------- Ende Eigenschaften ----------------------

//############################################################
// Struct
// Entsteht z.B aus record
//############################################################
constructor TStruct.Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
var
  SubNode:IXMLNode;
  I:Integer;

begin
  //XML-Knoten speichern und DevNotes lesen
  inherited Create(aNode);
  //In übergeordnete Liste eintragen
  setlength(Parent.Records,length(Parent.Records)+1);
  Parent.Records[High(Parent.Records)]:=Self;

   if Self.Node.HasChildNodes then
      for I := 0 to Self.Node.ChildNodes.Count-1 do
      begin
        SubNode:=Self.Node.ChildNodes[I];
        if SubNode.LocalName='devnotes' then
        else if SubNode.LocalName='field' then
          TField.Create(Self, SubNode)
        else if SubNode.LocalName='element' then
          TElement.Create(Self, SubNode)
        else
            begin
              Writeln('#####################################################');
              Writeln('TStruct.handleMembers ' + SubNode.LocalName + ' unbekannt');
              Writeln('#####################################################');
            end;
      end;

end;

procedure TStruct.Drucke;
var
  Feld:TField;
  I:Integer;
  hatDoku:Boolean;

begin
  Writeln('Typ: ',Name, ' Art: ', LocalName);
  Writeln(Summary);
  //Nur dokumentierte Typen ausgeben
  hatDoku:=False;
  if Summary<>'' then
    hatDoku:=True;

  for I:=0 to length(Felder)-1 do
  begin
    Feld:= Self.Felder[I] as TField;
    if Feld.Summary<>'' then
      hatDoku:=True;
  end;

  if not hatDoku then exit;

  Logger.Log('');
  Logger.Log(Frei + '.. cpp:type:: ' + Name);
  DruckeSummary(True);

  Einzug:=Einzug+3;
  Logger.Log('');
  for I:=0 to length(Felder)-1 do
  begin
   Feld:= Self.Felder[I] as TField;
   //Feld.Drucke;
   Writeln('Feld: ', Feld.Name, ' Typ: ',Feld.Typ);
   Writeln(Feld.Summary);
   Logger.Log('|'+Frei + Feld.Name + ':' + Feld.Typ+ ' ' + Feld.Summary);

  end;

  Einzug:=Einzug-3;

end;
//---------------- Ende Struct ----------------------

//############################################################
// TEnum
// Beschreibung eines Aufzählungstyps
//############################################################
constructor TEnum.Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
var
  SubNode:IXMLNode;
  I:Integer;

begin
  //XML-Knoten speichern und DevNotes lesen
  inherited Create(aNode);
  //In übergeordnete Liste eintragen
  setlength(Parent.Enums,length(Parent.Enums)+1);
  Parent.Enums[High(Parent.Enums)]:=Self;

   if Self.Node.HasChildNodes then
      for I := 0 to Self.Node.ChildNodes.Count-1 do
      begin
        SubNode:=Self.Node.ChildNodes[I];
        if SubNode.LocalName='devnotes' then
        else if SubNode.LocalName='element' then
          TElement.Create(Self, SubNode)
        else
            begin
              Writeln('#####################################################');
              Writeln('TEnum.handleMembers ' + SubNode.LocalName + ' unbekannt');
              Writeln('#####################################################');
            end;
      end;

end;

///Untergeordnete Elemente können nicht kommentiert werden
procedure TEnum.Drucke;
var
  Element:TElement;
  I:Integer;
  hatDoku:Boolean;
  Text: String;

begin
  Writeln('Typ: ',Name, ' Art: ', LocalName);
  Writeln(Summary);
  //Nur dokumentierte Typen ausgeben
  hatDoku:=False;
  if Summary<>'' then
    hatDoku:=True;

  if not hatDoku then exit;

  Logger.Log('');
  Logger.Log('.. cpp:type:: ' + Name);

  Text:=  Name + ': = (' + Self.Elements[0].Name;

  for I:=1 to length(Elements)-1 do
  begin
   Element:= Self.Elements[I] as TElement;
   //Feld.Drucke;
   Writeln('Element: ', Element.Name);
   Text:= Text + ',' + Element.Name;
  end;
  Text:=Text+');';

  Logger.Log('');
  Logger.Log(Text);
  DruckeSummary(True);

end;

//---------------- Ende Enum ----------------------

//############################################################
// TArray Beschreibung eines Array-Typs
//############################################################
constructor TArray.Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
var
  SubNode:IXMLNode;
  I:Integer;

begin
  //XML-Knoten speichern und DevNotes lesen
  inherited Create(aNode);
  //In übergeordnete Liste eintragen
  setlength(Parent.Arrays,length(Parent.Arrays)+1);
  Parent.Arrays[High(Parent.Arrays)]:=Self;

   if Self.Node.HasChildNodes then
      for I := 0 to Self.Node.ChildNodes.Count-1 do
      begin
        SubNode:=Self.Node.ChildNodes[I];
        if SubNode.LocalName='devnotes' then
        else if SubNode.LocalName='element' then
          TElement.Create(Self, SubNode)
        else
            begin
              Writeln('#####################################################');
              Writeln('TArray.handleMembers ' + SubNode.LocalName + ' unbekannt');
              Writeln('#####################################################');
            end;
      end;

end;

///Funktion zur Zeit sinnlos, das Delphi fuer Arrays keine Dokstring exportiert
procedure TArray.Drucke;
var
  Element:TElement;
  I:Integer;
  hatDoku:Boolean;

begin
  Writeln('Typ: ',Name, ' Art: ', LocalName);
  Writeln(Summary);
  //Nur dokumentierte Typen ausgeben
  hatDoku:=False;
  if Summary<>'' then
    hatDoku:=True;

  for I:=0 to length(Elements)-1 do
  begin
    Element:= Self.Elements[I] as TElement;
    if Element.Summary<>'' then
      hatDoku:=True;
  end;

  if not hatDoku then exit;

  Logger.Log('');
  Logger.Log(Frei + '.. cpp:type:: ' + Name);
  DruckeSummary(True);

  Einzug:=Einzug+3;
  Logger.Log('');
  for I:=0 to length(Elements)-1 do
  begin
   Element:= Self.Elements[I] as TElement;
   Writeln('Element: ', Element.Name, ' Typ: ',Element.Typ);
   Writeln(Element.Summary);
   Logger.Log('|'+Frei + Element.Name + ':' + Element.Typ+ ' ' + Element.Summary);

  end;

  Einzug:=Einzug-3;

end;


end.
