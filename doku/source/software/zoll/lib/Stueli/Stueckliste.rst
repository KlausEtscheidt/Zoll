Stueckliste
===========

.. py:module:: Stueckliste

.. py:exception:: EWStueli(Exception)

.. py:class:: TWStueliPos(TObject)

      .. py:attribute:: Vater

         :type: TWStueliPos

      .. py:attribute:: Ebene

         :type: Integer

      .. py:attribute:: EbeneNice

         :type: string

      .. py:attribute:: Menge

         :type: Double

      .. py:attribute:: MengeTotal

         :type: Double

      .. py:attribute:: hatTeil

         :type: Boolean

      .. py:method:: SetzeEbenenUndMengen (Level Integer; UebMenge Double);
         Berechnet die Stueli-Ebene und die summierte Menge aller Pos

         Berechnet Stueli-Ebene als Int und mit ... davor. Berechet die mit den Mengen der Väter multiplizierte MengeTotal aller Pos

         :param Integer Level: 
         :param Double UebMenge: 

      .. py:method:: StueliAdd (APos TWStueliPos);

         :param TWStueliPos APos: 

      .. py:method:: StueliTakePosFrom (APos TWStueliPos);
         Überträgt Position APos nach Self

         :param TWStueliPos APos: 

      .. py:method:: StueliTakeChildrenFrom (APos TWStueliPos);
         Überträgt die Kind Position APos nach Self, Apos wird gelöscht

         :param TWStueliPos APos: 

      .. py:method:: ReMove;


      .. py:function:: PosToStr : string;
         Liefert wichtige Felder in einem String verkettet


      .. py:function:: BaumAlsText (txt string): string;
         Liefert wichtige Felder aller Positionen in einem String verkettet

         :param string txt: 

      .. py:property:: Stueli[Key]

         type: TWStueliPos

      .. py:property:: StueliKeys

         type: TArray<System.Integer>

      .. py:property:: StueliPosCount

         type: Integer

      .. py:property:: IdStueliPosVater

         type: string

      .. py:property:: IdStueliPos

         type: string

      .. py:property:: StueliKey

         type: Integer
