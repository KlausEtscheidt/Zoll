unit PumpenDataSetx;

interface

uses System.SysUtils, Data.DB, Datasnap.DBClient,
      DatenModul ;
//System.SysUtils, Data.DB,System.Generics.Collections,
//      Tools;

type

//TWFilter = TArray<String>;
//TWWertliste = TList<String>;

EDatenspeicher = class(Exception);

TWDataSet = class(TClientDataSet)
private
   var FDataSet:TClientDataSet;

protected

public
  constructor Create();
//  procedure AddData(Key:String;Felder:TFields);overload;
  procedure AddData(Felder:TFields);overload;
  procedure AddData(Key:String;Val:String);overload;

end;


implementation

constructor TWDataSet.Create();
begin
  CreateDataSet;
  Active:=True;
end;


//Alle Felder eines Records uebernehmen
procedure TWDataSet.AddData(Felder:TFields);
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
procedure TWDataSet.AddData(Key:String;Val:String);
begin
    FDataSet.FieldByName(Key).Value:=Val;
end;


end.
