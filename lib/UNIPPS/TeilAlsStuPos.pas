unit TeilAlsStuPos;

interface

uses  SysUtils,UnippsStueliPos, Tools;

type
  TWTeilAlsStuPos = class(TWUniStueliPos)
    private
    protected
      { protected declarations }
    public
    { TODO 1 :
Datenherkunft uns SQL Zusammenhänge prüfen und dokumentieren
insbes t_tg_nr }
      TeilInStuTeilenummer: String; //= t_tg_nr
      TeilIdStuVater: String; //Achtung hier Teilenummer  //nur f Debug
      TeilIdPos: Integer; //teil_stuelipos.pos_nr
      constructor Create(einVater: TWUniStueliPos; Qry: TWUNIPPSQry);
    end;


implementation

constructor TWTeilAlsStuPos.Create(einVater: TWUniStueliPos; Qry: TWUNIPPSQry);
var
  IdStuPos:String;
begin
  {UNIPPS Mapping
  Suche mit SucheStuelizuTeil: Kriterium teil_stuelipos.ident_nr1=t_tg_nr
  liefert  teil_stuelipos.ident_nr1 As id_stu, teil_stuelipos.pos_nr,
   teil_stuelipos.t_tg_nr }

  TeilIdStuVater:=Qry.FieldByName('id_stu').AsString;
  TeilIdPos:=Qry.FieldByName('pos_nr').AsInteger;
  Menge:=Qry.FieldByName('menge').AsFloat;

  //Eigene ID aus t_tg_nr und UNIPPS pos_nr
  IdStuPos:=TeilIdStuVater+'_'+ IntToStr(TeilIdPos);
  inherited Create(einVater, 'Teil',IdStuPos, Menge);

  //Speichere typunabh�ngige Daten �ber geerbte Funktion
  PosDatenSpeichern(Qry);

  TeilInStuTeilenummer:=Qry.FieldByName('stu_t_tg_nr').AsString;

  //Suche Teil zur Position  (ueber Vaterklasse TWUniStueliPos)
  SucheTeilzurStueliPos();

end;

end.
