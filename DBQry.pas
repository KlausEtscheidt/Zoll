unit DBQry;

interface

  uses System.Classes,FireDAC.Comp.Client;

  type
    TZQry = class(TFDQuery)
      constructor Create(AOwner: TComponent;conn : TFDConnection);
      function SucheKundenRabatt(ka_id:string):Boolean;
      function SucheKundenAuftragspositionen(ka_id:string):Boolean;
      function SucheDatenzumTeil(t_tg_nr:string):Boolean;
      function SucheLetzte3Bestellungen(t_tg_nr:string): Boolean;
      function query(sql:string):Boolean;
    public
      { Public-Deklarationen }
        n_records: Integer;
        gefunden: Boolean;
    end;


implementation


constructor TZQry.Create(AOwner: TComponent;conn : TFDConnection);

begin
  inherited Create(AOwner);
  Connection:=conn;
  n_records:=0;
  gefunden:=False;
end;

function TZQry.SucheKundenAuftragspositionen(ka_id:string):Boolean;
begin
  var sql: String;
  {siehe Access Abfrage "b_hole_KAPositionen"
   sql = "SELECT auftragpos.ident_nr1 as id_stu, auftragpos.ident_nr2 as id_pos, auftragkopf.kunde, auftragpos.besch_art, auftragkopf.klassifiz, auftragpos.pos as pos_nr, " _
    & "auftragpos.t_tg_nr, auftragpos.oa, auftragpos.typ, auftragpos.menge, auftragpos.preis " _
    & "FROM auftragkopf INNER JOIN auftragpos ON auftragkopf.ident_nr = auftragpos.ident_nr1 " _
    & "WHERE auftragpos.ident_nr1 = """ & ka_id & """ "
  }
  sql := 'select id_stu, id_pos, kunde, besch_art, klassifiz, pos_nr, t_tg_nr, '
      +  'oa, typ, menge, preis '
      +  'from auftragkopf where id_stu = "' + ka_id + '";';
  Result:= query(sql);

end;

function TZQry.SucheKundenRabatt(ka_id:string):Boolean;
begin
  var sql: String;
  {siehe Access Abfrage "b_hole_Rabatt_zum_Kunden"
    sql = "SELECT ident_nr1 as kunden_id, zu_ab_proz, datum_von, datum_bis " _
        & "FROM kunde_zuab " _
        & "WHERE ident_nr1 = """ & kunden_id & """ AND datum_von<=" & heute_datum_str _
                 & " AND datum_bis>" & heute_datum_str & " ; "

  }
  sql := 'select kunden_id, zu_ab_proz, datum_von, datum_bis '
       + 'from kunde_zuab where kunden_id = "' + ka_id + '";';
  Result:= query(sql);

end;

function TZQry.SucheDatenzumTeil(t_tg_nr:string):Boolean;
{siehe Access Abfrage "b_hole_Daten_zu Teil"
sql = "SELECT teil_uw.t_tg_nr, teil_uw.oa, " _
    & "teil_uw.v_besch_art as besch_art, teil.typ, teil.urspr_land,
       teil.ausl_u_land,
       teil.praeferenzkennung, " _
    & "teil.sme, teil.faktlme_sme, teil.lme " _
    & "FROM teil INNER JOIN teil_uw ON teil.ident_nr = teil_uw.t_tg_nr AND teil.art = teil_uw.oa " _
    & "Where teil_uw.t_tg_nr=""" & t_tg_nr _
    & """ and teil_uw.oa<9 AND teil_uw.uw=1; "

    create Table teil (t_tg_nr text, oa integer, besch_art integer,
     typ text, urspr_land integer, ausl_u_land integer, praeferenzkennung integer,
      sme integer, faktlme_sme double, lme integer)
}

begin
  var sql: String;
  sql:= 'SELECT t_tg_nr, oa, besch_art, typ, praeferenzkennung, '
      + 'sme, faktlme_sme, lme '
      + 'FROM teil where t_tg_nr = "' + t_tg_nr + '" and oa<9;';
  Result:= query(sql);
end;

function TZQry.SucheLetzte3Bestellungen(t_tg_nr:string): Boolean;
{siehe Access Abfrage "b_Bestelldaten"
    'Suche �ber unipps_bestellpos.t_tg_nr=t_tg_nr; bestellkopf.datum muss aus der Unterabfrage hervorgehen (neuestes Datum)
    sql = "SELECT first 3 bestellkopf.ident_nr as bestell_id, bestellkopf.datum as bestell_datum, bestellpos.preis, bestellpos.basis, bestellpos.pme, bestellpos.bme, " _
        & "bestellpos.faktlme_bme, bestellpos.faktbme_pme, bestellpos.netto_poswert, bestellpos.menge, bestellpos.we_menge, " _
        & "bestellkopf.lieferant, adresse.kurzname, bestellpos.t_tg_nr " _
        & "FROM bestellpos INNER JOIN bestellkopf ON bestellpos.ident_nr1 = bestellkopf.ident_nr " _
        & "JOIN adresse ON bestellkopf.lieferant = adresse.ident_nr " _
        & "WHERE bestellpos.t_tg_nr=""" & t_tg_nr$ & """ order by bestellkopf.datum desc ;"

          bestell_id, bestell_datum, preis, basis, pme, bme,
          faktlme_bme, faktbme_pme, netto_poswert, menge,
          we_menge, lieferant, kurzname, t_tg_nr

}
begin
  var sql: String;
  sql:= 'SELECT bestell_id, bestell_datum, preis, basis, pme, bme, '
      + 'faktlme_bme, faktbme_pme, netto_poswert, menge, '
      + 'we_menge, lieferant, kurzname, t_tg_nr '
      + 'FROM bestellungen where t_tg_nr = "' + t_tg_nr
      + '" order by bestell_datum desc limit 3;';
  Result:= query(sql);

end;

function TZQry.query(sql:string):Boolean;
begin
  Open(sql);
  n_records:=RowsAffected;
  gefunden:=n_records>0;
  Result:= gefunden;
end;


end.
