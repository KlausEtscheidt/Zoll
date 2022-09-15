Units im Hauptverzeichnis
=========================

- Formular :doc:`Hauptfenster` 
   Benutzeroberfläche und die Software zur Berechnung sind weitestgehend getrennt.
   Das Hauptformular enthält kaum Code und ist daher selbsterklärend.
   Es ermöglicht die Eingabe, der ID des auszuwertenden Kundenauftrages
   und das Starten der Auswertung bzw der PDF-Erzeugung.

- Formular zur :doc:`Preiseingabe`
   Wird als modaler Dialog geöffnet und zeigt Daten über ein TDBGrid an.
   Das TDBGrid bezieht seine Daten aus einem TWDataset (s. xxx), welches von TDataset erbt.

- :doc:`DatenModul` 
   Enthält visuelle Delphi-Komponenten zum Abspeichern und Ausgeben der ermittelten Daten

- Unit :doc:`Auswerten` 
   Zentrale Unit des Programms. Hier wird der Ablauf der Auswertung gesteuert. 

.. toctree::
   :maxdepth: 2
   :caption: Detail-Beschreibung:

   Hauptfenster
   Preiseingabe
   DatenModul
   Auswerten