DatenModul
==========


.. py:module:: DatenModul

.. py:class:: TKaDataModule(TDataModule)
   
   
   
   
   
   
   
    
   .. py:method:: DataModuleCreate
      Befüllt ErgebnisFelderDict mit Info aus AlleErgebnisFelder 
      
      Mit den Daten werden beim Anlegen von DataSets die Feldeigenschaften  definiert. 

      
      :param TObject Sender: 
    
   .. py:method:: DefiniereGesamtErgebnisDataSet
      Definiere Tabelle fuer Gesamt-Ergebnis mit allen Feldern der Stücklistenpositionen, der Teile und der Bestellungen. 
      
      Aus diesem Dataset entstehen alle Ausgaben über Teilmengen-Datasets.  Es muss einmalig mit dieser Funktion angelegt werden. 

      
    
   .. py:method:: BefuelleAusgabeTabelle
      Überträgt Daten vom GesamtDatenset "ErgebnisDS" ins ZielDS  Überträgt Daten vom GesamtDatenset ins Default-AusgabeDatenset "AusgabeDS"  
      
      Die Feldeigenschaften werden dabei anhand der globalen  Festlegungen in AlleErgebnisFelder bzw dem daraus befüllten  ErgebnisFelderDict erneut definiert, da Batchmove diese ändert. 

      
      :param TWDataSet  ZielDS: 
    
   .. py:method:: ErzeugeAusgabeKurzFuerDoku
      Definiert und belegt die Ausgabe-Tabelle für die offizielle Dokumentation (Kurzform) der Analyse. 
      
    
   .. py:method:: ErzeugeAusgabeVollFuerDebug
      Definiert und belegt die Ausgabe-Tabelle mit großem Datenumfang (zu Debug-Zwecken). 
      
    
   .. py:method:: ErzeugeAusgabeFuerPreisabfrage
      Definiert und belegt die Ausgabe-Tabelle für die Abfrage von Preisen bei Neupumpen. 
      
      :param TWDAtaSet PreisDS: 
    
   .. py:method:: AusgabeAlsCSV
      Schreibt AusgabeDS in CSV-Datei  
      
      :param String DateiPfad: Pfad ohne slash am Ende 
      :param String DateiName: Dateiname ohne slash am Anfang

.. py:attribute:: const AlleErgebnisFelder
   
   :type:: array [0..49] of TWFeldTypRecord 

