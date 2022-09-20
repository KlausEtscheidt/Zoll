Kundenauftrag
=============

Die Klasse TWKundenauftrag bildet die oberste Ebene der auszulesenden  UNIPPS-Struktur ab. Sie ist vom Typ Stücklistenposition, da sie eine  untergeordnete Stückliste besitzt (geerbt von TWStueliPos). Diese enthält  die direkt untergeordneten Positionen des Kundenauftrags, die aus der  UNIPPS-Tabelle Auftragpos gelesen werden. 


.. py:module:: Kundenauftrag
   :synopsis: Oberster Knoten der UNIPPS-Struktur 

.. py:class:: EWKundenauftrag(Exception)
   
   Klasse für Exceptions dieser Unit 

.. py:class:: TWKundenauftrag(TWUniStueliPos)
   
   Kundenauftrag: Oberster Knoten der UNIPPS-Struktur 
   
   .. py:data:: var KaId
      
      UNIPPS-Id des Kundenauftrages 
      
      :type:: String
   
   .. py:data:: var komm_nr
      
      Kommissionsnummer des Kundenauftrages 
      
      :type:: String
   
   .. py:data:: var kunden_id
      
      UNIPPS-Id des Kunden zu diesem Auftrag 
      
      :type:: Integer
    
   .. py:method:: Create(NewKaId:String)
      
      Erzeugt über Basisklasse eine Stücklistenposition  
      
      :param String NewKaId: UNIPPS-Id des Kundenauftrages
    
   .. py:method:: liesKopfundPositionen
      
      Liest die Kopfdaten und die direkt (1. Ebene) untergeordneten Positionen des Kundenauftrags aus UNIPPS. 
      
      Über die KundenId wird der prinzipielle Rabatt dieses Kunden gelesen.  Für die gefundenen Positionen werden Objekte des Typs TWKundenauftragsPos  erzeugt und in die eigene Stückliste eingetragen. 

      :raises EWKundenauftrag: Wenn keine Kinder-Pos gefunden
      
    
   .. py:method:: holeKinder
      
      Schrittweise Suche aller untergeordneten Elemente  
      
      | Kommissions-FA haben bei der Suche Priorität. Daher zuerst:  
      | Fuer alle Stüli-Pos, die kein Kaufteil sind,  rekursiv in der UNIPPS-Tabelle ASTUELIPOS nach Kindern suchen.  
      | Gefundene Kinder werden in die zugehörige Stückliste aufgenommen.  
      | Alle Kinder, die in ASTUELIPOS selbst keine Kinder mehr haben,  werden in der Liste EndKnoten vermerkt, wenn es keine Kaufteile sind.  
      |   
      | In EndKnoten sollten jetzt nur noch Serien- und Fremd-Fertigungsteile sein.  
      | Mit TWUniStueliPos.holeKindervonEndKnoten wird nun nach Kindern  der Endknoten gesucht.  
      | Gefundene Kinder werden in die zugehörige Stückliste aufgenommen.  
      | Kinder, die nicht Kaufteil sind, werden in eine neue EndKnoten-Liste übernommen.  
      | Dies wird wiederholt, bis die neue EndKnoten-Liste leer bleibt. 
      
    
   .. py:method:: SammleAusgabeDaten
      
      Überträgt nach erfolgter Analyse rekursiv alle relevanten Daten in das DataSet ErgebnisDS. 
      
    
   .. py:method:: ErmittlePraferenzBerechtigung
      
      Ermittelt die Präferenz-Berechtigung für alle Positionen des Kundenauftrages. 
      
      Vorraussetzungen: Für alle Pos sind Verkaufspreise bekannt und die Kosten  der untergeordneten Kaufteile wurden für die Pos aufsummiert.  Dabei fließen die Preise der Teile, die in UNIPPS kein Flag praeferenzkennung  besitzen, in den Wert SummeNonEU ein.  

      | Bei Positionen, die aus einem Kauf- oder Fremdfertigungs-Teil bestehen und  bei denen SummeNonEU nicht Null ist, war dieses Flag nicht gesetzt. Sie sind  daher selbst auch nicht "Präferenz berechtigt".  
      | Für alle anderen Pos wird das Verhältnis aus SummeNonEU zum Verkaufspreis  gebildet. Überschreitet dieses den Grenzwert MaxAnteilNonEU aus Settings.pas,  ist die Pos nicht "Präferenz berechtigt". 
      
