Stueckliste
===========

Die Stücklistenposition wird über ihre Id IdStueliPos identifiziert,  die innerhalb der übergeordneten Stückliste eindeutig sein sollte.  Die Stücklistenposition besitzt eine untergeordnete Stückliste (Dictionary).  Mit StueliAdd werden Positionen in diese eigene Stüli aufgenommen.  Dabei wird in der Reihenfolge des Hinzufügens ein fortlaufender Key vergeben.  Die Stücklistenposition besitzt daher ebenfalls die Property StueliKey,  welche sie innerhalb der übergeordneten Stückliste identifiziert. 


.. py:module:: Stueckliste
   :synopsis: Allgemeine Form einer Stücklistenposition/Stückliste 

.. py:class:: EWStueli(Exception)
   
   Klasse für Exceptions dieser Unit 

.. py:class:: TWStueliPos
   
   Allgemeine Form einer Stücklistenposition mit  untergeordneter Stückliste. 
   
   .. py:property:: Stueli
      
       Stuecklistenposition[Key] zum Key 
      
      :type:: TWStueliPos 
   
   .. py:property:: StueliKeys
      
      Stueli-Keys in der Reihenfolge,  in der die Stueckliste aufgebaut wurde. 
      
      :type:: TWSortedKeyArray 
   
   .. py:property:: StueliPosCount
      
      :type:: Integer 
   
   .. py:property:: IdStueliPosVater
      
      Id des Vaterknotens bzgl der Stückliste, in der er steht 
      
      :type:: String 
   
   .. py:property:: IdStueliPos
      
      Eigene Id, d.h. Id dieser Stüli-Pos. Keine UNIPPS-Id 
      
      :type:: String 
   
   .. py:property:: StueliKey
      
      Key, der die Position in ihrer Vater-Stückliste identifiziert 
      
      :type:: Integer 
   
   .. py:data:: var Vater
      
      Vaterknoten als TWStueliPos-Objekt 
      
      :type:: TWStueliPos
   
   .. py:data:: var Ebene
      
      Ebene im Stücklistenbaum, in der sich die Pos befindet 
      
      :type:: Integer
   
   .. py:data:: var EbeneNice
      
      Ebene mit führenden Punkten, zur schöneren Darstellung 
      
      :type:: String
   
   .. py:data:: var Menge
      
      Menge von Self in Vater-Stueli (beliebige Einheiten) 
      
      :type:: Double
   
   .. py:data:: var MengeTotal
      
      Gesamt-Menge von Self (mit Übergeordneten Mengen multipliziert) 
      
      :type:: Double
   
   .. py:data:: var hatTeil
      
      True, wenn der Pos ein Teil zugeordnet wurde 
      
      :type:: Boolean
    
   .. py:method:: Create(einVater:TWStueliPos;StueliPosId:String;eineMenge:Double)
      
      Erzeugt eine Stücklisten-Position 
      
      :param TWStueliPos einVater: Vaterknoten Objekt
      :param String StueliPosId: Id zum Erkennen der neu zu erzeugenden Position
      :param Double eineMenge: Menge, mit der die Position in ihrer Stueli steht.
    
   .. py:method:: SetzeEbenenUndMengen(Level:Integer;UebMenge:Double)
      
      Berechnet die Stueli-Ebene und die summierte Menge aller Positionen 
      
      Die Proc durchläuft rekursiv den gesamten Stüli-Baum und  berechnet Stueli-Ebene als Int bzw String mit Punkten('...') davor.  Sie berechnet das Produkt (MengeTotal) aus der eigenen Menge der Position und  den Mengen all ihrer Väter. 

      
      :param Integer Level: 
      :param Double UebMenge: 
    
   .. py:method:: StueliAdd(APos:TWStueliPos)
      
      Fügt eine neue Pos zur eigenen Stüli dazu. 
      
      Die Stueckliste ist ein Dictionary mit einem Integer als key. Die keys werden fortlaufend vergeben. Eine Schleife über die sortierten Keys, gibt die Stuecklisten-Einträge daher in der Reihenfolge ihrer Erzeugung aus. 

      
      :param TWStueliPos APos: Einzufügende Position
    
   .. py:method:: StueliTakePosFrom(APos:TWStueliPos)
      
      Überträgt die Position APos in die eigene Stueli und entfernt sie aus der alten Liste 
      
      :param TWStueliPos APos: 
    
   .. py:method:: StueliTakeChildrenFrom(APos:TWStueliPos)
      
      Überträgt alle Kinder von APos in die eigene Stueli und entfernt sie aus der alten Liste 
      
      :param TWStueliPos APos: Position, deren Kinder übertragen werden sollen.
    
   .. py:method:: ReMove
      
      Entfernt aktuelle Pos (Self) aus Vater-Stüli. 
      
      Die Pos wird zur Neuverwendung frei gegeben:  Self.FStueliKey:=0; 

      
   
   .. py:function:: PosToStr
      
      Liefert zum Debuggen wichtige Felder in einem String verkettet. 
      
   
   .. py:function:: BaumAlsText(txt:String)
      
       Liefert zum Debuggen wichtige Felder aller Baum-Positionen  zu einem String verkettet.  
      
      :param String txt: 
