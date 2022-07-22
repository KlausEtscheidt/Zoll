unit StueliEigenschaften;

interface

uses System.SysUtils, Data.DB,System.Generics.Collections,
      Tools;

type

TWFilter = TArray<String>;

EEigenschaften = class(Exception);

TWEigenschaften = class(TDictionary<String, String>)
private

protected

public
  constructor Create(Felder:TFields);overload;
  procedure AddData(Felder:TFields;PreFix:String='');overload;
  procedure AddData(Key:String;Felder:TFields;PreFix:String='');overload;
  procedure AddData(Key:String;Val:String);overload;
  function ToStr():String;overload;
  function ToStr(KeyListe:TWFilter):String;overload;
  function ToStr(KeyListe:TWFilter;var header:String):String;overload;
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

//Liefert gefilterte Eigenschaften
function TWEigenschaften.ToStr(KeyListe:TWFilter):String;
var header:String;
begin
   Result:=Self.ToStr(KeyListe,header);
end;


//Liefert gefilterte Eigenschaften als Result
//und die Liste der zugehoerigen keys in header
function TWEigenschaften.ToStr(KeyListe:TWFilter;var header:String):String;
const trenn = ' ; ' ;
var
  ValueTxt,KeyTxt,key,value:string;
  myField:TField;

begin

  ValueTxt:='';
  KeyTxt:='';

  for key in  KeyListe do
  begin
    KeyTxt:= KeyTxt + key + trenn;
    if TryGetValue(key,value) then
      ValueTxt:= ValueTxt + value + trenn
    else
      ValueTxt:= ValueTxt + trenn;
  end;
  header:=KeyTxt;
  Result:=ValueTxt;

end;

//Liefert alle Eigenschaften
function TWEigenschaften.ToStr():String;
const trenn = ' ; ' ;
var
  val,txt:string;
  myfield:TField;
begin
  txt:='';
  for val in  Values do
  begin
    txt:= txt + val + trenn;
  end;
  Result:=txt;
end;

end.
