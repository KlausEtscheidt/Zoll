Programm-Aufbau
===============

Das Programm besteht aus:

  - dem Hauptformular
    Benutzeroberfläche und die Software zur Berechnung sind weitestgehend getrennt.
    Das Hauptformular enthält kaum Code und ist daher selbsterklärend
    Es ermöglicht die Eingabe, der ID des auszuwertenden Kundenauftrages
    und das Starten der Auswertung bzw der PDF-Erzeugung.

  - Dem Formular zur :doc:`Preiseingabe`
    Wird als modaler Dialog geöffnet und zeigt Daten über ein TDBGrid an.
    Das TDBGrid bezieht seine Daten aus einem TWDataset (s. xxx), welches von TDataset erbt.

  - Einem :doc:`DatenModul` class(TDataModule)
    Hier werden in der Hautsache zwei Tabellen definiert:

    - ErgebnisDS
    - AusgabeDS

    Beide sind aus der Klassen TWDataSet, welche von TDataSet abgeleitet wurde.
    ErgebnisDS speichert die Gesamtmenge der ermittelten STücklistendaten
    AusgabeDS ist ein Extrakt hieraus, der fuer die unterschiedlichen Ausgabeformen dynamisch angepasst wird.
    Hierzu werden die Daten von einer TFDBatchmove-Komponente von der Eingabe zur Ausgabe transferiert.
    Mit dieser werden auch die CSV-Dateien erzeugt.
    TKaDataModule enthält umfangreichere Software zur dynamischen Defintion von DataSets.

  - Der Unit :doc:`Auswerten` 
    Hier wird der Ablauf der Auswertung gesteuert. 
    Die Unit trenntund die projektspefischen Software-Anteile von den allgemeingültigeren Units in UNIPPS

  - Den Datenbankmodulen in  :doc:`lib/Datenbank/index`

  - Den Units in :doc:`lib/UNIPPS/index` , die eine UNIPPS-Struktur auslesen und in Delphi abbilden

  - Den Units in :doc:`lib/Drucken/index` zum Ausdrucken einer Tabelle

  - Unterstützenden Units in :doc:`lib/Tools/index`  

Ablauf aus Programmierer-Sicht
==============================