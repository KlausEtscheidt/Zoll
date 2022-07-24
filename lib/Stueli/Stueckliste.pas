unit Stueckliste;

interface
  uses System.RTTI, System.SysUtils, System.Generics.Collections,
       System.TypInfo,
       StueliEigenschaften,Teil,
       Exceptions,Data.DB,Tools,Logger;

 type
    TWValue = TValue; //alias
    TWFilter = TArray<String>;
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

        Ausgabe:TWEigenschaften;   //Positions-Daten fuer Ausgaben
//        StueliTeil: TWStueliTeil;  //optionales Teile-Objekt auf dieser Pos
        Teil: TWTeil;  //optionales Teile-Objekt auf dieser Pos

        hatTeil:Boolean;
        constructor Create(einVater:TWStueliPos; aIdStu:String;
                               aIdPos: Integer;eineMenge:Double);
        procedure ToTextFile(OutFile:TLogFile;Filter:TWFilter;FirstRun:Boolean=True);
        function SortedKeys(): TWSortedKeyArray;
        function ToStr():String;overload;
        function ToStr(KeyListe:TWFilter;var header:String):String;overload;
        function ToStr(KeyListe:TWFilter):String;overload;
        function GetTeileEigenschaften():String;virtual;abstract;
//        procedure SetzeEigenschaften(Eigenschaften:TWStuPosFelder);
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

uses Kundenauftrag,KundenauftragsPos,FertigungsauftragsKopf,
     FertigungsauftragsPos,TeilAlsStuPos,UnippsStueliPos;

constructor TWStueliPos.Create(einVater:TWStueliPos; aIdStu:String;
                                    aIdPos: Integer;eineMenge:Double);
begin
  IdStu:= aIdStu;
  IdPos:= aIdPos;
  Vater:= einVater;
  Menge:=eineMenge;

  //untergeordenete Stueli anlegen
  Stueli:= TWStueli.Create;
  Ausgabe:=TWEigenschaften.Create;

  //noch kein Teil zugeordnet (Teil wird auch nicht fuer alle PosTyp gesucht)
  hatTeil:=False;

end;

//--------------------------------------------------------------------------
// Ausgabe-Funktionen
//--------------------------------------------------------------------------

// Ergebnis als Text ausgeben
//--------------------------------------------------------------------------
procedure TWStueliPos.ToTextFile(OutFile:TLogFile;Filter:TWFilter;FirstRun:Boolean=True);

var
//  StueliPos: TWStueliPos;
  StueliPos: TValue;
  StueliPosTyp: PTypeInfo;
  StueliPosKey: Integer;
  StueliPosObj:TObject;
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
      Stueli[StueliPosKey].AsType<TWStueliPos>
                           .ToTextFile(OutFile, Filter, False);

    {
    StueliPosObj:=Stueli[StueliPosKey].AsObject;
    if StueliPosObj is TWKundenauftrag then
      TWKundenauftrag(StueliPosObj).ToTextFile(OutFile, Filter, False);
    if StueliPosObj is TWKundenauftragsPos then
      TWKundenauftragsPos(StueliPosObj).ToTextFile(OutFile, Filter, False);
    if StueliPosObj is TWFAKopf then
      TWFAKopf(StueliPosObj).ToTextFile(OutFile, Filter, False);
    if StueliPosObj is TWFAPos then
      TWFAPos(StueliPosObj).ToTextFile(OutFile, Filter, False);
    if StueliPosObj is TWTeilAlsStuPos then
      TWTeilAlsStuPos(StueliPosObj).ToTextFile(OutFile, Filter, False);
    }
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
  EbeneNice := StringOfChar('.', Ebene-1);
  Self.Ausgabe.AddData('Ebene', levelString);
  Self.Ausgabe.AddData('EbeneNice', EbeneNice+levelString);

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

//Liefert gefilterte Eigenschaften als Result
//und die Liste der zugehoerigen keys in header
function TWStueliPos.ToStr(KeyListe:TWFilter;var header:String):String;
var
  TeileDaten:String;
begin
  Result:=Ausgabe.ToStr(KeyListe, header);
  if hatTeil then
  begin
      TeileDaten:=Teil.ToStr(KeyListe, header);
      Result:=Result + TeileDaten
  end;
end;

//Liefert gefilterte Eigenschaften
function TWStueliPos.ToStr(KeyListe:TWFilter):String;
var header:String;
begin
   Result:=Ausgabe.ToStr(KeyListe,header);
end;

//Liefert alle Eigenschaften
function TWStueliPos.ToStr():String;
begin
  Result:=Ausgabe.ToStr;
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
