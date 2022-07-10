unit StuecklistenPosition;

interface
  uses System.SysUtils, System.Generics.Collections, DBConnect, DBQry, Teil;

  type
    TZStueliPosTyp = (KA, KA_Pos, FA_Komm);
    TZStueliPos = class(TObject)
      private

      protected

      public
        PosTyp:TZStueliPosTyp;
        id_stu : String;
        id_pos : String;
        besch_art : Integer;
        pos_nr : String;
        oa : Integer;
        t_tg_nr: String;
        unipps_typ: String;
        menge: Double;
        Stueli: TDictionary<String, TZStueliPos>;
        Teil: TZTeil;

      published
        constructor Create(APosTyp:TZStueliPosTyp);
        procedure PosDatenSpeichern(Qry: TZQry);
      end;

implementation

constructor TZStueliPos.Create(APosTyp:TZStueliPosTyp);
begin
  PosTyp:=APosTyp;
  Stueli:= TDictionary<String, TZStueliPos>.Create;

end;

procedure TZStueliPos.PosDatenSpeichern(Qry: TZQry);
var conn: TZDbConnector;
var TeileQry: TZQry;

begin
  //Allgemeingültige Felder
  id_stu:=trim(Qry.FieldByName('id_stu').AsString);
  id_pos:=trim(Qry.FieldByName('id_pos').AsString);
  besch_art:=Qry.FieldByName('besch_art').AsInteger;
  pos_nr:=trim(Qry.FieldByName('pos_nr').AsString);
  oa:=Qry.FieldByName('oa').AsInteger;
  t_tg_nr:=trim(Qry.FieldByName('t_tg_nr').AsString);
  unipps_typ:=trim(Qry.FieldByName('typ').AsString);
  menge:=Qry.FieldByName('menge').AsFloat;

  //typspezifische Felder
  if PosTyp=KA_Pos then
  begin
    var gefunden: Boolean;
    conn:= TZDbConnector.Create(nil);
    TeileQry:=conn.getQuery();
    gefunden:=TeileQry.SucheDatenzumTeil(t_tg_nr);
    if gefunden then
    begin
      Teil:= TZTeil.Create(TeileQry);
      if Teil.istKaufteil then
        Teil.holeMaxPreisAus3Bestellungen;
    end;


  end;

end;

end.
