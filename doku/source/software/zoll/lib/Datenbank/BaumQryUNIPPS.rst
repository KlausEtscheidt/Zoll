BaumQryUNIPPS
=============

Abfrage-Generator für Präfix-UNIPPS-Abfragen.

Anwendungsbeispiel: Abfrage zum Lesen des Kundenauftrags und seiner Positionen

Abfrage erzeugen

KAQry := TWBaumQryUNIPPS.Create(nil);

Datenbank-Connector setzen (DbConnector hat Typ TADOConnector)

KAQry.Connector:=DbConnector;

SQL für Abfrage setzen und Abfrage ausführen

gefunden := KAQry.SucheKundenAuftragspositionen(ka_id);

gefunden wird True, wenn die Abfrage Daten fand. Über KAQry können die Daten mit den Methoden der TADOQuery weiter verarbeitet werden.

Für das Programm PräFix wurden die ersten beiden Schritte in der Methode getQuery der Unit Tools zusammengfasst:

KAQry := Tools.getQuery;

Die Unit verfügt außerdem über einen Modus, bei alle Ergebnisse aus UNIPPS-Abfragen in eine SQLite-Datenbank kopiert werden.

.. py:module:: BaumQryUNIPPS
   :synopsis: UNIPPS-Datenbank-Abfragen für das Programm PräFix

.. py:class:: TWBaumQryUNIPPS(TWADOQuery)
   Abfragengenerator für alle nötigen UNIPPS-Abfragen.

   .. py:attribute:: Export2SQLite
      Flag: Bei True werden bei jeder Abfrage Daten von UNIPPS nach SQLite kopiert.

      :type: Boolean

   .. py:attribute:: SQLiteConnector
      Datenbank-Verbindung für SQLite.

      Muss gesetzt werden, wenn Daten kopiert werden sollen.

      :type: TWADOConnector

   .. py:function:: SucheKundenAuftragspositionen (KaId string): Boolean;
      Suche Positionen eines Kunden-Auftrags in UNIPPS auftragpos

      :param string KaId: UNIPPS-Id des Kundenauftrags (auftragpos.ident_nr1)

   .. py:function:: SucheFAzuKAPos (KaId string; id_pos Integer): Boolean;
      Suche Fertigungs-Aufrag(Kommissions-FA) zu einer zu Kunden-Auftrags-Position

      :param string KaId: UNIPPS-Id des Kundenauftrags (f_auftragkopf.auftr_nr)
      :param Integer id_pos: UNIPPS-Id der Position des Kundenauftrags (f_auftragkopf.auftr_pos)

   .. py:function:: SucheFAzuTeil (t_tg_nr string): Boolean;
      Suche Fertigungs-Aufrag(Serien-FA) zu einer Teile-Nummer in UNIPPS.f_auftragkopf

      :param string t_tg_nr: UNIPPS-Teilenummer (f_auftragkopf.t_tg_nr)

   .. py:function:: SuchePosZuFA (FA_Nr string): Boolean;
      Suche alle Positionen zu einem Fertigungsauftrag in UNIPPS ASTUELIPOS

      :param string FA_Nr: UNIPPS-ID des Fertigungsauftrages (astuelipos.ident_nr1)

   .. py:function:: SucheStuelizuTeil (t_tg_nr string): Boolean;
      Suche Stueckliste zu einem Teil in UNIPPS teil_stuelipos

      :param string t_tg_nr: UNIPPS-Teilenummer (teil_stuelipos.ident_nr1)

   .. py:function:: SucheDatenzumTeil (t_tg_nr string): Boolean;
      Suche Daten zu einem Teil aus UNIPPS.teil bzw teil_uw

      :param string t_tg_nr: UNIPPS-Teilenummer teil_uw.t_tg_nr

   .. py:function:: SucheBenennungZuTeil (t_tg_nr string): Boolean;
      Suche Benennung zu einem Teil aus UNIPPS teil_bez.

      :param string t_tg_nr: UNIPPS-Teilenummer (teil_bez.ident_nr1)

   .. py:function:: SucheLetzte3Bestellungen (t_tg_nr string): Boolean;
      Suche letzte 3 Bestellungen zu einem Teil um Preis zu bestimmen (aus UNIPPS bestellpos).

      :param string t_tg_nr: UNIPPS-Teilenummer (bestellpos.t_tg_nr)

   .. py:function:: SucheKundenRabatt (kunden_id string): Boolean;
      Suche Rabatt zu einem Kunden aus UNIPPS-kunde_zuab

      :param string kunden_id: UNIPPS-ID des Kunden (kunde_zuab.ident_nr1)

   .. py:method:: UNI2SQLite (tablename string);
      Kopiert Daten 1:1 nach SQLite

      :param string tablename: Name der Sqlite-Ziel-Tabelle
