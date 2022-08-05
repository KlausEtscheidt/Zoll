unit Stueckliste;

interface
  uses System.RTTI, System.SysUtils, System.Generics.Collections,
       System.TypInfo,
       Data.DB,
//       Tools,
//       PumpenDataSet, Datenmodul,
       Logger;

 type
    EWStueli=class(Exception);

 type
//    TWValue = TValue; //alias
    TWSortedKeyArray = TArray<Integer>;

    TWStueliPos = class
      private
        FStueli: TDictionary<Integer, TWStueliPos>;    //Hält die Kinder-Positionen
        function SortedKeys(): TWSortedKeyArray;
        function GetStueli(Key: Integer): TWStueliPos;
        function GetStueliPosCount:Integer;

      protected
      public
        Vater: TWStueliPos;  //Vaterknoten
        IdStu: String;     //Id der übergeordneten Stueli
        StueliKey:Integer; //Eindeutige ID für das Stueli-Dictionary
                            //wird vom System aut. vergeben
        Ebene: Integer;
        EbeneNice: String;
        Menge: Double;     //Menge von Self in IdStu (beliebige Einheiten)
        MengeTotal: Double; //Gesamt-Menge (mit übergeordneten Mengen mult.)


        hatTeil:Boolean;
        constructor Create(einVater:TWStueliPos; aIdStu:String;
                               eineMenge:Double);
//        procedure MaxPos(var Versuch:Integer);
        procedure SetzeEbenenUndMengen(Level:Integer;UebMenge:Double);
        procedure StueliAdd(APos: TWStueliPos);
        procedure StueliMove(APos: TWStueliPos);
        procedure StueliMoveChildren(APos: TWStueliPos);
        procedure ReMove();
        property Stueli[Key: Integer]: TWStueliPos read GetStueli;
        property StueliKeys: TWSortedKeyArray read SortedKeys;
        property StueliPosCount: Integer read GetStueliPosCount;
        function PosToStr():String;
        function BaumAlsText(txt:String): String;

    end;

    TWStueli = TDictionary<Integer, TWStueliPos>;

implementation


constructor TWStueliPos.Create(einVater:TWStueliPos; aIdStu:String;
                                    eineMenge:Double);
begin
  IdStu:= aIdStu;
  Vater:= einVater;
  Menge:=eineMenge;

  //untergeordenete Stueli (Dictionary) anlegen
  FStueli:= TWStueli.Create;

  //noch kein Teil zugeordnet (Teil wird auch nicht fuer alle PosTyp gesucht)
  hatTeil:=False;

end;

//Holt mittels Key eine Pos aus Stueli
function TWStueliPos.GetStueli(Key: Integer): TWStueliPos;
begin
  Result:=FStueli[Key];
end;

//Anzahl der Positionen in Stueli
function TWStueliPos.GetStueliPosCount: Integer;
begin
  Result:=FStueli.Count;
end;

//Verschiebt die Kinder von APos zur Stueli von Self und
//entfernt die Pos und die Kinder aus der alten Stueli
procedure TWStueliPos.StueliMoveChildren(APos: TWStueliPos);
var
  KindPos: TWStueliPos;
  Key:Integer;

begin
    for Key in APos.StueliKeys do
    begin
     //KindPos Pos aus alter Stu löschen
     KindPos:=APos.Stueli[Key];
     KindPos.ReMove;
     //KindPos Pos in eigene Stu übernehmen
     Self.StueliAdd(KindPos);
    end;
    // APos aus alter Stu löschen
    APos.ReMove;
    // Apos loeschen
    APos.Free;
end;


//Verschiebt APos zur Stueli von Self und entfernt die Pos aus der alten Stueli
procedure TWStueliPos.StueliMove(APos: TWStueliPos);
begin
   //Neue Pos aus alter Stu löschen
   APos.ReMove;
   //Neue Pos in eigene Stu übernehmen
   Self.StueliAdd(APos);
   //Korrigiere Vaterknoten
   APos.Vater:=Self;
   //Korrigiere IdStu

end;

//Position entfernt sich selbst aus Ihrer Vater-Stückliste
procedure TWStueliPos.ReMove();
begin
   //Position aus alter Stu löschen
   Self.Vater.FStueli.Remove(Self.StueliKey);
   //Position freigeben: StueliKey auf 0
   Self.StueliKey:=0;
end;


//Die Stueckliste wird in der Reihenfolge des Aufrufes dieser Funktion befüllt
procedure TWStueliPos.StueliAdd(APos: TWStueliPos);
var
  Key:Integer;
  keyArray: System.TArray<Integer>;
  msg:String;
begin

  //Jedes TWStueliPos ist ein Unikat und kann nur einmal verwendet werden
  msg:='Das StueliPos-Objekt ist bereits in einer Stueckliste enthalten.'+
        'Erzeugen Sie ein neues';
  if APos.StueliKey<>0 then
    raise EWStueli.Create(msg);

  //Sortiere Keys
  keyArray:=Self.SortedKeys;

  if length(keyArray)=0 then
    //Erster Eintrag
    Key:=1
  else
    //Neuer Key 1 höher als bisher letzter Key
    Key := keyArray[length(keyArray)-1] + 1 ;

  //Neue Pos in Stueckliste
  FStueli.Add(Key,APos);
  //Key merken
  APos.StueliKey:=Key;

end;

//--------------------------------------------------------------------------
// Ausgabe-Funktionen
//--------------------------------------------------------------------------
//Liefert wichtige Felder in einem String verkettet
function TWStueliPos.PosToStr():String;
begin
  Result:=Format('<Ebene %s Stu %s Pos %d Menge %5.2f>',
               [EbeneNice, IdStu, StueliKey, Menge ]) + #13 ;
end;

//--------------------------------------------------------------------------
//Liefert wichtige Felder aller Positionen in einem String verkettet
function TWStueliPos.BaumAlsText(txt:String):String;

var
  StueliPos: TWStueliPos;
  Key: Integer;
begin

  //Ausgabe
  Result:=txt+Self.PosToStr();

  //Zurueck, wenn Pos keine Kinder hat
  if FStueli.Count=0 then
    exit;

  //Wenn Kinder da, gehen wir tiefer;
  for Key in Self.StueliKeys  do
  begin
    StueliPos:= FStueli[Key];
    Result:=StueliPos.BaumAlsText(Result);
  end;
end;

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
  if FStueli.Count=0 then
    exit;

  //Wenn Kinder da, gehen wir tiefer; vorher Stuli sortieren

  //In sortierter Reihenfolge
  for StueliPosKey in SortedKeys  do
  begin
    StueliPos:= FStueli[StueliPosKey]; //As TWStueliPos;
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
  keyArray:=FStueli.Keys.ToArray;
  TArray.Sort<Integer>(keyArray);
  Result:=keyArray;
end;

//procedure TWStueliPos.MaxPos(var Versuch:Integer);
//var
//  max:Integer;
//  keyArray: System.TArray<Integer>;
//begin
//  keyArray:=Self.SortedKeys;
//  if length(keyArray)>0 then
//  begin
//    max := keyArray[length(keyArray)-1];
//    if Versuch<=max then
//      Versuch:=max+1;
//  end;
//end;

end.
