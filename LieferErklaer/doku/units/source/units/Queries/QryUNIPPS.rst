QryUNIPPS
=========

Abfrage-Generator für UNIPPS-Abfragen. 

|  Anwendungsbeispiel: Abfrage zum Lesen des Kundenauftrags und seiner Positionen 
|  Abfrage erzeugen 
|  KAQry := TWBaumQryUNIPPS.Create(nil); 
|  Datenbank-Connector setzen (DbConnector hat Typ TADOConnector) 
|  KAQry.Connector:=DbConnector; 
|  SQL für Abfrage setzen und Abfrage ausführen 
|  gefunden := KAQry.SucheKundenAuftragspositionen(ka_id); 
|   gefunden wird True, wenn die Abfrage Daten fand.   Über KAQry können die Daten mit den Methoden der TADOQuery weiter verarbeitet werden. 
|  Für das Programm PräFix wurden die ersten beiden Schritte   in der Methode getQuery der Unit Tools zusammengfasst: 
|  KAQry := Tools.getQuery; 

.. py:module:: QryUNIPPS
   :synopsis: UNIPPS-Datenbank-Abfragen für das Programm LEKL 

.. py:class:: TWQryUNIPPS(TWADOQuery)
   
   Abfragengenerator für alle nötigen UNIPPS-Abfragen.  
   
   .. py:function:: SucheBestellungen(delta_days:String)
      
      Suche Bestellungen in UNIPPS bestellkopf 
      
      Eindeutige Kombination aus IdLieferant, TeileNr  Zusatzinfo zu Lieferant: Kurzname,LName1,LName2 bzw zu Teil LTeileNr 

      
      :param String delta_days: Zeitraum ab heute-delta_days
   
   .. py:function:: HoleLieferantenAdressen
      
      Liest Adressdaten aller Lieferanten 
      
   
   .. py:function:: HoleLieferantenAnspechpartner
      
   
   .. py:function:: ZaehleAlleLieferantenTeilenummern
      
      Zaehle alle Lieferanten-Teilenummer in UNIPPS  
      
   
   .. py:function:: SucheAlleLieferantenTeilenummern(skip:Integer)
      
      Suche Alle Lieferanten-Teilenummer in UNIPPS  
      
      :param Integer skip: 
   
   .. py:function:: SucheLieferantenTeilenummer(IdLieferant:String;TeileNr:String)
      
      Suche Lieferanten-Teilenummer in UNIPPS  
      
      :param String IdLieferant: 
      :param String TeileNr: 
   
   .. py:function:: SucheTeileBenennung(delta_days:String)
      
      Suche Benennung zu bestellten Teilen in UNIPPS  
      
      :param String delta_days: 
   
   .. py:function:: SucheTeileInKA(TeileNr:String)
      
      Sucht Teil als Position eines KA in UNIPPS auftragpos 
      
      :param String TeileNr: t_tg_nr des Teils
   
   .. py:function:: TesteAufErsatzteil(delta_days:String)
      
      Teil in KA in UNIPPS auftragpos ist Ersatzteil 
      
      :param String delta_days: 
   
   .. py:function:: TesteAufPumpenteil(delta_days:String)
      
      Teile in FA, FA-Kopf oder Stückliste sind Pumpenteil 
      
      :param String delta_days: 
   
   .. py:function:: SucheTeileInFA(TeileNr:String)
      
      Sucht Teil als Position eines FA in UNIPPS astuelipos 
      
      :param String TeileNr: t_tg_nr des Teils
   
   .. py:function:: SucheTeileInFAKopf(TeileNr:String)
      
      Sucht Teil in FA-Kopf in UNIPPS f_auftragkopf 
      
      :param String TeileNr: t_tg_nr des Teils
   
   .. py:function:: SucheTeileInSTU(TeileNr:String)
      
      Sucht Teil in Stücklisten in UNIPPS teil_stuelipos 
      
      :param String TeileNr: t_tg_nr des Teils
   
   .. py:function:: HoleWareneingaenge
      
      Sucht Wareneingaenge seit Beginn des aktuellen Jahres 
      

.. py:attribute:: const sql_suche_Bestellungen
   
   :type:: String 
