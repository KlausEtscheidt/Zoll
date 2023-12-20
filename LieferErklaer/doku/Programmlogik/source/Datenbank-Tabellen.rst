Tabellen
========

Übersicht
---------

Das Programm verwendet folgende Access-Tabellen:

    - :ref:`Anwender<TabAnwender>`  
    - :ref:`Bestellungen<TabBestellungen>`  
    - :ref:`Export_PFK<TabExportPFK>`  
    - :ref:`LErklaerungen<TabLErklaerungen>`  
    - :ref:`Lieferanten<TabLieferanten>`  
    - :ref:`Lieferanten_Adressen<TabLieferantenAdressen>`  
    - :ref:`Lieferanten_Ansprechpartner<TabLieferantenAnsprechpartner>`  
    - :ref:`LieferantenStatusTxt<TabLieferantenStatusTxt>`  
    - :ref:`ProgrammDaten<TabProgrammDaten>`  
    - :ref:`Teile<TabTeile>`
    - :ref:`tmp_anz_xxx_je_teil<Tabtmp_anz_xxx_je_teil>`
    - :ref:`tmp_wareneingang_mit_PFK<Tabtmp_wareneingang_mit_PFK>`
    - :ref:`tmpLieferantTeilPfk<TabtmpLieferantTeilPfk>`
    - :ref:`tmpTeileBenennung<TabtmpTeileBenennung>`
    - :ref:`tmpTeileVerwendung<TabtmpTeileVerwendung>`


Die wichtigsten Tabellen sind :ref:`Lieferanten <TabLieferanten>` und 
:ref:`LErklaerungen <TabLErklaerungen>`, in denen das Ergebnis der Benutzereingaben abgespeichert
wird.

**Lieferanten** speichert den Status des Lieferanten bezüglich seiner Lieferanten-Erklärung:

- Wann wurde er zuletzt aufgefordert eine Erklärung abzugeben ?
- Wann hat er geantwortet ?
- Wie hat er geantwortet (Status seiner Erklärung, lekl) 
- Wie lange gilt die Erklärung noch?

Falls ein Lieferant nur für einige seiner Teile die Präferenzberechtigung bestätigt, 
wird dies in **LErklaerungen** vermerkt.

Die Tabelle :ref:`Bestellungen <TabBestellungen>` bildet eine Datenbasis, aus der andere Tabellen abgeleitet werden.
Sie muss jährlich, vor Beginn der Benutzereingaben, einmalig neu aus UNIPPS befüllt werden.

**Ausgabe**

ProgrammDaten
~~~~~~~~~~~~~
Beinhaltet Konfigurationsdaten für den Programmablauf

Bestellungen
~~~~~~~~~~~~
Datenbasis für alle anderen Tabellen, wird aber vom Programm ansonsten nicht benutzt.
Wird beim Import gelöscht und neu mit UNIPPS-Bestellungen der letzten xxx Tage gefüllt.

.. #################################################################################
.. Detail-Info
.. #################################################################################

Detail-Info
-----------

.. #################################################################################

.. _TabLieferanten:

Lieferanten
~~~~~~~~~~~

Zweck:
    Erfassung des generellen Status eines Lieferanten bezüglich Lieferantenerklärung:
    Im Feld "lekl" wird die Art der Lieferantenerklärung (s :ref:`LieferantenStatusTxt<TabLieferantenStatusTxt>` ) erfasst.
    

Verhalten beim Import:
    - Neue Lieferanten werden aufgenommen (Übernahme aus Bestellungen, Lieferstatus="neu").
    - Lieferanten, die nicht in Bestellungen stehen, werden mit Lieferstatus="entfallen" markiert.
    - Alle anderen Lieferanten werden mit Lieferstatus="aktuell" markiert. Ihre Daten bleiben erhalten.

Tabelle Lieferanten:

::
    
    Feld : IdLieferant                   Zahl   UNIPPS-ID
    Feld : LKurzname                     Text   UNIPPS-Kurzname
    Feld : LName1                        Text   UNIPPS-Name1
    Feld : LName2                        Text   UNIPPS-Name2
    Feld : lekl           0              Zahl   Art der Lieferantenerklärung
    Feld : Stand          "1900-01-01"   Text   Datum der Antwort (Eingabe lekl)
    Feld : gilt_bis       "1900-01-01"   Text   Verfallsdatum der Lieferantenerklärung
    Feld : Pumpenteile    0              Zahl   liefert der Lieferant Pumpenteile
    Feld : Lieferstatus   "neu"          Text   neu, aktuell oder entfallen
    Feld : Ersatzteile    0              Zahl   liefert der Lieferant Ersatzteile
    Feld : StandTeile     "1900-01-01"   Text   Eingabe teilespezifischer Erklärungen (Tab. LErklaerungen)
    Feld : letzteAnfrage  "1900-01-01"   Text   Wann wurde der Lief. zuletzt aufgefordert eine LEkl abzugeben
    Feld : Kommentar                     Text   Bemerkungen zur Antwort oder warum der Lief. nicht relevant ist
    Index: sqlite_autoindex_0(IdLieferant)  Primary

