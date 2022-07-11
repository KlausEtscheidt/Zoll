unit StuecklistenPosition;

interface
  uses System.RTTI, System.SysUtils, System.Generics.Collections, DBZugriff, Teil;

  type
    TZValue = TValue;
    TZStueliPosTyp = (KA, KA_Pos, FA_Komm, FA_Serie);
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
        FA_Nr: String;
        verurs_art: String;

        Stueli: TDictionary<String, TValue>;
        Teil: TZTeil;

      published
        constructor Create(APosTyp:TZStueliPosTyp);
        procedure PosDatenSpeichern(Qry: TZQry);
      end;

implementation

constructor TZStueliPos.Create(APosTyp:TZStueliPosTyp);
begin
  PosTyp:=APosTyp;
  //Stueli:= TDictionary<String, TZStueliPos>.Create;
  Stueli:= TDictionary<String, TValue>.Create;

end;

procedure TZStueliPos.PosDatenSpeichern(Qry: TZQry);
var TeileQry: TZQry;

begin
  //Allgemeingültige Felder
  id_stu:=trim(Qry.FieldByName('id_stu').AsString);
  pos_nr:=trim(Qry.FieldByName('pos_nr').AsString);
  oa:=Qry.FieldByName('oa').AsInteger;
  t_tg_nr:=trim(Qry.FieldByName('t_tg_nr').AsString);
  unipps_typ:=trim(Qry.FieldByName('typ').AsString);

  //typspezifische Felder
  if PosTyp=KA_Pos then
  begin
    id_pos:=trim(Qry.FieldByName('id_pos').AsString);
    besch_art:=Qry.FieldByName('besch_art').AsInteger;
    menge:=Qry.FieldByName('menge').AsFloat;

    var gefunden: Boolean;
    TeileQry:=DBConn.getQuery();
    gefunden:=TeileQry.SucheDatenzumTeil(t_tg_nr);
    if gefunden then
    begin
      Teil:= TZTeil.Create(TeileQry);
      if Teil.istKaufteil then
        Teil.holeMaxPreisAus3Bestellungen;
    end;
  end;

  if PosTyp=FA_Serie then
  begin
     FA_Nr:=trim(Qry.FieldByName('id_FA').AsString);
     verurs_art:=trim(Qry.FieldByName('verurs_art').AsString);
  end;

  if PosTyp=FA_Komm then
  begin
     FA_Nr:=trim(Qry.FieldByName('FA_Nr').AsString);
     verurs_art:=trim(Qry.FieldByName('verurs_art').AsString);
  end;


end;

end.
