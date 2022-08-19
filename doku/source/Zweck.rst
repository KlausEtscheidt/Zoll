Zweck des Programms
===================

Das Programm dient der Kalkulation der Präferenberechtigung unserer Produkte.
Die Präferenberechtigung ermöglich Verinfachungen/Kostenreduzierungen bei der Verzollung.
Sie wird erteilt, wenn ein Produkt größtenteils in der EU hergestellt wurde.

Hierzu muss ermittelt werden, wie das Verhältniss der Kosten aller Kaufteile,
die für die Herstellung eines Produktes (Pumpe/Ersatzteil) gebraucht werden,
zum Verkaufspreis des Produktes (abzüglich aller Rabatte) ist. 
Dabei müssen nur die Kaufteile berücksichtigt werden, die selbst nicht präferenzberechtigt sind.
Hierzu müssen die Artikel im UNIPPS ein entsprechendes Flag besitzen, welches vom Programm ausgelesen wird.

Die grundlegende Aufgabe besteht daher in der Ermittlung aller Teile, nach Art und Anzahl,
die in ein Produkt einfließen, also im Aufbau der kompletten Stücklistenstruktur.

Die Analyse findet auf Basis des Kundenauftrages (KA) statt. 
Für alle Positionen des KA wird das oben erwähnte Verhältnis bestimmt 
und dazu werden alle untergeordneten Stücklisten und deren Positionen ermittelt.

Das Ergebnis der Analyse wird in zwei Varianten erzeugt:

- einer Kurzform zur Dokumentation gegenüber Behörden
- einer ausführlichen Form, die es erlaubt den Ablauf der Analyse nachzuverfolgen

Die Ausgabe erfolgt als PDF und CSV.

Ablauf aus Benutzer-Sicht
=========================

Nach der Eingabe der ID des Kundenauftrages im Hauptformular, ermittelt das Programm die Positionen des Auftrags
und präsentiert diese dem Benutzer über das Formular :doc:`Preiseingabe`.

Dies ist für KA mit Neupumpen aus 2 Gründen nötig:

1. Bei Neupumpen sind im UNIPPS keine Preise hinterlegt. Diese müssen im Formular ergänzt werden.
   Werden nich für alle Pos. Preise eingegeben, bricht das Programm mit Fehlermeldung ab.
2. Bei Pumpen-Aggregaten steht der Motor nicht in der Stückliste des zugehörigen Aggregats.
   Im Sinne der Präferenzkalkulation muss er aber zu dieser Stückliste dazugerechnet werden.
   Der Benutzer kann daher im Formular angeben, das z.B. der Motor auf Pos. 3 zum Aggregat der Pos1. gehört.

Nach der Eingabe erfolgt die Ermittlung aller untergeordneten Stuecklisten, 
das "Umhängen" der Positionen entsprechend der Angaben im Formular und dann 
die Berechnung der benötigten Verhältnisse Kaufteile/Listenpreis.

Das Ergebnis wird dem Anwender präsentiert und kann dann von diesem über PDF-Erzeugung gedruckt werden.

Alle Auftragspositionen, bei denen die Kosten aller Nicht-EU-Kaufteile mehr als 40% des Netto-Verkaufspreises
betragen, werden dabei deutlich als nicht präferenzberechtigt gekennzeichnet.
Ausserdem alle Positionen, die reine Kaufteile sind, also von WERNERT nicht bearbeitet werden und dabei selbst
nicht präferenzberechtigt sind (Flag im UNIPPS). Auch diese Positionen sind nicht präferenzberechtigt.

Alle nicht präferenzberechtigten Positionen werden vom Verieb/Versand auf der Rechnung als solche gekennzeichnet.