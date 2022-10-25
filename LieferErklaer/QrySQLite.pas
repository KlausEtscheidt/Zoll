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
      function HoleStatuswert(Name: String):Boolean;
      function UpdateLErklaerungen():Boolean;
      function FuelleLieferantenTabelle():Boolean;
      function HoleLieferanten():Boolean;
      function HoleTeile():Boolean;
      function TeileName1InTabelle():Boolean;
      function TeileName2InTabelle():Boolean;
    end;

implementation

// Liest Statuswerte aus lokaler Tabelle Stati
//----------------------------------------------------------------
function TWQrySQLite.HoleStatuswert(Name: String):Boolean;
  var sql: String;

begin
  sql := 'select * From Stati where name=? ;';

  Result:= RunSelectQueryWithParam(sql,[Name]);
end;

// Ergänzt Tabelle LErklaerungen mit neuen Teilen aus Bestellungen
//---------------------------------------------------------------------------
function TWQrySQLite.UpdateLErklaerungen():Boolean;
  var
   sql: String;
begin
  sql := 'Insert Into LErklaerungen '
       + '(TeileNr, IdLieferant, LTeileNr, BestDatum, LPfk, Stand)'
       + 'SELECT Bestellungen.TeileNr, Bestellungen.IdLieferant, '
       + 'Bestellungen.LTeileNr, Bestellungen.BestDatum, 0 as LPfk, '
       + 'date() as Stand '
       + 'from Bestellungen '
       + 'left join LErklaerungen on '
       + 'Bestellungen.TeileNr=LErklaerungen.TeileNr '
       + 'and Bestellungen.IdLieferant = LErklaerungen.IdLieferant '
       + 'WHERE LErklaerungen.IdLieferant Is Null' ;

  Result:= RunExecSQLQuery(sql);
end;

// Hole Lieferanten; Erstmalige Befuellung der Tabelle lieferanten
//---------------------------------------------------------------------------
function TWQrySQLite.FuelleLieferantenTabelle():Boolean;
begin
  var sql: String;

  sql := 'INSERT INTO lieferanten '
      +  '( IdLieferant, LKurzname, LName1, LName1, Stand ) '
      +  'SELECT DISTINCT IdLieferant,LKurzname,LName1,LName2, eingelesen '
      +  'FROM Bestellungen '
      +  'ORDER BY IdLieferant;';
  Result:= RunExecSQLQuery(sql);
end;

// Liest Lieferanten aus lokaler Tabelle lieferanten
//---------------------------------------------------------------------------
function TWQrySQLite.HoleLieferanten():Boolean;
begin
  var sql: String;
  sql := 'select IdLieferant from lieferanten ORDER BY IdLieferant;';

  Result:= RunSelectQuery(sql);
end;

// Liest Teile aus lokaler Tabelle Teile
//---------------------------------------------------------------------------
function TWQrySQLite.HoleTeile():Boolean;
begin
  var sql: String;
  sql := 'select * From Teile;';

  Result:= RunSelectQuery(sql);
end;


// Zeile 1 der Benennung aus tmp-Tabelle in Tabelle Teile
// siehe Access "4a_TeileName1_In_Tabelle_Teile"
//---------------------------------------------------------------------------
function TWQrySQLite.TeileName1InTabelle():Boolean;
begin
  var sql: String;
  sql := 'INSERT INTO Teile (TeileNr, TName1, Pumpenteil, PFK)  '
      +  'SELECT TeileNr, text AS TName1, 0, 0 from tmpTeileBenennung '
      +  'WHERE Zeile=1 ORDER BY TeileNr; ';

  Result:= RunExecSQLQuery(sql);
//  Result:= RunSelectQuery(sql);

end;

// Zeile 2 der Benennung aus tmp-Tabelle in Tabelle Teile
// siehe Access "4b_TeileName2_In_Tabelle_Teile"
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
