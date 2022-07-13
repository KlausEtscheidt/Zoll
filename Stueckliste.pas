unit Stueckliste;

interface
  uses System.RTTI, System.SysUtils, System.Generics.Collections,
       Exceptions,Data.DB,Logger;

 type
    TZValue = TValue; //alias
    TZEndKnotenListe = class(TList<TValue>)
        private
        public
          Liste: TList<TValue>;
          constructor Create;
          function ToStr:String;
          procedure WriteToLog;
    end;

var
  EndKnotenListe: TZEndKnotenListe;

implementation

uses StuecklistenPosition;

constructor TZEndKnotenListe.Create;
begin
  inherited;
end;

function TZEndKnotenListe.ToStr:String;
var
  txt:String;
  Member:TZValue;
  StueliPos: TZStueliPos;

begin
  txt:= 'EndknotenListe: ';
  for Member in Self do
  begin
    StueliPos:= Member.AsType<TZStueliPos>;
    txt:= txt + '<' + StueliPos.ToStr +  '>'  ;
  end;
  Result := txt;
end;

procedure TZEndKnotenListe.WriteToLog;
var
  txt:String;
  Member:TZValue;
  StueliPos: TZStueliPos;

begin
  Log.Log('EndknotenListe: ');
  for Member in Self do
  begin
    StueliPos:= Member.AsType<TZStueliPos>;
    Log.Log(StueliPos.ToStr );
  end;
end;

end.
