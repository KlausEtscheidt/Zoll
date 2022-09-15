BaumQrySQLite
=============

Die Unit ist identisch zu BaumQryUNIPPS arbeitet jedoch mit einer  SQLite-Datenbank in der geeignete Daten hinterlegt sein müssen. 

|  Die Unit ermöglicht eine Entwicklung ohne UNIPPS-Zugang.  Sie wird durch Compiler-Flags anstatt BaumQryUNIPPS verwendet (s. Unit Tools)  und ist für den Produktivbetrieb überflüssig. 
|  Die Daten werden im UNIPPS-Modus durch Kopieren gewonnen. 
|  Die SQL-Strings sind nicht identisch zu BaumQryUNIPPS, da SQLite teilweise  eine andere Syntax hat, da die Daten aber auch in anderen Tabellen liegen. 

.. py:module:: BaumQrySQLite
   :synopsis: SQLite-Datenbank-Abfragen für das Programm PräFix 

.. py:class:: TWBaumQrySQLite(TWADOQuery)
   
   .. py:function:: SucheKundenAuftragspositionen(KaId:string)
      
      :param string KaId: 
   
   .. py:function:: SucheFAzuKAPos(KaId:String;id_pos:Integer)
      
      :param String KaId: 
      :param Integer id_pos: 
   
   .. py:function:: SucheFAzuTeil(t_tg_nr:String)
      
      :param String t_tg_nr: 
   
   .. py:function:: SuchePosZuFA(FA_Nr:String)
      
      :param String FA_Nr: 
   
   .. py:function:: SucheStuelizuTeil(t_tg_nr:String)
      
      :param String t_tg_nr: 
   
   .. py:function:: SucheDatenzumTeil(t_tg_nr:string)
      
      :param string t_tg_nr: 
   
   .. py:function:: SucheBenennungZuTeil(t_tg_nr:String)
      
      :param String t_tg_nr: 
   
   .. py:function:: SucheLetzte3Bestellungen(t_tg_nr:string)
      
      :param string t_tg_nr: 
   
   .. py:function:: SucheKundenRabatt(KaId:string)
      
      :param string KaId: 
