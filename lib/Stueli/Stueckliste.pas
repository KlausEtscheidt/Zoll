unit Stueckliste;

interface
  uses System.RTTI, System.SysUtils, System.Generics.Collections,
       Exceptions,Data.DB,Tools,Logger;

 type
    TWValue = TValue; //alias
    TWFilter = TArray<String>;
    TWPosdata = TDictionary<String, String>;
    TWSortedKeyArray = TArray<Integer>;
    TWStueli = TDictionary<Integer, TValue>;

    TWStueliPos = class
      private
//        FStueliTeil: TValue; //bel. Objekt

      protected

      public
        Ebene: Integer;
        Vater: TWStueliPos;  //Vaterknoten
        IdStu: String;     //Id der übergeordneten Stueli
        IdPos: Integer;    //Pos von Self in IdStu
        Menge: Double;     //Menge von Self in IdStu (beliebige Einheiten)
        Stueli: TWStueli;    //Hält die Kinder-Positionen

        PosData:TWPosdata;   //Positions-Daten fuer Ausgaben
        StueliTeil: TValue;  //optionales Teile-Objekt auf dieser Pos

        hatTeil:Boolean;
        constructor Create(einVater:TWStueliPos; aIdStu:String;
                               aIdPos: Integer;eineMenge:Double);
        procedure ToTextFile(OutFile:TLogFile;Filter:TWFilter;FirstRun:Boolean=True);
        function SortedKeys(): TWSortedKeyArray;
        function FeldNamensListe():String;
        function ToStr():String;overload;
        function ToStr(KeyListe:TWFilter;var header:String):String;overload;
        function ToStr(KeyListe:TWFilter):String;overload;
//        procedure SetzeEigenschaften(Eigenschaften:TWStuPosFelder);
        procedure AddPosData(Felder:TFields;PreFix:String='');overload;
        procedure AddPosData(PosDataKey:String;Felder:TFields);overload;
        procedure AddPosData(PosDataKey:String;PosDataVal:String);overload;
        procedure SetzeEbenen(level:Integer);
//        procedure SetStueliTeil(Teil: TValue);
//        property StueliTeil:TValue read FStueliTeil write SetStueliTeil;

    end;

    TWEndKnotenListe = class(TList<TValue>)
        private
        public
          Liste: TList<TValue>;
          constructor Create;
          function ToStr():String;
          procedure WriteToLog;
    end;

implementation

uses UnippsStueliPos;

constructor TWStueliPos.Create(einVater:TWStueliPos; aIdStu:String;
                                    aIdPos: Integer;eineMenge:Double);
begin
  IdStu:= aIdStu;
  IdPos:= aIdPos;
  Vater:= einVater;
  Menge:=eineMenge;

  //untergeordenete Stueli anlegen
  Stueli:= TWStueli.Create;
  Posdata:=TWPosdata.Create;
//  StuPosFelder:=TWStuPosFelder.Create;
//  TeileEigenschaften:=TWTeileEigenschaften.Create;

  //noch kein Teil zugeordnet (Teil wird auch nicht fuer alle PosTyp gesucht)
  hatTeil:=False;

//  inherited;
end;

//procedure TWStueliPos.SetStueliTeil(Teil: TValue);
//begin
//  FStueliTeil:=Teil;
//end;
procedure TWStueliPos.AddPosData(PosDataKey:String;PosDataVal:String);
begin
    PosData.Add(PosDataKey, PosDataVal);
end;

procedure TWStueliPos.AddPosData(PosDataKey:String;Felder:TFields);
begin
    PosData.Add( PosDataKey, trim(Felder.FieldByName(PosDataKey).AsString));
end;

procedure TWStueliPos.AddPosData(Felder:TFields;PreFix:String='');
var
  myField:TField;
  key: String;
begin
    for myField in Felder do
    begin
      key:=myField.FieldName;
      PosData.Add(PreFix+key , Felder.FieldByName(key).AsString );
    end;

end;


//--------------------------------------------------------------------------
// Ausgabe-Funktionen
//--------------------------------------------------------------------------

// Ergebnis als Text ausgeben
//--------------------------------------------------------------------------
procedure TWStueliPos.ToTextFile(OutFile:TLogFile;Filter:TWFilter;FirstRun:Boolean=True);

var
  StueliPos: TWStueliPos;
  StueliPosKey: Integer;
  Header:String;
  Values:String;
