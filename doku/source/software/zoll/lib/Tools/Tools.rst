Tools
=====

.. py:module:: Tools

.. py:class:: TWUNIPPSQry(TWADOQuery)

   .. py:function:: SucheKundenAuftragspositionen (KaId string): Boolean;

      :param string KaId: 

   .. py:function:: SucheFAzuKAPos (KaId string; id_pos Integer): Boolean;

      :param string KaId: 
      :param Integer id_pos: 

   .. py:function:: SucheFAzuTeil (t_tg_nr string): Boolean;

      :param string t_tg_nr: 

   .. py:function:: SuchePosZuFA (FA_Nr string): Boolean;

      :param string FA_Nr: 

   .. py:function:: SucheStuelizuTeil (t_tg_nr string): Boolean;

      :param string t_tg_nr: 

   .. py:function:: SucheDatenzumTeil (t_tg_nr string): Boolean;

      :param string t_tg_nr: 

   .. py:function:: SucheBenennungZuTeil (t_tg_nr string): Boolean;

      :param string t_tg_nr: 

   .. py:function:: SucheLetzte3Bestellungen (t_tg_nr string): Boolean;

      :param string t_tg_nr: 

   .. py:function:: SucheKundenRabatt (KaId string): Boolean;

      :param string KaId: 

   .. py:method:: init;


   .. py:function:: GetQuery : TWBaumQrySQLite;


   .. py:property:: Log

      :type: TLogFile

   .. py:property:: ErrLog

      :type: TLogFile

   .. py:property:: CSVKurz

      :type: TLogFile

   .. py:property:: CSVLang

      :type: TLogFile

   .. py:property:: DbConnector

      :type: TWADOConnector
