===========
SQL-Strings
===========


.. ########################################################################################################
..                                 Basis-Import aus UNIPPS    
.. ########################################################################################################

Basis-Import
============

.. #######################################################################################

.. _SQLSucheBestellungen:

Bestellungen einlesen
---------------------

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


.. #################################################################################

.. _SQLSucheLieferantenTeilenummer:

Suche alle Lieferanten-Teilenummern
-----------------------------------

Lädt alle Lieferanten-Teilenummern aus UNIPPS-Tabelle Lieferant_teil.

Das SQL überspringt die ersten "skip" Datensätze.

Delphi: TWQryUNIPPS.SucheAlleLieferantenTeilenummern

::

  sql := 'SELECT skip ' + IntToStr(skip)
       + ' first ' +  IntToStr(size)
       + ' ident_nr1 as IdLieferant, TRIM(ident_nr2) AS TeileNr, '
       + 'TRIM(l_teile_nr) AS LTeileNr '
       + 'FROM lieferant_teil '
       + 'where length(l_teile_nr)>0 '
       + 'order by IdLieferant, TeileNr ';

.. #################################################################################

.. _SQLLieferantenTeileNrInTabelle:

Lieferanten-TeileNr in Tabelle
------------------------------

Überträgt die Lieferanten-TeileNr aus **tmp_LTeilenummern** nach **Bestellungen**.

Delphi: TWQryAccess.LieferantenTeileNrInTabelle

::

  sql := 'UPDATE Bestellungen INNER JOIN tmp_LTeilenummern '
       + 'ON Bestellungen.TeileNr = tmp_LTeilenummern.TeileNr '
       + 'AND Bestellungen.IdLieferant = tmp_LTeilenummern.IdLieferant '
       + 'SET Bestellungen.LTeileNr = tmp_LTeilenummern.LTeileNr ;' ;


.. #################################################################################

.. _SQLSucheTeileBenennung:

Suche Teile-Benennung
---------------------

Holt die Teile-Benennung und die Zeilen 1 und 2 der deutschen Benennung zu
den Teilen aus allen Bestellungen seit xxx Tagen (TODAY - freigabe_datum < ?)

Delphi: TWQryUNIPPS.SucheTeileBenennung

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

.. #################################################################################

.. _SQLTeileBenennung1:

Teile-Benennung 1 in Tabelle Teile
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Überträgt Teile-Nr und Zeile 1 der Benennung aus tmpTeileBenennung nach Teile.
Die Datensätze in Teile werden dabei angelegt

Delphi: TWQryAccess.TeileName1InTabelle

::
        
    INSERT INTO Teile (TeileNr, TName1, Pumpenteil, PFK)  
    SELECT TeileNr, Benennung AS TName1, 0, 0 
    FROM tmpTeileBenennung WHERE Zeile=1 ORDER BY TeileNr; 

.. #################################################################################

.. _SQLTeileBenennung2:

Teile-Benennung 2 in Tabelle Teile
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Überträgt Zeile 2 der Benennung  aus tmpTeileBenennung nach Teile

Delphi: TWQryAccess.TeileName2InTabelle

::
        
    UPDATE Teile INNER JOIN tmpTeileBenennung ON Teile.TeileNr = tmpTeileBenennung.TeileNr 
    SET Teile.TName2 = tmpTeileBenennung.Benennung WHERE tmpTeileBenennung.Zeile=2;


Pumpen und Ersatzteile bestimmen
--------------------------------


.. #################################################################################

.. _SQLTeilinKA:

Ist Teil in KA
~~~~~~~~~~~~~~

Sucht Teil als Position eines KA in UNIPPS auftragpos

Delphi: TWQryUNIPPS.SucheTeileInKA

::
        
    SELECT t_tg_nr FROM auftragpos where t_tg_nr=?;


.. #################################################################################

.. _SQLTeilinFA:

Ist Teil in FA
~~~~~~~~~~~~~~

