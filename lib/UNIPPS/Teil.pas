﻿unit Teil;

interface

uses  System.SysUtils, Data.Db,  Bestellung,
      Exceptions,
      StueliEigenschaften, Tools;

type
  TWTeil = class
  private
    class var FFilter:TWFilter; //Filter zur Ausgabe der Eigenschaften
    function BerechnePreisJeLMERabattiert(Qry: TWUNIPPSQry): Double;
//    function BerechnePreisJeLMEUnrabattiert(Qry: TWQry): Double;
    function GetDruckDaten:TWWertliste;
    function GetDruckDatenAuswahl:TWWertliste;
  public
    TeilTeilenummer: String; //= t_tg_nr
    Ausgabe:TWEigenschaften;

    PreisGesucht: Boolean;
    PreisErmittelt: Boolean;
    Bestellung: TWBestellung;
    PreisJeLME: Double;

    istKaufteil:Boolean;
    istEigenfertigung:Boolean;
    istFremdfertigung:Boolean;

    constructor Create(TeileQry: TWUNIPPSQry);
    procedure holeBenennung;
    procedure holeMaxPreisAus3Bestellungen;
    function StueliPosGesamtPreis(menge:Double; faktlme_sme:Double) :Double;
    function ToStr():String;
    property DruckDaten:TWWertliste read GetDruckDaten;
    property DruckDatenAuswahl:TWWertliste read GetDruckDatenAuswahl;
    class property Filter:TWFilter read FFilter write FFilter;

  end;

implementation

constructor TWTeil.Create(TeileQry: TWUNIPPSQry);
{UNIPPS-Mapping
  teil_uw.t_tg_nr, teil_uw.oa, teil_uw.v_besch_art besch_art, '
  teil.typ as unipps_typ, teil.praeferenzkennung, teil.sme,
  teil.faktlme_sme, teil.lme
}
var
  besch_art:String;
begin
  try
    //Alle Daten in Ausgabespeicher
    Ausgabe:=TWEigenschaften.Create(TeileQry.Fields);

    //Einige wichtige Daten direkt in Felder
    TeilTeilenummer:=Ausgabe['t_tg_nr'];

    //Daten, die im weiteren Ablauf ermittelt werden
    Bestellung:=nil;
    PreisJeLME:=0;
    PreisGesucht:= False;
    PreisErmittelt:= False;

    besch_art:=Ausgabe['besch_art'];
    istKaufteil:= (besch_art ='1');
    istEigenfertigung:=(besch_art ='2');
    istFremdfertigung:=(besch_art ='4');

    if not (istKaufteil or istEigenfertigung or istFremdfertigung) then
      raise EStuBaumTeileErr.Create('Unzulässige Beschaffungsart >'
      + besch_art + '< in >TWTeil.Create<');

    holeBenennung;
  { TODO : Preise für Kaufteile in eigenem Lauf  oder konfiguriert ?? }
   if istKaufteil then
        holeMaxPreisAus3Bestellungen;

  except
   on EDatabaseError do
      Tools.ErrLog.Log('Fehler');
  else
      raise;
  end;

end;

function TWTeil.GetDruckDatenAuswahl:TWWertliste;
var
Werte, WerteBestellung: TWWertliste;
begin
  if length(Filter)=0 then
    //Alle ausgeben
    Werte:=Ausgabe.Wertliste()
  else
    //gefiltert ausgeben
    Werte:=Ausgabe.Wertliste(Filter);

  //Evtl Daten aus Bestellung dazu
//  WerteBestellung:=TWWertliste.Create;
  if PreisErmittelt Then
  begin
    WerteBestellung:=Bestellung.DruckDatenAuswahl;
    Werte.AddRange(WerteBestellung);
  end;

  Result:= Werte;

end;

//Alle ausgeben
function TWTeil.GetDruckDaten:TWWertliste;
begin

  Result:=Ausgabe.Wertliste();

  //Evtl Daten aus Bestellung dazu
  if PreisErmittelt Then
    Result.AddRange(Bestellung.DruckDatenAuswahl);

end;


procedure TWTeil.holeBenennung;
  var Qry: TWUNIPPSQry;
begin
  Qry:=Tools.getQuery();
  if Qry.SucheBenennungZuTeil(TeilTeilenummer) then
    Ausgabe.AddData('Bezeichnung',Qry.Fields);
  Qry.Free;
end;


procedure TWTeil.holeMaxPreisAus3Bestellungen;
  var gefunden: Boolean;
  var Qry: TWUNIPPSQry;
  var maxPreis:Double;
  var maxFields:TFields;

begin

  if not istKaufteil then
    exit;

  Qry:=Tools.getQuery();

    PreisGesucht:= True;
    gefunden:=Qry.SucheLetzte3Bestellungen(TeilTeilenummer);

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
    Ausgabe.AddData('PreisJeLME', FloatToStr(PreisJeLME));

    //Übertrage gemerkten Datensatz in Ojekt
    Bestellung := TWBestellung.Create(maxFields);

    Qry.Free;

end;

function TWTeil.BerechnePreisJeLMERabattiert(Qry: TWUNIPPSQry): Double;
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


//function TWTeil.BerechnePreisJeLMEUnrabattiert(Qry: TWQry): Double;
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

// Gesamt-Preis einer Stuecklistenposition
// aus Menge und Preis je Lagermengeeinheit berechnen
function TWTeil.StueliPosGesamtPreis(menge: Double;
                            faktlme_sme: Double) : Double;
{Beipiel
 SME=mm
 LME=m
 Preis je Liefermengeneinheit=10,35 EUR/m
 faktlme_sme=1000 [mm/m];  1000 SME [mm] ergeben eine LME  [m]

 Preis je Stuecklistenmengeneinheit ist:
       Preis je Lagermengeeinheit "Preis_je_LME" geteilt durch faktlme_sme
 Preis_je_SME also 10,35 EUR/m (Preis_je_LME) / (1000 mm/m) = 0,01035 EUR/mm
}
begin
  Result:= PreisJeLME / faktlme_sme;
  Result:= Result * menge;
end;



function TWTeil.ToStr():String;
begin
  Result:=Self.Ausgabe.ToCsv(Self.DruckDaten);
end;

end.
