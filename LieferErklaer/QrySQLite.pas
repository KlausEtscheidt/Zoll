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
      //Nacharbeit des UNIPPS-Imports
      function NeueLErklaerungenInTabelle():Boolean;
      function AlteLErklaerungenLoeschen():Boolean;
      function NeueLieferantenInTabelle():Boolean;
      function MarkiereAlteLieferanten():Boolean;
      function MarkiereAktuelleLieferanten():Boolean;
      function ResetPumpenErsatzteilMarkierungInLieferanten():Boolean;
      function MarkierePumpenteilLieferanten():Boolean;
      function MarkiereErsatzteilLieferanten():Boolean;
      function TeileName1InTabelle():Boolean;
      function TeileName2InTabelle():Boolean;
      function UpdateTeileZaehleLieferanten():Boolean;

      //Nur lesen für Formulare etc
      function HoleLieferantenMitStatusTxt():Boolean;
      function HoleLieferantenStatusTxt():Boolean;
      function HoleLErklaerungen(IdLieferant:Integer):Boolean;
      function HoleProgrammDaten(Name: String):Boolean;
      function HoleBestellungen():Boolean;
      function HoleLieferanten():Boolean;
      function HoleTeile():Boolean;

      //Datenpflege nach Benutzeraktion
      function UpdateLPfkInLErklaerungen(
                 IdLieferant:Integer; TeileNr:String; Pfk:Integer):Boolean;
      function UpdateLieferant(IdLieferant:Integer;
                            Stand,GiltBis,lekl:String):Boolean;

      //Auswertung nach Benutzereingaben
      function LeklAlleTeileInTmpTabelle(delta_days:String):Boolean;
      function LeklEinigeTeileInTmpTabelle(delta_days:String):Boolean;
      function UpdateTeileZaehleGueltigeLErklaerungen():Boolean;

    end;

implementation

// ---------------------------------------------------------------
//
// Abfragen fuer Basis-Datenimport
// (Aufbereiten der aus UNIPPS importierten Daten vor Benutzeraktionen)
//
// ---------------------------------------------------------------

//---------------------------------------------------------------------------
///<summary>Neue Teile-Lieferanten-Kombis aus Bestellungen in LErklaerungen</summary>
function TWQrySQLite.NeueLErklaerungenInTabelle():Boolean;
  var
   sql: String;
begin
  sql := 'Insert Into LErklaerungen '
       + '(TeileNr, IdLieferant, LTeileNr, BestDatum, LPfk)'
       + 'SELECT Bestellungen.TeileNr, Bestellungen.IdLieferant, '
       + 'Bestellungen.LTeileNr, Bestellungen.BestDatum, 0 as LPfk '
       + 'from Bestellungen '
       + 'left join LErklaerungen on '
       + 'Bestellungen.TeileNr=LErklaerungen.TeileNr '
       + 'and Bestellungen.IdLieferant = LErklaerungen.IdLieferant '
       + 'WHERE LErklaerungen.IdLieferant Is Null' ;

  Result:= RunExecSQLQuery(sql);
end;

///<summary>Lösche Teile-Lieferanten-Kombis, die nicht in Bestellungen sind.
///</summary>
function TWQrySQLite.AlteLErklaerungenLoeschen():Boolean;
  var sql: String;
begin
  sql := 'SELECT Id FROM LErklaerungen LEFT JOIN Bestellungen '
       + 'ON Bestellungen.TeileNr=LErklaerungen.TeileNr '
       + 'AND Bestellungen.IdLieferant = LErklaerungen.IdLieferant '
       + 'WHERE Bestellungen.IdLieferant Is Null ' ;
  sql := 'DELETE FROM LErklaerungen WHERE Id IN (' + sql + ');' ;
  Result:= RunExecSQLQuery(sql);
end;

//-----------------------------------------------------------
///<summary> Neue Lieferanten in Tabelle lieferanten</summary>
function TWQrySQLite.NeueLieferantenInTabelle():Boolean;
  var sql: String;
begin
  sql := 'INSERT INTO lieferanten '
      +  '( IdLieferant, LKurzname, LName1, LName1  ) '
       + 'SELECT DISTINCT IdLieferant, LKurzname, LName1, LName2  '
       + 'FROM Bestellungen where IdLieferant not in '
       + '(SELECT IdLieferant FROM Lieferanten) ORDER BY IdLieferant;' ;
  Result:= RunExecSQLQuery(sql);
end;

//-----------------------------------------------
///<summary>Markiere Lieferanten, die neu waren
/// und die noch aktuell sind, als aktuell.</summary>
function TWQrySQLite.MarkiereAktuelleLieferanten():Boolean;
  var sql: String;
begin
  sql := 'update Lieferanten set Lieferstatus="aktuell" '
