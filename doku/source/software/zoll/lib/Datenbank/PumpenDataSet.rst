PumpenDataSet
=============

Die Unit ermöglicht die dynamische Definition verschiedener  Datasets zur Laufzeit. Diese dienen zum Speichern der vom Programm  ermittelten Daten in Tabellenform.  

|Die Eigenschaften der Felder werden über Records vom   Typ TWFeldTypRecord definiert. Die Records aller Felder werden in  einem Dictionary TWFeldTypenDict abgelegt, bei dem der Feldname  als key für den Zugriff dient.  
|Weiterhin sind Prozeduren zum komfortablen Speichern von Daten  in einem DataSet enthalten. 

.. py:module:: PumpenDataSet
   :synopsis: Datenspeicher des Programms auf Basis einer Erweiterung von TClientDataSet. 

.. cpp:type:: TWFeldAusrichtung

   Ausrichtung l wird zu left c zu center r zu right 

.. cpp:type:: TWFeldTypRecord

   Definition eines Dataset-Feldes 

.. cpp:type:: TWFeldTypenDict


.. cpp:type:: TWFeldNamen

   Array mit Feldnamen 

.. py:class:: TWDataSet(TClientDataSet)
    
   .. py:method:: AddFields
      Alle Felder aus einer TFields-Liste speichern. 
      
      Hiermit können komplette Datensätze aus Datenbank-Querys im  DataSet gespeichert werden. 

      
      :param TFields Felder: Liste von Feldern
    
   .. py:method:: AddFieldByName
      Einzelnes Feld aus einer TFields-Liste speichern. 
      
      Hiermit können einzelne Felder aus Datenbank-Query im  DataSet gespeichert werden. 

      
      :param String FeldName: 
      :param TFields Felder: Liste von Feldern
    
   .. py:method:: AddValue
      Einen Wert in das Dataset-Feld mit Namen Key speichern. 
      
      :param String FeldName: 
      :param Variant Val: Wert, der gespeichert wird.
    
   .. py:method:: DefiniereTabelle
      Definiert dynamisch ein Dataset 
      
      Es werden Felder eines Dataset angelegt und konfiguriert.  Die Namen der anzulegenden Felder werden im Array Felder übergeben.  

      | Zuerst werden alle evtl vorhandenen Felder bzw FieldDefs gelöscht.  
      | Dann werden anhand des Arrays neue FieldDefs erzeugt.  
      | Für diese wird anhand der Informationen, die in FeldTypen übergeben wurden,  der Datentyp, ein Anzeige-Name und bei String-Feldern  eine Feldbreite definiert.  
      | Mittels CreateDataSet werden die Felder angelegt und anschließend  über DefiniereFeldEigenschaften weitere FeldEigenschaften definiert. 
      
      :param TWFeldTypenDict FeldTypen:  Dictionary mit Eigenschaften aller Felder. Als key dient ein Name aus "Felder".
      :param TWFeldNamen Felder:  Array mit den Namen aller Felder, die angelegt werden sollen. Das Array definiert auch die Reihenfolge der Spalten. Die Namen müssen in FeldTypen vorhanden sein.  
    
   .. py:method:: DefiniereFeldEigenschaften
      Es werden Eigenschaften der Felder eines DataSet definiert. 
      
      Für alle Felder werden der Anzeigename, die Ausrichtung und für  Float-Felder ein Standard-Display-Format "0.00" gesetzt.  

      | Die Ausrichtung(TWFeldAusrichtung) kann l,c oder r  für left,center oder right sein 
      
      :param TWFeldTypenDict FeldTypen:  Dictionary mit Eigenschaften aller Felder.
    
   .. py:method:: SetzeSchreibmodus
      Setzt die ReadOnly-Eigenschaft der übergebenen Felder auf False  
      
      Für alle Felder des DataSet, die nicht in der Liste übergeben wurden, wird ReadOnly auf True gesetzt. 

      
      :param TWFeldNamen Felder:  Array mit den Namen der Felder,   die "schreibbar" werden sollen. 
   
   .. py:function:: ToCSV
       Erzeugt einen String mit allen Feldnamen (; getrennt) 
      
    
   .. py:method:: FiltereSpalten
      Setzt alle Felder, die nicht in Felder übergeben wurden,  auf unsichtbar. 
      
      :param TWFeldNamen Felder: 
    
   .. py:method:: print
      Gibt die Feldeigenschaften in eine Datei aus. 
      
      Das Format ist geeignet, als Source-Code zur Definition einer Feldliste  vom Typ array of TWFeldTypRecord (s. Unit Datenmodul) verwendet zu werden. 

      
      :param TStreamWriter TxtFile: 
 
.. py:method:: Register
   
