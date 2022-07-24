unit Unit1;

interface
uses System.RTTI,System.TypInfo;
type

  TmyClass= class of TBasis;

TBasis = class
  var x,y:TValue;
  procedure out;
end;

TErbe = class(TBasis)
  Werte: Integer;
  procedure Eout;
end;

TErbe2 = class(TBasis)
  Werte: Integer;
end;

procedure testrun;

implementation

procedure TBasis.out;
var I: Integer;
begin
  i:=10;
  writeln('--------');
  writeln(I);
end;

procedure TErbe.Eout;
begin
  writeln('---TErbe-----');
end;


procedure testrun;
var
  mBasis1,mBasis2:TBasis;
  mErbe1,mErbe1b:TErbe;
  mErbe2:TErbe2;
  meinTyp:PTypeInfo;
  meinValue:Tvalue;
  myClass:TmyClass;
  myObj:TBasis;
  wahr:boolean;
begin
    mBasis1:=TBasis.Create;
    mErbe1:=TErbe.Create;
    mErbe1b:=TErbe.Create;
    mErbe2:=TErbe2.Create;
    myClass:=TBasis;
    myClass:=TErbe;

//        myClass:=TErbe;                                         :

    //    mBasis.out;
    mErbe1.Werte:=10;
    mErbe2.Werte:=20;
    mBasis1.x:=mErbe1;
    mBasis1.y:=mErbe2;
    meinValue:=mBasis1.x;

    wahr:=meinValue.IsObject;
    wahr:=meinValue.IsObjectInstance;
    wahr:=meinValue.IsInstanceOf(TErbe);
    meinTyp:=meinValue.TypeInfo;
    myClass:=meinTyp;

    //    wahr:=meinValue.TryCast(meinTyp,mErbe1b);
//    mErbe1b:=meinValue.GetReferenceToRawData;
//    mErbe1b:=meinValue.AsObject;
    meinValue.Cast(meinTyp).ExtractRawData(@mErbe1b);
    mErbe1b.Eout;
    writeln(mErbe1b.Werte);

//    meinValue.Cast(meinTyp).Werte;
    writeln(meinValue.AsType<TErbe>.Werte);
    meinValue.AsType<TErbe>.Eout;


end;

end.