//       + 'where Lieferstatus="neu" and '
       + 'where  '
       + 'IdLieferant in (SELECT IdLieferant FROM Bestellungen); ';
  Result:= RunExecSQLQuery(sql);
end;

//---------------------------------------------
///<summary>Entfallene Lieferanten in Tabelle markieren</summary>
function TWQrySQLite.MarkiereAlteLieferanten():Boolean;
  var sql: String;
begin
  sql := 'update Lieferanten set Lieferstatus="entfallen" '
       + 'where IdLieferant not in '
       + '(SELECT IdLieferant FROM Bestellungen); ';
  Result:= RunExecSQLQuery(sql);
end;


//----------------------------------------------------
///<summary>Setze Markierung f Pumpen-/Ersatzteile zurück.</summary>
function TWQrySQLite.ResetPumpenErsatzteilMarkierungInLieferanten():Boolean;
  var sql: String;
begin
  sql := 'UPDATE Lieferanten SET Pumpenteile=0, Ersatzteile=0;';
  Result:= RunExecSQLQuery(sql);
end;


//----------------------------------------------------
///<summary>Markiere Lieferanten die mind. 1 Pumpenteil liefern</summary>
function TWQrySQLite.MarkierePumpenteilLieferanten():Boolean;
  var sql: String;
begin
  sql := 'UPDATE Lieferanten SET Pumpenteile=-1 WHERE IdLieferant '
       + 'IN (SELECT DISTINCT IdLieferant FROM LErklaerungen '
       + 'JOIN Teile ON LErklaerungen.TeileNr=Teile.TeileNr  '
       + 'WHERE Pumpenteil=-1);';
  Result:= RunExecSQLQuery(sql);
end;

//----------------------------------------------------
///<summary>Markiere Lieferanten die mind. 1 Ersatzteil liefern</summary>
function TWQrySQLite.MarkiereErsatzteilLieferanten():Boolean;
  var sql: String;
begin
  sql := 'UPDATE Lieferanten SET Ersatzteile=-1 WHERE IdLieferant '
       + 'IN (SELECT DISTINCT IdLieferant FROM LErklaerungen '
       + 'JOIN Teile ON LErklaerungen.TeileNr=Teile.TeileNr  '
       + 'WHERE Ersatzteil=-1);';
  Result:= RunExecSQLQuery(sql);
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
  var
    sql: String;
begin
  sql := 'UPDATE Teile SET TName2 =  '
      +  '(SELECT text from tmpTeileBenennung '
      +  'WHERE Teile.TeileNr=tmpTeileBenennung.TeileNr '
      +  'AND tmpTeileBenennung.Zeile=2);' ;

  Result:= RunExecSQLQuery(sql);

end;


//---------------------------------------------------------------------------
///<summary> Anzahl der Lieferanten eines Teils in Tabelle Teile</summary>
function TWQrySQLite.UpdateTeileZaehleLieferanten():Boolean;
  var
    sql: String;
begin
  sql := 'UPDATE Teile SET n_Lieferanten= '
       + '(SELECT N_liefer FROM '
       + '(SELECT TeileNr as TNr, Count(IdLieferant) as N_liefer '
       + ' FROM LErklaerungen GROUP BY LErklaerungen.TeileNr) '
       + ' WHERE  Teile.TeileNr=TNr );' ;
  Result:= RunExecSQLQuery(sql);

end;


// ---------------------------------------------------------------
//
// Select-Abfragen
// (Input für Formulare, etc. Keine Datenänderungen
//
// ---------------------------------------------------------------

///<summary> Liest Tabelle Lieferanten mit Status im Klartext</summary>
function TWQrySQLite.HoleLieferantenMitStatusTxt():Boolean;
  var
    sql: String;
begin
    SQL := 'select *,StatusTxt from lieferanten '
         + 'join LieferantenStatusTxt '
         + 'on LieferantenStatusTxt.id=lieferanten.lekl '
         + 'WHERE Lieferstatus !="entfallen" '
         + 'order by LKurzname;';
  Result:= RunSelectQuery(sql);
end;

///<summary> Liest LieferantenStatus im Klartext</summary>
function TWQrySQLite.HoleLieferantenStatusTxt():Boolean;
  var
    sql: String;
begin
    SQL := 'select * from LieferantenStatusTxt; ';
  Result:= RunSelectQuery(sql);
end;

///<summary> Liest Tabelle LErklaerungen mit Zusazdaten zu Teilen. </summary>
function TWQrySQLite.HoleLErklaerungen(IdLieferant:Integer):Boolean;
  var
    sql: String;
begin
  SQL := 'select *, TName1, TName2, Pumpenteil '
         + 'from LErklaerungen '
         + 'join Teile on LErklaerungen.TeileNr=Teile.TeileNr '
         + 'where IdLieferant= ?' ;
  Result:= RunSelectQueryWithParam(sql,[IntToSTr(IdLieferant)]);
