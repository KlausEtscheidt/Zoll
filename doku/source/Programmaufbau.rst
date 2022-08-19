Programm-Aufbau
===============

Das Programm ist entsprechend der zu bearbeitenden Teilaufgaben auf mehrere Verzeichnisse aufgeteilt:

Hauptprojektverzeichnis
-----------------------

Hier liegen die Units der Bedienoberfläche (Formular :doc:`Hauptfenster`, Formular :doc:`Preiseingabe`), ein :doc:`DatenModul` (class(TDataModule)) und 
die Unit :doc:`Auswerten`, in welcher der Ablauf der Auswertung (s. :ref:`Ablauf aus Benutzer-Sicht`) gesteuert wird. 
Die Unit Auswerten baut nach der Abfrage der Preise die UNIPPS-Struktur auf. Dies ist zeitaufwändig und geschieht daher in einem eigenen Thread.
Abschließend erfolgt für diese Struktur die Ermittlung der Präferenzberechtigung.
Die Ergebnisse werden dem Benutzer im Hauptformular angezeigt.

:doc:`DatenModul` ist der zentrale Datenspeicher des Programms. Es werden zwei Tabellen definiert:

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

In  :doc:`Datenbank<lib/Datenbank/index>` liegen die Units zur Abfrage der UNIPPS-Daten. 
Es handelt sich um die Units :doc:`lib/Datenbank/ADOConnector` und :doc:`lib/Datenbank/ADOQuery`, 
mit denen grundsätzlich Datenbanken abgefragt werden können. 
Hierzu kann die UNIPPS-Informix-Datenbank oder eine beliebige SQLite-Datenbank verwendet werden.

In :doc:`lib/Datenbank/BaumQryUNIPPS` bzw :doc:`lib/Datenbank/BaumQrySQLite`, 
sind die projektspezifischen Abfragen definiert. 
BaumQrySQLite dient dabei lediglich zu Testzwecken, um unabhängig von UNIPPS mit einer Testdatenbank entwickeln zu können.
Durch bedingte Kompilierung und Umschalten der Konfiguration in Delphi wird zwischen den beiden Varianten gewechselt.
Beim Setzen der Compiler-Bedingung $HOME oder $SQLITE wird die SQLite-Datenbank gewählt.
Beide Units liefern für jede Abfrage ein Objekt der Klasse :py:class:`ADOQuery.TWADOQuery`.

Die Unit :doc:`lib/Datenbank/PumpenDataSet` dient zum Abspeichern der ermittelnten Daten in einem erweiterten TClientDataSet.

UNIPPS
------

In :doc:`lib/UNIPPS/index` liegen alle Units, die eine UNIPPS-Struktur auslesen und in Delphi abbilden.
Dies ist der zentrale und komplexeste Teil des Programms.


Drucken
-------

Die Units in :doc:`lib/Drucken/index` ermöglichen das Ausdrucken einer Tabelle.

Tools
-----

Die Units in :doc:`lib/Tools/index` sind unterstützender Natur.
Sie dienen der Konfiguration des Programm, dem Ablegen einiger gloabler Variablen
und zum Schreiben in Textfiles.


  - dem Hauptformular
    Benutzeroberfläche und die Software zur Berechnung sind weitestgehend getrennt.
    Das Hauptformular enthält kaum Code und ist daher selbsterklärend
    Es ermöglicht die Eingabe, der ID des auszuwertenden Kundenauftrages
    und das Starten der Auswertung bzw der PDF-Erzeugung.

  - Dem Formular zur :doc:`Preiseingabe`
    Wird als modaler Dialog geöffnet und zeigt Daten über ein TDBGrid an.
    Das TDBGrid bezieht seine Daten aus einem TWDataset (s. xxx), welches von TDataset erbt.

  
  - Der Unit :doc:`Auswerten` 
    Hier wird der Ablauf der Auswertung gesteuert. 
    Die Unit trenntund die projektspefischen Software-Anteile von den allgemeingültigeren Units in UNIPPS


Ablauf aus Programmierer-Sicht
==============================