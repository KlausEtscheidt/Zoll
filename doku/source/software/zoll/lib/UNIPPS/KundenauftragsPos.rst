KundenauftragsPos
=================

Die Unit bildet über die Klasse TWKundenauftragsPos die Position eines Kundenauftrags ab. In der Basisklasse TWUniStueliPos werden alle Eigenschaften abgelegt, die auch für andere Stücklisten-Typen (z.B Fertigungsauftrag) relevant sind. 


.. py:module:: KundenauftragsPos
   :synopsis: Position eines Kundenauftrags 

.. py:class:: TWKundenauftragsPos(TWUniStueliPos)
   
   Klasse zur Abbildung einer Kundenauftrags-Position 
   
   .. py:data:: var KaPosIdStuVater
      
      Id der Vater-Stueli aus UNIPPS auftragpos.ident_nr1 
      
      :type:: String
   
   .. py:data:: var KaPosIdPos
      
      Id der Position in der Vater-Stueli aus UNIPPS auftragpos.ident_nr2 
      
      :type:: Integer
   
   .. py:data:: var KaPosPosNr
      
      Positionsnr der Position in der Vater-Stueli aus UNIPPS auftragpos.pos 
      
      :type:: String
    
   .. py:method:: Create(einVater:TWUniStueliPos;Qry:TWUNIPPSQry;Kundenrabatt:Double)
      
      Erzeugt eine Kundenauftrags-Position 
      
      Die Position wird aus den übergebenen Daten der in "Kundenauftrag" ausgeführten Abfrage  "SucheKundenAuftragspositionen" erzeugt.  

      | Mit UnippsStueliPos.PosDatenSpeichern werden diejenigen Daten aus der Qry in Objekt-Felder  übernommen, welche auch für die anderen Stücklistentypen (z.B FA) relevant sind.  
      | Mit UnippsStueliPos.SucheTeilzurStueliPos wird das UNIPPS-Teil zu dieser Stücklisten-Position gesucht. 
      
      :param TWUniStueliPos einVater: Vaterknoten Objekt
      :param TWUNIPPSQry Qry: Aus den Daten der Abfrage wird die Position erzeugt.
      :param Double Kundenrabatt: Rabatt, der dem Kunden gewährt wird.
    
   .. py:method:: holeKinderAusASTUELIPOS
      
      Sucht kommissionsbezogene Fertigungsaufträge und deren Kinder 
      
