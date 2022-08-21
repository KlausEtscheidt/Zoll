unit DelphiXMLTop;

interface

uses SysUtils,System.Generics.Collections,Xml.XMLIntf,Xml.XMLDoc,Logger,DelphiXMLBasics;

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

implementation

//############################################################
// Procedure
//############################################################
constructor TProcedure.Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
var
  SubNode:IXMLNode;
  Param: TParam;
begin
  // XML-Knoten speichern und DevNotes lesen
  inherited Create(aNode);
  // In übergeordnete Liste eintragen
  Parent.Prozeduren.Add(Self);
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

//  writeln('-------- Proz ' + Name + ' -----------');
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


//############################################################
// Function
//############################################################
constructor TFunction.Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
var
  SubNode:IXMLNode;
  Param: TParam;
begin
  //XML-Knoten speichern und DevNotes lesen
  inherited Create(aNode);
  //In übergeordnete Liste eintragen
  Parent.Funktionen.Add(Self);

  ParameterListe:=TParameters.Create(Node);

  //Parameterbeschreibungen aus DEvNotes in Liste übernehmen
  for Param in ParameterListe.Liste do
  begin
      if ParamDescription.ContainsKey(Name) then
        Param.DokString:=ParamDescription[Name];
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


//############################################################
// Feld
//############################################################
constructor TField.Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
var
  SubNode:IXMLNode;
begin
  //XML-Knoten speichern und DevNotes lesen
  inherited Create(aNode);
  //In übergeordnete Liste eintragen
  Parent.Felder.Add(Self);
end;

procedure TField.Drucke;
begin
  Logger.Log('');
  Logger.Log(Frei+'.. py:attribute:: ' + Name);
  Einzug:=Einzug+3;
  DruckeSummary(False);
  DruckeRemarks(True);
  Einzug:=Einzug-3;

end;

//############################################################
// Variable
//############################################################
constructor TVar.Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
var
  SubNode:IXMLNode;
begin
  //XML-Knoten speichern und DevNotes lesen
  inherited Create(aNode);
  //In übergeordnete Liste eintragen
  Parent.Variable.Add(Self);
end;

procedure TVar.Drucke;
var
  Text:String;
begin
  Writeln(#10,'Var unfertig: ',Name,' Typ ', Typ );

end;

//############################################################
// Eigenschaften
//############################################################
constructor TProperties.Create(Parent: TOwnerOfMembers; aNode: IXMLNode);
var
  SubNode:IXMLNode;
begin
  //XML-Knoten speichern und DevNotes lesen
  inherited Create(aNode);
  //In übergeordnete Liste eintragen
  Parent.Eigenschaften.Add(Self);

  Readabel:= aNode.HasAttribute('read');
  Writeabel:= aNode.HasAttribute('write');

end;

procedure TProperties.Drucke;
var
  Text:String;
begin
  if ShowPublicOnly then
    if (Not IsPublic) then
      exit;
  Writeln(#10,'Property unfertig: ',Name);


end;

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
  Parent.Klassen.Add(Self);
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
  DruckeSummary(False);
  DruckeRemarks(True);
  Logger.Log('');
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
  Result:=False;
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

//############################################################
// Unit
//############################################################
constructor TUnit.Create(aNode: IXMLNode);
var
  I:Integer;
  SubNode: IXMLNode;

begin
  //XML-Knoten speichern und DevNotes lesen
  inherited Create(aNode);

   handleMembers;

   Drucke;

end;

procedure TUnit.handleMembers();
var
  MemberNode,MembersNode:IXMLNode;
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
        else if MemberNode.LocalName='array' then
        else if MemberNode.LocalName='const' then
        else if MemberNode.LocalName='enum' then
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
  DruckeKlassen;
  Einzug:=Einzug-3;
  DruckeMember;
end;

procedure TUnit.DruckeKlassen;
var
  I:Integer;
  Klasse:TKlasse;
begin
  for I:=0 to Self.Klassen.Count-1 do
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


end.
