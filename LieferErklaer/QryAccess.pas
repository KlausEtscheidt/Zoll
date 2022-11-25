/// <summary>Access-Datenbank-Abfragen für das
///  Programm LEKL Lieferantenerklärungen</summary>
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
unit QryAccess;

interface

  uses System.SysUtils, System.Classes, ADOQuery;

  type
    TWQryAccess = class(TWADOQuery)
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
      function UpdateTmpAnzLieferantenJeTeil():Boolean;
      function UpdateTeileZaehleLieferanten():Boolean;

      //Nur lesen für Formulare etc
      function HoleLieferantenMitStatusTxt():Boolean;
      function HoleLieferantenMitStatusTxtAbgelaufen(delta_days:String):Boolean;
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
      function UpdateLieferantStand(IdLieferant:Integer;Stand:String):Boolean;

      //Auswertung nach Benutzereingaben
      function LeklAlleTeileInTmpTabelle(delta_days:String):Boolean;
      function LeklEinigeTeileInTmpTabelle(delta_days:String):Boolean;
      function UpdateTmpAnzErklaerungenJeTeil():Boolean;
      function UpdateTeileZaehleGueltigeLErklaerungen():Boolean;

      //nur lesen mit 1 einzigen Rückgabewert
      function HoleAnzahlTabelleneintraege(tablename:String):Integer;
      function HoleAnzahlPumpenteile():Integer;
      function HoleAnzahlPumpenteileMitPfk():Integer;
      function HoleAnzahlLieferanten():Integer;
      function HoleAnzahlLieferPumpenteile():Integer;
      function HoleAnzahlLieferStatusUnbekannt():Integer;

      // Abfragen zum Lesen/Schreiben der ProgrammDaten (Konfiguration)
      function LiesProgrammDatenWert(Name:String):String;
      function SchreibeProgrammDatenWert(Name,Wert:String):Boolean;



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
function TWQryAccess.NeueLErklaerungenInTabelle():Boolean;
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
function TWQryAccess.AlteLErklaerungenLoeschen():Boolean;
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
function TWQryAccess.NeueLieferantenInTabelle():Boolean;
  var sql: String;
begin
  sql := 'INSERT INTO lieferanten '
      +  '( IdLieferant, LKurzname, LName1, LName2  ) '
       + 'SELECT DISTINCT IdLieferant, LKurzname, LName1, LName2  '
       + 'FROM Bestellungen where IdLieferant not in '
       + '(SELECT IdLieferant FROM Lieferanten) ORDER BY IdLieferant;' ;
  Result:= RunExecSQLQuery(sql);
end;

//-----------------------------------------------
///<summary>Markiere Lieferanten, die neu waren
/// und die noch aktuell sind, als aktuell.</summary>
function TWQryAccess.MarkiereAktuelleLieferanten():Boolean;
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
function TWQryAccess.MarkiereAlteLieferanten():Boolean;
  var sql: String;
begin
  sql := 'update Lieferanten set Lieferstatus="entfallen" '
       + 'where IdLieferant not in '
       + '(SELECT IdLieferant FROM Bestellungen); ';
  Result:= RunExecSQLQuery(sql);
end;


//----------------------------------------------------
///<summary>Setze Markierung f Pumpen-/Ersatzteile zurück.</summary>
function TWQryAccess.ResetPumpenErsatzteilMarkierungInLieferanten():Boolean;
  var sql: String;
begin
  sql := 'UPDATE Lieferanten SET Pumpenteile=0, Ersatzteile=0;';
  Result:= RunExecSQLQuery(sql);
end;


//----------------------------------------------------
///<summary>Markiere Lieferanten die mind. 1 Pumpenteil liefern</summary>
function TWQryAccess.MarkierePumpenteilLieferanten():Boolean;
  var sql: String;
begin
  sql := 'UPDATE Lieferanten SET Pumpenteile=-1 WHERE IdLieferant '
       + 'IN (SELECT DISTINCT IdLieferant FROM LErklaerungen '
       + 'INNER JOIN Teile ON LErklaerungen.TeileNr=Teile.TeileNr  '
       + 'WHERE Pumpenteil=-1);';
  Result:= RunExecSQLQuery(sql);
end;

//----------------------------------------------------
///<summary>Markiere Lieferanten die mind. 1 Ersatzteil liefern</summary>
function TWQryAccess.MarkiereErsatzteilLieferanten():Boolean;
  var sql: String;
