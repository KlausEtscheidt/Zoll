unit Unit2;

interface

uses System.RTTI,System.Generics.Collections,TypInfo;

type

  TDict = TDictionary<String,TObject>;

TBBasis = class
  procedure out;
end;

TEErbe = class(TBBasis)
  procedure Eout;
end;

procedure testrun2;

implementation

procedure TBBasis.out;
begin
  writeln('---Basis-----');
end;

procedure TEErbe.Eout;
begin
  writeln('---TErbe-----');
end;

procedure testrun2;
var
  obj1:TEErbe;
  obj2:TBBasis;
  dict: TDict;
  x:TObject;
  y:TValue;
  meinTyp:PTypeInfo;

  begin
  obj1 := TEErbe.create;
  obj2 := TBBasis.create;
//  y:=TValue.create;

  dict := TDict.Create;
  dict.add('obj1',obj1);
  dict.add('obj2',obj2);

  y:=obj2;

  x:=y.AsObject;
//  x:=dict['obj2'];

  if x is TEErbe then
    TEErbe(x).Eout;
  if x is TBBasis then
    TBBasis(x).out;

  meinTyp:=y.TypeInfo;
  if meinTyp.Name =  'TEErbe' then
    y.AsType<TEErbe>.Eout;
  if meinTyp.Name =  'TBBasis' then
    y.AsType<TBBasis>.out;

end;

end.
