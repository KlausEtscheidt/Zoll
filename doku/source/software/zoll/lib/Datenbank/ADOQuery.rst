ADOQuery
========



Komfort-Funktionen fuer Abfragen auf Basis der TADOQuery

Vor der eigentlichen Abfrage muss ein TWADOConnector für die Klasse gesetzt werden.

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


.. py:class:: TWADOQuery(TADOQuery)
   Funktionen fuer Abfragen auf Basis der TADOQuery.


   Vor der eigentlichen Abfrage einer neuen Instanz muss ein TWADOConnector für die Klasse gesetzt werden.



   .. py:method:: PrepareQuery (SQL string);

      :param string SQL: 

   .. py:method:: ExecuteQuery (WithResult Boolean);

      :param Boolean WithResult: 

   .. py:function:: RunSelectQuery (sql string): Boolean;
      Führt Abfragen aus, die Ergebnisse liefern (Select).


      gefunden wird True, wenn Daten gefunden. n_records enthält, die Anzahl der gefundenen Datensätze.


      :param string sql: 
      :rtype: Boolean

   .. py:function:: RunSelectQueryWithParam (sql string; paramlist TWParamlist): Boolean;
      Führt parametrisierte Abfragen aus, die Ergebnisse liefern (Select)


      gefunden wird True, wenn Daten gefunden n_records enthält, die Anzahl der gefundenen Datensätze


      :param string sql: 
      :param TWParamlist paramlist: 
      :rtype: Boolean

   .. py:function:: RunExecSQLQuery (sql string): Boolean;
      Führt Abfragen aus, die keine Ergebnisse liefern (z.B Delete).


      gefunden wird True, wenn Daten gefunden. n_records enthält, die Anzahl der gefundenen Datensätze.


      :param string sql: 
      :rtype: Boolean

   .. py:function:: InsertFields (tablename string; myFields TFields): Boolean;
      Mittels SQL-Insert werden Daten in "tablename" eingefügt.


      :param string tablename: 
      :param TFields myFields: 
      :rtype: Boolean

   .. py:function:: GetFieldValues : TArray<System.string>;

      :rtype: TArray<System.string>

   .. py:function:: GetFieldValuesAsText : string;

      :rtype: string

   .. py:function:: GetFieldNames : TArray<System.string>;

      :rtype: TArray<System.string>

   .. py:function:: GetFieldNamesAsText : string;

      :rtype: string

   .. py:attribute:: FConnector

   .. py:attribute:: n_records
      Anzahl der gefundenen Records


   .. py:attribute:: gefunden
      True, wenn Datensaetze gefunden