Sucht Teil als Position eines FA in UNIPPS astuelipos

Delphi: TWQryUNIPPS.SucheTeileInFA

::
        
    SELECT t_tg_nr FROM astuelipos where t_tg_nr=?;


.. #################################################################################

.. _SQLTeilinSTU:

Ist Teil in STückliste
~~~~~~~~~~~~~~~~~~~~~~

Sucht Teil in Stücklisten in UNIPPS teil_stuelipos

Delphi: TWQryUNIPPS.SucheTeileInSTU

::
        
    SELECT t_tg_nr FROM teil_stuelipos where t_tg_nr=?;


.. #################################################################################

.. _SQLTeilinFAKopf:

Ist Teil in FA-Kopf
~~~~~~~~~~~~~~~~~~~

Sucht Teil in FA-Kopf in UNIPPS f_auftragkopf

Delphi: TWQryUNIPPS.SucheTeileInFAKopf

::
        
    SELECT t_tg_nr FROM f_auftragkopf where t_tg_nr=?


Lieferanten Adressen
--------------------


.. #################################################################################

.. _SQLLieferantenAdressen:

Hole Lieferanten Adressen
~~~~~~~~~~~~~~~~~~~~~~~~~

Lese Adressdaten **aller** Lieferanten (unabhängig von Tabelle Lieferanten) aus UNIPPS

Delphi: TWQryUNIPPS.HoleLieferantenAdressen

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


.. #################################################################################

.. _SQLLieferantenAnspechpartner:

Hole Lieferanten Anspechpartner
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Liest Anspechpartner der Lieferanten, die im Feld Klassifiz "LEKL" enthalten.
Diese sind für Lieferanten-Erklärungen zuständig (s. UNIPPS-Shell Lieferanten)

Delphi: TWQryUNIPPS.HoleLieferantenAnspechpartner

::

    sql := 'SELECT ident_nr1 as IdLieferant, ident_nr2 as IdPerson, '
         + 'Trim(Kurzname) as anrede, Trim(vorname) as vorname, '
         + 'Trim(name) as Nachname, '
         + 'trim(telefax) as telefax, Trim(email) as email '
         + 'FROM adresse_anspr '
         + 'JOIN anrede ON adresse_anspr.anrede=anrede.ident_nr '
         + 'WHERE UPPER(klassifiz) LIKE "%LEKL%";' ;


.. #################################################################################

.. _SQLLieferantenAnspechpartnerUebertragen:

Lieferanten Anspechpartner übertragen
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Überträgt Anspechpartner der Lieferanten aus der Tabelle Lieferanten_Ansprechpartner
in die Tabelle Lieferanten_Adressen und ersetzt dort den allgemeinen Anspechpartner.

Delphi: TWQryUNIPPS.UpdateLieferantenAnsprechpartner

::

  sql := 'UPDATE Lieferanten_Adressen '
       + 'INNER JOIN Lieferanten_Ansprechpartner '
       + 'ON Lieferanten_Adressen.IdLieferant = '
       + 'Lieferanten_Ansprechpartner.IdLieferant '
       + 'SET Lieferanten_Adressen.hat_LEKL_Ansprechp = True, '
       + 'Lieferanten_Adressen.Anrede = Lieferanten_Ansprechpartner.Anrede, '
       + 'Lieferanten_Adressen.Vorname = Lieferanten_Ansprechpartner.Vorname, '
       + 'Lieferanten_Adressen.Nachname = Lieferanten_Ansprechpartner.Nachname, '
       + 'Lieferanten_Adressen.email = Lieferanten_Ansprechpartner.email, '
       + 'Lieferanten_Adressen.telefax = Lieferanten_Ansprechpartner.telefax ;' ;


Lieferanten
-----------


.. #################################################################################

.. _SQLaktuelleLieferanten:

