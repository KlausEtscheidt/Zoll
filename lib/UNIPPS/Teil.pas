unit Teil;

interface

uses  System.SysUtils, Data.Db, DBZugriff, Bestellung, Exceptions,
      Tools;

type
  TZTeil = class
  private
    { private declarations }
    function BerechnePreisJeLMERabattiert(Qry: TZQry): Double;
//    function BerechnePreisJeLMEUnrabattiert(Qry: TZQry): Double;
  protected
    { protected declarations }
  public
    besch_art: Integer;
    oa: Integer;
    praeferenzkennung: Integer;
    t_tg_nr: String;
    unipps_typ: String;
    sme: Integer;
    lme: Integer;
    faktlme_sme: Double;
    Bezeichnung:String;

    PreisGesucht: Boolean;
    PreisErmittelt: Boolean;
    Bestellung: TZBestellung;
    PreisJeLME: Double;

    istKaufteil:Boolean;
    istEigenfertigung:Boolean;
    istFremdfertigung:Boolean;

    constructor Create(TeileQry: TZQry);
    procedure holeBenennung;
    procedure holeMaxPreisAus3Bestellungen;
    function ToStr():String;

  end;

implementation

constructor TZTeil.Create(TeileQry: TZQry);
begin
  try
    t_tg_nr:=Trim(TeileQry.FieldByName('t_tg_nr').AsString);
    besch_art:=TeileQry.FieldByName('besch_art').AsInteger;
    oa:=TeileQry.FieldByName('oa').AsInteger;
    praeferenzkennung:=TeileQry.FieldByName('praeferenzkennung').AsInteger;
    unipps_typ:=Trim(TeileQry.FieldByName('typ').AsString);
    sme:=TeileQry.FieldByName('sme').AsInteger;
    faktlme_sme:=TeileQry.FieldByName('faktlme_sme').AsFloat;
    lme:=TeileQry.FieldByName('lme').AsInteger;
    Bestellung:=nil;
    PreisJeLME:=0;
    PreisGesucht:= False;
    PreisErmittelt:= False;
    if besch_art in [1,2,4] then
    begin
      istKaufteil:=besch_art=1;
      istEigenfertigung:=besch_art=2;
      istFremdfertigung:=besch_art=4;
    end
    else
      raise EStuBaumTeileErr.Create('Unzulässige Beschaffungsart >'
      + inttostr(besch_art) + '< in >TZTeil.Create<');

    holeBenennung;
  except
   on EDatabaseError do
      Wkz.ErrLog.Log('Fehler');
  else
      raise;
  end;

end;

procedure TZTeil.holeBenennung;
  var Qry: TZQry;
begin
  Qry:=DBConn.getQuery();
  if Qry.SucheBenennungZuTeil(t_tg_nr) then
    Bezeichnung:=Trim(Qry.FieldByName('Bezeichnung').AsString);
end;


procedure TZTeil.holeMaxPreisAus3Bestellungen;
  var gefunden: Boolean;
  var Qry: TZQry;
  var maxPreis:Double;
  var maxFields:TFields;

begin

  if not istKaufteil then
    exit;

  Qry:=DBConn.getQuery();

  PreisGesucht:= True;
  gefunden:=Qry.SucheLetzte3Bestellungen(t_tg_nr);

  if not gefunden then
  begin
      //Fehler ausgeben
      exit;
  end;

  maxPreis:=0;
  maxFields:=nil;

  while not Qry.Eof do
  begin
    PreisJeLME:=BerechnePreisJeLMERabattiert(Qry);
    If PreisJeLME > maxPreis Then
    begin
          //Datensatz und Preis merken
          maxPreis := PreisJeLME;
          maxFields:=Qry.Fields;
    end;

    Qry.next;
  end;

  PreisErmittelt:= True;

  //Übertrage gemerkten Datensatz in Ojekt
  Bestellung := TZBestellung.Create(maxFields);

end;

function TZTeil.BerechnePreisJeLMERabattiert(Qry: TZQry): Double;
begin
  {s. auch Erklärungen in BerechnePreisJeLMEUnrabattiert
    Wert der Bestellpos ohne Rabatte:
    wert = Preis_je_BME * Bestellmenge
    => analog
    Wert der Bestellpos mit Rabatt:
    wert = rs.Fields("netto_poswert") = Preis_je_BME_netto = rs.Fields("netto_poswert") * Bestellmenge
    also: Preis_je_BME_netto = rs.Fields("netto_poswert") / * Bestellmenge
  }
  var preis : double;
  preis := Qry.FieldByName('netto_poswert').AsFloat / Qry.FieldByName('menge').AsFloat;

  //Preis je Lagermengeneinheit
  Result := preis *Qry.FieldByName('faktlme_bme').AsFloat;

//    Probe noch VBA
//    If Abs(rs.Fields("netto_poswert") - rs.Fields("menge") * preis) > 0.01 Then
//        Logger.user_info "Fehlerhafte Preisberechnung in Bestellung: " & CStr(rs.Fields("bestell_id"))
//    End If
end;


//function TZTeil.BerechnePreisJeLMEUnrabattiert(Qry: TZQry): Double;
//begin
//  {Daten in UNIPPS aus Bestllung/Zusatz/Zusatzdaten zur Bestellposition (im Feld Preis) bzw Hauptformular zum Teil
//   Beispiel ERMPE�40
//   Basis=1
//   PME=kg (Preismengeneinheit)
//   BME=St�ck (Bestellmengeneinheit)
//   faktbme_pme= 2,48 Kg/St;   wieviele PME ergeben eine BME ? 2,48 Kg ergeben 1 St�ck
//   Preis_je_PME=8,35�/Kg aus Bestellung
//   Preis_je_BME = Preis_je_PME *faktbme_pme=8,35�/Kg * 2,48Kg/St = 20,71�/St
//   LME=m (Lagermengeeinheit)
//   faktlme_bme=0,5St/m;  wieviele BME ergeben eine LME ? 0,5 ergeben 1 St�ck
//   Preis_je_LME = Preis_je_BME * faktlme_bme = 20,71�/St * 0,5St/m = 10,35 �/m
//  }
//
//  //  UNIPPS-Feld Preis ist Preis je Basis (UNIPPS-Feld Basis) und Preismengeneinheit PME
//  //  unrabbatierter Preis je Preismengeneinheit
//  var preis : double;
//  preis := Qry.FieldByName('preis').AsFloat / Qry.FieldByName('basis').AsFloat;
//
//  // Preis je Bestellmengeneinheit
//  preis := preis * Qry.FieldByName('faktbme_pme').AsFloat;
//
//  // Preis je Lagermengeneinheit
//  Result := preis * Qry.FieldByName('faktlme_bme').AsFloat;
//
//end;

function TZTeil.ToStr():String;
  var trenn :String;
begin
    trenn:= ' ; ';
    ToStr:= t_tg_nr
    + trenn + intToStr(oa)
    + trenn + intToStr(besch_art)
    + trenn + intToStr(praeferenzkennung)
    + trenn + unipps_typ
    + trenn + intToStr(sme)
    + trenn + intToStr(lme)
    + trenn + FloatToStr(faktlme_sme)
    + trenn + Bezeichnung
    + trenn + FloatToStr(PreisJeLME)
    ;

end;

end.
