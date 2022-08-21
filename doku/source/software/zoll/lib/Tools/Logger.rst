Logger
======

.. py:module:: Logger

.. py:class:: TLogFile(TStreamWriter)
   Komfort-Funktionen zum Oeffnen von textfiles



   .. py:method:: OpenAppend (filedir string; filename string);
      Oeffnet Datei zum Anfügen


      :param string filedir: Pfad ohne slash am Ende
      :param string filename: Dateiname ohne slash am Anfang

   .. py:method:: OpenNew (filedir string; filename string);
      Oeffnet neue leere Datei


      :param string filedir: Pfad ohne slash am Ende
      :param string filename: Dateiname ohne slash am Anfang

   .. py:method:: Log (msg string);
      Schreibt msg in Datei


      :param string msg: 

   .. py:method:: Trennzeile (txt string; Anzahl Integer);
      Schreibt txt wiederholt in Datei


      :param string txt: Zeichen, die wiederholt werden
      :param Integer Anzahl: Anzahl der Wiederholungen

   .. py:attribute:: fullpath
