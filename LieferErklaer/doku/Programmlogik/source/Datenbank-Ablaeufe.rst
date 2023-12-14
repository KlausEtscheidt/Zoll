Abläufe
=======

.. contents:: Datenbank-Manipulationen
   :depth: 2
   :local:

UNIPPS-Import (Basis-Import)
----------------------------

procedure TBasisImport.Execute aus Unit Import;

1. Bestellungen
~~~~~~~~~~~~~~~

Tabelle: Bestellungen löschen und neu füllen  (s.auch :ref:`SQL <SQLSucheBestellungen>`).

procedure TBasisImport.BestellungenAusUnipps;

Aus Tabelle ProgrammDaten wird das Feld 'Bestellzeitraum' gelesen.
Dieses definiert die älteste Bestellung, die importiert wird.

2. Lieferanten-Teilenummer
~~~~~~~~~~~~~~~~~~~~~~~~~~

Tabelle: Bestellungen

procedure TBasisImport.LieferantenTeilenummerAusUnipps();

Für jede Lieferanten/Teile-Kombination aus Bestellungen wird in UNIPPS
eine Lieferanten-Teilenummer gesucht und in Bestellungen abgespeichert.

Der Prozess ist langsam und schlägt per ODBC immer wieder mal fehl (erst beim lesen des recordsets).
Deshalb wird jede Kombi einzeln gesucht, die Fehler werden abgefangen.

3. Teile-Benennung
~~~~~~~~~~~~~~~~~~

Tabelle: tmpTeileBenennung löschen und neu füllen

procedure TBasisImport.TeileBenennungAusUnipps;

Holt die Teile-Benennung und die Zeilen 1 und 2 der deutschen Benennung zu
den Teilen aus allen Bestellungen seit xxx Tagen.

xxx entspricht dem Feld 'Bestellzeitraum' aus Tabelle ProgrammDaten.

4. Teile
~~~~~~~~~~~~~~~~~~

Tabelle: Teile löschen und neu füllen

Überträgt Benennung aus tmpTeileBenennung in Teile

procedure TBasisImport.TeileBenennungInTeileTabelle();


5. Bestimme Pumpen- und Ersatzteile
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Tabelle: Teile ändern

procedure TBasisImport.PumpenteileAusUnipps();

Für jedes Teil in Tabelle Teile prüfen:

   - Ist das Teil in einem Kundenauftrag, ist es ein Ersatzteil. Die Prüfung ist dann beendet.
   - Ist das Teil in einem Fertigungsauftrag (Pumpenmontage), ist es ein Pumpenteil (da kein Ersatzteil)
   - Ist das Teil in einer Teile-Stückliste, ist es ein Pumpenteil
   - Ist das Teil im Kopf eines Fertigungsauftrags (es wird gefertigt), ist es ein Pumpenteil

Die Pumpen- und Ersatzteil-Flags in Teile werden gesetzt.


6. Lieferanten-Adressen lesen
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Tabelle: Lieferanten_Adressen löschen und neu füllen
Tabelle: Lieferanten_Ansprechpartner löschen und neu füllen

procedure LieferantenAdressdatenAusUnipps();


7. Lieferanten pflegen
~~~~~~~~~~~~~~~~~~~~~~

Tabelle: Lieferanten

procedure TBasisImport.LieferantenTabelleUpdaten();

Markiere zuerst alle Lieferanten als aktuell.
Übernehme Lieferanten, die in "Bestellungen" aber nicht in "Lieferanten" stehen als neu.
Markiere Lieferanten, die in "Lieferanten" aber nicht in "Bestellungen" stehen als entfallen.
Setze Flags auf false, die besagen, das ein Lieferant Pumpen- oder Ersatzteile liefert 
Setze die Flags für Pumpen-/Ersatzteile-Lieferanten neu

8. Lieferanten-Erklärungen
~~~~~~~~~~~~~~~~~~~~~~~~~~

Tabelle: LErklaerungen

procedure TBasisImport.LErklaerungenUpdaten

Übertrage Daten aus Bestellungen nach Lieferantenerklärungen, 
wenn die Teile-Lieferanten-Kombi in Bestellungen, aber nicht in Lieferantenerklärungen vorhanden ist.
Lösche Teile-Lieferanten-Kombis, die nicht in Bestellungen sind aus Lieferantenerklärungen.
 

9. Anzahl der Lieferanten je Teil
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Tabelle: tmp_anz_xxx_je_teil loeschen und neu füllen

Tabelle Teile: ändern

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