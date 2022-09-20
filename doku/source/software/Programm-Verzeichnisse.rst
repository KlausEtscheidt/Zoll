Verzeichnis-Struktur
====================

Das Programm besteht neben den Modulen, die speziell für dieses Projekt erstellt wurden,
aus Units allgemeiner Natur, die auch für andere Projekte genutzt werden könnten.
Hierauf wird in der Beschreibung der Module noch eingegangen. 

Das Programm ist entsprechend der zu bearbeitenden Teilaufgaben auf mehrere Verzeichnisse aufgeteilt:

Hauptprojektverzeichnis
-----------------------

Hier liegen die Units der Bedienoberfläche (Formular :doc:`zoll/Hauptfenster`, Formular :doc:`zoll/Preiseingabe`), ein :doc:`zoll/DatenModul` (class(TDataModule)) und 
die Unit Auswerten, in welcher der Ablauf der Auswertung (s. :ref:`Ablauf aus Benutzer-Sicht`) gesteuert wird. 

Die Unit :doc:`zoll/Auswerten` baut nach der Abfrage der Preise die UNIPPS-Struktur auf. Dies ist zeitaufwändig und geschieht daher in einem eigenen Thread.
Abschließend erfolgt für diese Struktur die Ermittlung der Präferenzberechtigung.
Die Ergebnisse werden dem Benutzer im Hauptformular angezeigt.

:doc:`zoll/DatenModul` ist der zentrale Datenspeicher des Programms. Es werden zwei Tabellen definiert:

    - ErgebnisDS
    - AusgabeDS

Beide sind aus der Klasse :py:class:`PumpenDataSet.TWDataSet` , welche von TDataSet abgeleitet wurde.
ErgebnisDS speichert die Gesamtmenge der ermittelten Stücklistendaten.
AusgabeDS ist ein Extrakt hieraus, der fuer die unterschiedlichen Ausgabeformen dynamisch angepasst wird.
Hierzu werden die Daten von einer TFDBatchmove-Komponente von der Eingabe zur Ausgabe transferiert.
Mit TFDBatchmove werden auch die CSV-Dateien erzeugt.
:py:class:`DatenModul.TKaDataModule` enthält umfangreichere Software zur dynamischen Defintion von DataSets.

Datenbank
---------

In  :doc:`Datenbank<zoll/lib/Datenbank/index>` liegen die Units zur Abfrage der UNIPPS-Daten. 
Es handelt sich um die Units :doc:`zoll/lib/Datenbank/ADOConnector` und :doc:`zoll/lib/Datenbank/ADOQuery`, 
mit denen grundsätzlich Datenbanken abgefragt werden können. 
Hierzu kann die UNIPPS-Informix-Datenbank oder eine beliebige SQLite-Datenbank verwendet werden.

In :doc:`zoll/lib/Datenbank/BaumQryUNIPPS` bzw :doc:`zoll/lib/Datenbank/BaumQrySQLite`, 
sind die projektspezifischen Abfragen definiert. 
BaumQrySQLite dient dabei lediglich zu Testzwecken, um unabhängig von UNIPPS mit einer Testdatenbank entwickeln zu können.
Durch bedingte Kompilierung und Umschalten der Konfiguration in Delphi wird zwischen den beiden Varianten gewechselt.
Beim Setzen der Compiler-Bedingung $HOME oder $SQLITE wird die SQLite-Datenbank gewählt.
Beide Units liefern für jede Abfrage ein Objekt der Klasse :py:class:`ADOQuery.TWADOQuery`.

Die Unit :doc:`zoll/lib/Datenbank/PumpenDataSet` dient zum Abspeichern der ermittelten Daten in einem erweiterten TClientDataSet.

UNIPPS
------

In :doc:`zoll/lib/UNIPPS/index` liegen alle Units, die eine UNIPPS-Struktur auslesen und in Delphi abbilden.
Dies ist der zentrale und komplexeste Teil des Programms.

Stueli
------

Die Unit  :doc:`zoll/lib/Stueli/Stueckliste` enthält die Basisklasse für die Stücklisten in UNIPPS.
Diese Klasse ist allgemeiner Natur und zur Abbildung beliebiger Stücklisten geeignet.

Drucken
-------

Die Units in :doc:`zoll/lib/Drucken/index` ermöglichen das Ausdrucken einer Tabelle.

Tools
-----

Die Units in :doc:`zoll/lib/Tools/index` sind unterstützender Natur.
Sie dienen der Konfiguration des Programm, dem Ablegen einiger globaler Variablen
und zum Schreiben in Textfiles.
