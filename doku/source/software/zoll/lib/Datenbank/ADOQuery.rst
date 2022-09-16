ADOQuery
========

|  Komfort-Funktionen fuer Abfragen auf Basis der TADOQuery 
|  Vor der eigentlichen Abfrage muss ein TWADOConnector gesetzt werden. 
|  Beispiel (die Owner sind auf nil gesetzt) 
|  1. Connector erzeugen 
|    dbUniConn:=TWADOConnector.Create(nil); 
|  2. Verbinden mit Datenbank (hier UNIPPS) 
|    dbUniConn.ConnectToUNIPPS(); 
|  3. Instanz anlegen 
|    QryUNIPPS:=TWADOQuery.Create(nil); 
|  4. Connector setzen 
|    QryUNIPPS.Connector:=dbUniConn; 
|  5. Qry benutzen 
|    QryUNIPPS.RunSelectQuery('Select * from tabellxy'); 

.. py:module:: ADOQuery
   :synopsis: Komfort-Funktionen fuer Abfragen auf Basis der TADOQuery  

.. py:class:: EWADOQuery(Exception)

.. py:class:: TWADOQuery(TADOQuery)
   
   Funktionen fuer Abfragen auf Basis der TADOQuery.  
   
   Vor der eigentlichen Abfrage einer neuen Instanz muss  ein TWADOConnector gesetzt werden. 

   
   .. py:property:: Connector
      
      Objekt, welches Datenbankverbindung hält.   
      
      :type:: TWADOConnector 
   
   .. py:property:: Datenbank
      
      Name, der verbundenen Datenbank 
      
      :type:: String 
   
   .. py:property:: Datenbankpfad
      
      Pfad, zur verbundenen Datenbank 
      
      :type:: String 
   
   .. py:data:: var n_records
      
      Anzahl der gefundenen Records   
      
      :type:: Integer
   
   .. py:data:: var gefunden
      
      True, wenn Datensaetze gefunden  
      
      :type:: Boolean
   
   .. py:function:: RunSelectQuery(sql:string)
      
      Führt Abfragen aus, die Ergebnisse liefern (Select). 
      
      gefunden wird True, wenn Daten gefunden.  n_records enthält, die Anzahl der gefundenen Datensätze. 

      
      :param string sql: SQL-String der Abfrage
      :return: True, wenn Datensätze gefunden. 
   
   .. py:function:: RunSelectQueryWithParam(sql:string;paramlist:TWParamlist)
      
      Führt parametrisierte Abfragen aus, die Ergebnisse liefern (Select) 
      
      gefunden wird True, wenn Daten gefunden wurde.   n_records enthält, die Anzahl der gefundenen Datensätze. 

      
      :param string sql: 
      :param TWParamlist paramlist: 
   
   .. py:function:: RunExecSQLQuery(sql:string)
      
      Führt Abfragen aus, die keine Ergebnisse liefern (z.B Delete). 
      
      gefunden wird True, wenn Daten gefunden.  n_records enthält, die Anzahl der gefundenen Datensätze. 

      
      :param string sql: 
   
   .. py:function:: InsertFields(tablename:String;myFields:TFields)
      
        Mittels SQL-Insert werden Daten in "tablename" eingefügt.  
      
      :param String tablename: 
      :param TFields myFields: 
   
   .. py:function:: GetFieldValuesAsText
      
      Zum Debuggen: Liefert alle Ergebnis-Felder eines Datensatzes als CSV-String. 
      