begin

  //Position (Self) ausgeben; aber nicht fuer Topknoten
  if not FirstRun then
  begin
     Values:=Self.ToStr(Filter,Header);
//     OutFile.Log(Header);
     OutFile.Log(Values);
  end;

//  Tools.ErrLog.Log(Self.FeldNamensListe);

  //Zurueck, wenn Pos keine Kinder hat
  if Stueli.Count=0 then
    exit;

  //Wenn Kinder da, gehen wir tiefer; vorher Stuli sortieren

  //In sortierter Reihenfolge
  for StueliPosKey in SortedKeys  do
  begin
    //spezielle Position (zB KA) in Allgemeine TWStueliPos wandeln
    StueliPos:= Stueli[StueliPosKey].AsType<TWStueliPos>;;
    //Ausgabe
    StueliPos.ToTextFile(OutFile, Filter, False);
  end;

end;

// Hinzufügen der Ebenen
//--------------------------------------------------------------------------
procedure TWStueliPos.SetzeEbenen(Level:Integer);

var
  StueliPos: TWStueliPos;
  StueliPosKey: Integer;
  var EbeneNice, levelString:String;

begin

  Ebene:=Level;
  levelString:=IntToStr(Ebene);
  EbeneNice := StringOfChar('.', Ebene);
  Self.AddPosData('Ebene', levelString);
  Self.AddPosData('EbeneNice', EbeneNice+levelString);

  //Zurueck, wenn Pos keine Kinder hat
  if Stueli.Count=0 then
    exit;

  //Wenn Kinder da, gehen wir tiefer; vorher Stuli sortieren

  //In sortierter Reihenfolge
  for StueliPosKey in SortedKeys  do
  begin
    //spezielle Position (zB KA) in Allgemeine TWStueliPos wandeln
    StueliPos:= Stueli[StueliPosKey].AsType<TWStueliPos>;;
    //Ausgabe
    StueliPos.SetzeEbenen(Ebene+1);
  end;

end;

function TWStueliPos.FeldNamensListe():String;
const trenn = ' ; ' ;
var
  txt,key:string;

begin
  txt:='';
  for key in PosData.Keys do
  begin
     txt:= txt + key + trenn;
  end;
  Result:= txt;
end;

function TWStueliPos.ToStr(KeyListe:TWFilter;var header:String):String;
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
    if PosData.TryGetValue(key,value) then
      ValueTxt:= ValueTxt + value + trenn
    else
      ValueTxt:= ValueTxt + trenn;
  end;
  header:=KeyTxt;
  Result:=ValueTxt;

end;

function TWStueliPos.ToStr(KeyListe:TWFilter):String;
var header:String;
begin
   Result:=Self.ToStr(KeyListe,header);
end;

function TWStueliPos.ToStr():String;
const trenn = ' ; ' ;
var
  val,txt:string;
  myfield:TField;
begin
  txt:='';
  for val in  PosData.Values do
  begin
    txt:= txt + val + trenn;
  end;
  Result:=txt;


end;

//--------------------------------------------------------------
//Holt sortierte Key Liste fuer Stueckliste
function TWStueliPos.SortedKeys(): TWSortedKeyArray;
var
  keyArray: System.TArray<Integer>;
begin
  //Unsortierte Zugriffs-Keys in sortiertes Array wandeln
  keyArray:=Stueli.Keys.ToArray;
  TArray.Sort<Integer>(keyArray);
  Result:=keyArray;
end;


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

constructor TWEndKnotenListe.Create;
begin
  inherited;
end;

function TWEndKnotenListe.ToStr():String;
var
  txt:String;
  Member:TWValue;
  StueliPos: TWStueliPos;

begin
  txt:= 'EndknotenListe: ';
  for Member in Self do
  begin
    StueliPos:= Member.AsType<TWStueliPos>;
    txt:= txt + '<' + StueliPos.ToStr() +  '>'  ;
  end;
  Result := txt;
end;

procedure TWEndKnotenListe.WriteToLog;
var
  Member:TWValue;
  StueliPos: TWStueliPos;

begin
  Tools.Log.Log('EndknotenListe: ');
  for Member in Self do
  begin
    StueliPos:= Member.AsType<TWStueliPos>;
    Tools.Log.Log(StueliPos.ToStr );
  end;
end;

end.