.. #################################################################################

.. _TabLErklaerungen:

LErklaerungen (Lieferanten-Erklärungen)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Zweck:
    Speichern des lieferanten-spezifischen LPfk fuer einzelne Teile

Verhalten beim Import:
 - Neue IdLieferant/TeileNr-Kombinationen aus Bestellungen übernehmen
 - Nicht mehr in Bestellungen vorhandene Kombinationen löschen


Tabelle: LErklaerungen

::

   Feld : Id                             Zahl   PRIMARY KEY (IdLieferant und TeileNr müssen unique sein)
   Feld : IdLieferant                    Zahl   
   Feld : TeileNr                        Text   
   Feld : LTeileNr                       Text   Teile-Bezeichnung beim Lieferanten (zum Sortieren verwendet)
   Feld : LPfk            0              Zahl   Pfk aus Benutzereingabe
   Feld : BestDatum       "1900-01-01"   Text   letztes Bestelldatum für Teil bei Lieferant
   Feld : LPfk_berechnet  0              Zahl   Pfk aus Auswertung
   Index: PrimaryKey(Id)  Primary

"LPfk_berechnet" wird bei der finalen Auswertung für alle Teile eines Lieferanten gesetzt, 
wenn dieser eine Erklärung für alle Teile abgegeben hat (s. :ref:`sql<SQLLeklMarkiereAlleTeile>`).

Wenn er eine Erklärung nur für einige Teile abgegeben hat, müssen diese mittels Benutzereingabe in "LPfk" vermerkt werden.
Bei der Auswertung werden die manuell gesetzten Flags aus "LPfk" nach "LPfk_berechnet" übertragen (s. :ref:`sql<SQLLeklMarkiereEinigeTeile>`).
Vorraussetzung ist in beiden Fällen, das die Erklärung noch eine ausreichende Rastgültigkeit hat.

.. #################################################################################

.. _TabLieferantenAdressen:    

Lieferanten_Adressen
~~~~~~~~~~~~~~~~~~~~

Zweck:
    Enthält die allgemeinen Firmenadressen (mail,fax,post,etc).
    Diese werden zum Versenden der Anforderungen neuer Lieferanten-Erklärungen verwendet,
    wenn es keine speziellen Ansprechpartner für Lieferanten-Erklärungen gibt.

Import:
   Die Tabelle wird bei jedem Basis-Import geleert und neu befüllt.

Tabelle: Lieferanten_Adressen

::

   Feld : IdLieferant             Zahl   
   Feld : adresse                 Zahl   
   Feld : kurzname                Text   
   Feld : name1                   Text   zum Versand von Anfragen
   Feld : name2                   Text   zum Versand von Anfragen
   Feld : name3                   Text   
   Feld : name4                   Text   
   Feld : strasse                 Text   
   Feld : postfach                Text   
   Feld : staat                   Text   
   Feld : plz_haus                Text   
   Feld : plz_postfach            Text   
   Feld : ort                     Text   
   Feld : ort_postfach            Text   
   Feld : telefon                 Text   
   Feld : telefax                 Text   zum Versand von Anfragen
   Feld : email                   Text   zum Versand von Anfragen
   Feld : hat_LEKL_Ansprechp  0   Text   definiert Sonderbehandlung beim Versand von Anfragen
   Feld : Anrede                  Text   zum Versand von Anfragen
   Feld : Vorname                 Text   zum Versand von Anfragen
   Feld : Nachname                Text   zum Versand von Anfragen
   Index: PrimaryKey(IdLieferant)  Primary


.. #################################################################################

.. _TabLieferantenAnsprechpartner:    

Lieferanten_Ansprechpartner
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Zweck:
    Speichert spezielle Personen, falls vorhanden, die für Lieferantenerklärungen zuständig sind.
    In diesem Fall werden deren Adressdaten statt der allgemeinen Firmenadressen 
    zum Versenden der Anfragen verwendet.

Import:
   Die Tabelle wird bei jedem Basis-Import geleert und neu befüllt.

Tabelle: Lieferanten_Ansprechpartner

::

   Feld : ID               Zahl   
   Feld : IdLieferant  0   Zahl32 
   Feld : IdPerson     0   Zahl   
   Feld : Anrede           Text   
   Feld : Vorname          Text   
   Feld : Nachname         Text   
   Feld : email            Text   
   Feld : telefax          Text   
   Index: ID(IdLieferant)
   Index: Id_Person(IdPerson)
   Index: PrimaryKey(ID)  Primary

.. #################################################################################

