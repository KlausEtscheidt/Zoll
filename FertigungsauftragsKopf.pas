unit FertigungsauftragsKopf;

interface

uses  StuecklistenPosition, DBZugriff;

type
  TZFAKopf = class(TZStueliPos)
    private
      Qry: TZQry;
    protected
      { protected declarations }
    public
    published
      constructor Create(einTyp: TZStueliPosTyp; AQry: TZQry);
      procedure holeKinderAusASTUELIPOS;

    end;

implementation

constructor TZFAKopf.Create(einTyp: TZStueliPosTyp; AQry: TZQry);
begin
  inherited Create(einTyp);
  Qry:=AQry;
  //Speichere typunabhängige Daten über geerbte Funktion
  PosDatenSpeichern(Qry);


end;

procedure TZFAKopf.holeKinderAusASTUELIPOS;
begin

end;

end.
