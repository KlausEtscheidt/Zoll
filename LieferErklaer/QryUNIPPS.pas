/// <summary>UNIPPS-Datenbank-Abfragen für das Programm LEKL</summary>
/// <remarks>
/// Abfrage-Generator für UNIPPS-Abfragen.
///| Anwendungsbeispiel: Abfrage zum Lesen des Kundenauftrags und seiner Positionen
///| Abfrage erzeugen
///| KAQry := TWBaumQryUNIPPS.Create(nil);
///| Datenbank-Connector setzen (DbConnector hat Typ TADOConnector)
///| KAQry.Connector:=DbConnector;
///| SQL für Abfrage setzen und Abfrage ausführen
///| gefunden := KAQry.SucheKundenAuftragspositionen(ka_id);
///|  gefunden wird True, wenn die Abfrage Daten fand.
///  Über KAQry können die Daten mit den Methoden der TADOQuery weiter verarbeitet werden.
///| Für das Programm PräFix wurden die ersten beiden Schritte
///  in der Methode getQuery der Unit Tools zusammengfasst:
///| KAQry := Tools.getQuery;
/// </remarks>//
unit QryUNIPPS;

interface
  uses System.SysUtils,System.Classes,ADOConnector, ADOQuery;

  type
    ///<summary>Abfragengenerator für alle nötigen UNIPPS-Abfragen.
    ///</summary>
    TWQryUNIPPS = class(TWADOQuery)
      function SucheBestellungen(delta_days: Integer): Boolean;
      function SucheLieferantenTeilenummer(IdLieferant: String;
                                   TeileNr: String): Boolean;
      function SucheTeileBenennung(delta_days: Integer):Boolean;
      function SucheTeileInFA(TeileNr: String):Boolean;
      function SucheTeileInFAKopf(TeileNr: String):Boolean;
      function SucheTeileInKA(TeileNr: String):Boolean;
      function SucheTeileInSTU(TeileNr: String):Boolean;

    end;

  const
      //SQL zum Holen von Bestellungen mit Positionen und Datum seit xxx
      // => IdLieferant, TeileNr, BestDatumSub
      // s. Access "1_HoleBestellungen_seit"

      //Var. 1 mit festem Zeitraum
      sql_suche_Bestellungen_fix : String = 'SELECT bestellkopf.lieferant as IdLieferant, '
      + 'bestellpos.t_tg_nr as TeileNr, '
      + 'bestellkopf.freigabe_datum as BestDatumSub '
      + 'FROM bestellkopf '
      + 'INNER JOIN bestellpos ON bestellkopf.ident_nr = bestellpos.ident_nr1 '
      + 'where bestellkopf.freigabe_datum > TODAY -5*365 ';
//      + 'order by bestellpos.t_tg_nr, IdLieferant ;';

      //Var. 2 mit Zeitraum als Parameter
      sql_suche_Bestellungen : String = 'SELECT bestellkopf.lieferant as IdLieferant, '
      + 'bestellpos.t_tg_nr as TeileNr, '
      + 'bestellkopf.freigabe_datum as BestDatumSub '
      + 'FROM bestellkopf '
      + 'INNER JOIN bestellpos ON bestellkopf.ident_nr = bestellpos.ident_nr1 '
      + 'where TODAY - freigabe_datum <  ?  ' ;

implementation


///<summary>Suche Bestellungen in UNIPPS bestellkopf</summary>
/// <remarks>
/// Eindeutige Kombination aus IdLieferant, TeileNr
/// Zusatzinfo zu Lieferant: Kurzname,LName1,LName2 bzw zu Teil LTeileNr
/// </remarks>
///<param name="delta_days">Zeitraum ab heute-delta_days</param>
//---------------------------------------------------------------------------
function TWQryUNIPPS.SucheBestellungen(delta_days: Integer):Boolean;
var  sql: String;
begin

    //Neueste Bestellung je Teil und Lieferant (unique) seit Datum xxx
    //siehe Access Abfrage "2a_Bestellungen_grouped_Teil_u_Lieferant"
    sql := 'SELECT IdLieferant, TeileNr, max(BestDatumSub) as BestDatum '
      + 'FROM (' + sql_suche_Bestellungen + ') '
      + 'GROUP BY IdLieferant, TeileNr '
      + 'order by TeileNr, IdLieferant';

    //Lieferanten Kurz- und Langname dazu
    //siehe Access Abfrage "2b_Bestellungen_Lieferantendaten"
    sql := 'SELECT IdLieferant, trim(TeileNr) as TeileNr, BestDatum, '
      + 'trim(adresse.kurzname) AS LKurzname, '
      + 'trim(adresse.name1) AS LName1, trim(adresse.name2) AS LName2, '
      + 'TODAY as eingelesen '
      + 'FROM (' + sql + ') as Bestellungen '
      + 'INNER JOIN lieferant on lieferant.ident_nr = IdLieferant '
      + 'INNER JOIN adresse on lieferant.adresse = adresse.ident_nr ';

  Result:= RunSelectQueryWithParam(sql,[intToStr(delta_days)]);
