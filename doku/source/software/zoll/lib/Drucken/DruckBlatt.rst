DruckBlatt
==========

.. py:module:: DruckBlatt

.. py:class:: TWBlatt(TComponent)


   .. py:attribute:: Kopfzeile

   .. py:attribute:: Dokumentenkopf

   .. py:attribute:: Inhalt

   .. py:attribute:: Fusszeile

   .. py:method:: Drucken (DruckJobName string);

      :param string DruckJobName: 

   .. py:method:: DruckeKopfzeile;


   .. py:method:: DruckeInhalt;


   .. py:method:: DruckeDokumentenkopf;


   .. py:method:: DruckeFusszeile;


   .. py:function:: PosHorizAusgerichtet (Text string; FeldBreite Integer; Ausrichtung TWAusrichtungsArten; NNachKomma Integer): Integer;

      :param string Text: 
      :param Integer FeldBreite: 
      :param TWAusrichtungsArten Ausrichtung: 
      :param Integer NNachKomma: 

   .. py:function:: NeueSeite : Boolean;

