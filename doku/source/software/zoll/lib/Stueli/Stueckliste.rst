Stueckliste
===========


.. py:module:: Stueckliste

.. py:class:: EWStueli(Exception)

.. py:class:: TWStueliPos
   
   .. py:property:: Stueli
      
      :type:: TWStueliPos 
   
   .. py:property:: StueliKeys
      
      :type:: TWSortedKeyArray 
   
   .. py:property:: StueliPosCount
      
      :type:: Integer 
   
   .. py:property:: IdStueliPosVater
      
      :type:: String 
   
   .. py:property:: IdStueliPos
      
      :type:: String 
   
   .. py:property:: StueliKey
      
      :type:: Integer 
   
   .. py:data:: var Vater
      
      :type:: TWStueliPos
   
   .. py:data:: var Ebene
      
      :type:: Integer
   
   .. py:data:: var EbeneNice
      
      :type:: String
   
   .. py:data:: var Menge
      
      :type:: Double
   
   .. py:data:: var MengeTotal
      
      :type:: Double
   
   .. py:data:: var hatTeil
      
      :type:: Boolean
    
   .. py:method:: Create(einVater:TWStueliPos;StueliPosId:String;eineMenge:Double)
      
      :param TWStueliPos einVater: 
      :param String StueliPosId: 
      :param Double eineMenge: 
    
   .. py:method:: SetzeEbenenUndMengen(Level:Integer;UebMenge:Double)
      Berechnet die Stueli-Ebene und die summierte Menge aller Pos 
      
      Berechnet Stueli-Ebene als Int und mit ... davor.  Berechet die mit den Mengen der Väter multiplizierte MengeTotal aller Pos 

      
      :param Integer Level: 
      :param Double UebMenge: 
    
   .. py:method:: StueliAdd(APos:TWStueliPos)
      
      :param TWStueliPos APos: 
    
   .. py:method:: StueliTakePosFrom(APos:TWStueliPos)
      Überträgt Position APos nach Self  
      
      :param TWStueliPos APos: 
    
   .. py:method:: StueliTakeChildrenFrom(APos:TWStueliPos)
      Überträgt die Kind Position APos nach Self,  Apos wird gelöscht  
      
      :param TWStueliPos APos: 
    
   .. py:method:: ReMove)
      
   
   .. py:function:: PosToStr)
      Liefert wichtige Felder in einem String verkettet  
      
   
   .. py:function:: BaumAlsText(txt:String)
      Verkettet wichtige Felder aller Pos zu einem String  Liefert wichtige Felder aller Positionen in einem String verkettet   
      
      :param String txt: 
