/// <summary>Allgemeine Form einer Stücklistenposition/Stückliste</summary>
/// <remarks>Die Stücklistenposition wird über ihre Id IdStueliPos identifiziert,
/// die innerhalb der übergeordneten Stückliste eindeutig sein sollte.
/// Die Stücklistenposition besitzt eine untergeordnete Stückliste (Dictionary).
/// Mit StueliAdd werden Positionen in diese eigene Stüli aufgenommen.
/// Dabei wird in der Reihenfolge des Hinzufügens ein fortlaufender Key vergeben.
/// Die Stücklistenposition besitzt daher ebenfalls die Property StueliKey,
/// welche sie innerhalb der übergeordneten Stückliste identifiziert.
/// </remarks>
unit Stueckliste;

interface
  uses System.RTTI, System.SysUtils, System.Generics.Collections,
       System.TypInfo, Data.DB;

 type
    /// <summary>Klasse für Exceptions dieser Unit</summary>
    EWStueli=class(Exception);

 type
    TWSortedKeyArray = TArray<Integer>;
    /// <summary>Allgemeine Form einer Stücklistenposition mit
    /// untergeordneter Stückliste.</summary>
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
        ///<summary>Vaterknoten als TWStueliPos-Objekt</summary>
        Vater: TWStueliPos;
        ///<summary>Ebene im Stücklistenbaum, in der sich die Pos befindet</summary>
        Ebene: Integer;
        ///<summary>Ebene mit führenden Punkten, zur schöneren Darstellung</summary>
        EbeneNice: String;
        ///<summary>Menge von Self in Vater-Stueli (beliebige Einheiten)</summary>
        Menge: Double;     
        ///<summary>Gesamt-Menge von Self (mit Übergeordneten Mengen multipliziert)</summary>
        MengeTotal: Double;
        ///<summary>True, wenn der Pos ein Teil zugeordnet wurde</summary>
        hatTeil:Boolean;

        constructor Create(einVater:TWStueliPos;
                               StueliPosId:String;eineMenge:Double);
        procedure SetzeEbenenUndMengen(Level:Integer;UebMenge:Double);
        procedure StueliAdd(APos: TWStueliPos);
        procedure StueliTakePosFrom(APos: TWStueliPos);
        procedure StueliTakeChildrenFrom(APos: TWStueliPos);
        procedure ReMove();
        function PosToStr():String;
        function BaumAlsText(txt:String): String;
        /// <summary> Stuecklistenposition[Key] zum Key</summary>
        property Stueli[Key: Integer]: TWStueliPos read GetStueliPos;
        /// <summary>Stueli-Keys in der Reihenfolge,
        /// in der die Stueckliste aufgebaut wurde.</summary>
        property StueliKeys: TWSortedKeyArray read SortedKeys;
        property StueliPosCount: Integer read GetStueliPosCount;
        /// <summary>Id des Vaterknotens bzgl der Stückliste, in der er steht</summary>
        property IdStueliPosVater:String read GetIdStueliPosVater;
        ///<summary>Eigene Id, d.h. Id dieser Stüli-Pos. Keine UNIPPS-Id</summary>
        property IdStueliPos:String read FIdStueliPos;
        ///<summary>Key, der die Position in ihrer Vater-Stückliste identifiziert</summary>
        property StueliKey:Integer read FStueliKey; //Key zum Stueli-Dict

    end;

    TWStueli = TDictionary<Integer, TWStueliPos>;

implementation

///<summary>Erzeugt eine Stücklisten-Position</summary>
/// <param name="einVater">Vaterknoten Objekt</param>
/// <param name="StueliPosId">Id zum Erkennen der neu zu erzeugenden Position</param>
/// <param name="eineMenge">Menge, mit der die Position in ihrer Stueli steht.</param>
constructor TWStueliPos.Create(einVater:TWStueliPos;
                               StueliPosId:String;eineMenge:Double);
