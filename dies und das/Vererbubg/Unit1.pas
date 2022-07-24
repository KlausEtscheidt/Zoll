unit Unit1;

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

procedure testrun;

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


procedure testrun;
var
  mBasis:TBasis;
  mErbe1:TErbe1;
  mErbe2:TErbe2;
  meinTyp:PTypeInfo;
  X:TValue;

  myClass:TmyClass;
  obj:TObject;   //auf Basisklasse
  BasisObj:TBasis;   //auf Basisklasse
  wahr:boolean;
  //Folgendes sollte von außen übergeben werden
  dict:TDictionary<String,TmyClass>;
  typcontainer:TList<TmyClass>;
  genericTeil:TBasis;
  cname:String;
begin
    //3 OBjekte anlegen
//    mBasis:=TBasis.Create;
    mErbe1:=TErbe1.Create;
    mErbe2:=TErbe2.Create;

//    BasisObj:=TBasis.Create;

    //Testobjekt in Tvalue ablegen
    X:=mErbe1;

    //Wie bekommen wir das Originalobjekt (korrekte Klasse) zurück
    //------------------------------------------------------------

    //Tests
    wahr:=X.IsObject;
    wahr:=X.IsObjectInstance;
    wahr:=X.IsInstanceOf(TErbe1);

    //Erst in Objekt wandeln
    obj:=X.AsObject;

    //statisch casten
    //--------------------------------------------------------
    TErbe1(obj).Eout;

    //zur Laufzeit ohne explizite Klassenangaben casten
    //--------------------------------------------------------
    typcontainer:=TList<TmyClass>.Create;
    typcontainer.Add(TErbe1);
//     MyFactory := TDictionary<string, MyBaseClass>.Create;
//     MyFactory.Add('xxx1', MyClass1);


    //Typ-Variable könnte übergeben werden
    myClass:=TErbe1;

    //Typ als PTypeInfo bestimmen
//    meinTyp:=X.TypeInfo;

    //Typ-Variable auf ermittelten Typ setzen
//    myClass:=meinTyp;
    genericTeil:=typcontainer[0].Create;
    cname:=genericTeil.ClassName;
    TErbe1(genericTeil).out;
    genericTeil:=obj as TErbe1;
    cname:=genericTeil.ClassName;
    genericTeil.out;
    cname:=genericTeil.ClassName;
//    X.Cast(meinTyp).AsObject;

    //    wahr:=meinValue.TryCast(meinTyp,mErbe1b);
//    mErbe1b:=meinValue.GetReferenceToRawData;
//    mErbe1b:=meinValue.AsObject;
//    X.Cast(meinTyp).ExtractRawData(@obj);
//    Y.Eout;
//    writeln(Y.E1Werte);

//    meinValue.Cast(meinTyp).Werte;
//    writeln(meinValue.AsType<TErbe>.Werte);
//    meinValue.AsType<TErbe>.Eout;


end;

end.
