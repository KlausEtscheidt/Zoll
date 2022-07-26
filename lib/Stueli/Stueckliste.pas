unit Stueckliste;

interface
  uses System.RTTI, System.SysUtils, System.Generics.Collections,
       System.TypInfo,
       StueliEigenschaften,StueliTeil,Teil,
       Exceptions,Data.DB,Tools,Logger;

 type
    TWValue = TValue; //alias
    TWFilter = TArray<String>;
    TWSortedKeyArray = TArray<Integer>;
    TWStueli = TDictionary<Integer, TValue>;

    TWStueliPos = class
      private
        class var FFilter:TWFilter; //Filter zur Ausgabe der Eigenschaften
        function GetDruckDaten:TWWertliste;
        function GetDruckDatenAuswahl:TWWertliste;
      public
        Ebene: Integer;
        Vater: TWStueliPos;  //Vaterknoten
        IdStu: String;     //Id der �bergeordneten Stueli
        IdPos: Integer;    //Pos von Self in IdStu
        Menge: Double;     //Menge von Self in IdStu (beliebige Einheiten)
        Stueli: TWStueli;    //H�lt die Kinder-Positionen

        Ausgabe:TWEigenschaften;   //Positions-Daten fuer Ausgaben

        StueliTeil: TWTeil;  //optionales Teile-Objekt auf dieser Pos
//        Teil: TWTeil;  //optionales Teile-Objekt auf dieser Pos

        hatTeil:Boolean;
        constructor Create(einVater:TWStueliPos; aIdStu:String;
                               aIdPos: Integer;eineMenge:Double);
        procedure ToTextFile(OutFile:TLogFile;FirstRun:Boolean=True);
        function SortedKeys(): TWSortedKeyArray;
        function ToStr(const Trennzeichen:String=';'):String;
        procedure SetzeEbenen(level:Integer);
        property DruckDaten:TWWertliste read GetDruckDaten;
        property DruckDatenAuswahl:TWWertliste read GetDruckDatenAuswahl;
        class property Filter:TWFilter read FFilter write FFilter;

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
procedure TWStueliPos.ToTextFile(OutFile:TLogFile;FirstRun:Boolean=True);

var
//  StueliPos: TWStueliPos;
  StueliPos: TValue;
  StueliPosTyp: PTypeInfo;
  StueliPosKey: Integer;
  StueliPosObj:TObject;
  Werte,WerteTeil:TWWertliste;
  WerteCSV:String;
begin

  //Position (Self) ausgeben; aber nicht fuer Topknoten
  if not FirstRun then
  begin

     //Erst Werte zur Position holen
     Werte:=Self.DruckDatenAuswahl;
     //Dann Werte zum Teil();
     if hatTeil then
     begin
       WerteTeil:=TWTeil(StueliTeil).DruckDatenAuswahl;
       Werte.AddRange(WerteTeil);
     end;

     WerteCSV:=self.Ausgabe.ToCSV(Werte);
//     OutFile.Log(Header);
     OutFile.Log(WerteCSV);
  end;

//  Tools.ErrLog.Log(Self.FeldNamensListe);

  //Zurueck, wenn Pos keine Kinder hat
  if Stueli.Count=0 then
    exit;

  //Wenn Kinder da, gehen wir tiefer; vorher Stuli sortieren

  //In sortierter Reihenfolge
  for StueliPosKey in SortedKeys  do
  begin
//      Stueli[StueliPosKey].AsType<TWStueliPos>
//                           .ToTextFile(OutFile, False);

//    {
    StueliPosObj:=Stueli[StueliPosKey].AsObject;
    if StueliPosObj is TWKundenauftrag then
      TWKundenauftrag(StueliPosObj).ToTextFile(OutFile, False);
    if StueliPosObj is TWKundenauftragsPos then
      TWKundenauftragsPos(StueliPosObj).ToTextFile(OutFile, False);
    if StueliPosObj is TWFAKopf then
      TWFAKopf(StueliPosObj).ToTextFile(OutFile, False);
    if StueliPosObj is TWFAPos then
      TWFAPos(StueliPosObj).ToTextFile(OutFile, False);
    if StueliPosObj is TWTeilAlsStuPos then
      TWTeilAlsStuPos(StueliPosObj).ToTextFile(OutFile, False);
//    }
  end;

end;

// Hole Eigenschaften zum Drucken
//--------------------------------------------------------------------------
function TWStueliPos.GetDruckDatenAuswahl:TWWertliste;
begin
  if length(Filter)=0 then
    //Alle ausgeben
    Result:=Ausgabe.Wertliste()
  else
    //gefiltert ausgeben
    Result:=Ausgabe.Wertliste(Filter);
end;

function TWStueliPos.GetDruckDaten:TWWertliste;
begin
  //Alle ausgeben
  Result:=Ausgabe.Wertliste()
end;

// Hinzuf�gen der Ebenen
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

//Liefert alle Eigenschaften in Werte in einem String verkettet
function TWStueliPos.ToStr(const Trennzeichen:String=';'):String;
begin
  Result:=self.Ausgabe.ToCSV(Self.DruckDaten);
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
