Stueckliste
===========

.. py:module:: Stueckliste

.. py:exception:: EWStueli(Exception)


.. py:class:: TWStueliPos(TObject)


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


      :rtype: string

   .. py:function:: BaumAlsText (txt string): string;
      Liefert wichtige Felder aller Positionen in einem String verkettet


      :param string txt: 
      :rtype: string

   .. py:attribute:: FIdStueliPos

   .. py:attribute:: FStueli

   .. py:attribute:: FStueliKey

   .. py:attribute:: Vater

   .. py:attribute:: Ebene

   .. py:attribute:: EbeneNice

   .. py:attribute:: Menge

   .. py:attribute:: MengeTotal

   .. py:attribute:: hatTeil
