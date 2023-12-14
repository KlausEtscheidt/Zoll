===========
SQL-Strings
===========

Basis-Import
============

Bestellungen einlesen
---------------------

.. _SQLSucheBestellungen:

Delphi: TWQryUNIPPS.SucheBestellungen

Liest Bestellungen, der Teile und Lieferanten aus UNIPPS.
Die Felder werden mit Delphi in die Access-Tabelle :ref:`Bestellungen <TabBestellungen>` geschrieben.

::

    SELECT IdLieferant, trim(TeileNr) as TeileNr, BestDatum, trim(adresse.kurzname) AS LKurzname, 
    trim(adresse.name1) AS LName1, trim(adresse.name2) AS LName2, TODAY as eingelesen 
    FROM (
    SELECT IdLieferant, TeileNr, max(BestDatumSub) as BestDatum 
    FROM (
    SELECT lieferant as IdLieferant, t_tg_nr as TeileNr, freigabe_datum as BestDatumSub 
    FROM bestellkopf 
    INNER JOIN bestellpos ON bestellkopf.ident_nr = bestellpos.ident_nr1 
    where TODAY - freigabe_datum <  ?  ) 
    GROUP BY IdLieferant, TeileNr order by TeileNr, IdLieferant) as Bestellungen 
    INNER JOIN lieferant on lieferant.ident_nr = IdLieferant 
    INNER JOIN adresse on lieferant.adresse = adresse.ident_nr

Die innerste Sub-Query

|    SELECT lieferant as IdLieferant, t_tg_nr as TeileNr, freigabe_datum as BestDatumSub 
|    FROM bestellkopf 
|    INNER JOIN bestellpos ON bestellkopf.ident_nr = bestellpos.ident_nr1 
|    where TODAY - freigabe_datum <  ?  

verknüpft *bestellkopf* mit *bestellpos* und liefert alle Bestellungen und ihre Teile, bei denen das UNIPPS-Freigabedatum
nicht mehr als *?* Tage zurück liegt (TODAY - freigabe_datum <  ?).  

? wird TWQryUNIPPS.SucheBestellungen als Parameter übergeben.

Die nächst äußere Sub-Query *Bestellungen*

|   SELECT IdLieferant, TeileNr, max(BestDatumSub) as BestDatum 
|   FROM (   *innerste Sub-Query* )
|   GROUP BY IdLieferant, TeileNr order by TeileNr, IdLieferant) as Bestellungen 

liefert für jede Kombination aus IdLieferant und TeileNr das Datum der jüngsten Bestellung.

Die Gesamtabfrage verknüpft dann die Sub-Query *Bestellungen* mit den UNIPPS-Tabellen *lieferant* und *adresse*
um die Kurz- und Langnamen des Lieferanten zu erhalten.

|    SELECT IdLieferant, trim(TeileNr) as TeileNr, BestDatum, trim(adresse.kurzname) AS LKurzname, 
|    trim(adresse.name1) AS LName1, trim(adresse.name2) AS LName2, TODAY as eingelesen 
|    FROM Bestellungen 
|    INNER JOIN lieferant on lieferant.ident_nr = IdLieferant 
|    INNER JOIN adresse on lieferant.adresse = adresse.ident_nr


Suche Lieferanten Teilenummer
-----------------------------

TWQryUNIPPS.SucheLieferantenTeilenummer(IdLieferant: String; TeileNr: String): Boolean;

::

   SELECT ident_nr1 as IdLieferant, TRIM(ident_nr2) AS TeileNr, TRIM(l_teile_nr) AS LTeileNr 
   FROM lieferant_teil where ident_nr1=? and ident_nr2=?;

mit ident_nr1=IdLieferant ident_nr2=TeileNr als Parameter


Suche Teile-Benennung
---------------------

Holt die Teile-Benennung und die Zeilen 1 und 2 der deutschen Benennung zu
den Teilen aus allen Bestellungen seit xxx Tagen (TODAY - freigabe_datum < ?)

TWQryUNIPPS.SucheTeileBenennung

::

    SELECT trim(ident_nr1) as TeileNr, art as Zeile, trim(Text) as Benennung FROM teil_bez  
    where (art=1 or art=2) and sprache="D" and ident_nr1 in 
    (SELECT TeileNr FROM 
    (SELECT bestellkopf.lieferant as IdLieferant, bestellpos.t_tg_nr as TeileNr, bestellkopf.freigabe_datum as BestDatumSub 
    FROM bestellkopf INNER JOIN bestellpos ON bestellkopf.ident_nr = bestellpos.ident_nr1 
    where TODAY - freigabe_datum <  ?  ) 
    group by TeileNr ) order by ident_nr1 


