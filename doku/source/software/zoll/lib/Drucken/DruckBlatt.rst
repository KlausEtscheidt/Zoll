DruckBlatt
==========

.. py:module:: DruckBlatt

.. py:class:: TWBlatt(TComponent)

   .. py:attribute:: DefBlattRaender

      :type: TRect

   .. py:attribute:: DefDecimalSep

      :type: string

   .. py:attribute:: Kopfzeile

      :type: TWBlatt.TWKopfzeile

   .. py:attribute:: Dokumentenkopf

      :type: TWBlatt.TWDokumentenkopf

   .. py:attribute:: Inhalt

      :type: TWBlatt.TWInhalt

   .. py:attribute:: Fusszeile

      :type: TWBlatt.TWFusszeile

   .. py:function:: PosHorizAusgerichtet (Text string; FeldBreite Integer; Ausrichtung TWAusrichtungsArten; NNachKomma Integer): Integer;

      :param string Text: 
      :param Integer FeldBreite: 
      :param TWAusrichtungsArten Ausrichtung: 
      :param Integer NNachKomma: 

   .. py:method:: Drucken (DruckJobName string);

      :param string DruckJobName: 

   .. py:function:: NeueSeite : Boolean;


   .. py:method:: DruckeKopfzeile;


   .. py:method:: DruckeInhalt;


   .. py:method:: DruckeDokumentenkopf;


   .. py:method:: DruckeFusszeile;


   .. py:property:: Drucker

      type: TPrinter

   .. py:property:: Raender

      type: TRect

   .. py:property:: Innen

      type: TRect

   .. py:property:: Left

      type: Integer

   .. py:property:: Right

      type: Integer

   .. py:property:: DecimalSeparator

      type: string
