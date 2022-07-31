unit Stueckliste;

interface
  uses System.RTTI, System.SysUtils, System.Generics.Collections,
       System.TypInfo,
       Data.DB,Tools,
       PumpenDataSet, Datenmodul,
       Logger;

 type
    TWValue = TValue; //alias
    TWSortedKeyArray = TArray<Integer>;

    TWStueliPos = class
      private

      protected
      public
        Vater: TWStueliPos;  //Vaterknoten
        IdStu: String;     //Id der übergeordneten Stueli
        IdPos: Integer;    //Pos von Self in IdStu
        Ebene: Integer;
        EbeneNice: String;
        Menge: Double;     //Menge von Self in IdStu (beliebige Einheiten)
        MengeTotal: Double; //Gesamt-Menge (mit übergeordneten Mengen mult.)

        Stueli: TDictionary<Integer, TWStueliPos>;    //Hält die Kinder-Positionen

        hatTeil:Boolean;
        constructor Create(einVater:TWStueliPos; aIdStu:String;
                               aIdPos: Integer;eineMenge:Double);
        function SortedKeys(): TWSortedKeyArray;
        procedure SetzeEbenenUndMengen(Level:Integer;UebMenge:Double);

    end;

    TWStueli = TDictionary<Integer, TWStueliPos>;

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

begin

  Ebene:=Level;
  EbeneNice := StringOfChar('.', Ebene-1) + IntToStr(Ebene);
  MengeTotal:=Menge*UebMenge;  //Eigene Menge mal übergeordnete

  //Zurueck, wenn Pos keine Kinder hat
  if Stueli.Count=0 then
    exit;

  //Wenn Kinder da, gehen wir tiefer; vorher Stuli sortieren

  //In sortierter Reihenfolge
  for StueliPosKey in SortedKeys  do
  begin
    StueliPos:= Stueli[StueliPosKey]; //As TWStueliPos;
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


end.