Teile
-----

Teile-Benennung 1 in Tabelle Teile
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Überträgt Teile-Nr und Zeile 1 der Benennung aus tmpTeileBenennung nach Teile.
Die Datensätze in Teile werden dabei angelegt

TWQryAccess.TeileName1InTabelle

INSERT INTO Teile (TeileNr, TName1, Pumpenteil, PFK)  
SELECT TeileNr, Benennung AS TName1, 0, 0 
FROM tmpTeileBenennung WHERE Zeile=1 ORDER BY TeileNr; 

Teile-Benennung 2 in Tabelle Teile
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Überträgt Zeile 2 der Benennung  aus tmpTeileBenennung nach Teile

TWQryAccess.TeileName2InTabelle

UPDATE Teile INNER JOIN tmpTeileBenennung ON Teile.TeileNr = tmpTeileBenennung.TeileNr 
SET Teile.TName2 = tmpTeileBenennung.Benennung WHERE tmpTeileBenennung.Zeile=2;


Pumpen und Ersatzteile bestimmen
--------------------------------

Ist Teil in KA
~~~~~~~~~~~~~~

Sucht Teil als Position eines KA in UNIPPS auftragpos

TWQryUNIPPS.SucheTeileInKA

SELECT t_tg_nr FROM auftragpos where t_tg_nr=?;

Ist Teil in FA
~~~~~~~~~~~~~~

Sucht Teil als Position eines FA in UNIPPS astuelipos

TWQryUNIPPS.SucheTeileInFA

SELECT t_tg_nr FROM astuelipos where t_tg_nr=?;

Ist Teil in STückliste
~~~~~~~~~~~~~~~~~~~~~~

Sucht Teil in Stücklisten in UNIPPS teil_stuelipos

TWQryUNIPPS.SucheTeileInSTU

SELECT t_tg_nr FROM teil_stuelipos where t_tg_nr=?;

Ist Teil in FA-Kopf
~~~~~~~~~~~~~~~~~~~

Sucht Teil in FA-Kopf in UNIPPS f_auftragkopf

TWQryUNIPPS.SucheTeileInFAKopf

SELECT t_tg_nr FROM f_auftragkopf where t_tg_nr=?


Lieferanten Adressen
--------------------

Hole Lieferanten Adressen
~~~~~~~~~~~~~~~~~~~~~~~~~

Lese Adressdaten **aller** Lieferanten (unabhängig von Tabelle Lieferanten) aus UNIPPS

TWQryUNIPPS.HoleLieferantenAdressen

::

    sql := 'SELECT lieferant.ident_nr as IdLieferant,adresse, '
         + 'Trim(kurzname) as kurzname, Trim(name1) as name1, '
         + 'Trim(name2) as name2, Trim(name3) as name3, Trim(name4) as name4,'
         + 'Trim(strasse) as strasse, Trim(postfach) as postfach, '
         + 'Trim(staat) as staat, Trim(plz_haus) as plz_haus, '
         + 'Trim(plz_postfach) as plz_postfach, Trim(ort) as ort,'
         + 'Trim(ort_postfach) as ort_postfach, Trim(telefon) as telefon,'
         + 'trim(telefax) as telefax, Trim(email) as email '
         + 'FROM lieferant '
         + 'INNER JOIN adresse ON lieferant.adresse = adresse.ident_nr;' ;

Hole Lieferanten Anspechpartner
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Liest Anspechpartner der Lieferanten, die im Feld Klassifiz "LEKL" enthalten.
Diese sind für Lieferanten-Erklärungen zuständig (s. UNIPPS-Shell Lieferanten)

TWQryUNIPPS.HoleLieferantenAnspechpartner

::

    sql := 'SELECT ident_nr1 as IdLieferant, ident_nr2 as IdPerson, '
         + 'Trim(Kurzname) as anrede, Trim(vorname) as vorname, '
         + 'Trim(name) as Nachname, '
         + 'trim(telefax) as telefax, Trim(email) as email '
         + 'FROM adresse_anspr '
         + 'JOIN anrede ON adresse_anspr.anrede=anrede.ident_nr '
         + 'WHERE UPPER(klassifiz) LIKE "%LEKL%";' ;

Lieferanten
-----------

Markiere aktuelle Lieferanten in Tabelle "Lieferanten"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Markiere alle Lieferanten, die in Bestellungen stehen als aktuell.

TWQryAccess.MarkiereAktuelleLieferanten

update Lieferanten set Lieferstatus="aktuell" where  IdLieferant in (SELECT IdLieferant FROM Bestellungen); 