begin
  FIdStueliPos:= StueliPosId;
  Vater:= einVater;
  Menge:=eineMenge;

  //untergeordenete Stueli (Dictionary) anlegen
  FStueli:= TWStueli.Create;

  //noch kein Teil zugeordnet (Teil wird auch nicht fuer alle Pos-Typen gesucht)
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

///<summary>Überträgt alle Kinder von APos in die eigene Stueli und
///entfernt sie aus der alten Liste</summary>
/// <param name="APos">Position, deren Kinder übertragen werden sollen.</param>
procedure TWStueliPos.StueliTakeChildrenFrom(APos: TWStueliPos);
var
  KindPos: TWStueliPos;
  Key:Integer;

begin
    for Key in APos.StueliKeys do
    begin
     //KindPos Pos aus alter Stu löschen
     KindPos:=APos.Stueli[Key];
     Self.StueliTakePosFrom(KindPos)
    end;
end;


///<summary>Überträgt die Position APos in die eigene Stueli und
///entfernt sie aus der alten Liste</summary>
procedure TWStueliPos.StueliTakePosFrom(APos: TWStueliPos);
begin
   //Neue Pos aus alter Stu löschen
   APos.ReMove;
   //Neue Pos in eigene Stu übernehmen
   Self.StueliAdd(APos);
   //Korrigiere Vaterknoten
   APos.Vater:=Self;

end;

///<summary>Entfernt aktuelle Pos (Self) aus Vater-Stüli.</summary>
/// <remarks>Die Pos wird zur Neuverwendung frei gegeben:
/// Self.FStueliKey:=0;</remarks>
procedure TWStueliPos.ReMove();
begin
   //Position aus alter Stu löschen
   Self.Vater.FStueli.Remove(Self.StueliKey);
   //Position freigeben: StueliKey auf 0
   Self.FStueliKey:=0;
end;


//Die Stueckliste wird in der Reihenfolge des Aufrufes dieser Funktion befüllt
///<summary>Fügt eine neue Pos zur eigenen Stüli dazu.</summary>
///<remarks>Die Stueckliste ist ein Dictionary mit einem Integer als key.
///Die keys werden fortlaufend vergeben. Eine Schleife über die sortierten Keys,
///gibt die Stuecklisten-Einträge daher in der Reihenfolge ihrer Erzeugung aus.
///</remarks>
///<param name="APos">Einzufügende Position</param>
procedure TWStueliPos.StueliAdd(APos: TWStueliPos);
var
  Key:Integer;
  keyArray: System.TArray<Integer>;
  msg:String;
begin

  //Jedes TWStueliPos ist ein Unikat und kann nur einmal verwendet werden
  //Falls APos.StueliKey schon einen Wert hat, ist es schon in einer Stueckliste
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

  //Neue Pos in Stueckliste einfuegen
  FStueli.Add(Key,APos);
  //Key in Property  merken
  APos.FStueliKey:=Key;

end;

//--------------------------------------------------------------------------
// Ausgabe-Funktionen
//--------------------------------------------------------------------------

///<summary>Liefert zum Debuggen wichtige Felder in einem String verkettet.</summary>
function TWStueliPos.PosToStr():String;
begin
  Result:=Format('<Ebene %s zu Stu %s bin Stu %s Pos %d Menge %5.2f>',
               [EbeneNice, IdStueliPosVater, IdStueliPos, StueliKey, Menge ]) + #13 ;
end;

//--------------------------------------------------------------------------
/// <summary> Liefert zum Debuggen wichtige Felder aller Baum-Positionen
/// zu einem String verkettet. </summary>
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
///<summary>Berechnet die Stueli-Ebene und die summierte Menge aller Positionen</summary>
/// <remarks>Die Proc durchläuft rekursiv den gesamten Stüli-Baum und
/// berechnet Stueli-Ebene als Int bzw String mit Punkten('...') davor.
/// Sie berechnet das Produkt (MengeTotal) aus der eigenen Menge der Position und
/// den Mengen all ihrer Väter.
///</remarks>
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
