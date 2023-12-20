.. _FormulareRef:

Formulare
=========

.. #################################################################################

.. _FormLeklAnfordern:

LeklAnfordernFrame
------------------

Formular-Unit "LeklAnfordernFrame" mit Klasse "TLieferantenErklAnfordernFrm"

Anfordern einer Lieferantenerklärung

.. image:: pics/LeklAnfordern.png

In TLieferantenErklAnfordernFrm.ShowFrame werden Parameter aus :ref:`ProgrammDaten<TabProgrammDaten>` geladen.

::

    minRestGueltigkeit:=LocalQry.LiesProgrammDatenWert('Gueltigkeit_Lekl');
    veraltet:=LocalQry.LiesProgrammDatenWert('veraltet');

Die Abfrage :ref:`HoleLieferantenMitAdressen<SQLHoleLieferantenMitAdressen>` dient als Basis für das Formular.

Die Datensätze werden üer TLieferantenErklAnfordernFrm.FilterUpdateActionExecute gefiltert.

Dabei gilt eine Erklärung als "**abgelaufen**", wenn **gilt_noch < minRestGueltigkeit**. 
Hierbei ist **gilt_noch** die Differenz aus dem Wert **gilt_bis** aus der Tabelle :ref:`Lieferanten<TabLieferanten>` und dem aktuellem Datum,
also die Restgültigkeit in Tagen.

Eine Erklärung gilt als "**schon angefordert**", wenn **angefragt_vor_Tagen <= veraltet**. 
Mit **angefragt_vor_Tagen** als Differenz aus aktuellem Datum und dem Wert **letzteAnfrage** aus der Tabelle :ref:`Lieferanten<TabLieferanten>` 

Die Buttons "mail" bzw "Fax" versenden eine Anforderung einer Lieferanten-Erklärung über die Actions "mailAction" bzw "FaxAction".

Der Button "Status" ruft die Execute-Methode der "StatusUpdateAction", welcher den Dialog "LieferantenStatusDialog" öffnet.


.. #################################################################################

.. _FormLeklStatuseingabe:

LeklStatusEingabeFrame
----------------------

Formular-Unit "LeklStatusEingabeFrame" mit Klasse "TLeklStatusFrm"

Einpflegen der Rückmeldung eines Lieferanten

.. image:: pics/LeklStatuseingabe.png


In TLeklStatusFrm.ShowFrame werden Parameter aus :ref:`ProgrammDaten<TabProgrammDaten>` geladen.

::

    minRestGueltigkeit:=LocalQry.LiesProgrammDatenWert('Gueltigkeit_Lekl');
    veraltet:=LocalQry.LiesProgrammDatenWert('veraltet');

Die Abfrage :ref:`HoleLieferantenMitAdressen<SQLHoleLieferantenMitAdressen>` dient als Basis für das Formular.

Die Datensätze werden üer TLeklStatusFrm.FilterUpdateActionExecute gefiltert.

Es werden nur Lieferanten angezeigt, für die schon eine Erklärung angefordert wurde.
Eine Erklärung gilt als "**schon angefordert**", wenn **angefragt_vor_Tagen <= veraltet**. 
Mit **angefragt_vor_Tagen** als Differenz aus aktuellem Datum und dem Wert **letzteAnfrage** aus der Tabelle :ref:`Lieferanten<TabLieferanten>`.
Das Datum der letzten Anfrage darf also nicht zu weit in der Vergangenheit liegen, sonst gehört die Anfrage zum Vorjahr.

Eine Antwort gilt als "**schon erfasst**", wenn **Stand_minus_Anfrage >=0**.
Mit **Stand_minus_Anfrage** als Differenz aus dem Wert **Stand**  und dem Wert **letzteAnfrage** aus der Tabelle :ref:`Lieferanten<TabLieferanten>`.
Das Datum, zu dem der Lieferantenstatus das letzte Mal erfasst wurde (Stand), muss also nach dem Versenden der letzten Anfrage (letzteAnfrage) liegen.
Ansonsten gehört das Datum der Erfassung (Stand) zu den Vorjahresdaten.


