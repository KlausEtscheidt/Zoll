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
      function TeileName1InTabelle():Boolean;
      function TeileName2InTabelle():Boolean;
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


// Zeile 1 der Benennung aus tmp-Tabelle in Tabelle Teile
//---------------------------------------------------------------------------
function TWQrySQLite.TeileName1InTabelle():Boolean;
begin
  var sql: String;
  sql := 'INSERT INTO Teile (TeileNr, TName1)  '
      +  'SELECT TeileNr, text AS TName1 from tmpTeileBenennung '
      +  'WHERE Zeile=1 ORDER BY TeileNr; ';

  Result:= RunExecSQLQuery(sql);
//  Result:= RunSelectQuery(sql);

end;

// Zeile 2 der Benennung aus tmp-Tabelle in Tabelle Teile
//---------------------------------------------------------------------------
function TWQrySQLite.TeileName2InTabelle():Boolean;
begin
  var sql: String;
  sql := 'UPDATE Teile SET TName2 =  '
      +  '(SELECT text from tmpTeileBenennung '
      +  'WHERE Teile.TeileNr=tmpTeileBenennung.TeileNr '
      +  'AND tmpTeileBenennung.Zeile=2);' ;

  Result:= RunExecSQLQuery(sql);

end;

end.
