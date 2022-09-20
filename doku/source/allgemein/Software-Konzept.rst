Software-Konzept
================

Aufgrund der komplexen Suche enthält das Programm viele Elemente, die eigentlich nur dem Debuggen dienen.
Hierauf wird im Folgenden noch eingegangen.

Ablauf der Stücklistensuche
---------------------------

Ziel der Suche ist es, ausgehend vom Kundenauftrag alle untergeordneten Teile zu finden
und in eine Baumstruktur einzuordnen. 
Alle Datenbank-Abfragen hierzu sind als Funktionen in :py:mod:`BaumQryUNIPPS` abgelegt.

.. toctree::
   :maxdepth: 1
   :caption: Details hierzu in:
   
   UnippsDetails



Kundenauftrag
.............

Die Suche beginnt deshalb mit der Suche nach einem Kundenauftrag und dessen Positionen.
Hierzu dienen die Units :py:mod:`Kundenauftrag` und  :py:mod:`KundenauftragsPos`.
Falls die Positionen Kaufteile oder zugekaufte Fertigunsteile sind, 
ist die Suche für diese Positionen abgeschlossen.

kommissionsbez. Fertigungsauftrag
.................................

FÜr alle Positionen des Kundenauftrages, die keine Zukaufteile sind, 
werden zuerst kommissionsbezogene Fertigungsaufträge gesucht.
Diese haben Priorität vor den Teilestücklisten.

Der Kopf des Fertigungsauftrages wird in der Unit :py:mod:`FertigungsauftragsKopf` 
als eigenes Stücklistenpositions-Objekt abgebildet und aus Gründen der Nachvollziehbarkeit
(debuggen) in den Stücklistenbaum integriert. 
Für die endgültige Kurzform der Dokumentation werden sie wieder entfernt.

:ref:`Tabelle-ASTUELIPOS`


Datenspeicherung
----------------

.. _Datenspeicherung:

Die Daten werden auf zwei Arten gespeichert:
- als Objektstruktur
- und in Tabellenform




