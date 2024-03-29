﻿unit Teil;

interface

uses  System.SysUtils, Data.Db,  Bestellung,
      PumpenDataSet, Datenmodul, Tools;

type
    EWTeil = class(Exception);

type
  TWTeil = class
  private
    function BerechnePreisJeLMERabattiert(Qry: TWUNIPPSQry): Double;
//    function BerechnePreisJeLMEUnrabattiert(Qry: TWQry): Double;

  public
    //aus UNIPPS
    TeileNr: String; //= t_tg_nr
    OA: Integer;
    UnippsTyp: String;
    Bezeichnung:String;
    BeschaffungsArt: Integer;
    Praeferenzkennung: Integer;
    Sme: Integer;
    FaktorLmeSme: Double;
    Lme: Integer;

    //Berechnet, nicht zum Ausgeben
    PreisGesucht: Boolean;
    PreisErmittelt: Boolean;
    Bestellung: TWBestellung;

    IstPraeferenzberechtigt:Boolean;
    IstKaufteil:Boolean;
    IstEigenfertigung:Boolean;
    IstFremdfertigung:Boolean;

    //Berechnet, zum Ausgeben
    PreisJeLME: Double;

    constructor Create(TeileQry: TWUNIPPSQry);
    procedure holeBenennung;
    procedure holeMaxPreisAus3Bestellungen;
    function StueliPosGesamtPreis(menge:Double; faktlme_sme:Double) :Double;
    function ToStr():String;
    procedure DatenInAusgabe(ZielDS:TWDataSet);

  end;

implementation

constructor TWTeil.Create(TeileQry: TWUNIPPSQry);
{UNIPPS-Mapping
  teil_uw.t_tg_nr, teil_uw.oa, teil_uw.v_besch_art besch_art, '
  teil.typ as unipps_typ, teil.praeferenzkennung, teil.sme,
  teil.faktlme_sme, teil.lme
}
//var
//  besch_art:String;
begin
  try

    //Daten aus UNIPPS-Abfrage in Felder
    TeileNr:=TeileQry.FieldByName('t_tg_nr').AsString;
    OA:=TeileQry.FieldByName('oa').AsInteger;
    UnippsTyp:=TeileQry.FieldByName('unipps_typ').AsString;
//    Bezeichnung:=TeileQry.FieldByName('Bezeichnung').AsString;
    BeschaffungsArt:=TeileQry.FieldByName('v_besch_art').AsInteger;
    Praeferenzkennung:=TeileQry.FieldByName('praeferenzkennung').AsInteger;
    Sme:=TeileQry.FieldByName('sme').AsInteger;
    FaktorLmeSme:=TeileQry.FieldByName('faktlme_sme').AsFloat;
    Lme:=TeileQry.FieldByName('lme').AsInteger;

    IstPraeferenzberechtigt:= (Praeferenzkennung=1);

    //Daten, die im weiteren Ablauf ermittelt werden
    Bestellung:=nil;
    PreisJeLME:=0;
    PreisGesucht:= False;
    PreisErmittelt:= False;

    istKaufteil:= (BeschaffungsArt =1);
    istEigenfertigung:=(BeschaffungsArt =2);
    istFremdfertigung:=(BeschaffungsArt =4);

    if not (istKaufteil or istEigenfertigung or istFremdfertigung) then
      raise EWTeil.Create('Unzulässige Beschaffungsart >'
      + IntToSTr(BeschaffungsArt) + '< in >TWTeil.Create<');

    holeBenennung;
  { TODO : Preise für Kaufteile in eigenem Lauf  oder konfiguriert ?? }
   if istKaufteil or istFremdfertigung then
        holeMaxPreisAus3Bestellungen;

  except
   on EDatabaseError do
      Tools.ErrLog.Log('Fehler');
  else
      raise;
  end;

end;


procedure TWTeil.holeBenennung;
  var Qry: TWUNIPPSQry;
begin
  Qry:=Tools.getQuery();
  if Qry.SucheBenennungZuTeil(TeileNr) then
    Bezeichnung:=Qry.Fields.FieldByName('Bezeichnung').AsString;
  Qry.Free;
end;


procedure TWTeil.holeMaxPreisAus3Bestellungen;
  var gefunden: Boolean;
  var Qry: TWUNIPPSQry;
  var Preis,maxPreis:Double;
  var Merker:TBookmark;
  var msg:String;

begin

  if not (istKaufteil or istFremdfertigung) then
    exit;

  Qry:=Tools.getQuery();

    PreisGesucht:= True;
    gefunden:=Qry.SucheLetzte3Bestellungen(TeileNr);

    if not gefunden then
    begin
        //Fehler ausgeben
        msg:= 'Keine Bestellungen zu Teil >' + TeileNr + '< gefunden.';
        Tools.ErrLog.Log(msg);
        Tools.Log.Log(msg);
//        raise EWTeil.Create(msg);
        exit;
    end;

    maxPreis:=0;

    while not Qry.Eof do
    begin
//      Tools.Log.Log(Qry.GetFieldValuesAsText);
      Preis:=BerechnePreisJeLMERabattiert(Qry);
      If Preis > maxPreis Then
      begin
            //Datensatz und Preis merken
            maxPreis := Preis;
            Merker:=Qry.GetBookmark;
      end;

      Qry.next;
    end;

    PreisErmittelt:= True;
    //Eregbnis in Ausgabespeicher und als Objekt-Feld
    PreisJeLME:=maxPreis;

    //Übertrage gemerkten Datensatz in Ojekt
    Qry.GotoBookmark(Merker);
    Tools.Log.Log('Preis zu Teil: ' + TeileNr + '=' +
                       FloatToSTr(PreisJeLME) + Qry.GetFieldValuesAsText);
    Bestellung := TWBestellung.Create(Qry.Fields);

    Qry.Free;

end;

function TWTeil.BerechnePreisJeLMERabattiert(Qry: TWUNIPPSQry): Double;
begin
  {s. auch Erklärungen in BerechnePreisJeLMEUnrabattiert
    Wert der Bestellpos ohne Rabatte:
    wert = Preis_je_BME * Bestellmenge
    => analog
    Wert der Bestellpos mit Rabatt:
    wert = UNIPPS("netto_poswert")= Preis_je_BME_netto * Bestellmenge
    also: Preis_je_BME_netto = netto_poswert /  Bestellmenge
  }
  var preis : double;
  preis := Qry.FieldByName('netto_poswert').AsFloat / Qry.FieldByName('best_menge').AsFloat;

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

procedure TWTeil.DatenInAusgabe(ZielDS:TWDataSet);

begin
  //ZielDS.Append;
  ZielDS.AddValue('t_tg_nr',TeileNr);
  ZielDS.AddValue('oa',OA);
  ZielDS.AddValue('unipps_typ',UnippsTyp);
  ZielDS.AddValue('Bezeichnung',Bezeichnung);
  ZielDS.AddValue('v_besch_art',BeschaffungsArt);
  ZielDS.AddValue('praeferenzkennung',Praeferenzkennung);
  ZielDS.AddValue('sme',Sme);
  ZielDS.AddValue('faktlme_sme',FaktorLmeSme);
  ZielDS.AddValue('lme',Lme);
  ZielDS.AddValue('PreisJeLme',PreisJeLme);
  if PreisErmittelt Then
    Bestellung.DatenInAusgabe(ZielDS);

  //ZielDS.Post;
end;

function TWTeil.ToStr():String;
begin
  Result:='Teil:' + TeileNr + ' ' + Bezeichnung + ' Preis: '
      + FloatToStr(PreisJeLme);
end;

end.
