QryAccess
=========

Die Unit ist identisch zu QrySQLite arbeitet jedoch mit einer  Access-Datenbank. 

|  Die SQL-Strings sind nicht identisch zu QrySQLite, da SQLite teilweise  eine andere Syntax hat. 

.. py:module:: QryAccess
   :synopsis: Access-Datenbank-Abfragen für das   Programm DigiLek Lieferantenerklärungen 

.. py:class:: TWQryAccess(TWADOQuery)
   
   .. py:function:: LieferantenTeileNrInTabelle
      
      Lieferanten-TeileNr aus temp Tabelle nach Bestellungen 
      
   
   .. py:function:: NeueLErklaerungenInTabelle
      
      Neue Teile-Lieferanten-Kombis aus Bestellungen in LErklaerungen 
      
   
   .. py:function:: AlteLErklaerungenLoeschen
      
      Lösche Teile-Lieferanten-Kombis, die nicht in Bestellungen sind.  
      
   
   .. py:function:: NeueLieferantenInTabelle
      
       Neue Lieferanten in Tabelle lieferanten. Lieferstatus "neu" ist default in "Lieferanten" 
      
   
   .. py:function:: MarkiereAlteLieferanten
      
      Entfallene Lieferanten in Tabelle markieren 
      
   
   .. py:function:: MarkiereAktuelleLieferanten
      
      Markiere Lieferanten, die in Bestellungen stehen,  als aktuell. 
      
   
   .. py:function:: ResetPumpenErsatzteilMarkierungInLieferanten
      
      Setze Markierung f Pumpen-/Ersatzteile zurück. 
      
   
   .. py:function:: MarkierePumpenteilLieferanten
      
      Markiere Lieferanten die mind. 1 Pumpenteil liefern 
      
   
   .. py:function:: MarkiereErsatzteilLieferanten
      
      Markiere Lieferanten die mind. 1 Ersatzteil liefern 
      
   
   .. py:function:: TeileName1InTabelle
      
   
   .. py:function:: TeileName2InTabelle
      
   
   .. py:function:: UpdateTeilPumpenteile
      
   
   .. py:function:: UpdateTeilErsatzteile
      
   
   .. py:function:: UpdateTmpAnzLieferantenJeTeil
      
       Anzahl der Lieferanten eines Teils in tmp Tabelle  tmp_anz_xxx_je_teil  
      
   
   .. py:function:: UpdateTeileZaehleLieferanten
      
       Anzahl der Lieferanten eines Teils in Tabelle Teile 
      
   
   .. py:function:: UpdateLieferantenAnsprechpartner
      
       Überträgt Ansprechpartner in Tabelle Lieferanten_Adressen 
      
   
   .. py:function:: HoleLieferantenMitAdressen
      
       Liest Tabelle Lieferanten mit Adressdaten 
      
   
   .. py:function:: HoleLieferantenFuerTeileEingabe(min_guelt:string)
      
       Liest Lieferanten fuer die teilespezifische Eingabe 
      
      Liest nur Lieferanten die Pumpenteile liefern  mit gültiger Erklärung (Anzahl Tage Restgültig.> min_guelt)  mit Status der LEKL=3 (einige Teile) 

      
      :param string min_guelt: 
   
   .. py:function:: HoleLieferantenStatusTxt
      
       Liest LieferantenStatus im Klartext 
      
   
   .. py:function:: HoleLErklaerungen(IdLieferant:Integer)
      
       Liest Tabelle LErklaerungen mit Zusazdaten zu Teilen.  
      
      :param Integer IdLieferant: 
   
   .. py:function:: HoleBestellungen
      
   
   .. py:function:: HoleLieferanten
      
   
   .. py:function:: HoleTeile
      
   
   .. py:function:: HoleLieferantenZuTeil(TeileNr:String)
      
      Liest Teile mit Lieferanten-Info  
      
      :param String TeileNr: 
   
   .. py:function:: HoleTeileZumLieferanten(IdLieferant:String)
      
      :param String IdLieferant: 
   
   .. py:function:: ResetLPfkInLErklaerungen(IdLieferant:String)
      
       Set LPfk-Flag in Tabelle LErklaerungen 
      
      :param String IdLieferant: 
   
   .. py:function:: UpdateLPfkInLErklaerungen(IdLieferant:Integer;TeileNr:String;Pfk:Integer)
      
       Set LPfk-Flag in Tabelle LErklaerungen 
      
      :param Integer IdLieferant: 
      :param String TeileNr: 
      :param Integer Pfk: 
   
   .. py:function:: UpdateLieferant(IdLieferant:Integer;Stand,GiltBis,lekl,Kommentar:String)
      
       Setzt Stand, gilt_bis und lekl in Tabelle Lieferanten 
      
      :param Integer IdLieferant: 
      :param String Stand: 
      :param String GiltBis: 
      :param String lekl: 
      :param String Kommentar: 
   
   .. py:function:: UpdateLieferantStand(IdLieferant:Integer;Stand:String)
      
       Setzt Stand (Bearbeitungsdatum) in Tabelle Lieferanten 
      
      :param Integer IdLieferant: 
      :param String Stand: 
   
   .. py:function:: UpdateLieferantStandTeile(IdLieferant:Integer;Stand:String)
      
       Setzt Stand (Bearbeitungsdatum) in Tabelle Lieferanten 
      
      :param Integer IdLieferant: 
      :param String Stand: 
   
   .. py:function:: UpdateLieferantAnfrageDatum(IdLieferant:Integer;Datum:String)
      
       Setzt Datum der lezten Anfrage in Tabelle Lieferanten 
      
      :param Integer IdLieferant: 
      :param String Datum: 
   
   .. py:function:: LeklMarkiereAlleTeile(delta_days:String)
      
      markiere Teile von Lieferanten mit gültiger Erklärung "alle Teile" in Tabelle LErklaerungen 
      
      :param String delta_days: 
   
   .. py:function:: LeklMarkiereEinigeTeile(delta_days:String)
      
      markiere Teile von Lieferanten mit gültiger Erklärung "einige Teile" in Tabelle LErklaerungen 
      
      :param String delta_days: 
   
   .. py:function:: UpdateTeileDeletePFK
      
       Loesche PFK-Flag eines Teils in Tabelle Teile,  wenn ein Lieferant EU-Herkunft nicht bestätigt 
      
   
   .. py:function:: UpdatePFKTabellePFK0
      
       Übertrage Teile mit in UNIPPS zu loeschenden PFK-Flags in  Tabelle Export_PFK 
      
   
   .. py:function:: UpdatePFKTabellePFK1
      
       Übertrage Teile mit in UNIPPS zu setzenden PFK-Flags in  Tabelle Export_PFK 
      
   
   .. py:function:: HoleAnzahlTabelleneintraege(tablename:String)
      
      :param String tablename: 
   
   .. py:function:: HoleAnzahlPumpenteile
      
   
   .. py:function:: HoleAnzahlPumpenteileMitPfk
      
   
   .. py:function:: HoleAnzahlLieferanten
      
   
   .. py:function:: HoleAnzahlLieferPumpenteile
      
   
   .. py:function:: HoleAnzahlLieferStatusUnbekannt
      
   
   .. py:function:: LiesProgrammDatenWert(Name:String)
      
      :param String Name: 
   
   .. py:function:: SchreibeProgrammDatenWert(Name,Wert:String)
      
      :param String Name: 
      :param String Wert: 
