unit TeilAlsStuPos;

interface

uses  StuecklistenPosition, DBZugriff;

type
  TZTeilAlsStuPos = class(TZStueliPos)
    private
    protected
      { protected declarations }
    public
      pos_nr: String;
      t_tg_nr: String;
      constructor Create(AQry: TZQry);
    end;


implementation

constructor TZTeilAlsStuPos.Create(AQry: TZQry);
begin
  inherited Create('Teil');
  //Speichere typunabhängige Daten über geerbte Funktion
  PosDatenSpeichern(AQry);
  pos_nr:=Self.PosData['pos_nr'];
  t_tg_nr:=Self.PosData['t_tg_nr'];

end;

end.