.. _TabBestellungen:

Bestellungen
~~~~~~~~~~~~

Zweck:
    Speichert alle Bestellungen (inkl. der Lieferanten und Teile) im Bestellzeitraum, der in ProgrammDaten definiert ist. 
    Bildet eine Datenbasis, aus der andere Tabellen abgeleitet werden. 

Verhalten beim Import: 
  - Die Tabelle wird bei jedem Basis-Import geleert.
  - Bestellungen und Bestell-Positionen werden mit Lieferanten-Kurzname, Name1, Name2 gelesen
  - LTeileNr des Lieferanten dazu.
    Hier macht ODBC bei manchen Datensätzen Probleme. Deshalb wird jede Teile-Nummer einzeln gelesen.


Tabelle: Bestellungen

::
 
   Feld : IdLieferant  0   Zahl   UNIPPS-Id des Lieferanten
   Feld : TeileNr          Text   UNIPPS-Id des Teils
   Feld : BestDatum        Datum  Letzte Bestellung zu Teile/Lieferant
   Feld : eingelesen       Datum  Datum des Imports
   Feld : LKurzname        Text   Kurzname des Lieferanten
   Feld : LName1           Text   Langname1 des Lieferanten
   Feld : LName2           Text   Langname2 des Lieferanten
   Feld : LAdressId    0   Zahl   kann weg ? immer 0
   Feld : LTeileNr         Text   Lieferanten-Teilenummer
   Index: id_teil_lief(TeileNr,IdLieferant)  Primary


.. #################################################################################

.. _TabTeile:    

Teile
~~~~~

Zweck:
    ??? PFK für alle Teile zum Export nach UNIPPS speichern

Verhalten beim Import: 
  - Die Tabelle wird bei jedem Basis-Import geleert.
  - Neue Records mit TeileNr und TName1 aus tmpTeileBenennung anlegen.
  - Update mit TName2
  - Flags Pumpenteil und Ersatzteil neu berechnen

Tabelle: Teile

::

   Feld : TeileNr            Text   UNIPPS t_tg_nr
   Feld : TName1             Text   Teilebenennung Zeile 1
   Feld : TName2             Text   Teilebenennung Zeile 2
   Feld : Pumpenteil     0   Zahl   wird das Teil in Pumpen verbaut
   Feld : PFK            0   Zahl   Flag Präferenzkennzeichen => UNIPPS
   Feld : Ersatzteil     0   Zahl   wird das Teil als Ersatzteil verkauft
   Feld : n_Lieferanten  0   Zahl   
   Feld : n_LPfk         0   Zahl   
   Index: sqlite_autoindex_Teile_1(TeileNr)  Primary


.. #################################################################################

.. _TabProgrammDaten:    

ProgrammDaten
~~~~~~~~~~~~~

Zweck:
    Beinhaltet Konfigurationsdaten für den Programmablauf

Import:
    nicht betroffen

Inhalte:

Bestellzeitraum: 
    Anzahl Tage, die das Freigabedatum einer Bestellung zurückliegen darf, damit sie importiert wird

Gueltigkeit_Lekl: 
    Anzahl Tage, die eine Lieferantenerklärung noch gültig sein muss um als gültig betrachtet zu werden.
    Hintergrund: Beim Anfordern neuer Erklärungen soll z.B. eine Erklärung, die nur noch 30 Tage gilt,
    neu angefordert werden.

veraltet:
    Angaben mit Datum älter als *veraltet* Tage gelten als veraltet (z.B. Status LEKL) 200
    Hintergrund: Angaben aus dem Vorjahr von aktuellen unterscheiden
    Wird in diversen Formularen verwendet.


.. #################################################################################

.. _TabAnwender:    

Anwender
~~~~~~~~

Zweck:
    Zuordnung von Faxvorlagen zu Anwendern

Import:
    nicht betroffen

Tabelle: Anwender

::

   Feld : WinName        Text   Windows User-Name
   Feld : Vorname        Text   
   Feld : Nachname       Text   
   Feld : used           Text   
   Feld : Faxvorlage     Text   Name des Word-Muster-Dokuments zum Faxen einer Anforderung
   Index: PrimaryKey(WinName)  Primary

.. #################################################################################

.. _TabLieferantenStatusTxt:    

LieferantenStatusTxt
~~~~~~~~~~~~~~~~~~~~
Zweck:
    Beinhaltet Klartext für den Status "lekl" der Lieferanten-Erklärung eines Lieferanten

Import:
    nicht betroffen

Tabelle: LieferantenStatusTxt

::

   Feld : Id            Zahl   Id des Status (entspricht lekl in Lieferanten)
   Feld : StatusTxt     Text   Klartext des Status
   Index: __uniqueindex(Id)  Primary

Inhalt