begin
  sql := 'UPDATE Lieferanten SET Ersatzteile=-1 WHERE IdLieferant '
       + 'IN (SELECT DISTINCT IdLieferant FROM LErklaerungen '
       + 'INNER JOIN Teile ON LErklaerungen.TeileNr=Teile.TeileNr  '
       + 'WHERE Ersatzteil=-1);';
  Result:= RunExecSQLQuery(sql);
end;


// Zeile 1 der Benennung aus tmp-Tabelle in Tabelle Teile
// siehe Access "4a_TeileName1_In_Tabelle_Teile"
//---------------------------------------------------------------------------
function TWQryAccess.TeileName1InTabelle():Boolean;
begin
  var sql: String;
  sql := 'INSERT INTO Teile (TeileNr, TName1, Pumpenteil, PFK)  '
      +  'SELECT TeileNr, Benennung AS TName1, 0, 0 '
      +  'FROM tmpTeileBenennung '
      +  'WHERE Zeile=1 ORDER BY TeileNr; ';

  Result:= RunExecSQLQuery(sql);

end;

// Zeile 2 der Benennung aus tmp-Tabelle in Tabelle Teile
// siehe Access "4b_TeileName2_In_Tabelle_Teile"
//---------------------------------------------------------------------------
function TWQryAccess.TeileName2InTabelle():Boolean;
  var
    sql: String;
begin

  sql := 'UPDATE Teile INNER JOIN tmpTeileBenennung '
       + 'ON Teile.TeileNr = tmpTeileBenennung.TeileNr '
       + 'SET Teile.TName2 = tmpTeileBenennung.Benennung '
      +  'WHERE tmpTeileBenennung.Zeile=2;' ;
  Result:= RunExecSQLQuery(sql);

end;

//---------------------------------------------------------------------------
///<summary> Anzahl der Lieferanten eines Teils in tmp Tabelle
/// tmp_anz_lieferanten_je_teil </summary>
function TWQryAccess.UpdateTmpAnzLieferantenJeTeil():Boolean;
  var
    sql: String;
begin

  sql := 'INSERT INTO tmp_anz_xxx_je_teil ( TeileNr, n ) '
       + 'SELECT TeileNr, Count(TeileNr) AS n FROM LErklaerungen '
       + 'GROUP BY TeileNr; ' ;
  Result:= RunExecSQLQuery(sql);

end;

//---------------------------------------------------------------------------
///<summary> Anzahl der Lieferanten eines Teils in Tabelle Teile</summary>
function TWQryAccess.UpdateTeileZaehleLieferanten():Boolean;
  var
    sql: String;
begin

  sql := 'UPDATE Teile INNER JOIN tmp_anz_xxx_je_teil '
       + 'ON Teile.TeileNr=tmp_anz_xxx_je_teil.TeileNr '
       + 'SET Teile.n_Lieferanten = tmp_anz_xxx_je_teil.n ;' ;
  Result:= RunExecSQLQuery(sql);

end;


// ---------------------------------------------------------------
//
// Select-Abfragen
// (Input für Formulare, etc. Keine Datenänderungen
//
// ---------------------------------------------------------------

///<summary> Liest Tabelle Lieferanten mit Status im Klartext</summary>
function TWQryAccess.HoleLieferantenMitStatusTxt():Boolean;
  var
    sql: String;
begin
    SQL := 'select *,StatusTxt from lieferanten '
         + 'inner join LieferantenStatusTxt '
         + 'on LieferantenStatusTxt.id=lieferanten.lekl '
         + 'WHERE Lieferstatus <> "entfallen" '
         + 'order by LKurzname;';
  Result:= RunSelectQuery(sql);
end;


///<summary> Liest Tabelle Lieferanten mit Status im Klartext,
///jedoch nur diejenigen mit bald ablaufenden Erklärungen</summary>
function TWQryAccess.HoleLieferantenMitStatusTxtAbgelaufen(delta_days:String)
                                                                 :Boolean;
  var
    sql: String;
begin
    SQL := 'select *,StatusTxt from lieferanten '
         + 'inner join LieferantenStatusTxt '
         + 'on LieferantenStatusTxt.id=lieferanten.lekl '
         + 'WHERE Lieferstatus <> "entfallen" '
         + 'AND CDate(gilt_bis)-Date()<=' + delta_days
         + ' order by LKurzname;';
  Result:= RunSelectQuery(sql);
end;

