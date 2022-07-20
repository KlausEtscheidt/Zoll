unit TeilAlsStuPos;

interface

uses  UnippsStueliPos, Tools;

type
  TWTeilAlsStuPos = class(TWUniStueliPos)
    private
    protected
      { protected declarations }
    public
      pos_nr: String;
      t_tg_nr: String;
      constructor Create(AQry: TWUNIPPSQry);
    end;


implementation

constructor TWTeilAlsStuPos.Create(AQry: TWUNIPPSQry);
begin
  inherited Create('Teil');
  //Speichere typunabh�ngige Daten �ber geerbte Funktion
  PosDatenSpeichern(AQry);
  pos_nr:=Self.PosData['pos_nr'];
  t_tg_nr:=Self.PosData['t_tg_nr'];

end;

end.
