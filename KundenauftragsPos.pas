unit KundenauftragsPos;

interface

uses  StuecklistenPosition,DBConnect,DBQry;

type
  TZKundenauftragsPos = class(TZStueliPos)
    private
      Rabatt:Double;
    protected
      { protected declarations }
    public
      vk_brutto: Double;
      vk_netto: Double;
    published
      constructor Create(Qry: TZQry; Kundenrabatt: Double);
    end;

implementation

constructor TZKundenauftragsPos.Create(Qry: TZQry; Kundenrabatt: Double);
begin
  inherited Create(KA_Pos);
  //Speichere typunabhängige Daten über geerbte Funktion
  PosDatenSpeichern(Qry);
  //Speichere typabhängige Daten
  Rabatt:=Kundenrabatt;
  vk_brutto:=Qry.FieldByName('preis').AsFloat;
  vk_netto:=vk_brutto * (1 + Rabatt) //Rabbat hat Minuszeichen in UNIPPS
end;

end.
