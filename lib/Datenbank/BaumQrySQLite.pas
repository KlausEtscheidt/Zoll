//Abfragen fuer SQLite Datenbank über TFDQuery
{Anwendungsbeispiel:
  Abfrage zum Lesen des Kundenauftrags und seiner Positionen
  KAQry := DBConn.getQuery;
  gefunden := KAQry.SucheKundenAuftragspositionen(ka_id);

  mit DBConn.getQuery wird die Abfrage,
  d.h. eine Instanz dieser Klasse TWQryUNIPPS erzeugt.
  TWQrySQLite.SucheKundenAuftragspositionen füllt sie
  mit einem geeigneten SQL und führt sie aus.

}

unit BaumQrySQLite;

interface

  uses System.SysUtils, System.Classes, ADOQuery;

  type
    TWBaumQrySQLite = class(TWADOQuery)
      function SucheKundenAuftragspositionen(ka_id:string):Boolean;
      function SucheFAzuKAPos(KaId:String; id_pos:Integer): Boolean;
      function SucheFAzuTeil(t_tg_nr:String): Boolean;
      function SuchePosZuFA(FA_Nr:String): Boolean;
      function SucheStuelizuTeil(t_tg_nr:String): Boolean;

      function SucheDatenzumTeil(t_tg_nr:string):Boolean;
      function SucheBenennungZuTeil(t_tg_nr:String): Boolean;
      function SucheLetzte3Bestellungen(t_tg_nr:string): Boolean;
      function SucheKundenRabatt(ka_id:string):Boolean;
    end;

implementation

//---------------------------------------------------------------------------
// Struktur-Aufbau: Suche Stueli-Positionen
//---------------------------------------------------------------------------

// Kunden-Auftrags-Positionen
//---------------------------------------------------------------------------
function TWBaumQrySQLite.SucheKundenAuftragspositionen(ka_id:string):Boolean;
begin
  var sql: String;
  sql := 'select id_stu, id_pos, kunde, besch_art, klassifiz, pos_nr, '
      +  't_tg_nr as stu_t_tg_nr, '
      +  'oa  as stu_oa, unipps_typ as stu_unipps_typ, menge, preis '
      +  'from auftragkopf where id_stu like "' + ka_id + '" order by id_pos;';
  Result:= RunSelectQuery(sql);
end;

// Fertigungs-Aufrag (FA) zu Kunden-Auftrags-Positionen (Kommissions-FA)
//---------------------------------------------------------------------------
function TWBaumQrySQLite.SucheFAzuKAPos(KaId:String; id_pos:Integer): Boolean;
begin
  var sql: String;
  sql:= 'SELECT id_stu, pos_nr, auftragsart, verurs_art, '
      + 't_tg_nr as stu_t_tg_nr, oa as stu_oa, '
      + 'unipps_typ as stu_unipps_typ, FA_Nr '
      + 'FROM f_auftragkopf where id_stu = ? and pos_nr= ? '
      + 'and oa<9 ORDER BY FA_Nr';
  Result:= RunSelectQueryWithParam(sql,[KaId,IntToStr(id_pos)]);

end;

// Fertigungs-Aufrag (FA) zu einer Teile-Nummer (Serien-FA)
//---------------------------------------------------------------------------
function TWBaumQrySQLite.SucheFAzuTeil(t_tg_nr:String): Boolean;
begin
  var sql: String;
  sql:= 'SELECT t_tg_nr as id_stu, 1 as pos_nr, auftragsart, verurs_art, '
      + 't_tg_nr as stu_t_tg_nr, oa as stu_oa, '
      + 'unipps_typ as stu_unipps_typ, FA_Nr '
      + 'FROM f_auftragkopf '
      + 'Where t_tg_nr= ? and oa<9 ORDER BY FA_Nr desc limit 1';
  Result:= RunSelectQueryWithParam(sql,[t_tg_nr]);

end;

//Suche alle Positionen zu einem FA (ASTUELIPOS)
function TWBaumQrySQLite.SuchePosZuFA(FA_Nr:String): Boolean;
begin
  var sql: String;
  sql:= 'SELECT id_stu, id_pos, '
      + 'ueb_s_nr, ds, set_block, pos_nr, t_tg_nr as stu_t_tg_nr, '
      + 'oa as stu_oa, unipps_typ as stu_unipps_typ, menge '
      + 'FROM astuelipos where id_stu = ? '
      + 'and oa<9 ORDER BY pos_nr';
  Result:= RunSelectQueryWithParam(sql,[FA_Nr]);

end;

// Suche Stueckliste zu einem Teil (Objekt TeilAlsStuPos wird hieraus erzeugt)
//---------------------------------------------------------------------------
function TWBaumQrySQLite.SucheStuelizuTeil(t_tg_nr:String): Boolean;
begin
  var sql: String;
  //####################################
  sql:= 'SELECT id_stu, pos_nr, t_tg_nr as stu_t_tg_nr, oa as stu_oa, '
      + 'unipps_typ as stu_unipps_typ, menge '
      + 'FROM teil_stuelipos where id_stu= ? '
      + 'ORDER BY pos_nr ;';
  Result:= RunSelectQueryWithParam(sql,[t_tg_nr]);
end;

//---------------------------------------------------------------------------
// Suche Zusatz-Infos
//---------------------------------------------------------------------------


// Suche Daten zu einem Teil (Objekt Teil wird hieraus erzeugt)
//---------------------------------------------------------------------------
function TWBaumQrySQLite.SucheDatenzumTeil(t_tg_nr:string):Boolean;
begin
  var sql: String;
  sql:= 'SELECT t_tg_nr, oa, besch_art as v_besch_art, unipps_typ, '
      + 'praeferenzkennung, sme, faktlme_sme, lme '
      + 'FROM teil where t_tg_nr = (?) and oa<9;';
  Result:= RunSelectQueryWithParam(sql,[t_tg_nr]);
end;

// Suche Benennung zu einem Teil (wird Objekt Teil zugefuegt)
//---------------------------------------------------------------------------
function TWBaumQrySQLite.SucheBenennungZuTeil(t_tg_nr:String): Boolean;
begin
  var sql: String;
  sql:= 'SELECT teil_bez_id, Bezeichnung '
      + 'FROM teil_bez where teil_bez_id= ? ;' ;
  Result:= RunSelectQueryWithParam(sql,[t_tg_nr]);
end;

// Suche letzte 3 Bestellungen zu einem Teil um Preis zu bestimmen
//(Objekt Bestellung wird hieraus erzeugt)
//---------------------------------------------------------------------------
function TWBaumQrySQLite.SucheLetzte3Bestellungen(t_tg_nr:string): Boolean;
begin
  var sql: String;
  sql:= 'SELECT bestell_id, bestell_datum, preis, basis, pme, bme, '
      + 'faktlme_bme, faktbme_pme, netto_poswert, menge as best_menge, '
      + 'we_menge, lieferant, kurzname, t_tg_nr as best_t_tg_nr '
      + 'FROM bestellungen where t_tg_nr = ? '
      + 'order by bestell_datum desc limit 3;';
  Result:= RunSelectQueryWithParam(sql,[t_tg_nr]);
end;

// Suche Rabatt zu einem Kunden (wird an Kundenauftrags-Pos angefuegt)
//---------------------------------------------------------------------------
function TWBaumQrySQLite.SucheKundenRabatt(ka_id:string):Boolean;
begin
  var sql: String;
  sql := 'select kunden_id, zu_ab_proz, datum_von, datum_bis '
       + 'from kunde_zuab where kunden_id = "' + ka_id + '";';
  Result:= RunSelectQuery(sql);
end;


end.