::

   Id  Klartext       Bedeutung
    0  unbekannt      Lieferant ist neu oder hat noch nie geantwortet
    1  weigert sich   Lieferant hat geantwortet; gibt aber keine Erklärung ab
    2  alle Teile     Lieferant erklärt **alle** Teile, die er liefert als präferenzberechtigt
    3  einige Teile   Lieferant erklärt **einige** Teile, die er liefert als präferenzberechtigt
    4  irrelevant     Der Lieferant ist bezüglich Lieferanten-Erklärung irrelevant


.. #################################################################################

.. _TabExportPFK:

Export_PFK
~~~~~~~~~~

Zweck:
    Alle Teile deren PFK in UNIPPS geändert werden muss. 
    Diese Tabelle wird verwendet, solange noch nicht alle Antworten eingegangen sind (s. :ref:`FinaleAuswertung`) .

Import:
    nicht betroffen

Tabelle: Export_PFK

::

   Feld : t_tg_nr       Text   
   Feld : PFK      No   Bool   


.. #################################################################################

.. _TabtmpTeileBenennung:    

tmpTeileBenennung
~~~~~~~~~~~~~~~~~

Zweck:
    Nur temporär zum Abspeichern von Zeile 1 und 2 der Teile-Benennung

Import:
  - Die Tabelle wird bei jedem Basis-Import geleert.
  - Zu jedem bestellten Teil wird aus UNIPPS die Benennung (Zeile 1 und 2) geholt. 

Tabelle: tmpTeileBenennung

::

   Feld : Zeile         Zahl   
   Feld : Benennung     Text   
   Feld : TeileNr       Text   
   Index: pkey(Zeile,TeileNr)  Primary


.. #################################################################################

.. _Tabtmp_LTeilenummern:    

tmp_LTeilenummern
~~~~~~~~~~~~~~~~~

Zweck:
    Nur temporär zum Abspeichern von Lieferanten-Teilenummern

Import:
  - Die Tabelle wird bei jedem Basis-Import geleert.
  - Es werden alle Lieferanten-Teilenummern aus der UNIPPS-Tabelle Lieferant_teil geladen. 

Tabelle: tmp_LTeilenummern

::

   Feld : IdLieferant    Zahl   UNIPPS-Id des Lieferanten
   Feld : TeileNr        Text   UNIPPS-Id des Teils (t_tg_nr)
   Feld : LTeileNr       Text   Teilenummer beim Lieferanten
   Index: pkey(IdLieferant,TeileNr)  Primary



.. #################################################################################

.. _Tabtmp_anz_xxx_je_teil:

tmp_anz_xxx_je_teil
~~~~~~~~~~~~~~~~~~~

Zweck:
    Nur temporär zum Abspeichern der Anzahl Lieferanten je Teil

Import:
  - Die Tabelle wird bei jedem Basis-Import geleert und neu gefüllt.

Tabelle: tmp_anz_xxx_je_teil

::

   Feld : n           Zahl   
   Feld : TeileNr     Text   


.. #################################################################################

.. _Tabtmp_wareneingang_mit_PFK:

tmp_wareneingang_mit_PFK
~~~~~~~~~~~~~~~~~~~~~~~~

Zweck:
    Nur temporär zum Abspeichern aller Wareneingänge seit Jahresanfang,
    bei denen das PFK-Flag in UNIPPS gesetzt ist. 
    Ist "LPfk_berechnet" in "LErklaerungen" für eine Teile-Lieferanten-Kombi aus "tmp_wareneingang_mit_PFK"=False, 
    so muss für dieses Teil das PFK-Flag in UNIPPS gelöscht werden.

Die Tabelle wird vor jeder Auswertung gelöscht.

Tabelle: tmp_wareneingang_mit_PFK

::

   Feld : t_tg_nr       Text   
   Feld : lieferant     Zahl   


.. #################################################################################

.. _TabtmpLieferantTeilPfk:

tmpLieferantTeilPfk
~~~~~~~~~~~~~~~~~~~

Zweck:
    obsolet ???? Nur temporär zum Abspeichern 

Import:
  - Die Tabelle wird bei jedem Basis-Import geleert und neu gefüllt.

Tabelle: tmpLieferantTeilPfk

::

   Feld : TeileNr         Text   
   Feld : IdLieferant     Zahl   
   Feld : lekl            Zahl   
   Feld : Id              Zahl   
   Index: sqlite_autoindex_0(Id)  Primary


.. #################################################################################

.. _TabtmpTeileVerwendung:

tmpTeileVerwendung
~~~~~~~~~~~~~~~~~~~

Zweck:
    obsolet ?????

Import:
  - Die Tabelle wird bei jedem Basis-Import geleert und neu gefüllt.

Tabelle: tmpTeileVerwendung

::

   Feld : t_tg_nr     Text   
   Index: t_tg_nr(t_tg_nr)

