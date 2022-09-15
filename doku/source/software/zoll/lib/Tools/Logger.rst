Logger
======


.. py:module:: Logger

.. py:class:: TLogFile(TStreamWriter)
   Komfort-Funktionen zum Oeffnen von textfiles   
    
   .. py:method:: OpenAppend(filedir:string;filename:string)
      Oeffnet Datei zum Anfügen 
      
      :param string filedir: Pfad ohne slash am Ende 
      :param string filename: Dateiname ohne slash am Anfang
    
   .. py:method:: OpenNew(filedir:string;filename:string)
      Oeffnet neue leere Datei  
      
      :param string filedir: Pfad ohne slash am Ende 
      :param string filename: Dateiname ohne slash am Anfang
    
   .. py:method:: Destroy)
      
    
   .. py:method:: Log(msg:String)
      Schreibt msg in Datei 
      
      :param String msg: 
    
   .. py:method:: Trennzeile(txt:String;Anzahl:Integer)
      Schreibt txt wiederholt in Datei 
      
      :param String txt: Zeichen, die wiederholt werden
      :param Integer Anzahl: Anzahl der Wiederholungen
