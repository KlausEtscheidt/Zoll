Abläufe
=======

.. contents:: Datenbank-Manipulationen
   :depth: 2
   :local:

UNIPPS-Import (Basis-Import)
----------------------------

Der Import erfolgt über die procedure TBasisImport.Execute aus Unit Import;

1. Bestellungen
~~~~~~~~~~~~~~~

Tabelle: Bestellungen löschen und neu füllen  (:ref:`SQL <SQLSucheBestellungen>`).

procedure TBasisImport.BestellungenAusUnipps;

Aus Tabelle ProgrammDaten wird das Feld 'Bestellzeitraum' gelesen.
Dieses definiert die älteste Bestellung, die importiert wird.

2. Lieferanten-Teilenummer
~~~~~~~~~~~~~~~~~~~~~~~~~~

Tabelle: Bestellungen updaten (:ref:`SQL <SQLSucheLieferantenTeilenummer>`)

procedure TBasisImport.LieferantenTeilenummerAusUnipps();

Für jede Lieferanten/Teile-Kombination aus Bestellungen wird in UNIPPS
eine Lieferanten-Teilenummer gesucht und in Bestellungen abgespeichert.

Der Prozess ist langsam und schlägt per ODBC immer wieder mal fehl (erst beim lesen des recordsets).
Deshalb wird jede Kombi einzeln gesucht, die Fehler werden abgefangen.

3. Teile-Benennung
~~~~~~~~~~~~~~~~~~

Tabelle: tmpTeileBenennung löschen und neu füllen (:ref:`SQL <SQLSucheTeileBenennung>`)

procedure TBasisImport.TeileBenennungAusUnipps;

Holt die Teile-Benennung und die Zeilen 1 und 2 der deutschen Benennung zu
den Teilen aus allen Bestellungen seit xxx Tagen.

xxx entspricht dem Feld 'Bestellzeitraum' aus Tabelle ProgrammDaten.

4. Teile
~~~~~~~~~~~~~~~~~~

Tabelle: Teile löschen und neu füllen

Schritt1: Teile-Nr und Benennungszeile 1 aus tmpTeileBenennung in Teile (:ref:`SQL <SQLTeileBenennung1>`)

Schritt2: Benennungszeile 2 aus tmpTeileBenennung in Teile (:ref:`SQL <SQLTeileBenennung2>`)

procedure TBasisImport.TeileBenennungInTeileTabelle();


5. Bestimme Pumpen- und Ersatzteile
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Tabelle: Teile ändern

procedure TBasisImport.PumpenteileAusUnipps();

Für jedes Teil in Tabelle Teile prüfen:

   - Ist das Teil in einem Kundenauftrag, ist es ein Ersatzteil. Die Prüfung ist dann beendet. (:ref:`SQL <SQLTeilinKA>`)
   - Ist das Teil in einem Fertigungsauftrag (Pumpenmontage), ist es ein Pumpenteil (da kein Ersatzteil) (:ref:`SQL <SQLTeilinFA>`)
   - Ist das Teil in einer Teile-Stückliste, ist es ein Pumpenteil (:ref:`SQL <SQLTeilinSTU>`)
   - Ist das Teil im Kopf eines Fertigungsauftrags (es wird gefertigt), ist es ein Pumpenteil (:ref:`SQL <SQLTeilinFAKopf>`)

Die Pumpen- und Ersatzteil-Flags in Teile werden gesetzt.


6. Lieferanten-Adressen lesen
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Tabelle: Lieferanten_Adressen löschen und neu füllen (:ref:`SQL <SQLLieferantenAdressen>`)

Tabelle: Lieferanten_Ansprechpartner löschen und neu füllen (:ref:`SQL <SQLLieferantenAnspechpartner>`)

procedure LieferantenAdressdatenAusUnipps();

In Lieferanten_Adressen stehen die allgemeinen Firmenadressen (mail,fax,post,etc).

In Lieferanten_Ansprechpartner stehen spezielle Personen, falls vorhanden, die für Lieferantenerklärungen zuständig sind.


7. Lieferanten pflegen
~~~~~~~~~~~~~~~~~~~~~~

Tabelle: Lieferanten ändern

procedure TBasisImport.LieferantenTabelleUpdaten();

Markiere zuerst alle Lieferanten als aktuell (:ref:`SQL <SQLaktuelleLieferanten>`)

Übernehme Lieferanten, die in "Bestellungen" aber nicht in "Lieferanten" stehen als neu (:ref:`SQL <SQLneueLieferanten>`).

Markiere Lieferanten, die in "Lieferanten" aber nicht in "Bestellungen" stehen als entfallen(:ref:`SQL <SQLobsoleteLieferanten>`).

Setze Flags auf false, die besagen, das ein Lieferant Pumpen- oder Ersatzteile liefert (:ref:`SQL <SQLLieferantenResetPumpenflags>`).

Setze die Flags für Pumpen-(:ref:`SQL <SQLLieferantenSetPumpenflags>`)/Ersatzteile-Lieferanten (:ref:`SQL <SQLLieferantenSetErsatzflags>`)neu


8. Lieferanten-Erklärungen
~~~~~~~~~~~~~~~~~~~~~~~~~~

Tabelle: LErklaerungen

procedure TBasisImport.LErklaerungenUpdaten

Übertrage Daten aus Bestellungen nach Lieferantenerklärungen, wenn die Teile-Lieferanten-Kombi 
in Bestellungen, aber nicht in Lieferantenerklärungen vorhanden ist (:ref:`SQL <SQLLErklaerungenNeu>`).

Lösche Teile-Lieferanten-Kombis, die nicht in Bestellungen sind aus Lieferantenerklärungen (:ref:`SQL <SQLLErklaerungenObsolet>`).
 

9. Anzahl der Lieferanten je Teil
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Tabelle: tmp_anz_xxx_je_teil loeschen und neu füllen (:ref:`SQL <SQLTmpAnzLieferantenJeTeil>`).

Tabelle Teile: ändern  (:ref:`SQL <SQLTeileAnzLieferanten>`).

procedure TBasisImport.TeileUpdateZaehleLieferanten

Anzahl der Lieferanten eines Teils in tmp Tabelle tmp_anz_xxx_je_teil Speichern

Anzahl Tabelle Teile übertragen
 

manuelle Pflege
---------------
- Pflege des Lieferantenstatus bzgl Lieferanten-Erklärung inkl Gültigkeit Abfrage "HoleLieferantenMitStatusTxt" für Formular "LieferantenStatusFrame"
- Eingabe der teilebezogenen Lieferanten-Erklärungen in LErklaerungen Abfrage "HoleLErklaerungen" für Formular "LieferantenErklaerungenFrame" 

Auswertung
----------
- 