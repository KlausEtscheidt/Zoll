ADOConnector
============

Funktionalitäten aus der Delphi-Klasse TADOConnection werden ergänzt, um komfortabel eine Verbindung zur WERNERT-Unipps-Datenbank oder zur einer beliebigen SQLite-Datenbank aufzubauen.

Die Eigenschaft Connection enthält eine TADOConnection, die an Instanzen von TWADOQuery übergeben werden kann.

.. py:module:: ADOConnector
   :synopsis: Komfort-Funktionen zum Verbinden mit einer Datenbank

.. py:exception:: EADOConnector(Exception)
   Wenn die Verbindung zur Datenbank fehlschlägt, wird der Fehler: "Konnte Datenbank nicht öffen." erzeugt.

.. py:class:: TWADOConnector(TComponent)
      Klasse zur einfachen Verbindung mit UNIPPS oder SQLite

      .. py:attribute:: verbunden
         True, wenn Verbindung hergestellt.

         :type: Boolean

      .. py:attribute:: Datenbank
         Name der Datenbank (z Debuggen)

         :type: string

      .. py:attribute:: Datenbankpfad
         Pfad zur Datenbank (bei SQLite-DB)

         :type: string

      .. py:function:: ConnectToUNIPPS : TADOConnection;
         Mit UNIPPS-Datenbank verbinden.

         Die Verbindung erfolgt über die allgemeine Funktion ConnectToDB.

         :return: Geöffnete TADOConnection

      .. py:function:: ConnectToSQLite (PathTODBFile string): TADOConnection;
         Mit SQLite-Datenbank verbinden.

         Die Verbindung erfolgt über die allgemeine Funktion ConnectToDB.

         :param string PathTODBFile: Pfad zur SQLite-Datenbank-Datei.
         :return: Geöffnete TADOConnection

      .. py:function:: ConnectToDB (AConnectStr string; AProvider string): TADOConnection;
         Mit beliebiger Datenbank verbinden.

         Per Connection-String und Provider wird eine Verbindung (TADOConnection) zu einer beliebigen Datenbank hergestellt.

         Die Werte für Connection-String und Provider müssen an die spezielle Datenbank angepasst werden und müssen in deren Doku recherchiert werden.

         Es wird ein Fehler erzeugt, wenn der Connection.State ungleich stOpen oder wenn die verbundene DB keine Tabellen enthält.

         Im Erfolgsfall enthält die Eigenschaft Tabellen, die in der DB gefundenen Tabellen, die Eigenschaft Connection die geöffnete TADOConnection und die Eigenschaft verbunden, wird auf True gesetzt.

         :param string AConnectStr: Zum Öffnen der DB geeigneter Connection-String.
         :param string AProvider: Zum Öffnen der DB geeigneter Provider.
         :return: Geöffnete TADOConnection

      .. py:property:: Connection
         Verbindung zur Datenbank

         type: TADOConnection

      .. py:property:: Tabellen
         Liste aller Tabellen der Datenbank

         type: TArray<System.string>
