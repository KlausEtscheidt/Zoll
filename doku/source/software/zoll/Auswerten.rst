Auswerten
=========

Die Unit enthält die übergeordneten Funktionen zur Analyse eines Kundenauftrages inkl. der Ermittlung der Präferenzberechtigung. Hierzu dient die Prozedur Auswerten.KaAuswerten .

.. py:module:: Auswerten
   :synopsis: Komplettanalyse eines Kundenauftrages mit Berechnung der Präferenzberechtigung.

.. cpp:type:: TWZuordnung

Zuordnung von Positionen des Kundenauftrags zu anderen Positionen

|   VaterPos:Integer Id der neuen übergeordneten Position.
|   KindPos:Integer Id der Position, die umgehängt wird.

.. py:exception:: EAuswerten(Exception)
   Ausnahmen während der Ausführung des Threads

.. py:class:: TWPraeFixThread(TThread)
      Ausführung der UNIPPS-Analyse im thread

      .. py:attribute:: ErrMsg
         Speichert Meldungen zu Fehlern, die während der Thread-Ausführung entstehen.

         :type: string

      .. py:attribute:: Success
         True, wenn Thread-Ausführung fehlerfrei.

         :type: Boolean

      .. py:method:: Execute;
         Sucht alle Kinder-Positionen zu einem Kundenauftrag.


      .. py:method:: KaAuswerten (KaId string);
         Startet eine Komplettanalyse eines Kundeaufrages.

         Nach der Ermittlung der Positionen des Kundenauftrages werden die Verkaufspreise vom Anwender erfragt. Anschließend wird in separatem Thread die kompl. Auftragstruktur ermittelt.

         :param string KaId: Id des Kundenauftrages

      .. py:function:: PraeferenzKalkBeginn (KaId string): Boolean;
         Vorbereitung der Präferenzkalkulation mit Abfrage der Preise der Kundenauftragspositionen

         Bereitet Ergebniss und Ausgabe-Dataset vor, legt TWKundenauftrag an, liest den Kopf und die Positionen des Kundenauftrags ein und erfragt die Preise zu den Positionen

         :param string KaId: Id des Kundenauftrages
         :return: True, wenn die Auswertung erfolgreich war und alle Preise eingegeben wurden.

      .. py:method:: PraeferenzKalkAbschluss;
         Abschliesssen der Berechnung einer Präferenzberechtigung

         Diese Funktion wird von mainfrm.FinishPraefKalk gerufen, welche wiederum vom OnTerminate-Ereignis des Threads getriggert wird. Falls der Thread nicht fehlerfrei ablief, bricht die Funktion ab.

         Sonst werden zuerst entsprechend der Benutzerangaben bei der Preisabfrage Positionen des Kundenauftrags (z.B. Motoren) umgehängt. Dann werden für den Gesamtbaum die Mengen der Positionen aufmultipliziert und die Ebene der Pos. im Baum bestimmt.

         Es werden die Preise aufsummiert und dann die PräferenzBerechtigung berechnet. Daten für die Ausgabe im Vollumfang werden gesammelt und als CSV ausgegeben. Für die komprimierte Ausgabe werden dann die Einträge der Fertigungsauftragsköpfe (nicht die Positionen) aus der Struktur entfernt. Die Ebene werden neu numeriert, Daten zur Ausgabe erneut gesammelt. Die Daten werden als CSV ausgegeben und im Hauptfenster angezeigt.


      .. py:function:: Preisabfrage (KA TWKundenauftrag; Zuordnungen TWZuordnungen): Boolean;
         Abfrage der Preise und Zuordnungen mittels Formular

         Die bisher ermittelten Daten werden gesammelt, in das Datenset PreisDS übertragen und damit im Formular angezeigt. Der Anwender ergänzt ALLE Preise und gibt evtl an, das Positionen des Kundenauftrags (z.B. Motoren) anderen Positionen untergeordnet werden sollen.

         :param TWKundenauftrag KA: Kundenauftrag
         :param TWZuordnungen Zuordnungen: array mit Zuordnungen
         :return: True, wenn alle Preise eingegeben wurden.

      .. py:method:: ZuordnungAendern (KA TWKundenauftrag; Zuordnungen TWZuordnungen);
         Umhängen von Positionen des Kundenauftrages

         Auf Basis der Eingaben im Formular Preiseingabe, werden Positionen des Kundenauftrags (z.B. Motoren) anderen Positionen untergeordnet.

         :param TWKundenauftrag KA: Kundenauftrag
         :param TWZuordnungen Zuordnungen: array mit Vater-Sohn-Zuordnungen

      .. py:method:: RunItGui;
         Testlauf: Automatischer Start beim Laden des Hauptformulars.


      .. py:property:: Zuordnungen

         :type: TWZuordnungen

      .. py:property:: PraeFixKalkThread

         :type: TWPraeFixThread

      .. py:property:: startzeit

         :type: TDateTime