Neue Lieferanten in Tabelle "Lieferanten"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Übertrage Lieferanten, die in "Bestellungen" aber nicht in "Lieferanten" stehen.
Lieferstatus "neu" ist default in "Lieferanten"
TWQryAccess.NeueLieferantenInTabelle

'INSERT INTO lieferanten ( IdLieferant, LKurzname, LName1, LName2  ) 
SELECT DISTINCT IdLieferant, LKurzname, LName1, LName2  
FROM Bestellungen where IdLieferant not in (SELECT IdLieferant FROM Lieferanten) ORDER BY IdLieferant;'

Markiere alte Lieferanten in Tabelle "Lieferanten"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Entfallene Lieferanten markieren, wenn sie nicht in Bestellungen stehen
TWQryAccess.MarkiereAlteLieferanten

update Lieferanten set Lieferstatus="entfallen" 
where IdLieferant not in (SELECT IdLieferant FROM Bestellungen); 

Reset Pumpen- und Ersatzteil-Flag in Tabelle "Lieferanten"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Setze Flag für Pumpen-/Ersatzteile-Lieferant zurück

TWQryAccess.ResetPumpenErsatzteilMarkierungInLieferanten

UPDATE Lieferanten SET Pumpenteile=0, Ersatzteile=0;

Markiere Pumpenteil-Lieferanten  in Tabelle "Lieferanten"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Markiere Lieferanten die mind. 1 Pumpenteil liefern

TWQryAccess.MarkierePumpenteilLieferanten

UPDATE Lieferanten SET Pumpenteile=-1 WHERE IdLieferant IN 
(SELECT DISTINCT IdLieferant 
FROM LErklaerungen INNER JOIN Teile ON LErklaerungen.TeileNr=Teile.TeileNr  WHERE Pumpenteil=-1);'

Markiere Ersatzteil-Lieferanten  in Tabelle "Lieferanten"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Markiere Lieferanten die mind. 1 Ersatzteil liefern

TWQryAccess.MarkiereErsatzteilLieferanten

UPDATE Lieferanten SET Ersatzteile=-1 WHERE IdLieferant IN 
(SELECT DISTINCT IdLieferant 
FROM LErklaerungen INNER JOIN Teile ON LErklaerungen.TeileNr=Teile.TeileNr  WHERE Ersatzteil=-1);

Lieferantenerklärungen
----------------------

Neue Lieferantenerklärungen in Tabelle LErklaerungen
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Übertrage Daten aus Bestellungen in Lieferantenerklärungen, wenn die Teile-Lieferanten-Kombi
in Bestellungen, aber nicht in Lieferantenerklärungen vorhanden ist

TWQryAccess.NeueLErklaerungenInTabelle

Insert Into LErklaerungen (TeileNr, IdLieferant, LTeileNr, BestDatum, LPfk) 
SELECT Bestellungen.TeileNr, Bestellungen.IdLieferant, Bestellungen.LTeileNr, Bestellungen.BestDatum, 0 as LPfk 
from Bestellungen left join LErklaerungen 
on Bestellungen.TeileNr=LErklaerungen.TeileNr and Bestellungen.IdLieferant = LErklaerungen.IdLieferant 
WHERE LErklaerungen.IdLieferant Is Null

Obsolete Lieferantenerklärungen loeschen
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Lösche Teile-Lieferanten-Kombis, die nicht in Bestellungen sind aus Lieferantenerklärungen.
 
TWQryAccess.AlteLErklaerungenLoeschen

DELETE FROM LErklaerungen WHERE Id IN (
SELECT Id FROM LErklaerungen LEFT JOIN Bestellungen ON 
Bestellungen.TeileNr=LErklaerungen.TeileNr AND Bestellungen.IdLieferant = LErklaerungen.IdLieferant 
WHERE Bestellungen.IdLieferant Is Null );'


Anzahl Lieferanten je Teil
--------------------------

Zähle Lieferanten je Teil (tmp)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Anzahl der Lieferanten eines Teils in tmp Tabelle tmp_anz_xxx_je_teil 

TWQryAccess.UpdateTmpAnzLieferantenJeTeil

INSERT INTO tmp_anz_xxx_je_teil ( TeileNr, n ) 
SELECT TeileNr, Count(TeileNr) AS n FROM LErklaerungen GROUP BY TeileNr; 


Anzahl Lieferanten je Teil  in Tabelle Teile
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

TWQryAccess.UpdateTeileZaehleLieferanten

UPDATE Teile INNER JOIN tmp_anz_xxx_je_teil 
ON Teile.TeileNr=tmp_anz_xxx_je_teil.TeileNr 
SET Teile.n_Lieferanten = tmp_anz_xxx_je_teil.n;