Markiere aktuelle Lieferanten in Tabelle "Lieferanten"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Markiere alle Lieferanten, die in Bestellungen stehen als aktuell.

Delphi: TWQryAccess.MarkiereAktuelleLieferanten

::

    update Lieferanten set Lieferstatus="aktuell" where  IdLieferant in (SELECT IdLieferant FROM Bestellungen); 


.. #################################################################################

.. _SQLneueLieferanten:

Neue Lieferanten in Tabelle "Lieferanten"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Übertrage Lieferanten, die in "Bestellungen" aber nicht in "Lieferanten" stehen.
Lieferstatus "neu" ist default in "Lieferanten"

Delphi: TWQryAccess.NeueLieferantenInTabelle

::

    INSERT INTO lieferanten ( IdLieferant, LKurzname, LName1, LName2  ) 
    SELECT DISTINCT IdLieferant, LKurzname, LName1, LName2  
    FROM Bestellungen where IdLieferant not in (SELECT IdLieferant FROM Lieferanten) ORDER BY IdLieferant;


.. #################################################################################

.. _SQLobsoleteLieferanten:

Markiere alte Lieferanten in Tabelle "Lieferanten"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Entfallene Lieferanten markieren, wenn sie nicht in Bestellungen stehen

Delphi: TWQryAccess.MarkiereAlteLieferanten

::
        
    Update Lieferanten set Lieferstatus="entfallen" 
    where IdLieferant not in (SELECT IdLieferant FROM Bestellungen); 


.. #################################################################################

.. _SQLLieferantenResetPumpenflags:

Reset Pumpen- und Ersatzteil-Flag in Tabelle "Lieferanten"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Setze Flag für Pumpen-/Ersatzteile-Lieferant zurück

Delphi: TWQryAccess.ResetPumpenErsatzteilMarkierungInLieferanten

::
        
    UPDATE Lieferanten SET Pumpenteile=0, Ersatzteile=0;


.. #################################################################################

.. _SQLLieferantenSetPumpenflags:

Markiere Pumpenteil-Lieferanten  in Tabelle "Lieferanten"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Markiere Lieferanten die mind. 1 Pumpenteil liefern

Delphi: TWQryAccess.MarkierePumpenteilLieferanten

::
        
    UPDATE Lieferanten SET Pumpenteile=-1 WHERE IdLieferant IN 
    (SELECT DISTINCT IdLieferant 
    FROM LErklaerungen INNER JOIN Teile ON LErklaerungen.TeileNr=Teile.TeileNr  WHERE Pumpenteil=-1);'


.. #################################################################################

.. _SQLLieferantenSetErsatzflags:

Markiere Ersatzteil-Lieferanten  in Tabelle "Lieferanten"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Markiere Lieferanten die mind. 1 Ersatzteil liefern

Delphi: TWQryAccess.MarkiereErsatzteilLieferanten

::
        
    UPDATE Lieferanten SET Ersatzteile=-1 WHERE IdLieferant IN 
    (SELECT DISTINCT IdLieferant 
    FROM LErklaerungen INNER JOIN Teile ON LErklaerungen.TeileNr=Teile.TeileNr  WHERE Ersatzteil=-1);


Lieferantenerklärungen
----------------------

.. #################################################################################

.. _SQLLErklaerungenNeu:

Neue Lieferantenerklärungen in Tabelle LErklaerungen
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Übertrage Daten aus Bestellungen in Lieferantenerklärungen, wenn die Teile-Lieferanten-Kombi
in Bestellungen, aber nicht in Lieferantenerklärungen vorhanden ist

Delphi: TWQryAccess.NeueLErklaerungenInTabelle

::
        
    Insert Into LErklaerungen (TeileNr, IdLieferant, LTeileNr, BestDatum, LPfk) 
    SELECT Bestellungen.TeileNr, Bestellungen.IdLieferant, Bestellungen.LTeileNr, Bestellungen.BestDatum, 0 as LPfk 
    from Bestellungen left join LErklaerungen 
    on Bestellungen.TeileNr=LErklaerungen.TeileNr and Bestellungen.IdLieferant = LErklaerungen.IdLieferant 
    WHERE LErklaerungen.IdLieferant Is Null


