unit Datenspeicher;

interface

uses System.SysUtils, Data.DB, Datasnap.DBClient,
      DatenModul ;

type

EDatenspeicher = class(Exception);

TWDatenspeicher = class
private
   var FDataSet:TClientDataSet;

protected

public
  constructor Create(CDS:TClientDataSet);
  property DataSet:TClientDataSet read FDataSet write FDataSet;
  procedure Append;
  procedure Post;
  procedure AddData(Key:String;Felder:TFields);overload;
  procedure AddData(Felder:TFields);overload;
  procedure AddData(Key:String;Val:String);overload;
  function FieldByName(Key:String):TField;
  function GetBookmark:TBookmark;

end;


implementation

constructor TWDatenspeicher.Create(CDS:TClientDataSet);
begin
  //übergebenes TClientDataSet verwenden
  FDataSet:=CDS;
  FDataSet.CreateDataSet;
  FDataSet.Active:=True;
end;

procedure TWDatenspeicher.Append;
begin
   FDataSet.Append;
end;

procedure TWDatenspeicher.Post;
begin
  FDataSet.Post;
end;


//Feld mit Namen Key eines Records uebernehmen
procedure TWDatenspeicher.AddData(Key:String;Felder:TFields);
begin
    FDataSet.FieldByName(Key).Value:=Felder.FieldByName(Key).Value
end;

//Alle Felder eines Records uebernehmen
procedure TWDatenspeicher.AddData(Felder:TFields);
var
  Feld:TField;
  Key:String;
begin
    for Feld in Felder do
    begin
      Key:=Feld.FieldName;
      FDataSet.FieldByName(Key).Value:=Feld.Value;
    end;
end;

//Einen Wert fuer Feld mit Namen Key uebernehmen
procedure TWDatenspeicher.AddData(Key:String;Val:String);
begin
    FDataSet.FieldByName(Key).Value:=Val;
end;

//Liefert Feld
function TWDatenspeicher.FieldByName(Key:String):TField;
begin
  Result:=FDataSet.FieldByName(Key);
end;

function TWDatenspeicher.GetBookmark:TBookmark;
begin
  Result:=FDataSet.GetBookmark;
end;

end.
