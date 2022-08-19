Auswerten
=========
.. py:module:: Auswerten

.. py:exception:: EAuswerten(Exception)

.. py:class:: TWPraeFixThread(TThread)

   .. py:method:: Execute ;

   .. py:attribute:: ErrMsg

   .. py:attribute:: Success

.. py:method:: PraeferenzKalkAbschluss ;

   2. Teil der Berechnung einer Präferenzberechtigung

.. py:method:: KaAuswerten (KaId string);

   Startet eine Komplettanalyse eines Kundeaufrages

   Nach der Ermittlung der Positionen des Kundenauftrages
   werden die Verkaufspreise vom Anwender erfragt.
   Anschließend wird im einem eigenen Thread die kompl. Auftragstruktur ermittelt.

   :param string KaId: Id des Kundenauftrages

.. py:method:: ZuordnungAendern (KA TWKundenauftrag; Zuordnungen TWZuordnungen);

.. py:method:: RunItGui ;

   Einsprung fuer GUI Version fuer automatischen Testlauf

.. py:function:: PraeferenzKalkBeginn (KaId string): Boolean;

   Anfang der Berechnung einer Präferenzberechtigung mit Preisabfrage

   :param string KaId: 

   :rtype: Boolean

.. py:function:: Preisabfrage (KA TWKundenauftrag; Zuordnungen TWZuordnungen): Boolean;

   Abfrage der Preise und Zuordnungen mittels Formular

   Die bisher ermittelten Daten werden gesammelt, in das Datenset PreisDS
   übertragen und damit im Formular angezeigt.
   Der Anwender ergänzt ALLE Preise und gibt evtl an,
   das Positionen anderen Positionen untergeordnet werden sollen.

   :param TWKundenauftrag KA: Kundenauftrag(TWKundenauftrag)
   :param TWZuordnungen Zuordnungen: array mit Zuordnungen

   :rtype: Boolean