//  Result:= RunSelectQuery(sql);

end;


///<summary>Suche Lieferanten-Teilenummer in UNIPPS </summary>
//---------------------------------------------------------------------
function TWQryUNIPPS.SucheLieferantenTeilenummer(IdLieferant: String;
                                                 TeileNr: String): Boolean;
var
  sql: String;
begin
  sql := 'SELECT ident_nr1 as IdLieferant, TRIM(ident_nr2) AS TeileNr, '
       + 'TRIM(l_teile_nr) AS LTeileNr '
       + 'FROM lieferant_teil '
       + 'where ident_nr1=? and ident_nr2=?;';
  Result:= RunSelectQueryWithParam(sql,[IdLieferant,TeileNr]);
end;

///<summary>Suche Benennung zu bestellten Teilen in UNIPPS </summary>
//---------------------------------------------------------------------------
function TWQryUNIPPS.SucheTeileBenennung(delta_days: Integer):Boolean;
var  sql: String;
begin

      //Eindeutige TeileNr aus Bestellungen der letzten 5 Jahre
      //siehe Access Abfrage "3a_Teile_aus_Bestellungen_unique"
      sql := 'SELECT TeileNr '
           + 'FROM (' + sql_suche_Bestellungen + ') '
           + 'group by TeileNr ';

       // Zeilen 1 und 2 der deutschen Benennung dazu
       //siehe Access Abfrage "xxxxxxx"
       sql := 'SELECT trim(ident_nr1) as TeileNr, art as Zeile, trim(Text) as Text '
           + 'FROM teil_bez  '
           + 'where (art=1 or art=2) '
           + 'and sprache="D" and ident_nr1 in (' + sql + ') '
           + 'order by ident_nr1 ';

//  Result:= RunSelectQuery(sql);
  Result:= RunSelectQueryWithParam(sql,[intToStr(delta_days)]);


end;


///<summary>Sucht Teil als Position eines FA in UNIPPS astuelipos</summary>
///<param name="TeileNr">t_tg_nr des Teils</param>
//---------------------------------------------------------------------------
function TWQryUNIPPS.SucheTeileInFA(TeileNr: String):Boolean;
var  sql: String;
begin
  sql := 'SELECT t_tg_nr FROM astuelipos where t_tg_nr=?;' ;
  Result:= RunSelectQueryWithParam(sql,[TeileNr]);
end;

///<summary>Sucht Teil als Position eines KA in UNIPPS auftragpos</summary>
///<param name="TeileNr">t_tg_nr des Teils</param>
//---------------------------------------------------------------------------
function TWQryUNIPPS.SucheTeileInKA(TeileNr: String):Boolean;
var  sql: String;
begin
  sql := 'SELECT t_tg_nr FROM auftragpos where t_tg_nr=?;' ;
  Result:= RunSelectQueryWithParam(sql,[TeileNr]);
end;

///<summary>Sucht Teil in Stücklisten in UNIPPS teil_stuelipos</summary>
///<param name="TeileNr">t_tg_nr des Teils</param>
//---------------------------------------------------------------------------
function TWQryUNIPPS.SucheTeileInSTU(TeileNr: String):Boolean;
var  sql: String;
begin
  sql := 'SELECT t_tg_nr FROM teil_stuelipos where t_tg_nr=?;' ;
  Result:= RunSelectQueryWithParam(sql,[TeileNr]);
end;

///<summary>Sucht Teil in FA-Kopf in UNIPPS f_auftragkopf</summary>
///<param name="TeileNr">t_tg_nr des Teils</param>
//---------------------------------------------------------------------------
function TWQryUNIPPS.SucheTeileInFAKopf(TeileNr: String):Boolean;
var  sql: String;
begin
  sql := 'SELECT t_tg_nr FROM f_auftragkopf where t_tg_nr=?;' ;
  Result:= RunSelectQueryWithParam(sql,[TeileNr]);
end;


end.