///<summary> Liest LieferantenStatus im Klartext</summary>
function TWQryAccess.HoleLieferantenStatusTxt():Boolean;
  var
    sql: String;
begin
    SQL := 'select * from LieferantenStatusTxt; ';
  Result:= RunSelectQuery(sql);
end;

///<summary> Liest Tabelle LErklaerungen mit Zusazdaten zu Teilen. </summary>
function TWQryAccess.HoleLErklaerungen(IdLieferant:Integer):Boolean;
  var
    sql: String;
begin
  SQL := 'select Teile.TeileNr, LTeileNr, LPfk, TName1, TName2, Pumpenteil '
         + 'from LErklaerungen '
         + 'inner join Teile on LErklaerungen.TeileNr=Teile.TeileNr '
         + 'where IdLieferant= ?' ;
  Result:= RunSelectQueryWithParam(sql,[IntToSTr(IdLieferant)]);
end;

// Liest Statuswerte aus Tabelle ProgrammDaten
//----------------------------------------------------------------
function TWQryAccess.HoleProgrammDaten(Name: String):Boolean;
  var sql: String;

begin
  sql := 'select * From ProgrammDaten where name=? ;';

  Result:= RunSelectQueryWithParam(sql,[Name]);
end;

// Liest Bestellungen aus lokaler Tabelle
//---------------------------------------------------------------------------
function TWQryAccess.HoleBestellungen():Boolean;
begin
  var sql: String;
  sql := 'select * From Bestellungen;';
  Result:= RunSelectQuery(sql);
end;

// Liest Lieferanten aus lokaler Tabelle lieferanten
//---------------------------------------------------------------------------
function TWQryAccess.HoleLieferanten():Boolean;
begin
  var sql: String;
  sql := 'select IdLieferant from lieferanten ORDER BY IdLieferant;';

  Result:= RunSelectQuery(sql);
end;

// Liest Teile aus lokaler Tabelle Teile
//---------------------------------------------------------------------------
function TWQryAccess.HoleTeile():Boolean;
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
function TWQryAccess.UpdateLPfkInLErklaerungen(
                 IdLieferant:Integer; TeileNr:String; Pfk:Integer):Boolean;
  var
    sql: String;
begin
  SQL := 'Update LErklaerungen set LPfk="' + IntToSTr(Pfk) + '"  '
        +  'where IdLieferant=' + IntToSTr(IdLieferant) + ' '
        +  'and TeileNr="' + TeileNr + '";' ;
  Result:= RunExecSQLQuery(sql);
end;

