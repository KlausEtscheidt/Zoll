UnippsStueliPos
===============


.. py:module:: UnippsStueliPos

.. py:class:: EWUnippsStueliPos(Exception)

.. py:class:: TWUniStueliPos(TWStueliPos)
   
   .. py:data:: var PosTyp
      
      :type:: String
   
   .. py:data:: var TeileNr
      
      :type:: String
   
   .. py:data:: var IdPos
      
      :type:: Integer
   
   .. py:data:: var PosNr
      
      :type:: String
   
   .. py:data:: var OA
      
      :type:: Integer
   
   .. py:data:: var UnippsTyp
      
      :type:: String
   
   .. py:data:: var BeschaffungsArt
      
      :type:: Integer
   
   .. py:data:: var FANr
      
      :type:: Integer
   
   .. py:data:: var VerursacherArt
      
      :type:: Integer
   
   .. py:data:: var UebergeordneteStueNr
      
      :type:: Integer
   
   .. py:data:: var Ds
      
      :type:: Integer
   
   .. py:data:: var SetBlock
      
      :type:: Integer
   
   .. py:data:: var SummeEU
      
      :type:: Double
   
   .. py:data:: var SummeNonEU
      
      :type:: Double
   
   .. py:data:: var PreisEU
      
      :type:: Double
   
   .. py:data:: var PreisNonEU
      
      :type:: Double
   
   .. py:data:: var VerkaufsPreisRabattiert
      
      :type:: Double
   
   .. py:data:: var VerkaufsPreisUnRabattiert
      
      :type:: Double
   
   .. py:data:: var AnteilNonEU
      
      :type:: Double
   
   .. py:data:: var PraefBerechtigt
      
      :type:: String
   
   .. py:data:: var Teil
      
      :type:: TWTeil
    
   .. py:method:: Create(einVater:TWUniStueliPos;APosTyp:String;IdStuPos:String;eMenge:Double)
      
      :param TWUniStueliPos einVater: 
      :param String APosTyp: 
      :param String IdStuPos: 
      :param Double eMenge: 
    
   .. py:method:: PosDatenSpeichern(Qry:TWUNIPPSQry)
      
      :param TWUNIPPSQry Qry: 
    
   .. py:method:: SucheTeilzurStueliPos)
      
    
   .. py:method:: holeKindervonEndKnoten)
      
   
   .. py:function:: holeKinderAusASTUELIPOS)
      
   
   .. py:function:: holeKinderAusTeileStu)
      
    
   .. py:method:: SummierePreise)
      
    
   .. py:method:: BerechnePreisDerPosition)
      
   
   .. py:function:: ToStr)
      
    
   .. py:method:: DatenInAusgabe(ZielDS:TWDataSet)
      
      :param TWDataSet ZielDS: 
    
   .. py:method:: StrukturInErgebnisTabelle(ZielDS:TWDataSet;FirstRun:Boolean)
      
      :param TWDataSet ZielDS: 
      :param Boolean FirstRun: 
    
   .. py:method:: EntferneFertigungsauftraege)
      Entfernt Fertigungsaufträge aus der Struktur  
      

.. py:class:: TWEndKnotenListe(TList<TWUniStueliPos>)
   
   .. py:function:: ToStr)
      

.. py:attribute:: var EndKnotenListe
   
   :type:: TWEndKnotenListe
