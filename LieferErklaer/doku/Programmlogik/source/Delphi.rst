
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



Formulare
=========

.. #################################################################################

.. _FormLeklAnfordern:

LeklAnfordernFrame
------------------

Formular-Unit "LeklAnfordernFrame" mit Klasse "TLieferantenErklAnfordernFrm"

.. image:: pics/LeklAnfordern.png

In TLieferantenErklAnfordernFrm.ShowFrame werden Parameter aus :ref:`ProgrammDaten<TabProgrammDaten>` geladen.

::

    minRestGueltigkeit:=LocalQry.LiesProgrammDatenWert('Gueltigkeit_Lekl');
    veraltet:=LocalQry.LiesProgrammDatenWert('veraltet');

Die Abfrage :ref:`HoleLieferantenMitAdressen<SQLHoleLieferantenMitAdressen>` dient als Basis für das Formular.

Die Datensätze werden üer TLieferantenErklAnfordernFrm.FilterUpdateActionExecute gefiltert.

Dabei gilt eine Erklärung als abgelaufen, wenn *gilt_noch < minRestGueltigkeit*. 
Hierbei ist *gilt_noch* die Differenz aus dem Wert *gilt_bis* aus der Tabelle :ref:`Lieferanten<TabLieferanten>` und dem aktuellem Datum,
also die Restgültigkeit in Tagen.

Eine Erklärung gilt als "schon angefordert", wenn *angefragt_vor_Tagen <= veraltet*. 
Mit *angefragt_vor_Tagen* als Differenz aus aktuellem Datum und dem Wert *letzteAnfrage* aus der Tabelle :ref:`Lieferanten<TabLieferanten>` 

Die Buttons "mail" bzw "Fax" versenden eine Anforderung einer Lieferanten-Erklärung über die Actions "mailAction" bzw "FaxAction".

Der Button "Status" ruft die Execute-Methode der "StatusUpdateAction", welcher den Dialog "LieferantenStatusDialog" öffnet.


.. #################################################################################

.. _FormLeklStatuseingabe:

LeklStatusEingabeFrame
----------------------

Formular-Unit "LeklStatusEingabeFrame" mit Klasse "TLeklStatusFrm"

.. image:: pics/LeklStatuseingabe.png



In TLeklStatusFrm.ShowFrame werden Parameter aus :ref:`ProgrammDaten<TabProgrammDaten>` geladen.

::

    minRestGueltigkeit:=LocalQry.LiesProgrammDatenWert('Gueltigkeit_Lekl');
    veraltet:=LocalQry.LiesProgrammDatenWert('veraltet');

Die Abfrage :ref:`HoleLieferantenMitAdressen<SQLHoleLieferantenMitAdressen>` dient als Basis für das Formular.

Die Datensätze werden üer TLeklStatusFrm.FilterUpdateActionExecute gefiltert.

Es werden nur Lieferanten angezeigt, für die schon eine Erklärung angefordert wurde.
Eine Erklärung gilt als "schon angefordert", wenn *angefragt_vor_Tagen <= veraltet*. 
Mit *angefragt_vor_Tagen* als Differenz aus aktuellem Datum und dem Wert *letzteAnfrage* aus der Tabelle :ref:`Lieferanten<TabLieferanten>`.

Eine Antwort gilt als schon erfasst, wenn *Stand_minus_Anfrage* >=0.
Mit *Stand_minus_Anfrage* als Differenz aus dem Wert *Stand*  und dem Wert *letzteAnfrage* aus der Tabelle :ref:`Lieferanten<TabLieferanten>`.
Das Datum zu dem der Lieferantenstatus das letzte Mal erfasst wurde (*Stand*) muss also nach dem Versenden der letzten Anfrage (*letzteAnfrage*) liegen.


.. #################################################################################

Dialoge
=======

.. #################################################################################

LieferantenStatusDlg
--------------------


Dialog-Unit LieferantenStatusDlg mit Klasse TLieferantenStatusDialog

Einpflegen der Rückmeldung eines Lieferanten Eingabe des allegemeinen Status der Lieferanten-Erklärungen über Dialog "LieferantenStatusDialog".




Menüs
=====

Lieferanten
-----------

Erklärungen anfordern/eingeben
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

öffnet Formular :ref:`LeklAnfordernFrame<FormLeklAnfordern>` 

LieferantenErklAnfordernFrm1.ShowFrame;

ruft 

LocalQry.HoleLieferantenMitAdressen;

"Status prüfen/eingeben"
~~~~~~~~~~~~~~~~~~~~~~~~

öffnet Formular :ref:`LeklStatusEingabeFrame<FormLeklStatusEingabeFrame>` 

LeklStatusEingabeFrm.ShowFrame

ruft LocalQry.HoleLieferantenMitAdressen

