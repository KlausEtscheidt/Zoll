unit Unit1;

interface

type

TBasis = class
  procedure out;
  procedure out2;
end;

TErbe = class(TBasis)
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

procedure TBasis.out2;
begin
  writeln('--------');
  writeln(Werte);
end;

procedure testrun;
var
  mBasis:TBasis;
  mErbe:TErbe;
begin
    mBasis:=TBasis.Create;
    mErbe:=TErbe.Create;
//    mBasis.out;
    mErbe.Werte:=20;
    mErbe.out2;
end;

end.