end;

// Liest Statuswerte aus Tabelle ProgrammDaten
//----------------------------------------------------------------
function TWQrySQLite.HoleProgrammDaten(Name: String):Boolean;
  var sql: String;

begin
  sql := 'select * From ProgrammDaten where name=? ;';

  Result:= RunSelectQueryWithParam(sql,[Name]);
end;

// Liest Bestellungen aus lokaler Tabelle
//---------------------------------------------------------------------------
function TWQrySQLite.HoleBestellungen():Boolean;
begin
  var sql: String;
  sql := 'select * From Bestellungen;';
  Result:= RunSelectQuery(sql);
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


// ---------------------------------------------------------------
//
// Änderungs-Abfragen
// Datenänderungen zur Pflege der Datenbasis nach Benutzeraktionen
//
// ---------------------------------------------------------------

///<summary> Set LPfk-Flag in Tabelle LErklaerungen</summary>
function TWQrySQLite.UpdateLPfkInLErklaerungen(
                 IdLieferant:Integer; TeileNr:String; Pfk:Integer):Boolean;
  var
    sql: String;
begin
  SQL := 'Update LErklaerungen set LPfk="' + IntToSTr(Pfk) + '"  '
        +  'where IdLieferant=' + IntToSTr(IdLieferant) + ' '
        +  'and TeileNr="' + TeileNr + '";' ;
  Result:= RunExecSQLQuery(sql);
end;

///<summary> Set Stand, gilt_bis und lekl in Tabelle Lieferanten</summary>
function TWQrySQLite.UpdateLieferant(IdLieferant:Integer;
                            Stand,GiltBis,lekl:String):Boolean;
  var
    sql: String;
begin
      SQL := 'Update Lieferanten set stand="' + Stand + ' " , '
          +  'gilt_bis="' + GiltBis + ' " , '
          +  'lekl="' + lekl + ' "  '
          +  'where IdLieferant=' + IntToSTr(IdLieferant)  +';' ;
  Result:= RunExecSQLQuery(sql);
end;


// ---------------------------------------------------------------
//
// Änderungs-Abfragen
// Datenänderungen zur Auswertung nach allen Benutzeraktionen
//
// ---------------------------------------------------------------

///<summary>Fuege Teile von Lieferanten mit gültiger Erklärung "alle Teile"
///</summary>
function TWQrySQLite.LeklAlleTeileInTmpTabelle(delta_days:String):Boolean;
  var
    sql: String;
begin
      SQL := 'INSERT INTO tmpLieferantTeilPfk (TeileNr, IdLieferant, lekl) '
           + 'SELECT Teilenr, Lieferanten.IdLieferant, lekl '
           + 'FROM Lieferanten JOIN LErklaerungen '
           + 'ON Lieferanten.IdLieferant=LErklaerungen.IdLieferant '
           + 'WHERE lekl=2 and Lieferstatus !="entfallen" and '
           + 'Julianday(gilt_bis)-Julianday(Date())>+' + delta_days + ' ;' ;
  Result:= RunExecSQLQuery(sql);
end;

///<summary>Fuege Teile von Lieferanten mit gültiger Erklärung "einige Teile"
///</summary>
function TWQrySQLite.LeklEinigeTeileInTmpTabelle(delta_days:String):Boolean;
  var
    sql: String;
begin
      SQL := 'INSERT INTO tmpLieferantTeilPfk (TeileNr, IdLieferant, lekl) '
           + 'SELECT Teilenr, Lieferanten.IdLieferant, lekl '
           + 'FROM Lieferanten JOIN LErklaerungen '
           + 'ON Lieferanten.IdLieferant=LErklaerungen.IdLieferant '
           + 'WHERE lekl=3 and Lieferstatus !="entfallen" and LPfk=-1 and '
           + 'Julianday(gilt_bis)-Julianday(Date())>+' + delta_days + ' ;' ;
  Result:= RunExecSQLQuery(sql);
end;

//---------------------------------------------------------------------------
///<summary> Anzahl der gültigen Lieferanten-Erklaerungen
///                           eines Teils in Tabelle Teile</summary>
function TWQrySQLite.UpdateTeileZaehleGueltigeLErklaerungen():Boolean;
  var
    sql: String;
begin
  sql := 'UPDATE Teile SET n_LPfk= '
       + '(SELECT Anz_Pfk FROM '
       + '(SELECT TeileNr as TNr, Count(IdLieferant) as Anz_Pfk '
       + 'FROM tmpLieferantTeilPfk '
       + 'GROUP BY TeileNr)'
       + 'WHERE  Teile.TeileNr=TNr  ); ' ;

  Result:= RunExecSQLQuery(sql);

end;



end.
