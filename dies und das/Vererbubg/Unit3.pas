unit Unit3;

interface

uses System.RTTI,System.TypInfo,
      System.Generics.Collections;
type


TBasis = class
  var x,y:TValue;
  procedure out;
end;

TmyClass= class of TBasis;

TErbe1 = class(TBasis)
  E1Werte: Integer;
  procedure out;
  procedure Eout;
end;

TErbe2 = class(TBasis)
  E2Werte: Integer;
end;

procedure testrun3;


implementation

procedure TBasis.out;
var I: Integer;
begin
  i:=10;
  writeln('----Basis----');
  writeln(I);
end;

procedure TErbe1.Eout;
begin
  writeln('---TErbe-----');
end;

procedure TErbe1.out;
begin
  writeln('---TErbe--out---');
end;

procedure testrun3;
var
  mBasis:TBasis;
  mErbe1:TErbe1;
  mErbe2:TErbe2;
  X:TValue;

  myClass:TmyClass;
  obj:TObject;   //auf Basisklasse
  BasisObj:TBasis;   //auf Basisklasse
  wahr:boolean;
  //Folgendes sollte von außen übergeben werden
//  dict:TDictionary<String,TmyClass>;
  typcontainer:TList<TmyClass>;
  genericTeil:TBasis;
  cname:String;

begin

    //3 OBjekte anlegen
    mBasis:=TBasis.Create;
    mErbe1:=TErbe1.Create;
    mErbe2:=TErbe2.Create;

    //Testobjekt in Tvalue ablegen
    X:=mErbe1;

    //Wie bekommen wir das Originalobjekt (korrekte Klasse) zurück
    //------------------------------------------------------------

    //Daten koennen/sollen von außen kommen
    typcontainer:=TList<TmyClass>.Create;
    typcontainer.Add(TErbe1);
    //     MyFactory := TDictionary<string, MyBaseClass>.Create;
    //     MyFactory.Add('xxx1', MyClass1);

    //Erst in Objekt wandeln
    obj:=X.AsObject;

    //Einem Objekt der Basisklasse korrektes Objekt zuweisen
    myClass:=typcontainer[0];
    genericTeil:=myClass.Create;
    cname:=genericTeil.ClassName;  //Klasse pruefen
    (genericTeil as myClass).out;
    (obj as myClass).out;
    (obj as TErbe1).out;
//    myClass(genericTeil).out;
    TErbe1(genericTeil).out;


    cname:=genericTeil.ClassName;  //Klasse pruefen


end;

end.
