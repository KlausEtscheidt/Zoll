ADOConnector
============

Funktionalitäten aus der Delphi-Klasse TADOConnection werden ergänzt,  um komfortabel eine Verbindung zur WERNERT-Unipps-Datenbank oder  zur einer beliebigen SQLite-Datenbank aufzubauen.  

|   Die Eigenschaft Connection enthält eine TADOConnection,  die an Instanzen von TWADOQuery übergeben werden kann. 

.. py:module:: ADOConnector
   :synopsis: Komfort-Funktionen zum Verbinden mit einer Datenbank  

.. py:class:: EADOConnector(Exception)
   Wenn die Verbindung zur Datenbank fehlschlägt, wird der Fehler: &quot;Konnte Datenbank nicht öffen.&quot; erzeugt. 

.. py:class:: TWADOConnector(TComponent)
   Klasse zur einfachen Verbindung mit UNIPPS oder SQLite 
   
   .. py:property:: Connection
      Verbindung zur Datenbank 
      
      :type:: TADOConnection 
   
   .. py:property:: Tabellen
      Liste aller Tabellen der Datenbank 
      
      :type:: System.TArray<String> 
   
   .. py:data:: var verbunden
      True, wenn Verbindung hergestellt. 
      
      :type:: Boolean
   
   .. py:data:: var Datenbank
      Name der Datenbank (z Debuggen) 
      
      :type:: String
   
   .. py:data:: var Datenbankpfad
      Pfad zur Datenbank (bei SQLite-DB) 
      
      :type:: String
    
   .. py:method:: Create
      
      :param TComponent AOwner: 
   
   .. py:function:: ConnectToUNIPPS
      Mit UNIPPS-Datenbank verbinden. 
      
      Die Verbindung erfolgt über die allgemeine Funktion ConnectToDB. 

      
      :return: Geöffnete TADOConnection  
   
   .. py:function:: ConnectToSQLite
      Mit SQLite-Datenbank verbinden. 
      
      Die Verbindung erfolgt über die allgemeine Funktion ConnectToDB. 

      
      :param String PathTODBFile: Pfad zur SQLite-Datenbank-Datei.
      :return: Geöffnete TADOConnection  
   
   .. py:function:: ConnectToDB
      Mit beliebiger Datenbank verbinden. 
      
      Per Connection-String und Provider wird eine Verbindung (TADOConnection)  zu einer beliebigen Datenbank hergestellt.  

      |   Die Werte für Connection-String und Provider müssen an die spezielle  Datenbank angepasst werden und müssen in deren Doku recherchiert werden.  
      |   Es wird ein Fehler erzeugt, wenn der Connection.State ungleich stOpen  oder wenn die verbundene DB keine Tabellen enthält.  
      |   Im Erfolgsfall enthält die Eigenschaft Tabellen, die in der DB gefundenen  Tabellen, die Eigenschaft Connection die geöffnete TADOConnection  und die Eigenschaft verbunden, wird auf True gesetzt. 
      
      :param String AConnectStr: Zum Öffnen der DB geeigneter Connection-String. 
      :param String AProvider: Zum Öffnen der DB geeigneter Provider.
      :return: Geöffnete TADOConnection  