.. #################################################################################

.. _SQLLErklaerungenObsolet:

Obsolete Lieferantenerklärungen loeschen
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Lösche Teile-Lieferanten-Kombis, die nicht in Bestellungen sind aus Lieferantenerklärungen.
 
Delphi: TWQryAccess.AlteLErklaerungenLoeschen

::
        
    DELETE FROM LErklaerungen WHERE Id IN (
    SELECT Id FROM LErklaerungen LEFT JOIN Bestellungen ON 
    Bestellungen.TeileNr=LErklaerungen.TeileNr AND Bestellungen.IdLieferant = LErklaerungen.IdLieferant 
    WHERE Bestellungen.IdLieferant Is Null );'



Anzahl Lieferanten je Teil
--------------------------


.. #################################################################################

.. _SQLTmpAnzLieferantenJeTeil:

Zähle Lieferanten je Teil (tmp)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Anzahl der Lieferanten eines Teils in tmp Tabelle tmp_anz_xxx_je_teil 

Delphi: TWQryAccess.UpdateTmpAnzLieferantenJeTeil

::
        
    INSERT INTO tmp_anz_xxx_je_teil ( TeileNr, n ) 
    SELECT TeileNr, Count(TeileNr) AS n FROM LErklaerungen GROUP BY TeileNr; 


.. #################################################################################

.. _SQLTeileAnzLieferanten:

Anzahl Lieferanten je Teil in Tabelle Teile
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Delphi: TWQryAccess.UpdateTeileZaehleLieferanten

::
        
    UPDATE Teile INNER JOIN tmp_anz_xxx_je_teil 
    ON Teile.TeileNr=tmp_anz_xxx_je_teil.TeileNr 
    SET Teile.n_Lieferanten = tmp_anz_xxx_je_teil.n;

.. ########################################################################################################
..                                 Abfragen für Formulare
.. ########################################################################################################

Formulare
=========

.. #################################################################################
..                         Formulare:    Select-Abfragen
.. #################################################################################


.. _SQLHoleLieferantenMitAdressen:

Hole Lieferanten mit Adressen
-----------------------------

Basis für Formular zum Anfordern von Lieferanten-Erklärungen "LieferantenErklAnfordernFrm"

Delphi: TWQryAccess.HoleLieferantenMitAdressen

::

  sql := 'Select Lieferanten.IdLieferant, LKurzname, Stand, gilt_bis, letzteAnfrage, '
       + 'lekl, StatusTxt, Kommentar, Pumpenteile, Ersatzteile, '
       + 'name1,name2,strasse,plz_haus,ort,staat,telefax,email, '
       + 'hat_LEKL_Ansprechp,Anrede,Vorname,Nachname, '
       + 'CDate(gilt_bis)-Date() as gilt_noch, '
       + 'Date()-CDate(letzteAnfrage) as angefragt_vor_Tagen, '
       + 'CDate(Stand)-CDate(letzteAnfrage) as Stand_minus_Anfrage '
       + 'from (Lieferanten '
       + 'inner join Lieferanten_Adressen '
       + 'on Lieferanten.IdLieferant=Lieferanten_Adressen.IdLieferant) '
       + 'inner join LieferantenStatusTxt '
       + 'on LieferantenStatusTxt.id=lieferanten.lekl '
       + 'WHERE Lieferstatus <> "entfallen" '
       + 'order by LKurzname; ' ;


.. #################################################################################

.. _SQLHoleLErklaerungen:

Hole LErklaerungen
------------------

Liest Tabelle LErklaerungen mit Zusazdaten zu Teilen als Basis des Formulars :ref:`LeklTeileEingabeFrame<FormLeklTeileEingabeFrame>` 

