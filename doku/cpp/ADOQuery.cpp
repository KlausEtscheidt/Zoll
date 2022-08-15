   
      class EWADOQuery(Exception){
      };
    
      /**
      * Funktionen fuer Abfragen auf Basis der TADOQuery
      *
      * Vor der ersten "Benutzung" einer neuen Instanz muss ein TWADOConnector für die Klasse gesetzt werden
      */
      class TWADOQuery{        
      /**
      * Insert-Statement für "tablename" anhand einer Feldliste ausführen
      *
      */
       Boolean InsertFields(string tablename; TFields myFields);
        
      /**
       * \brief Anzahl der gefundenen Records
       *
       */
        Integer n_records;

      };
    