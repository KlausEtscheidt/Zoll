unit StueliEigenschaften;

interface

uses System.SysUtils, Data.DB,System.Generics.Collections,
      Tools;

type

TWFilter = TArray<String>;
TWWertliste = TList<String>;

EEigenschaften = class(Exception);

TWEigenschaften = class(TDictionary<String, String>)
private

protected

public
  constructor Create(Felder:TFields);overload;
  procedure AddData(Felder:TFields;PreFix:String='');overload;
  procedure AddData(Key:String;Felder:TFields;PreFix:String='');overload;
  procedure AddData(Key:String;Val:String);overload;
  function Wertliste():TWWertliste;overload;
  function Wertliste(KeyListe:TWFilter):TWWertliste;overload;
  function ToCSV(Werte:TWWertliste; const Trennzeichen:String=';'):String;
  function FeldNamensListe():String;

end;


implementation

constructor TWEigenschaften.Create(Felder:TFields);
begin
  inherited Create;
  Self.AddData(Felder);

end;


//Ein Wertepaar direkt übernehmen
procedure TWEigenschaften.AddData(Key:String;Val:String);
var msg:String;
begin
    Add(Key, Val);
end;

//Ein Wert wird per key aus einer Feldliste gesucht
procedure TWEigenschaften.AddData(Key:String;Felder:TFields;PreFix:String);
var msg:String;
begin
  try
    Add( PreFix+Key, trim(Felder.FieldByName(Key).AsString));
  except
    on E: EDataBaseError do
      begin
        msg:=Self.Classname + ' Feld ' + Key + ' nicht in Query-Daten gefunden.';
        Tools.Log.Log(msg);
        Tools.ErrLog.Log(msg);
        raise EEigenschaften.Create(Self.Classname + ' Feld '+Key+' nicht in Daten gefunden');
      end;
    on E: Exception do
      raise;
  end;
end;

//Alle Felder werden übernommen
procedure TWEigenschaften.AddData(Felder:TFields;PreFix:String);
var
  myField:TField;
  key: String;
begin
    for myField in Felder do
    begin
      key:=myField.FieldName;
      AddData(key , Felder, PreFix );
    end;

end;

//Liefert Liste aller keys
function TWEigenschaften.FeldNamensListe():String;
const trenn = ' ; ' ;
var
  txt,key:string;

begin
  txt:='';
  for key in Keys do
  begin
     txt:= txt + key + trenn;
  end;
  Result:= txt;
end;

//liefert alle Werte des Objektes
function TWEigenschaften.Wertliste():TWWertliste;
var
  val:String;
  Liste:TWWertliste;
begin
  Liste:=TWWertliste.Create();
  for val in  Self.Values do
  begin
    Liste.Add(val);
  end;
  Result:=Liste;
end;

function TWEigenschaften.Wertliste(KeyListe:TWFilter):TWWertliste;
var
  key,val:String;
  Liste:TWWertliste;
begin
  Liste:=TWWertliste.Create();

  for key in  KeyListe do
  begin

    if TryGetValue(key,val) then
      Liste.Add(val);

  end;

  Result:=Liste;
end;


//Liefert alle Eigenschaften in Werte in einem String verkettet
function TWEigenschaften.ToCSV(Werte:TWWertliste; const Trennzeichen:String=';'):String;
var value:String;
begin
  Result:='';
  for value in Werte do
  begin
    Result:=Result+value + Trennzeichen;
  end;

end;

end.
