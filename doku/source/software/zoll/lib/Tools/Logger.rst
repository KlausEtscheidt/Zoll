Logger
======


.. py:module:: Logger

.. py:class:: TLogFile(TStreamWriter)
   Komfort-Funktionen zum Oeffnen von textfiles   
    
   .. py:method:: OpenAppend
      Oeffnet Datei zum Anfügen 
      
      :param string filedir: Pfad ohne slash am Ende 
      :param string filename: Dateiname ohne slash am Anfang
    
   .. py:method:: OpenNew
      Oeffnet neue leere Datei  
      
      :param string filedir: Pfad ohne slash am Ende 
      :param string filename: Dateiname ohne slash am Anfang
    
   .. py:method:: Destroy
      
    
   .. py:method:: Log
      Schreibt msg in Datei 
      
      :param String msg: 
    
   .. py:method:: Trennzeile
      Schreibt txt wiederholt in Datei 
      
      :param String txt: Zeichen, die wiederholt werden
      :param Integer Anzahl: Anzahl der Wiederholungen
