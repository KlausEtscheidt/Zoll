ADOQuery
========
.. py:module:: ADOQuery
   :synopsis: Komfort-Funktionen für Abfragen auf Basis der TADOQuery.

.. 	py:class:: TWADOQuery

	Komfort-Funktionen für Abfragen auf Basis der TADOQuery.
	
	Vor der ersten "Benutzung" einer neuen Instanz muss
	ein TWADOConnector für die Klasse gesetzt werden.

	
	.. py:attribute:: gefunden
	
	   True, wenn Abfrage erfolgreich war bzw. Datensätze gefunden wurden. 

	.. py:attribute:: n_records
	
	   Anzahl der von einer Abfrage gefundenen Datensätze 

	.. py:function:: RunSelectQuery(sql:string)
	   
	   Query ausführen, die ein Ergebnis liefert.
	   Die Felder n_records und gefunden werden gesetzt.
	   
	   :param string sql: SQL-Statement der Abfrage
	   :return: True, wenn Daten gefunden
	   :rtype: Boolean


	.. py:classmethod:: RunSelectQueryWithParam(sql:string;paramlist:TWParamlist)
	   
	   Parametrisierte Query ausführen, die ein Ergebnis liefert.
	   Die Felder n_records und gefunden werden gesetzt.
	   
	   :param string sql: SQL-Statement der Abfrage
	   :param TWParamlist paramlist: Liste mit Parametern
	   :type paramlist: array of String
	   :return: True, wenn Daten gefunden
	   :rtype: Boolean
