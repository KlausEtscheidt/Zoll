unit StuecklistenPosition;

interface
  uses System.RTTI, System.SysUtils, System.Generics.Collections, DBZugriff, Teil;

  type
    TZValue = TValue; //alias
    TZEndKnoten =  TList<TValue>;
    TZStueliPosTyp = (KA, KA_Pos, FA_Komm, FA_Serie, FA_Pos, Teil);

    TZStueliPos = class(TObject)
      private
        procedure SucheTeilzurStueliPos();
      protected

      public
        PosTyp:TZStueliPosTyp;
        id_stu : String;
        id_pos : String;
        besch_art : String;
        pos_nr : String;
        oa : Integer;
        t_tg_nr: String;
        unipps_typ: String;
        menge: Double;
        FA_Nr: String;
        verurs_art: String;
        ueb_s_nr:String;
        ds:String;
        set_block:String;

        Stueli: TDictionary<String, TValue>;
        Teil: TZTeil;

      published
        constructor Create(APosTyp:TZStueliPosTyp);
        procedure PosDatenSpeichern(Qry: TZQry);
      end;

var
  EndKnoten: TZEndKnoten;

implementation


constructor TZStueliPos.Create(APosTyp:TZStueliPosTyp);
begin
  PosTyp:=APosTyp;
  Stueli:= TDictionary<String, TValue>.Create;

end;

procedure TZStueliPos.PosDatenSpeichern(Qry: TZQry);

begin
  //Allgemeingültige Felder
  //-----------------------------------------------
  id_stu:=trim(Qry.FieldByName('id_stu').AsString);
  pos_nr:=trim(Qry.FieldByName('pos_nr').AsString);
  oa:=Qry.FieldByName('oa').AsInteger;
  t_tg_nr:=trim(Qry.FieldByName('t_tg_nr').AsString);
  unipps_typ:=trim(Qry.FieldByName('typ').AsString);

  //typspezifische Felder
  //-----------------------------------------------
  //vorbelegen
  id_pos:='';
  besch_art:='';
  menge:=1.;
  FA_Nr:='';
  verurs_art:='';
  ueb_s_nr:='';
  ds:='';
  set_block:='';

  if PosTyp=KA_Pos then
  begin
    id_pos:=trim(Qry.FieldByName('id_pos').AsString);
    besch_art:=Qry.FieldByName('besch_art').AsString;
    menge:=Qry.FieldByName('menge').AsFloat;

    //Suche Teil zur Position
    SucheTeilzurStueliPos;

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

  if PosTyp=FA_Pos then
  begin
    id_pos:=trim(Qry.FieldByName('id_pos').AsString);
    ueb_s_nr:=trim(Qry.FieldByName('ueb_s_nr').AsString);
    ds:=trim(Qry.FieldByName('ds').AsString);
    set_block:=trim(Qry.FieldByName('set_block').AsString);
  end;

end;

procedure TZStueliPos.SucheTeilzurStueliPos();

var
  TeileQry: TZQry;
  gefunden: Boolean;

begin
      TeileQry:=DBConn.getQuery();
      gefunden:=TeileQry.SucheDatenzumTeil(t_tg_nr);
      if gefunden then
      begin
        Teil:= TZTeil.Create(TeileQry);
        if   Teil.istKaufteil then
          Teil.holeMaxPreisAus3Bestellungen;
      end;
    
end;
end.
