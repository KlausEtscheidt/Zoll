Auswerten
=========
.. py:module:: Auswerten

.. py:class:: EStuBaumMainExc

.. py:class:: TWPraeFixThread

   .. py:method:: Execute ;

   .. py:attribute:: ErrMsg

   .. py:attribute:: Success

   .. py:method:: PraeferenzKalkAbschluss ;

      2. Teil der Berechnung einer Präferenzberechtigung

   .. py:method:: KaAuswerten (KaId string);

      Startet eine Komplettanalyse

      :param string KaId: 

   .. py:method:: ZuordnungAendern (KA TWKundenauftrag; Zuordnungen TWZuordnungen);

   .. py:method:: RunItGui ;

      Einsprung fuer GUI Version fuer automatischen Testlauf

   .. py:function:: PraeferenzKalkBeginn (KaId string): Boolean;

      Anfang der Berechnung einer Präferenzberechtigung mit Preisabfrage

      :param string KaId: 

      :rtype: Boolean

   .. py:function:: Preisabfrage (KA TWKundenauftrag; Zuordnungen TWZuordnungen): Boolean;

      :rtype: Boolean
