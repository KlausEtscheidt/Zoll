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
      function SucheKundenRabatt(ka_id:string):Boolean;
      function SucheKundenAuftragspositionen(ka_id:string):Boolean;
      function SucheDatenzumTeil(t_tg_nr:string):Boolean;
      function SucheLetzte3Bestellungen(t_tg_nr:string): Boolean;
      function SucheFAzuKAPos(KaId:String; id_pos:Integer): Boolean;
      function SucheFAzuTeil(t_tg_nr:String): Boolean;
      function SucheBenennungZuTeil(t_tg_nr:String): Boolean;
      function SucheStuelizuTeil(t_tg_nr:String): Boolean;
      function SuchePosZuFA(FA_Nr:String): Boolean;
    end;

implementation

function TWBaumQrySQLite.SucheKundenAuftragspositionen(ka_id:string):Boolean;
begin
  var sql: String;
  sql := 'select id_stu, id_pos, kunde, besch_art, klassifiz, pos_nr, t_tg_nr, '
      +  'oa, typ, menge, preis '
      +  'from auftragkopf where id_stu = "' + ka_id + '"order by id_pos;';
  Result:= RunSelectQuery(sql);
end;

function TWBaumQrySQLite.SucheKundenRabatt(ka_id:string):Boolean;
begin
  var sql: String;
  sql := 'select kunden_id, zu_ab_proz, datum_von, datum_bis '
       + 'from kunde_zuab where kunden_id = "' + ka_id + '";';
  Result:= RunSelectQuery(sql);
end;

function TWBaumQrySQLite.SucheDatenzumTeil(t_tg_nr:string):Boolean;
begin
  var sql: String;
  sql:= 'SELECT t_tg_nr, oa, besch_art, typ as unipps_typ, praeferenzkennung, '
      + 'sme, faktlme_sme, lme '
      + 'FROM teil where t_tg_nr = "' + t_tg_nr + '" and oa<9;';
  Result:= RunSelectQuery(sql);
end;

function TWBaumQrySQLite.SucheLetzte3Bestellungen(t_tg_nr:string): Boolean;
begin
  var sql: String;
  sql:= 'SELECT bestell_id, bestell_datum, preis, basis, pme, bme, '
      + 'faktlme_bme, faktbme_pme, netto_poswert, menge, '
      + 'we_menge, lieferant, kurzname, t_tg_nr '
      + 'FROM bestellungen where t_tg_nr = "' + t_tg_nr
      + '" order by bestell_datum desc limit 3;';
  Result:= RunSelectQuery(sql);
end;

function TWBaumQrySQLite.SucheBenennungZuTeil(t_tg_nr:String): Boolean;
begin
  var sql: String;
  sql:= 'SELECT teil_bez_id, Bezeichnung '
      + 'FROM teil_bez where teil_bez_id="' + t_tg_nr + '" ;' ;
  Result:= RunSelectQuery(sql);
end;

function TWBaumQrySQLite.SucheStuelizuTeil(t_tg_nr:String): Boolean;
begin
  var sql: String;
  sql:= 'SELECT id_stu, pos_nr, t_tg_nr, oa, typ as typ, menge '
      + 'FROM teil_stuelipos where id_stu="' + t_tg_nr
      + '" ORDER BY pos_nr ;';
  Result:= RunSelectQuery(sql);
end;

function TWBaumQrySQLite.SucheFAzuKAPos(KaId:String; id_pos:Integer): Boolean;
begin
  var sql: String;
  sql:= 'SELECT id_stu, pos_nr, auftragsart, verurs_art, '
      + 't_tg_nr, oa, typ, FA_Nr '
      + 'FROM f_auftragkopf where id_stu = "' + KaId
      + '" and pos_nr="' + IntToStr(id_pos)
      + '" and oa<9 ORDER BY FA_Nr';
  Result:= RunSelectQuery(sql);

end;

function TWBaumQrySQLite.SucheFAzuTeil(t_tg_nr:String): Boolean;
begin
  var sql: String;
  sql:= 'SELECT id_stu, pos_nr, auftragsart, verurs_art, '
      + 't_tg_nr, oa, typ, FA_Nr '
      + 'FROM f_auftragkopf '
      + 'Where t_tg_nr="' + t_tg_nr + '" and oa<9 ORDER BY FA_Nr desc limit 1';
  Result:= RunSelectQuery(sql);

end;

//Suche alle Positionen zu einem FA (ASTUELIPOS)
function TWBaumQrySQLite.SuchePosZuFA(FA_Nr:String): Boolean;
begin
  var sql: String;
  sql:= 'SELECT id_stu, id_pos, '
      + 'ueb_s_nr, ds, set_block, pos_nr, t_tg_nr, oa, typ, menge '
      + 'FROM astuelipos where id_stu = "' + FA_Nr
      + '" and oa<9 ORDER BY pos_nr';
  Result:= RunSelectQuery(sql);
end;

end.
