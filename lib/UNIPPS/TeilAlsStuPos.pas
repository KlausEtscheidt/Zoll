unit TeilAlsStuPos;

interface

uses  UnippsStueliPos, Tools;

type
  TWTeilAlsStuPos = class(TWUniStueliPos)
    private
    protected
      { protected declarations }
    public
      t_tg_nr: String;
      TeilIdStu: String; //Achtung hier Teilenummer  //nur f Debug
      TeilIdPos: Integer; //teil_stuelipos.pos_nr
      constructor Create(einVater: TWUniStueliPos; Qry: TWUNIPPSQry);
    end;


implementation

constructor TWTeilAlsStuPos.Create(einVater: TWUniStueliPos; Qry: TWUNIPPSQry);
begin
  {UNIPPS Mapping
  Suche mit SucheStuelizuTeil: Kriterium teil_stuelipos.ident_nr1=t_tg_nr
  liefert  teil_stuelipos.ident_nr1 As id_stu, teil_stuelipos.pos_nr,
   teil_stuelipos.t_tg_nr }

  TeilIdStu:=Qry.FieldByName('id_stu').AsString;
  TeilIdPos:=Qry.FieldByName('pos_nr').Value;
  Menge:=Qry.FieldByName('menge').Value;
  inherited Create(einVater, 'Teil', TeilIdStu, TeilIdPos, Menge);

  //Speichere typunabh�ngige Daten �ber geerbte Funktion
  PosDatenSpeichern(Qry);

//  pos_nr:=Self.PosData['pos_nr'];
  t_tg_nr:=Self.PosData['t_tg_nr'];

  //Suche Teil zur Position  (ueber Vaterklasse TWUniStueliPos)
  SucheTeilzurStueliPos();

end;

end.
