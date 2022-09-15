DruckBlatt
==========


.. py:module:: DruckBlatt

.. py:class:: TWBlatt(TComponent)
   
   .. py:property:: Drucker
      
      :type:: TPrinter 
   
   .. py:property:: Raender
      
      :type:: TRect  
   
   .. py:property:: Innen
      
      :type:: TRect  
   
   .. py:property:: Left
      
      :type:: Integer  
   
   .. py:property:: Right
      
      :type:: Integer  
   
   .. py:property:: DecimalSeparator
      
      :type:: String 
   
   .. py:data:: var Kopfzeile
      
      :type:: TWKopfzeile
   
   .. py:data:: var Dokumentenkopf
      
      :type:: TWDokumentenkopf
   
   .. py:data:: var Inhalt
      
      :type:: TWInhalt
   
   .. py:data:: var Fusszeile
      
      :type:: TWFusszeile
   
   .. py:attribute:: const DefDecimalSep
      
      :type:: String
   
   .. py:function:: PosHorizAusgerichtet(Text:String;FeldBreite:Integer;Ausrichtung:TWAusrichtungsArten;NNachKomma:Integer)
      
      :param String Text: 
      :param Integer FeldBreite: 
      :param TWAusrichtungsArten Ausrichtung: 
      :param Integer NNachKomma: 
    
   .. py:method:: Create(AOwner:TComponent;PrinterName:String)
      
      :param TComponent AOwner: 
      :param String PrinterName: 
    
   .. py:method:: Drucken(DruckJobName:String)
      
      :param String DruckJobName: 
   
   .. py:function:: NeueSeite)
      
    
   .. py:method:: DruckeKopfzeile)
      
    
   .. py:method:: DruckeInhalt)
      
    
   .. py:method:: DruckeDokumentenkopf)
      
    
   .. py:method:: DruckeFusszeile)
      
