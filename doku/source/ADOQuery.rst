ADOQuery
========
.. py:module:: ADOQuery
   :synopsis: Komfort-Funktionen fuer Abfragen auf Basis der TADOQuery

.. py:class:: EWADOQuery

.. py:class:: TWADOQuery

   Funktionen fuer Abfragen auf Basis der TADOQuery

   Vor der ersten "Benutzung" einer neuen Instanz muss
   ein TWADOConnector für die Klasse gesetzt werden

   .. py:method:: SetConnector (AConnector TWADOConnector);

   .. py:method:: PrepareQuery (SQL string);

   .. py:method:: ExecuteQuery (WithResult Boolean);

   .. py:function:: GetDatenbank ;

      :rtype: string

   .. py:function:: GetDatenbankpfad ;

      :rtype: string

   .. py:function:: GetIsConnected ;

      :rtype: Boolean

   .. py:function:: RunSelectQuery (sql string): Boolean;

      :rtype: Boolean

   .. py:function:: RunSelectQueryWithParam (sql string; paramlist TWParamlist): Boolean;

      :rtype: Boolean

   .. py:function:: RunExecSQLQuery (sql string): Boolean;

      :rtype: Boolean

   .. py:function:: InsertFields (tablename string; myFields TFields): Boolean;

      Insert-Statement für "tablename" anhand einer Feldliste ausführen

      :param string tablename: 
      :param TFields myFields: 

      :rtype: Boolean

   .. py:function:: GetFieldValues ;

      :rtype: TArray<System.string>

   .. py:function:: GetFieldValuesAsText ;

      :rtype: string

   .. py:function:: GetFieldNames ;

      :rtype: TArray<System.string>

   .. py:function:: GetFieldNamesAsText ;

      :rtype: string

   .. py:attribute:: FConnector

   .. py:attribute:: n_records

      Anzahl der gefundenen Records

   .. py:attribute:: gefunden

      True, wenn Datensaetze gefunden
