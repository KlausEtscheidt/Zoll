Tabellen
========

Bestellungen
------------

UNIPPS-Bestellungen seit xxxx

Datenbasis für alle anderen Tabellen, wird aber vom Programm ansonten nicht benutzt.

Eindeutige Kombination aus IdLieferant, TeileNr.
Zusatzinfo zu Lieferant: Kurzname,LName1,LName2.
Zusatzinfo zum Teil  LTeileNr (Lieferanten-Teilenummer).

Import 
Die Tabelle wird bei jedem Basis-Import geleert.
Schritt 1: Lese Bestellungen mit Lieferanten-Kurzname, Name1, Name2
Schritt 2: LTeileNr des Lieferanten dazu
Hier macht ODBC bei manchen Datensätzen Probleme. Deshalb wird jede Nummer einzeln gelesen.

tmpTeileBenennung
-----------------

Nur temporär zum Abspeichern von Zeile 1 und 2 der Teile-Benennung

Import 
Schritt 3: Mit der Basis-Abfrage für die Bestellungen wird zu jedem bestellten Teile aus UNIPPS die Benennung geholt und in tmpTeileBenennung gespeichert. Der Zeitraum für die Bestellungen wird gegenüber Import-Schritt 1 leicht erhöht um sicher alle Teile zu bekommen.

Teile
-----

CREATE TABLE "Teile" (
        "TeileNr"       varchar(255),
        "TName1"        varchar(255),
        "TName2"        varchar(255),
        "Pumpenteil"    INTEGER DEFAULT 0,
        "PFK"   INTEGER  DEFAULT 0,
        PRIMARY KEY("TeileNr")

Zu jeder Teilenr im Bestellzeitraum Teilebenennung Zeile 1 und 2 dazu.
In Pumpenteil wird vermerkt, ob die Teile in Pumpen verbaut werden
PFK: Flag Präferenzkennzeichen, wird abschließend nach UNIPPS geschrieben.


Import 
Die Tabelle wird bei jedem Basis-Import geleert.

Schritt 4: Übernahme der Teilebenennung aus tmpTeileBenennung
Schritt 5: Test ob Teil Pumpenteil => Flag Pumpenteil setzen
Prüfe je Teil, das Vorkommen:
    - in FA (astuelipos)
    - in KA (auftragpos)
    - in FA-Kopfdaten (f_auftragkopf) (Ottenstein: Kaufteil mit FA)
    - in Stückliste (teil_stuelipos)


!!!! ToDo es bleibt ein verdächtiger Rest von Bestellteilen, 
die nach Pumpenteilen aussehen


Lieferanten
-----------

CREATE TABLE Lieferanten (
    IdLieferant  INTEGER       NOT NULL,
    LKurzname    VARCHAR (200),
    LName1       VARCHAR (200),
    LName2       VARCHAR (200),
    lekl         INTEGER       DEFAULT 0,
    Stand        VARCHAR (50)  DEFAULT [1900-01-01],
    gilt_bis     VARCHAR (50)  DEFAULT [1900-01-01],
    Pumpenteile  INTEGER       DEFAULT 0,
    Lieferstatus VARCHAR (10)  DEFAULT neu,
    PRIMARY KEY (
        IdLieferant
    )
);


Dient zur Erfassung des generellen Status eines Lieferanten bezüglich Lieferantenerklärung im Feld "lekl" und der Eingabe eines Ablaufdatums  der Erklärung "gilt_bis"
Lieferstatus ist neu,aktuell oder entfallen bzgl des x-Tages-Zeitraums

Import

Ziel ist es alte Eingaben zu erhalten
Schritt 6.1: Lieferant ist in Bestellungen, war schon in Tabelle,
             aber  als neu markiert => SET Lieferstatus="aktuell"
Schritt 6.2: Lieferant ist in Bestellungen, war nicht in Tabelle => 
             Uebernahme von Id und Namen aus Bestellungen, Rest auf Default 
Schritt 6.3: Lieferant ist nicht in Bestellungen, aber in Tabelle => 
             SET Lieferstatus="entfallen"  

LieferErklaer
-------------

CREATE TABLE LErklaerungen (Id INTEGER, IdLieferant INTEGER NOT NULL, TeileNr varchar (255) NOT NULL, LTeileNr varchar (255), LPfk INTEGER DEFAULT 0, Stand varchar (50) DEFAULT "1900-01-01", BestDatum varchar (50) DEFAULT "1900-01-01", PRIMARY KEY (Id) AUTOINCREMENT);

Sinn: Speichern des lieferanten-spezifischen LPfk fuer einzelne Teile

Felder
Id: PRIMARY KEY (IdLieferant und TeileNr müssen unique sein)
IdLieferant
TeileNr
LTeileNr: Bezeichnung beim Lieferanten (zum Sortieren verwendet)
LPfk: True, wenn Teil in der Erklärung des Lieferanten EU-Ursprung hat
Stand: letzter Bearbeitungsstand
BestDatum: zur Info; letztes Bestelldatum für Teil bei Lieferant

Import

!?!?! Ist es Ziel, alte Eingaben zu erhalten !?!?! 
Nein, eher nicht

Schritt 7.1: Neue IdLieferant/TeileNr-Kombinationen einfuegen
Schritt 7.2: Nicht in Bestelungen vorhandene Kombinationen löschen

evtl 
Schritt 7.3: LPfk auf 0 und Stand auf 1.1.1900