Delphi: TWQryAccess.HoleLErklaerungen

::

  SQL := 'select Teile.TeileNr, LTeileNr, LPfk, TName1, TName2, Pumpenteil '
         + 'from LErklaerungen '
         + 'inner join Teile on LErklaerungen.TeileNr=Teile.TeileNr '
         + 'where IdLieferant= ?' ;

.. #################################################################################

.. _SQLHoleLieferantenFuerTeileEingabe:

Hole Lieferanten für teilespez. Eingabe
---------------------------------------

Liest Lieferanten fuer die teilespezifische Eingabe

Liest nur Lieferanten die Pumpenteile liefern mit gültiger Erklärung (Anzahl Tage Restgültig.> min_guelt)
mit Status der LEKL=3 (einige Teile)

Delphi: TWQryAccess.HoleLieferantenFuerTeileEingabe

::

    SQL := 'select lieferanten.*, '
         + 'Date()-CDate(Stand) as AlterStand, '
         + 'Date()-CDate(StandTeile) as AlterStandTeile '
         + 'from lieferanten '
         + 'WHERE Lieferstatus <> "entfallen" '
         + 'AND Pumpenteile=-1 AND lekl=3 '
         + 'AND CDate(gilt_bis)-Date() >' + min_guelt
         + ' ORDER by LKurzname;';


.. #################################################################################
..                         Formulare Update-Abfragen
.. #################################################################################

.. #################################################################################

.. _SQLUpdateLieferant:

Update Lieferant
----------------

Pflege der Tabelle Lieferanten nach Status-Eingabe im Dialog "LieferantenStatusDlg".

Delphi: TWQryAccess.UpdateLieferant

::

      SQL := 'Update Lieferanten set stand="' + Stand + ' " , '
          +  'gilt_bis=' + QuotedStr(GiltBis) + ', '
          +  'lekl=' + QuotedStr(lekl) + ', '
          +  ' Kommentar=' + QuotedStr(Kommentar)
          +  ' where IdLieferant=' + IntToSTr(IdLieferant)  +';' ;



.. #################################################################################

.. _SQLUpdateLPfkInLErklaerungen:

Update LPfk in LErklaerungen
----------------------------

Setzt LPfk-Flag in Tabelle LErklaerungen.

Delphi: TWQryAccess.UpdateLPfkInLErklaerungen

::

  SQL := 'Update LErklaerungen set LPfk="' + IntToSTr(Pfk) + '"  '
        +  'where IdLieferant=' + IntToSTr(IdLieferant) + ' '
        +  'and TeileNr="' + TeileNr + '";' ;
  Result:= RunExecSQLQuery(sql);



.. ########################################################################################################
..                                 Finale Auswertung
.. ########################################################################################################

Auswertung
==========

.. #################################################################################

.. _SQLLeklMarkiereAlleTeile:

Lekl Markiere Alle Teile
------------------------

markiere Teile von Lieferanten mit gültiger Erklärung "alle Teile" in Tabelle LErklaerungen

Delphi: TWQryAccess.LeklMarkiereAlleTeile

::

      SQL := 'UPDATE LErklaerungen SET LPfk_berechnet=-1 '
           + 'WHERE IdLieferant IN '
           + '( SELECT IdLieferant FROM Lieferanten '
           + 'WHERE lekl=2 and Lieferstatus <> "entfallen" and '
           //Lekl gilt noch mindestens
           + 'CDate(gilt_bis)-Date()>' + delta_days + ' );' ;

.. #################################################################################

.. _SQLLeklMarkiereEinigeTeile:

Lekl Markiere Einige Teile
--------------------------

markiere Teile von Lieferanten mit gültiger Erklärung "einige Teile" in Tabelle LErklaerungen

Delphi: TWQryAccess.LeklMarkiereEinigeTeile

