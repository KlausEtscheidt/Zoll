unit Stueckliste;

interface
  uses System.RTTI, System.SysUtils, System.Generics.Collections,
       System.TypInfo,
       Data.DB,Tools,
       PumpenDataSet, Datenmodul,
       Logger;

 type
    TWValue = TValue; //alias
    TWFilter = TArray<String>;
    TWSortedKeyArray = TArray<Integer>;

    TWStueliPos = class
      private

      protected
      public
        Ebene: Integer;
        Vater: TWStueliPos;  //Vaterknoten
        IdStu: String;     //Id der übergeordneten Stueli
        IdPos: Integer;    //Pos von Self in IdStu
        Menge: Double;     //Menge von Self in IdStu (beliebige Einheiten)
        MengeTotal: Double; //Gesamt-Menge (mit übergeordneten Mengen mult.)
        Stueli: TDictionary<Integer, TWStueliPos>;    //Hält die Kinder-Positionen

        hatTeil:Boolean;
        constructor Create(einVater:TWStueliPos; aIdStu:String;
                               aIdPos: Integer;eineMenge:Double);
        function SortedKeys(): TWSortedKeyArray;
        function ToStr(const Trennzeichen:String=';'):String;
        procedure SetzeEbenenUndMengen(Level:Integer;UebMenge:Double);

    end;

    TWStueli = TDictionary<Integer, TWStueliPos>;

    TWEndKnotenListe = class(TList<TWStueliPos>)
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

  //noch kein Teil zugeordnet (Teil wird auch nicht fuer alle PosTyp gesucht)
  hatTeil:=False;

end;

//--------------------------------------------------------------------------
// Ausgabe-Funktionen
//--------------------------------------------------------------------------


// Hinzufügen der Ebenen und Gesamtmengen
//--------------------------------------------------------------------------
procedure TWStueliPos.SetzeEbenenUndMengen(Level:Integer;UebMenge:Double);

var
  StueliPos: TWStueliPos;
  StueliPosKey: Integer;
  var EbeneNice, levelString:String;

begin

  Ebene:=Level;
  levelString:=IntToStr(Ebene);
  EbeneNice := StringOfChar('.', Ebene-1);
  MengeTotal:=Menge*UebMenge;  //Eigene Menge mal übergeordnete

  //Zurueck, wenn Pos keine Kinder hat
  if Stueli.Count=0 then
    exit;

  //Wenn Kinder da, gehen wir tiefer; vorher Stuli sortieren

  //In sortierter Reihenfolge
  for StueliPosKey in SortedKeys  do
  begin
    //spezielle Position (zB KA) in Allgemeine TWStueliPos wandeln
//    StueliPos:= Stueli[StueliPosKey].AsType<TWStueliPos>;;
{ TODO : gehts auch ohne cast ? }
    StueliPos:= Stueli[StueliPosKey] As TWStueliPos;
    //Ausgabe
    StueliPos.SetzeEbenenUndMengen(Ebene+1,MengeTotal);
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
  Result:='noch nicht realisiert';
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
