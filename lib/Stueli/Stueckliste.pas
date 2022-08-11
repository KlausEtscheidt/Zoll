unit Stueckliste;

interface
  uses System.RTTI, System.SysUtils, System.Generics.Collections,
       System.TypInfo, Data.DB;

 type
    EWStueli=class(Exception);

 type
    TWSortedKeyArray = TArray<Integer>;

    TWStueliPos = class
      private
        //Eigene Id (Programmintern unabhängig von UNIPPS)
        FIdStueliPos: String;
        //Haelt die Kinder-Positionen
        FStueli: TDictionary<Integer, TWStueliPos>;
        //Eindeutiger Key fuer Stueli-Dictionary (wird vom System aut. vergeben)
        //Es wird eine fortlaufend Nr vergeben, in der Reihenfolge,
        // in der die Pos zur Stuli hinzugefügt werden.
        FStueliKey:Integer;
        //Liefert alle StueliKeys aufsteigend sortiert
        //Dies entspricht der Reihenfolge in der die Stueli aufgebaut wurde
        function SortedKeys(): TWSortedKeyArray;
        function GetStueliPos(Key: Integer): TWStueliPos;
        function GetStueliPosCount:Integer;
        function GetIdStueliPosVater:String;
      public
        Vater: TWStueliPos;  //Vaterknoten
        Ebene: Integer;
        EbeneNice: String;
        Menge: Double;     //Menge von Self in Vater-Stueli (beliebige Einheiten)
        MengeTotal: Double; //Gesamt-Menge (mit Übergeordneten Mengen mult.)
        hatTeil:Boolean;

        constructor Create(einVater:TWStueliPos;
                               StueliPosId:String;eineMenge:Double);
        //Berechnet die Stueli-Ebene und die summierte Menge aller Pos
        procedure SetzeEbenenUndMengen(Level:Integer;UebMenge:Double);
        procedure StueliAdd(APos: TWStueliPos);
        ///<summary>Überträgt Position APos nach Self </summary>
        procedure StueliTakePosFrom(APos: TWStueliPos);
        ///<summary>Überträgt die Kind Position APos nach Self,
        /// Apos wird gelöscht </summary>
        procedure StueliTakeChildrenFrom(APos: TWStueliPos);
        procedure ReMove();
        ///<summary>Liefert wichtige Felder in einem String verkettet </summary>
        function PosToStr():String;
        ///<summary>Verkettet wichtige Felder aller Pos zu einem String</summary>
        function BaumAlsText(txt:String): String;
        property Stueli[Key: Integer]: TWStueliPos read GetStueliPos;
        property StueliKeys: TWSortedKeyArray read SortedKeys;
        property StueliPosCount: Integer read GetStueliPosCount;
        property IdStueliPosVater:String read GetIdStueliPosVater;
        property IdStueliPos:String read FIdStueliPos; //Eigene Id
        property StueliKey:Integer read FStueliKey; //Key zum Stueli-Dict

    end;

    TWStueli = TDictionary<Integer, TWStueliPos>;

implementation


constructor TWStueliPos.Create(einVater:TWStueliPos;
                               StueliPosId:String;eineMenge:Double);
begin
  FIdStueliPos:= StueliPosId;
  Vater:= einVater;
  Menge:=eineMenge;

  //untergeordenete Stueli (Dictionary) anlegen
  FStueli:= TWStueli.Create;

  //noch kein Teil zugeordnet (Teil wird auch nicht fuer alle PosTyp gesucht)
  hatTeil:=False;

end;

function TWStueliPos.GetIdStueliPosVater:String;
begin
  if Vater<>nil then
    Result:= Vater.IdStueliPos
  else
    Result:='';
end;

//Holt mittels Key eine Pos aus Stueli
function TWStueliPos.GetStueliPos(Key: Integer): TWStueliPos;
begin
  Result:=FStueli[Key];
end;

//Anzahl der Positionen in Stueli
function TWStueliPos.GetStueliPosCount: Integer;
begin
  Result:=FStueli.Count;
end;

//Verschiebt die Kinder von APos zur Stueli von Self
procedure TWStueliPos.StueliTakeChildrenFrom(APos: TWStueliPos);
var
  KindPos: TWStueliPos;
  Key:Integer;

begin
    for Key in APos.StueliKeys do
    begin
     //KindPos Pos aus alter Stu löschen
     KindPos:=APos.Stueli[Key];
     SElf.StueliTakePosFrom(KindPos)
//     KindPos.ReMove;
     //KindPos Pos in eigene Stu übernehmen
//     Self.StueliAdd(KindPos);
    end;
end;


//Verschiebt APos zur Stueli von Self und entfernt die Pos aus der alten Stueli
procedure TWStueliPos.StueliTakePosFrom(APos: TWStueliPos);
begin
   //Neue Pos aus alter Stu l�schen
   APos.ReMove;
   //Neue Pos in eigene Stu �bernehmen
   Self.StueliAdd(APos);
   //Korrigiere Vaterknoten
   APos.Vater:=Self;

end;

//Position entfernt sich selbst aus Ihrer Vater-St�ckliste
procedure TWStueliPos.ReMove();
begin
   //Position aus alter Stu l�schen
   Self.Vater.FStueli.Remove(Self.StueliKey);
   //Position freigeben: StueliKey auf 0
   Self.FStueliKey:=0;
end;


//Die Stueckliste wird in der Reihenfolge des Aufrufes dieser Funktion bef�llt
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
    //Neuer Key 1 h�her als bisher letzter Key
    Key := keyArray[length(keyArray)-1] + 1 ;

  //Neue Pos in Stueckliste
  FStueli.Add(Key,APos);
  //Key merken
  APos.FStueliKey:=Key;

end;

//--------------------------------------------------------------------------
// Ausgabe-Funktionen
//--------------------------------------------------------------------------
//Liefert wichtige Felder in einem String verkettet
function TWStueliPos.PosToStr():String;
begin
  Result:=Format('<Ebene %s zu Stu %s bin Stu %s Pos %d Menge %5.2f>',
               [EbeneNice, IdStueliPosVater, IdStueliPos, StueliKey, Menge ]) + #13 ;
end;

//--------------------------------------------------------------------------
/// <summary> Liefert wichtige Felder aller Positionen in einem String verkettet
/// </summary>//
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
///<summary>Berechnet die Stueli-Ebene und die summierte Menge aller Pos</summary>
/// <remarks>
/// Berechnet Stueli-Ebene als Int und mit ... davor.
/// Berechet die mit den Mengen der Väter multiplizierte MengeTotal aller Pos
/// </remarks>
procedure TWStueliPos.SetzeEbenenUndMengen(Level:Integer;UebMenge:Double);

var
  StueliPos: TWStueliPos;
  StueliPosKey: Integer;

begin

  Ebene:=Level;
  EbeneNice := StringOfChar('.', Ebene-1) + IntToStr(Ebene);
  MengeTotal:=Menge*UebMenge;  //Eigene Menge mal �bergeordnete

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