///<summary> Setzt Stand, gilt_bis und lekl in Tabelle Lieferanten</summary>
function TWQryAccess.UpdateLieferant(IdLieferant:Integer;
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

///<summary> Setzt Stand (Bearbeitungsdatum) in Tabelle Lieferanten</summary>
function TWQryAccess.UpdateLieferantStand(IdLieferant:Integer;
                                               Stand:String):Boolean;
  var
    sql: String;
begin
      SQL := 'Update Lieferanten set stand=' +QuotedStr(Stand)
          +  ' where IdLieferant=' + IntToSTr(IdLieferant)  +';' ;
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
function TWQryAccess.LeklAlleTeileInTmpTabelle(delta_days:String):Boolean;
  var
    sql: String;
begin
      SQL := 'INSERT INTO tmpLieferantTeilPfk (TeileNr, IdLieferant, lekl) '
           + 'SELECT Teilenr, Lieferanten.IdLieferant, lekl '
           + 'FROM Lieferanten INNER JOIN LErklaerungen '
           + 'ON Lieferanten.IdLieferant=LErklaerungen.IdLieferant '
           + 'WHERE lekl=2 and Lieferstatus <> "entfallen" and '
           + 'CDate(gilt_bis)-Date()>' + delta_days + ' ;' ;
  Result:= RunExecSQLQuery(sql);
end;

///<summary>Fuege Teile von Lieferanten mit gültiger Erklärung "einige Teile"
///</summary>
function TWQryAccess.LeklEinigeTeileInTmpTabelle(delta_days:String):Boolean;
  var
    sql: String;
begin
      SQL := 'INSERT INTO tmpLieferantTeilPfk (TeileNr, IdLieferant, lekl) '
           + 'SELECT Teilenr, Lieferanten.IdLieferant, lekl '
           + 'FROM Lieferanten INNER JOIN LErklaerungen '
           + 'ON Lieferanten.IdLieferant=LErklaerungen.IdLieferant '
           + 'WHERE lekl=3 and Lieferstatus <> "entfallen" and LPfk=-1 and '
           + 'CDate(gilt_bis)-Date()>' + delta_days + ' ;' ;
  Result:= RunExecSQLQuery(sql);
end;


//---------------------------------------------------------------------------
///<summary> Anzahl der gültigen Lieferanten-Erklaerungen
///                           eines Teils in tmp Tabelle </summary>
function TWQryAccess.UpdateTmpAnzErklaerungenJeTeil():Boolean;
  var
    sql: String;
begin
  sql := 'INSERT INTO tmp_anz_xxx_je_teil ( TeileNr, n ) '
       + 'SELECT TeileNr, Count(TeileNr) AS n FROM tmpLieferantTeilPfk '
       + 'GROUP BY TeileNr; ' ;

  Result:= RunExecSQLQuery(sql);

end;

//---------------------------------------------------------------------------
///<summary> Anzahl der gültigen Lieferanten-Erklaerungen
///                           eines Teils in Tabelle Teile</summary>
function TWQryAccess.UpdateTeileZaehleGueltigeLErklaerungen():Boolean;
  var
    sql: String;
begin
  sql := 'UPDATE Teile INNER JOIN tmp_anz_xxx_je_teil '
       + 'ON Teile.TeileNr=tmp_anz_xxx_je_teil.TeileNr '
       + 'SET Teile.n_LPfk = tmp_anz_xxx_je_teil.n ;' ;

  Result:= RunExecSQLQuery(sql);

end;


// ---------------------------------------------------------------
//
// Nur lesen mit 1 einzigen Rückgabewert
//
// ---------------------------------------------------------------

//Anzahl der Einträge in tablename
function TWQryAccess.HoleAnzahlTabelleneintraege(tablename:String) :Integer;
var
  SQL:string;

begin
  SQL:='Select count(*) as n from ' + tablename + ';';
  RunSelectQuery(SQL);
  result:= FieldByName('n').AsInteger;
end;

function TWQryAccess.HoleAnzahlPumpenteile :Integer;
var
  SQL:string;
begin
  SQL:='Select count(*) as n from Teile where Pumpenteil=-1;';
  RunSelectQuery(SQL);
  result:= FieldByName('n').AsInteger;
end;

function TWQryAccess.HoleAnzahlPumpenteileMitPfk :Integer;
var
  SQL:string;
begin
  SQL := 'Select count(*) as n from Teile where Pumpenteil=-1 ' +
          'AND n_Lieferanten=n_LPfk;';
  RunSelectQuery(SQL);
  result:= FieldByName('n').AsInteger;
end;

function TWQryAccess.HoleAnzahlLieferanten():Integer;
var
  SQL:string;
begin
  SQL := 'Select count(*) as n from Lieferanten where Lieferstatus<>"entfallen"; ';
  RunSelectQuery(SQL);
  result:= FieldByName('n').AsInteger;
end;

function TWQryAccess.HoleAnzahlLieferPumpenteile():Integer;
var
  SQL:string;
begin
  SQL := 'Select count(*) as n from Lieferanten where Pumpenteile=-1 '
       + 'and Lieferstatus<>"entfallen" ; ';
  RunSelectQuery(SQL);
  result:= FieldByName('n').AsInteger;
end;

function TWQryAccess.HoleAnzahlLieferStatusUnbekannt():Integer;
var
  SQL:string;
begin
  SQL := 'Select count(*) as n from Lieferanten where Pumpenteile=-1 '
       + 'and Lieferstatus<>"entfallen" and lekl=0; ';

  RunSelectQuery(SQL);
  result:= FieldByName('n').AsInteger;
end;

// ---------------------------------------------------------------
//
// Abfragen zum Lesen/Schreiben der ProgrammDaten (Konfiguration)
//
// ---------------------------------------------------------------

function TWQryAccess.SchreibeProgrammDatenWert(Name,Wert:String):Boolean;
var
  SQL:string;
begin
  SQL := 'Update ProgrammDaten SET wert=' + Wert
       + ' where name="' + Name + '";' ;
  result:= RunExecSQLQuery(SQL);
end;

function TWQryAccess.LiesProgrammDatenWert(Name:String):String;
var
  SQL:string;
begin
  SQL := 'SELECT Wert FROM ProgrammDaten where Name=?; ';
  RunSelectQueryWithParam(SQL,[Name]);
  result:= FieldByName('Wert').AsString;
end;

end.
