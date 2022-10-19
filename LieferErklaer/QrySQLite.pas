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
      function HoleLieferanten():Boolean;
      function HoleLieferantenLokal():Boolean;
    end;

implementation


// Hole Lieferanten; Erstmalige Befuellung der Tabelle lieferanten
//---------------------------------------------------------------------------
function TWQrySQLite.HoleLieferanten():Boolean;
begin
  var sql: String;
  sql := 'INSERT INTO lieferanten ( IdLieferant ) '
      +  'SELECT DISTINCT Bestellungen.IdLieferant '
      +  'FROM Bestellungen '
      +  'ORDER BY Bestellungen.IdLieferant;';
  Result:= RunExecSQLQuery(sql);
end;

// Liest Lieferanten aus lokaler Tabelle lieferanten
//---------------------------------------------------------------------------
function TWQrySQLite.HoleLieferantenLokal():Boolean;
begin
  var sql: String;
  sql := 'select IdLieferant from lieferanten ORDER BY IdLieferant;';

  Result:= RunSelectQuery(sql);
end;

end.
