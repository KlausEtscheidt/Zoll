UNIPPS-Details
==============

Abfragen und Daten-Mapping
--------------------------

Kundenauftrag
.............

    Abfrage:
        :py:func:`SucheKundenAuftragspositionen`

    UNIPPS-Tabellen:
        Auftragkopf und Auftragpos


    auftragpos.ident_nr1 entspricht der Kundenauftragsnummer (im Programm KaId)

kommissionsbez. Fertigungsauftrag
.................................

.. csv-table:: 
    :widths: 10, 20

    "Abfrage", :py:func:`SucheFAzuKAPos`
    "UNIPPS-Tabelle:", "f_auftragkopf"
    "Suche über:", "f_auftragkopf.auftr_nr=auftragpos.ident_nr1"
    "",         "f_auftragkopf.auftr_pos=auftragpos.ident_nr2" 

auftragpos.ident_nr1 bzw 2 kommen aus der Abfrage SucheKundenAuftragspositionen.

Positionen des Fertigungsauftrags
.................................

Abfrage 
:py:func:`SuchePosZuFA`
UNIPPS-Tabelle: astuelipos
Suche über: astuelipos.ident_nr1=f_auftragkopf.ident_nr

f_auftragkopf.ident_nr aus der Abfrage SucheFAzuKAPos

.. _Tabelle-ASTUELIPOS:

Tabelle ASTUELIPOS
------------------

Die Tabelle enthält mehrere Stücklistenebenen.