::

      SQL := 'UPDATE LErklaerungen '
           + 'INNER JOIN Lieferanten '
           + 'ON Lieferanten.IdLieferant=LErklaerungen.IdLieferant '
           + 'SET LPfk_berechnet=-1 '
           + 'WHERE lekl=3 and Lieferstatus <> "entfallen" and LPfk=-1 and '
           //Eingabe der teilspez. Lekl nach Eingabe allgem. Status
           + 'CDate(StandTeile)>CDate(Stand) and '
           //Lekl gilt noch mindestens
           + 'CDate(gilt_bis)-Date()>' + delta_days + ' ;' ;

.. #################################################################################

.. _SQLUpdateTeileDeletePFK:

Update Teile Delete PFK
-----------------------

Loesche PFK-Flag eines Teils in Tabelle Teile, wenn ein Lieferant EU-Herkunft nicht bestätigt

Delphi: TWQryAccess.UpdateTeileDeletePFK

::

  sql := 'UPDATE Teile SET Pfk=0 '
       + 'WHERE TeileNr IN '
       + '(SELECT TeileNr FROM LErklaerungen '
       + 'WHERE LPfk_berechnet=0);' ;

.. #################################################################################

.. _SQLUpdatePFKTabellePFK0:

Update PFK-Tabelle PFK0
------------------------

Übertrage Teile mit in UNIPPS zu loeschenden PFK-Flags in Tabelle Export_PFK

Delphi: TWQryAccess.UpdatePFKTabellePFK0

::

  sql := 'INSERT INTO Export_PFK ( t_tg_nr, PFK ) '
       + 'SELECT tmp_wareneingang_mit_PFK.t_tg_nr, 0 AS Pfk '
       + 'FROM tmp_wareneingang_mit_PFK '
       + 'INNER JOIN LErklaerungen '
       + 'ON tmp_wareneingang_mit_PFK.lieferant = LErklaerungen.IdLieferant '
       + 'AND tmp_wareneingang_mit_PFK.t_tg_nr = LErklaerungen.TeileNr '
       + 'WHERE LErklaerungen.LPfk_berechnet=0 '
       + 'ORDER BY t_tg_nr;';

.. #################################################################################

.. _SQLUpdatePFKTabellePFK1:

Update PFK-Tabelle PFK1
-----------------------

Übertrage Teile mit in UNIPPS zu setzenden PFK-Flags in Tabelle Export_PFK

Delphi: TWQryAccess.UpdatePFKTabellePFK1

::

  sql := 'INSERT INTO Export_PFK ( t_tg_nr, PFK ) '
       + 'SELECT Teile.TeileNr, Teile.PFK '
       + 'FROM Teile '
       + 'WHERE Teile.PFK=-1;' ;


.. #################################################################################

.. _SQLHoleWareneingaenge:

Hole Wareneingaenge
-------------------

Sucht Wareneingaenge seit Beginn des aktuellen Jahres mit PFK gesetzt.

Delphi: TWQryUNIPPS.HoleWareneingaenge


Sub-Query sucht Wareneingaenge seit Beginn des aktuellen Jahres

::

    sql_sub := 'SELECT DISTINCT t_tg_nr, lieferant '
        + 'FROM wareneingang '
        + 'JOIN wepos '
        + 'ON wareneingang.ident_nr = wepos.ident_nr1 '
        + 'WHERE wareneingang.status>0 AND wareneingang.art=1 '
        + 'AND wareneingang.we_art=1 '
        + 'AND wareneingang.we_datum>=MDY(1,1,YEAR(TODAY))' ;

Join mit UNIPPS-Teil (nur Teile mit praeferenzkennung=1)

::

    sql := 'SELECT t_tg_nr, lieferant '
        + 'FROM Teil '
        + 'JOIN ( ' + sql_sub + ') '
        + 'ON Teil.ident_nr = t_tg_nr '
        + 'WHERE praeferenzkennung=1;' ;

