//Abfragen fuer SQLite Datenbank
unit DBQryUNIPPS;

interface

  uses System.SysUtils,System.Classes,Data.Win.ADODB;

  type
    TZQryUNIPPS = class(TADOQuery)
      constructor Create(AOwner: TComponent;conn : TADOConnection);
      function SucheKundenRabatt(ka_id:string):Boolean;
      function SucheKundenAuftragspositionen(ka_id:string):Boolean;
      function SucheDatenzumTeil(t_tg_nr:string):Boolean;
      function SucheLetzte3Bestellungen(t_tg_nr:string): Boolean;
      function SucheFAzuKAPos(id_stu:String; id_pos:String): Boolean;
      function query(sqlqry:String):Boolean;
    public
      { Public-Deklarationen }
        n_records: Integer;
        gefunden: Boolean;
    end;


implementation


constructor TZQryUNIPPS.Create(AOwner: TComponent;conn : TADOConnection);

begin
  inherited Create(AOwner);
  Connection:=conn;
  n_records:=0;
  gefunden:=False;
end;

function TZQryUNIPPS.SucheKundenAuftragspositionen(ka_id:string):Boolean;
begin
  var sql: String;
  {siehe Access Abfrage "b_hole_KAPositionen"
   sql = "SELECT auftragpos.ident_nr1 as id_stu, auftragpos.ident_nr2 as id_pos, auftragkopf.kunde,
     auftragpos.besch_art, auftragkopf.klassifiz, auftragpos.pos as pos_nr, " _
    & "auftragpos.t_tg_nr, auftragpos.oa, auftragpos.typ, auftragpos.menge, auftragpos.preis " _
    & "FROM auftragkopf INNER JOIN auftragpos ON auftragkopf.ident_nr = auftragpos.ident_nr1 " _
    & "WHERE auftragpos.ident_nr1 = """ & ka_id & """ "
  }
  sql := 'select auftragpos.ident_nr1 as id_stu, auftragpos.ident_nr2 as id_pos, '
      +  ' auftragkopf.kunde, auftragpos.besch_art, '
      +  ' auftragkopf.klassifiz, auftragpos.pos as pos_nr, auftragpos.t_tg_nr, '
      +  'auftragpos.oa, auftragpos.typ, auftragpos.menge, auftragpos.preis '
      +  'from auftragkopf INNER JOIN auftragpos ON auftragkopf.ident_nr = auftragpos.ident_nr1 '
      +  'where auftragpos.ident_nr1 = "' + ka_id + '" order by id_pos;';
  Result:= query(sql);

end;

function TZQryUNIPPS.SucheKundenRabatt(ka_id:string):Boolean;
begin
  var sql: String;
  {siehe Access Abfrage "b_hole_Rabatt_zum_Kunden"
    sql = "SELECT ident_nr1 as kunden_id, zu_ab_proz, datum_von, datum_bis " _
        & "FROM kunde_zuab " _
        & "WHERE ident_nr1 = """ & kunden_id & """ AND datum_von<=" & heute_datum_str _
                 & " AND datum_bis>" & heute_datum_str & " ; "

  }
  sql := 'select ident_nr1 as kunden_id, zu_ab_proz, datum_von, datum_bis '
       + 'from kunde_zuab where ident_nr1 = "' + ka_id + '";';
  Result:= query(sql);

end;

function TZQryUNIPPS.SucheDatenzumTeil(t_tg_nr:string):Boolean;
{siehe Access Abfrage "b_hole_Daten_zu Teil"
sql = "SELECT teil_uw.t_tg_nr, teil_uw.oa, " _
    & "teil_uw.v_besch_art as besch_art, teil.typ, teil.urspr_land,
       teil.ausl_u_land,
       teil.praeferenzkennung, " _
    & "teil.sme, teil.faktlme_sme, teil.lme " _
    & "FROM teil INNER JOIN teil_uw ON teil.ident_nr = teil_uw.t_tg_nr AND teil.art = teil_uw.oa " _
    & "Where teil_uw.t_tg_nr=""" & t_tg_nr _
    & """ and teil_uw.oa<9 AND teil_uw.uw=1; "

}

begin
  var sql: String;
  sql:= 'SELECT teil_uw.t_tg_nr, teil_uw.oa, teil_uw.v_besch_art besch_art, teil.typ, '
      + 'teil.praeferenzkennung, teil.sme, teil.faktlme_sme, teil.lme '
      + 'FROM teil INNER JOIN teil_uw ON teil.ident_nr = teil_uw.t_tg_nr AND teil.art = teil_uw.oa '
      + 'where teil_uw.t_tg_nr = "' + t_tg_nr + '" and teil_uw.oa<9 and teil_uw.uw=1;';
  Result:= query(sql);
end;

function TZQryUNIPPS.SucheLetzte3Bestellungen(t_tg_nr:string): Boolean;
{siehe Access Abfrage "b_Bestelldaten"
    'Suche �ber unipps_bestellpos.t_tg_nr=t_tg_nr; bestellkopf.datum muss aus der Unterabfrage hervorgehen (neuestes Datum)
    sql = "SELECT first 3 bestellkopf.ident_nr as bestell_id, bestellkopf.datum as bestell_datum,
           bestellpos.preis, bestellpos.basis, bestellpos.pme, bestellpos.bme, _
           bestellpos.faktlme_bme, bestellpos.faktbme_pme, bestellpos.netto_poswert, bestellpos.menge,
           bestellpos.we_menge, bestellkopf.lieferant, adresse.kurzname, bestellpos.t_tg_nr " _
        & "FROM bestellpos INNER JOIN bestellkopf ON bestellpos.ident_nr1 = bestellkopf.ident_nr " _
        & "JOIN adresse ON bestellkopf.lieferant = adresse.ident_nr " _
        & "WHERE bestellpos.t_tg_nr=""" & t_tg_nr$ & """ order by bestellkopf.datum desc ;"

          bestell_id, bestell_datum, preis, basis, pme, bme,
          faktlme_bme, faktbme_pme, netto_poswert, menge,
          we_menge, lieferant, kurzname, t_tg_nr

}

begin
  var sql: String;
  sql:= 'SELECT first 3 bestellkopf.ident_nr as bestell_id, bestellkopf.datum as bestell_datum, '
      + 'bestellpos.preis, bestellpos.basis, bestellpos.pme, bestellpos.bme, '
      + 'bestellpos.faktlme_bme, bestellpos.faktbme_pme, bestellpos.netto_poswert, bestellpos.menge,  '
      + 'bestellpos.we_menge,bestellkopf.lieferant, adresse.kurzname, bestellpos.t_tg_nr '
      + 'FROM bestellpos INNER JOIN bestellkopf ON bestellpos.ident_nr1 = bestellkopf.ident_nr '
      + 'JOIN adresse ON bestellkopf.lieferant = adresse.ident_nr '
      + 'WHERE bestellpos.t_tg_nr="' + t_tg_nr + '" order by bestellkopf.datum desc ;';
  Result:= query(sql);

end;

function TZQryUNIPPS.SucheFAzuKAPos(id_stu:String; id_pos:String): Boolean;
{siehe Access Abfrage "a_FA_Kopf_zu_KAPos_mit_Teileinfo"
 Suche ueber f_auftragkopf.auftr_nr=KA_id (Id des Kundenauftrages) und f_auftragkopf.auftr_pos=pos_id
    sql = "SELECT f_auftragkopf.auftr_nr as id_stu, f_auftragkopf.auftr_pos as pos_nr, f_auftragkopf.auftragsart,
           f_auftragkopf.verurs_art, f_auftragkopf.t_tg_nr, f_auftragkopf.oa, f_auftragkopf.typ
           f_auftragkopf.ident_nr as id_FA " _
           FROM f_auftragkopf " _
           where f_auftragkopf.auftr_nr=" & id_stu & " and f_auftragkopf.auftr_pos=" & id_pos _
           and f_auftragkopf.oa<9 ORDER BY id_FA;"
}
begin
  var sql: String;
  sql:= 'SELECT f_auftragkopf.auftr_nr as id_stu, f_auftragkopf.auftr_pos as pos_nr, f_auftragkopf.auftragsart, '
      + 'f_auftragkopf.verurs_art, f_auftragkopf.t_tg_nr, f_auftragkopf.oa, f_auftragkopf.typ, '
      + 'f_auftragkopf.ident_nr as id_FA '
      + 'FROM f_auftragkopf '
      + 'Where f_auftragkopf.auftr_nr=' + id_stu + ' and f_auftragkopf.auftr_pos=' + id_pos
      + ' and f_auftragkopf.oa<9 ORDER BY id_FA';
  Result:= query(sql);

end;

function TZQryUNIPPS.query(sqlqry:String):Boolean;
begin

  SQL.Add(sqlqry);
  Open;
  n_records:=GetRecordCount;
  gefunden:=n_records>0;
  Result:= gefunden;
end;


end.
