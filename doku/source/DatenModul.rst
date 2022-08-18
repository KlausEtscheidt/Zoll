DatenModul
==========
.. py:module:: DatenModul

.. py:class:: TKaDataModule

   .. py:method:: DefiniereGesamtErgebnisDataSet ;

      Definiere Tabelle fuer Gesamt-Ergebnis mit allen Feldern
      der Stücklistenpositionen, der Teile und der Bestellungen.

      Aus diesem Dataset entstehen alle Ausgaben über Teilmengen-Datasets.
      Es muss einmalig mit dieser Funktion angelegt werden.

   .. py:method:: BefuelleAusgabeTabelle (ZielDS TWDataSet);

      Überträgt Daten vom GesamtDatenset ins Default-AusgabeDatenset
      "AusgabeDS"

      Die Feldeigenschaften werden dabei anhand der globalen
      Festlegungen in AlleErgebnisFelder bzw dem daraus befüllten
      ErgebnisFelderDict erneut definiert, da Batchmove diese ändert.

      :param TWDataSet ZielDS: 

   .. py:method:: ErzeugeAusgabeKurzFuerDoku ;

      Definiert und belegt die Ausgabe-Tabelle
      für die offizielle Dokumentation (Kurzform) der Analyse.

   .. py:method:: ErzeugeAusgabeVollFuerDebug ;

      Definiert und belegt die Ausgabe-Tabelle
      mit großem Datenumfang (zu Debug-Zwecken).

   .. py:method:: ErzeugeAusgabeFuerPreisabfrage (PreisDS TWDataSet);

      Definiert und belegt die Ausgabe-Tabelle
      für die Abfrage von Preisen bei Neupumpen.

      :param TWDataSet PreisDS: 

   .. py:method:: AusgabeAlsCSV (DateiPfad string; DateiName string);

      Schreibt AusgabeDS in CSV-Datei

      :param string DateiPfad: Pfad ohne slash am Ende
      :param string DateiName: Dateiname ohne slash am Anfang

   .. py:attribute:: ErgebnisFelderDict