.. #################################################################################

.. _FormLekl3Statuseingabe:

LieferantenLEKL3AuswahlFrame
----------------------------

Formular-Unit "LieferantenLEKL3AuswahlFrame" mit Klasse "TLieferantenStatusFrm"

Auswahl von Lieferanten (lekl=3) zur Eingabe der teilespezifischen Lieferantenerklärungen.

.. image:: pics/Lekl3LieferantenAuswahl.png

In TLieferantenStatusFrm.ShowFrame werden Parameter aus :ref:`ProgrammDaten<TabProgrammDaten>` geladen.

::

    minRestGueltigkeit:=LocalQry.LiesProgrammDatenWert('Gueltigkeit_Lekl');
    veraltet:=LocalQry.LiesProgrammDatenWert('veraltet');

Die Abfrage :ref:`HoleLieferantenFuerTeileEingabe<SQLHoleLieferantenFuerTeileEingabe>` dient als Basis für das Formular.

Die Datensätze werden üer TLieferantenStatusFrm.FilterUpdateActionExecute gefiltert.

Die Lieferantenerklärung gilt als "**aktuell**", wenn **AlterStand < veraltet**.
Mit **AlterStand** als Differenz aus aktuellem Datum und dem Wert **Stand** aus der Tabelle :ref:`Lieferanten<TabLieferanten>`.
Das Datum, zu dem der Lieferantenstatus das letzte Mal erfasst wurde (Stand), liegt also nicht zu weit in der Vergangenheit.

Eine Erklärung gilt als "**unbearbeitet**", wenn **AlterStandTeile > veraltet**. 
Mit **AlterStandTeile** als Differenz aus aktuellem Datum und dem Wert **StandTeile** aus der Tabelle :ref:`Lieferanten<TabLieferanten>`.
Die letzte Eingabe der Teiledaten (StandTeile) liegt also zu lange zurück und gehört zum Vorjahr.
Für die aktuelle Erklärung wurden noch keine teilspez Daten erfasst.

Der Button "**Teile**" öffnet den Dialog **LeklTeileEingabeDlg** zur Eingabe der teilespezifischen Präferenzkennung.

Nach Schließen des Dialogs erfolgt eine Benutzerabfrage, ob die Bearbeitung des Lieferanten abgeschlossen ist.

Wenn ja, wird das aktuelle Datum als Erfassungsdatum "**StandTeile**" in die Tabelle Lieferanten geschrieben.


.. #################################################################################

.. _FormLeklTeileEingabeFrame:

LeklTeileEingabeFrame
---------------------

Unit "LeklTeileEingabeFrame" mit Klasse "TLieferantenErklaerungenFrm"

Eingabe der teilebezogenen Präferenzkennzeichen.

.. image:: pics/TeilePFKeingeben.png

Die Abfrage :ref:`Hole LErklaerungen<SQLHoleLErklaerungen>` dient als Basis für das Formular.

.. #################################################################################

.. #################################################################################


.. _DialogeRef:

Dialoge
=======

.. #################################################################################

.. _LieferantenStatusDlg:

LieferantenStatusDlg
--------------------

Unit LieferantenStatusDlg mit Klasse TLieferantenStatusDialog

Einpflegen der Rückmeldung eines Lieferanten Eingabe des allegemeinen Status der Lieferanten-Erklärungen über Dialog "LieferantenStatusDialog".

.. image:: pics/StatusDialog.png

.. #################################################################################

.. _LeklTeileEingabeDlg:

LeklTeileEingabeDlg
-------------------

Unit LeklTeileEingabeDlg mit Klasse TLeklTeileEingabeDialog

Eingabe der teilebezogenen Präferenzkennzeichen. 

Besitzt die Instanz "LeklTeileEingabeFrm" der Klasse "TLieferantenErklaerungenFrm" (Unit :ref:`"LeklTeileEingabeFrame"<FormLeklTeileEingabeFrame>`).

.. image:: pics/TeilePFKeingeben.png