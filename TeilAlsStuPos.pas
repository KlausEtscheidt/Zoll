unit TeilAlsStuPos;

interface

uses  StuecklistenPosition, DBZugriff;

type
  TZTeilAlsStuPos = class(TZStueliPos)
    private
    protected
      { protected declarations }
    public
    published
      constructor Create(AQry: TZQry);
    end;


implementation

constructor TZTeilAlsStuPos.Create(AQry: TZQry);
begin
  inherited Create('Teil');
  //Speichere typunabh�ngige Daten �ber geerbte Funktion
  PosDatenSpeichern(AQry);
end;

end.
