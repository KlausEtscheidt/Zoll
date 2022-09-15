DatenModul
==========

Die Unit enthält visuelle Komponenten zum Abspeichern und Ausgeben der ermittelten Daten. Die Gesamtheit der Daten wird im Dataset ErgebnisDS gespeichert. Mittels "BatchMove" kann hieraus ein Extrakt oder eine CSV-Datei erzeugt werden. Die Datenfelder werden mittels der Konstanten AlleErgebnisFelder definiert. 


.. py:module:: DatenModul
   :synopsis: Datenbasis des Programms mit DataSets zum Speichern der Analyse. 

.. py:class:: TKaDataModule(TDataModule)
   Klasse mit visuellen Komponenten 
   
   .. py:data:: var BatchMoveTextWriter
      
      :type:: TFDBatchMoveTextWriter
   
   .. py:data:: var BatchMoveDSReader
      
      :type:: TFDBatchMoveDataSetReader
   
   .. py:data:: var BatchMove
      
      :type:: TFDBatchMove
   
   .. py:data:: var BatchMoveDSWriter
      
      :type:: TFDBatchMoveDataSetWriter
   
   .. py:data:: var ErgebnisDS
      Dataset zum Abspeichern aller Felder der Analyse 
      
      :type:: TWDataSet
   
   .. py:data:: var AusgabeDS
      Extrakt aus ErgebnisDS zur Ausgabe der Analyse 
      
      :type:: TWDataSet
   
   .. py:data:: var ErgebnisFelderDict
      Dictionary mit den Feld-Definitionen aus AlleErgebnisFelder 
      
      Ermöglicht gegenüber AlleErgebnisFelder einen komfortableren Zugriff. 

      
      :type:: TWFeldTypenDict
    
   .. py:method:: DataModuleCreate(Sender:TObject)
      Befüllt ErgebnisFelderDict mit Info aus AlleErgebnisFelder 
      
      Mit den Daten werden beim Anlegen von DataSets die Feldeigenschaften  definiert. 

      
      :param TObject Sender: 
    
   .. py:method:: DefiniereGesamtErgebnisDataSet)
      Definiere Tabelle fuer Gesamt-Ergebnis mit allen Feldern der Stücklistenpositionen, der Teile und der Bestellungen. 
      
      Aus diesem Dataset entstehen alle Ausgaben über Teilmengen-Datasets.  Es muss einmalig mit dieser Funktion angelegt werden. 

      
    
   .. py:method:: BefuelleAusgabeTabelle(ZielDS:TWDataSet )
      Überträgt Daten vom GesamtDatenset "ErgebnisDS" ins ZielDS  Überträgt Daten vom GesamtDatenset ins Default-AusgabeDatenset "AusgabeDS"  
      
      Die Feldeigenschaften werden dabei anhand der globalen  Festlegungen in AlleErgebnisFelder bzw dem daraus befüllten  ErgebnisFelderDict erneut definiert, da Batchmove diese ändert. 

      
      :param TWDataSet  ZielDS: 
    
   .. py:method:: ErzeugeAusgabeKurzFuerDoku)
      Definiert und belegt die Ausgabe-Tabelle für die offizielle Dokumentation (Kurzform) der Analyse. 
      
    
   .. py:method:: ErzeugeAusgabeVollFuerDebug)
      Definiert und belegt die Ausgabe-Tabelle mit großem Datenumfang (zu Debug-Zwecken). 
      
    
   .. py:method:: ErzeugeAusgabeFuerPreisabfrage(PreisDS:TWDAtaSet)
      Definiert und belegt die Ausgabe-Tabelle für die Abfrage von Preisen bei Neupumpen. 
      
      :param TWDAtaSet PreisDS: 
    
   .. py:method:: AusgabeAlsCSV(DateiPfad,DateiName:String)
      Schreibt AusgabeDS in CSV-Datei  
      
      :param String DateiPfad: Pfad ohne slash am Ende 
      :param String DateiName: Dateiname ohne slash am Anfang

.. py:attribute:: const AlleErgebnisFelder
   Definitionen aller Felder von ErgebnisDS. 
   
   :type:: array [0..49] of TWFeldTypRecord 

.. py:attribute:: var KaDataModule
   
   :type:: TKaDataModule
