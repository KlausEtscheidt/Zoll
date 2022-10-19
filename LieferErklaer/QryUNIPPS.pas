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
///| Die Unit verfügt außerdem über einen Modus, bei alle Ergebnisse aus
///  UNIPPS-Abfragen in eine SQLite-Datenbank kopiert werden.
/// </remarks>//
unit QryUNIPPS;

interface
  uses System.SysUtils,System.Classes,ADOConnector, ADOQuery;

  type
    ///<summary>Abfragengenerator für alle nötigen UNIPPS-Abfragen.
    ///</summary>
    TWQryUNIPPS = class(TWADOQuery)
      function SucheBestellungen(delta_days: Integer): Boolean;
      function SucheZusatzInfoZuLieferant(IdLieferant: Integer):Boolean;
    end;


implementation


///<summary>Suche Bestellungen in UNIPPS bestellkopf</summary>
///<param name="delta_days">Zeitraum ab heute-delta_days</param>
//---------------------------------------------------------------------------
function TWQryUNIPPS.SucheBestellungen(delta_days: Integer):Boolean;
var sql_sub, sql: String;
begin
  //siehe Access Abfrage "xxxxxxx"

    sql_sub := 'SELECT bestellkopf.lieferant as IdLieferant, '
      + 'bestellpos.t_tg_nr, '
      + 'bestellkopf.freigabe_datum as BestDatumSub '
      + 'FROM bestellkopf '
      + 'INNER JOIN bestellpos ON bestellkopf.ident_nr = bestellpos.ident_nr1 '
      + 'where bestellkopf.freigabe_datum > TODAY -5*365 '
      + 'order by bestellpos.t_tg_nr, IdLieferant';
//      +  'where freigabe_datum < TODAY - ? order by ident_nr;';

    sql := 'SELECT IdLieferant, t_tg_nr, max(BestDatumSub) as BestDatum, '
      + 'TODAY as eingelesen '
      + 'FROM (' + sql_sub + ') '
      + 'GROUP BY IdLieferant, t_tg_nr '
      + 'order by t_tg_nr, IdLieferant';


//  Result:= RunSelectQueryWithParam(sql,[delta_days]);
  Result:= RunSelectQuery(sql);

end;

// Hole Zusatzinfos zu Lieferanten
//---------------------------------------------------------------------------
function TWQryUNIPPS.SucheZusatzInfoZuLieferant(IdLieferant: Integer):Boolean;
begin
  var sql: String;

  sql:= 'SELECT lieferant.ident_nr as IdLieferant, adresse.kurzname, '
      + 'adresse.name1, adresse.name2, '
      + 'TODAY as eingelesen '
      + 'FROM lieferant '
      + 'INNER JOIN adresse on lieferant.adresse = adresse.ident_nr '
      + 'where lieferant.ident_nr = ? '
      + 'ORDER BY lieferant.ident_nr';
  Result:= RunSelectQueryWithParam(sql,[IntToStr(IdLieferant)]);

end;



end.
