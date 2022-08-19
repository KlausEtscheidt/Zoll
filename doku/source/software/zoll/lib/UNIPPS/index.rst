UNIPPS
------

Hier liegen die Units zur Abbildung einer UNIPPS-Struktur. 
Als Basis dient die Klasse :class:`Stueckliste.TWStueliPos` von der :class:`UnippsStueliPos.TWUniStueliPos` erbt.
Alle Klassen (ausser Bestellung und Teil) stellen Positionen einer Stückliste dar. 

Über die Basisklasse besitzen sie:

- eine untergeordnete Stückliste, die wiederum aus Stücklistenpositionen besteht
- eine Stückzahl
- eine Ebene (Tiefe im Stücklistenbaum)
- einen Vaterknoten

Die Klasse TWStueliPos ist daher prinzipell als Basis für andere Stücklisten oder Baumstrukturen geeignet.
TWUniStueliPos ist die UNIPPS spezifische Ableitung dieser Basis.
Alle anderen Stücklisten-Klassen erben von TWUniStueliPos. 
Sie enthalten einige projektspezifische Funktionen können jedoch als Basis für andere UNIPPS-Auswertungen dienen.

.. toctree::
   :caption: Die folgenden Units bilden Stücklistenpositionen ab.

   Kundenauftrag
   KundenauftragsPos
   FertigungsauftragsKopf
   FertigungsauftragsPos
   TeilAlsStuPos
   UnippsStueliPos

Die oben stehenden Units enthalten Klassen, die von :any:`Stueckliste.TWStueliPos` erben.

.. toctree::
   :caption: Zur Abbildung von Zusatzinformationen dienen:

   Bestellung
   Teil

