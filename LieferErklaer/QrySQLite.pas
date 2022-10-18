/// <summary>SQLite-Datenbank-Abfragen für das Programm PräFix</summary>
/// <remarks>
/// Die Unit ist identisch zu BaumQryUNIPPS arbeitet jedoch mit einer
/// SQLite-Datenbank in der geeignete Daten hinterlegt sein müssen.
///| Die Unit ermöglicht eine Entwicklung ohne UNIPPS-Zugang.
/// Sie wird durch Compiler-Flags anstatt BaumQryUNIPPS verwendet (s. Unit Tools)
/// und ist für den Produktivbetrieb überflüssig.
///| Die Daten werden im UNIPPS-Modus durch Kopieren gewonnen.
///| Die SQL-Strings sind nicht identisch zu BaumQryUNIPPS, da SQLite teilweise
/// eine andere Syntax hat, da die Daten aber auch in anderen Tabellen liegen.
/// </remarks>
unit QrySQLite;

interface

  uses System.SysUtils, System.Classes, ADOQuery;

  type
    TWQrySQLite = class(TWADOQuery)
      function SucheKundenAuftragspositionen(KaId:string):Boolean;
      function SucheFAzuKAPos(KaId:String; id_pos:Integer): Boolean;
      function SucheFAzuTeil(t_tg_nr:String): Boolean;
      function SuchePosZuFA(FA_Nr:String): Boolean;
      function SucheStuelizuTeil(t_tg_nr:String): Boolean;

      function SucheDatenzumTeil(t_tg_nr:string):Boolean;
      function SucheBenennungZuTeil(t_tg_nr:String): Boolean;
      function SucheLetzte3Bestellungen(t_tg_nr:string): Boolean;
      function SucheKundenRabatt(KaId:string):Boolean;
    end;

implementation

//---------------------------------------------------------------------------
// Struktur-Aufbau: Suche Stueli-Positionen
//---------------------------------------------------------------------------

// Kunden-Auftrags-Positionen
//---------------------------------------------------------------------------
function TWQrySQLite.SucheKundenAuftragspositionen(KaId:string):Boolean;
begin
  var sql: String;
  sql := 'select id_stu, id_pos, kunde, besch_art, klassifiz, pos_nr, '
      +  'stu_t_tg_nr, '
      +  'stu_oa, stu_unipps_typ, menge, preis '
      +  'from auftragkopf where id_stu like ? order by id_pos;';
  Result:= RunSelectQueryWithParam(sql,[KaId]);
end;

// Fertigungs-Aufrag (FA) zu Kunden-Auftrags-Positionen (Kommissions-FA)
//---------------------------------------------------------------------------
function TWQrySQLite.SucheFAzuKAPos(KaId:String; id_pos:Integer): Boolean;
begin
  var sql: String;
  sql:= 'SELECT id_stu, pos_nr, auftragsart, verurs_art, '
      + 'stu_t_tg_nr, stu_oa, stu_unipps_typ, FA_Nr '
      + 'FROM f_auftragkopf where id_stu = ? and pos_nr= ? '
      + 'and stu_oa<9 ORDER BY FA_Nr';
  Result:= RunSelectQueryWithParam(sql,[KaId,IntToStr(id_pos)]);

end;

// Fertigungs-Aufrag (FA) zu einer Teile-Nummer (Serien-FA)
//---------------------------------------------------------------------------
function TWQrySQLite.SucheFAzuTeil(t_tg_nr:String): Boolean;
begin
  var sql: String;
  sql:= 'SELECT stu_t_tg_nr as id_stu, 1 as pos_nr, auftragsart, verurs_art, '
      + 'stu_t_tg_nr, stu_oa, stu_unipps_typ, FA_Nr '
      + 'FROM f_auftragkopf '
      + 'Where stu_t_tg_nr= ? and stu_oa<9 ORDER BY FA_Nr desc limit 1';
  Result:= RunSelectQueryWithParam(sql,[t_tg_nr]);

end;

//Suche alle Positionen zu einem FA (ASTUELIPOS)
function TWQrySQLite.SuchePosZuFA(FA_Nr:String): Boolean;
begin
  var sql: String;
  sql:= 'SELECT id_stu, id_pos, '
      + 'ueb_s_nr, ds, set_block, pos_nr, stu_t_tg_nr, '
      + 'stu_oa, stu_unipps_typ, menge '
      + 'FROM astuelipos where id_stu = ? '
      + 'and stu_oa<9 ORDER BY pos_nr';
  Result:= RunSelectQueryWithParam(sql,[FA_Nr]);

end;

// Suche Stueckliste zu einem Teil (Objekt TeilAlsStuPos wird hieraus erzeugt)
//---------------------------------------------------------------------------
function TWQrySQLite.SucheStuelizuTeil(t_tg_nr:String): Boolean;
begin
  var sql: String;
  //####################################
  sql:= 'SELECT id_stu, pos_nr, stu_t_tg_nr, stu_oa, stu_unipps_typ, menge '
      + 'FROM teil_stuelipos where id_stu= ? '
      + 'ORDER BY pos_nr ;';
  Result:= RunSelectQueryWithParam(sql,[t_tg_nr]);
end;

//---------------------------------------------------------------------------
// Suche Zusatz-Infos
//---------------------------------------------------------------------------


// Suche Daten zu einem Teil (Objekt Teil wird hieraus erzeugt)
//---------------------------------------------------------------------------
function TWQrySQLite.SucheDatenzumTeil(t_tg_nr:string):Boolean;
begin
  var sql: String;
  sql:= 'SELECT t_tg_nr, oa, v_besch_art, unipps_typ, '
      + 'praeferenzkennung, sme, faktlme_sme, lme '
      + 'FROM teil where t_tg_nr = (?) and oa<9;';
  Result:= RunSelectQueryWithParam(sql,[t_tg_nr]);
end;

// Suche Benennung zu einem Teil (wird Objekt Teil zugefuegt)
//---------------------------------------------------------------------------
function TWQrySQLite.SucheBenennungZuTeil(t_tg_nr:String): Boolean;
begin
  var sql: String;
  sql:= 'SELECT teil_bez_id, Bezeichnung '
      + 'FROM teil_bez where teil_bez_id= ? ;' ;
  Result:= RunSelectQueryWithParam(sql,[t_tg_nr]);
end;

// Suche letzte 3 Bestellungen zu einem Teil um Preis zu bestimmen
//(Objekt Bestellung wird hieraus erzeugt)
//---------------------------------------------------------------------------
function TWQrySQLite.SucheLetzte3Bestellungen(t_tg_nr:string): Boolean;
begin
  var sql: String;
  sql:= 'SELECT bestell_id, bestell_datum, preis, basis, pme, bme, '
      + 'faktlme_bme, faktbme_pme, netto_poswert, best_menge, '
      + 'we_menge, lieferant, kurzname, best_t_tg_nr '
      + 'FROM bestellungen where best_t_tg_nr = ? '
      + 'order by bestell_datum desc limit 3;';
  Result:= RunSelectQueryWithParam(sql,[t_tg_nr]);
end;

// Suche Rabatt zu einem Kunden (wird an Kundenauftrags-Pos angefuegt)
//---------------------------------------------------------------------------
function TWQrySQLite.SucheKundenRabatt(KaId:string):Boolean;
begin
  var sql: String;
  sql := 'select kunden_id, zu_ab_proz, datum_von, datum_bis '
       + 'from kunde_zuab where kunden_id = ? '
       + 'and DATUM_VON <date() and date()<DATUM_BIS;';
  Result:= RunSelectQueryWithParam(sql,[KaId]);

end;


end.
