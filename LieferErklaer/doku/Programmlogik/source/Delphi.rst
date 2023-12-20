Der Ablauf in Delphi wird durch einen automatischen Ablauf beim Programmstart 
und die Benutzeraktionen in Menüs, :ref:`Formularen<FormulareRef>` und :ref:`Dialogen<DialogeRef>`  bestimmt.

Programmstart
=============

In den Units Import und Tools gibt es Initialisierungs-Funktionen.
Anschließend wird die MainForm geladen.

Tools
-----

Tools.Init wird zuerst durchlaufen und verbindet in Tools.GetConnection mit der Datenbank.

Tools.CheckUser ermittelt den Windows-Usernamen und die Faxvorlage.

Tools.CopyHelpToTmp verschiebt Help-File auf lokale Platte, da dieser auf einem Netz-LW nicht korrekt angezeigt wird.

Import
------

Import.Init erzeugt die zwei Abfrage-Objekte "LocalQry1" bzw "UnippsQry1", 
die im Weiteren für die meisten Access- bzw UNIPPS-Abfragen genutzt werden.

mainfrm
-------

In TmainForm.FormShow wird LieferantenErklAnfordernFrm1.ShowFrame gerufen.

Mit dem Laden des Formular-Frames LieferantenErklAnfordernFrm1 endet der automatische Start-Ablauf.
Alle weiteren Aktionen werden durch Benutzereingaben (Menüwahl, Buttons in Formularen, etc.) gestartet.


Menüs
=====

.. #################################################################################

Lieferanten
-----------

Erklärungen anfordern/eingeben
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

öffnet Formular :ref:`LeklAnfordernFrame<FormLeklAnfordern>` 

LieferantenErklAnfordernFrm1.ShowFrame;

ruft 

LocalQry.HoleLieferantenMitAdressen;

Status prüfen/eingeben
~~~~~~~~~~~~~~~~~~~~~~

öffnet Formular :ref:`LeklStatusEingabeFrame<FormLeklStatuseingabe>` 

LeklStatusEingabeFrm.ShowFrame

ruft LocalQry.HoleLieferantenMitAdressen

Teile
-----

Status eingeben
~~~~~~~~~~~~~~~

öffnet Formular :ref:`LieferantenLEKL3AuswahlFrame<FormLekl3Statuseingabe>` 

Lekl3LieferantAuswahlFrm.ShowFrame

ruft LocalQry.HoleLieferantenFuerTeileEingabe

Export
------

Erzeugen
~~~~~~~~

ruft Import.Auswerten

Liest minimale Rest-Gültigkeit einer Erklärung aus Tabelle :ref:`ProgrammDaten<TabProgrammDaten>`.
Erklärungen mit einer kürzeren Rest-Gültigkeit werden als ungültig betrachtet.

Weiterer Ablauf dann wie in :ref:`Finale Auswertung<FinaleAuswertung>` beschrieben.

