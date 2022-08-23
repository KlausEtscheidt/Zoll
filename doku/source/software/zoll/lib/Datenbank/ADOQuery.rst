ADOQuery
========



Komfort-Funktionen fuer Abfragen auf Basis der TADOQuery

Vor der eigentlichen Abfrage muss ein TWADOConnector gesetzt werden.

Beispiel (die Owner sind auf nil gesetzt)

1. Connector erzeugen

dbUniConn:=TWADOConnector.Create(nil);

2. Verbinden mit Datenbank (hier UNIPPS)

dbUniConn.ConnectToUNIPPS();

3. Instanz anlegen

QryUNIPPS:=TWADOQuery.Create(nil);

4. Connector setzen

QryUNIPPS.Connector:=dbUniConn;

5. Qry benutzen

QryUNIPPS.RunSelectQuery('Select * from tabellxy');


.. py:module:: ADOQuery
   :synopsis: Komfort-Funktionen fuer Abfragen auf Basis der TADOQuery

.. py:exception:: EWADOQuery(Exception)
   Fehler, wenn Datenbank nicht verbunden.



.. py:class:: TWADOQuery(TADOQuery)
   Funktionen fuer Abfragen auf Basis der TADOQuery.


   Vor der eigentlichen Abfrage einer neuen Instanz muss ein TWADOConnector gesetzt werden.



   .. py:attribute:: n_records
      Anzahl der gefundenen Records


   .. py:attribute:: gefunden
      True, wenn Datensaetze gefunden


   .. py:function:: RunSelectQuery (sql string): Boolean;
      Führt Abfragen aus, die Ergebnisse liefern (Select).


      gefunden wird True, wenn Daten gefunden. n_records enthält, die Anzahl der gefundenen Datensätze.


      :param string sql: SQL-String der Abfrage
      :return: True, wenn Datensätze gefunden.

   .. py:function:: RunSelectQueryWithParam (sql string; paramlist TWParamlist): Boolean;
      Führt parametrisierte Abfragen aus, die Ergebnisse liefern (Select)


      gefunden wird True, wenn Daten gefunden wurde. n_records enthält, die Anzahl der gefundenen Datensätze.


      :param string sql: 
      :param TWParamlist paramlist: 

   .. py:function:: RunExecSQLQuery (sql string): Boolean;
      Führt Abfragen aus, die keine Ergebnisse liefern (z.B Delete).


      gefunden wird True, wenn Daten gefunden. n_records enthält, die Anzahl der gefundenen Datensätze.


      :param string sql: 

   .. py:function:: InsertFields (tablename string; myFields TFields): Boolean;
      Mittels SQL-Insert werden Daten in "tablename" eingefügt.


      :param string tablename: 
      :param TFields myFields: 

   .. py:function:: GetFieldValuesAsText : string;
      Zum Debuggen: Liefert alle Ergebnis-Felder eines Datensatzes als CSV-String.


