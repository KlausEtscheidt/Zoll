Teil
====


.. py:module:: Teil

.. py:class:: EWTeil(Exception)

.. py:class:: TWTeil
   
   .. py:data:: var TeileNr
      
      :type:: String
   
   .. py:data:: var OA
      
      :type:: Integer
   
   .. py:data:: var UnippsTyp
      
      :type:: String
   
   .. py:data:: var Bezeichnung
      
      :type:: String
   
   .. py:data:: var BeschaffungsArt
      
      :type:: Integer
   
   .. py:data:: var Praeferenzkennung
      
      :type:: Integer
   
   .. py:data:: var Sme
      
      :type:: Integer
   
   .. py:data:: var FaktorLmeSme
      
      :type:: Double
   
   .. py:data:: var Lme
      
      :type:: Integer
   
   .. py:data:: var PreisGesucht
      
      :type:: Boolean
   
   .. py:data:: var PreisErmittelt
      
      :type:: Boolean
   
   .. py:data:: var Bestellung
      
      :type:: TWBestellung
   
   .. py:data:: var IstPraeferenzberechtigt
      
      :type:: Boolean
   
   .. py:data:: var IstKaufteil
      
      :type:: Boolean
   
   .. py:data:: var IstEigenfertigung
      
      :type:: Boolean
   
   .. py:data:: var IstFremdfertigung
      
      :type:: Boolean
   
   .. py:data:: var PreisJeLME
      
      :type:: Double
    
   .. py:method:: Create(TeileQry:TWUNIPPSQry)
      
      :param TWUNIPPSQry TeileQry: 
    
   .. py:method:: holeBenennung
      
    
   .. py:method:: holeMaxPreisAus3Bestellungen
      
   
   .. py:function:: StueliPosGesamtPreis(menge:Double;faktlme_sme:Double)
      
      :param Double menge: 
      :param Double faktlme_sme: 
   
   .. py:function:: ToStr
      
    
   .. py:method:: DatenInAusgabe(ZielDS:TWDataSet)
      
      :param TWDataSet ZielDS: 
