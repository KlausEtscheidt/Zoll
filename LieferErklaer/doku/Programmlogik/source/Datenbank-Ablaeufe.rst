Abläufe
=======

.. contents:: Datenbank-Manipulationen
   :depth: 2
   :local:

UNIPPS-Import (Basis-Import)
----------------------------

Der Import erfolgt über die procedure TBasisImport.Execute aus Unit Import;

1. Bestellungen
~~~~~~~~~~~~~~~

Tabelle: :ref:`Bestellungen<TabBestellungen>` löschen und neu füllen  (:ref:`SQL <SQLSucheBestellungen>`).

procedure TBasisImport.BestellungenAusUnipps;

Aus Tabelle ProgrammDaten wird das Feld 'Bestellzeitraum' gelesen.
Dieses definiert die älteste Bestellung, die importiert wird.

2. Lieferanten-Teilenummer
~~~~~~~~~~~~~~~~~~~~~~~~~~

Tabelle: :ref:`Bestellungen<TabBestellungen>` updaten (:ref:`SQL <SQLSucheLieferantenTeilenummer>`)

procedure TBasisImport.LieferantenTeilenummerAusUnipps();

Für jede Lieferanten/Teile-Kombination aus Bestellungen wird in UNIPPS
eine Lieferanten-Teilenummer gesucht und in Bestellungen abgespeichert.

Der Prozess ist langsam und schlägt per ODBC immer wieder mal fehl (erst beim lesen des recordsets).
Deshalb wird jede Kombi einzeln gesucht, die Fehler werden abgefangen.

3. Teile-Benennung
~~~~~~~~~~~~~~~~~~

Tabelle: :ref:`tmpTeileBenennung<TabtmpTeileBenennung>` löschen und neu füllen (:ref:`SQL <SQLSucheTeileBenennung>`)

procedure TBasisImport.TeileBenennungAusUnipps;

Holt die Teile-Benennung und die Zeilen 1 und 2 der deutschen Benennung zu
den Teilen aus allen Bestellungen seit xxx Tagen.

xxx entspricht dem Feld 'Bestellzeitraum' aus Tabelle ProgrammDaten.

4. Teile
~~~~~~~~~~~~~~~~~~

Tabelle: :ref:`Teile<TabTeile>` löschen und neu füllen

Schritt1: Teile-Nr und Benennungszeile 1 aus tmpTeileBenennung in Teile (:ref:`SQL <SQLTeileBenennung1>`)

Schritt2: Benennungszeile 2 aus tmpTeileBenennung in Teile (:ref:`SQL <SQLTeileBenennung2>`)

procedure TBasisImport.TeileBenennungInTeileTabelle();


5. Bestimme Pumpen- und Ersatzteile
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Tabelle: :ref:`Teile<TabTeile>` ändern

procedure TBasisImport.PumpenteileAusUnipps();

Für jedes Teil in Tabelle Teile prüfen:

   - Ist das Teil in einem Kundenauftrag, ist es ein Ersatzteil. Die Prüfung ist dann beendet. (:ref:`SQL <SQLTeilinKA>`)
   - Ist das Teil in einem Fertigungsauftrag (Pumpenmontage), ist es ein Pumpenteil (da kein Ersatzteil) (:ref:`SQL <SQLTeilinFA>`)
   - Ist das Teil in einer Teile-Stückliste, ist es ein Pumpenteil (:ref:`SQL <SQLTeilinSTU>`)
   - Ist das Teil im Kopf eines Fertigungsauftrags (es wird gefertigt), ist es ein Pumpenteil (:ref:`SQL <SQLTeilinFAKopf>`)

Die Pumpen- und Ersatzteil-Flags in Teile werden gesetzt.


5b Lieferanten-Adressen lesen
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Tabelle: :ref:`Lieferanten_Adressen<TabLieferantenAdressen>` löschen und neu füllen (:ref:`SQL <SQLLieferantenAdressen>`)

Tabelle: :ref:`Lieferanten_Ansprechpartner<TabLieferantenAnsprechpartner>`  löschen und neu füllen (:ref:`SQL <SQLLieferantenAnspechpartner>`)

procedure LieferantenAdressdatenAusUnipps();

In Lieferanten_Adressen stehen die allgemeinen Firmenadressen (mail,fax,post,etc).

In Lieferanten_Ansprechpartner stehen spezielle Personen, falls vorhanden, die für Lieferantenerklärungen zuständig sind.

Diesen speziellen Anspechpartner werden abschließend aus Lieferanten_Ansprechpartner
nach Lieferanten_Adressen übertragen und ersetzen dort den allgemeinen Anspechpartner (:ref:`SQL <SQLLieferantenAnspechpartnerUebertragen>`).
In Lieferanten_Adressen wird dann das Feld hat_LEKL_Ansprechp True gesetzt.

1. Lieferanten pflegen
~~~~~~~~~~~~~~~~~~~~~~

Tabelle: :ref:`Lieferanten<TabLieferanten>`  ändern

procedure TBasisImport.LieferantenTabelleUpdaten();

Markiere zuerst alle Lieferanten als aktuell (:ref:`SQL <SQLaktuelleLieferanten>`)

Übernehme Lieferanten, die in "Bestellungen" aber nicht in "Lieferanten" stehen als neu (:ref:`SQL <SQLneueLieferanten>`).

Markiere Lieferanten, die in "Lieferanten" aber nicht in "Bestellungen" stehen als entfallen(:ref:`SQL <SQLobsoleteLieferanten>`).

Setze Flags auf false, die besagen, das ein Lieferant Pumpen- oder Ersatzteile liefert (:ref:`SQL <SQLLieferantenResetPumpenflags>`).

Setze die Flags für Pumpen-(:ref:`SQL <SQLLieferantenSetPumpenflags>`)/Ersatzteile-Lieferanten (:ref:`SQL <SQLLieferantenSetErsatzflags>`)neu


8. Lieferanten-Erklärungen
~~~~~~~~~~~~~~~~~~~~~~~~~~

Tabelle: :ref:`LErklaerungen<TabLErklaerungen>` 

procedure TBasisImport.LErklaerungenUpdaten

Übertrage Daten aus Bestellungen nach Lieferantenerklärungen, wenn die Teile-Lieferanten-Kombi 
in Bestellungen, aber nicht in Lieferantenerklärungen vorhanden ist (:ref:`SQL <SQLLErklaerungenNeu>`).

Lösche Teile-Lieferanten-Kombis, die nicht in Bestellungen sind aus Lieferantenerklärungen (:ref:`SQL <SQLLErklaerungenObsolet>`).
 

9. Anzahl der Lieferanten je Teil
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Tabelle: :ref:`tmp_anz_xxx_je_teil<Tabtmp_anz_xxx_je_teil>` loeschen und neu füllen (:ref:`SQL <SQLTmpAnzLieferantenJeTeil>`).

Tabelle :ref:`Teile<TabTeile>`: ändern  (:ref:`SQL <SQLTeileAnzLieferanten>`).

procedure TBasisImport.TeileUpdateZaehleLieferanten

Anzahl der Lieferanten eines Teils in tmp Tabelle tmp_anz_xxx_je_teil Speichern

Anzahl in Tabelle Teile übertragen
 

Benutzereingaben
----------------

1. Anfordern von Lieferanten Erklärungen
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Formular-Unit "LeklAnfordernFrame" mit Klasse "TLieferantenErklAnfordernFrm"

Anfordern von Lieferanten-Erklärungen, Pflege des Lieferantenstatus bzgl Lieferanten-Erklärung inkl Gültigkeit.

Die Abfrage :ref:`HoleLieferantenMitAdressen<SQLHoleLieferantenMitAdressen>` dient als Basis für das Formular.

Die Buttons "mail" bzw "Fax" versenden eine Anforderung einer Lieferanten-Erklärung.

Ist dieser Vorgang erfolgreich, wird über TLieferantenErklAnfordernFrm.UpdateAnfrageDatum das Feld "letzteAnfrage"
der Tabelle :ref:`Lieferanten<tablieferanten>` aktualisiert. 

::

   SQL := 'Update Lieferanten set letzteAnfrage=' +QuotedStr(Datum)
      +  ' where IdLieferant=' + IntToSTr(IdLieferant)  +';' ;


2. Einpflegen der Rückmeldung eines Lieferanten
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Im Formular :ref:`LeklAnfordernFrame<FormLeklAnfordern>` ruft der Button "Status" die Execute-Methode der "StatusUpdateAction", 
welche den Dialog ":ref:`LieferantenStatusDlg`"  öffnet.

In TLieferantenErklAnfordernFrm.StatusUpdateActionExecute werden über eine Abfrage (s. :ref:`SQL<SQLUpdateLieferant>`)
die Felder "Stand" , "gilt_bis", "lekl" und "Kommentar" der Tabelle :ref:`Lieferanten<TabLieferanten>` mit den Daten aus dem Dialog besetzt.

Der gleiche Ablauf wird über das Formular  :ref:`LeklStatusEingabeFrame<FormLeklStatuseingabe>` mittels TLeklStatusFrm.StatusUpdateActionExecute erreicht.
Hier gibt es jedoch andere Filtermöglichkeiten.


.. _EingabeTeileLekl:

3. Eingabe der teilebezogenen Lieferanten-Erklärungen 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Im Formular :ref:`LieferantenLEKL3AuswahlFrame<FormLekl3Statuseingabe>` öffnet der Button "*Teile*"
den Dialog :ref:`LeklTeileEingabeDlg` zur Eingabe der teilespezifischen Präferenzkennung.

Die Abfrage :ref:`Hole LErklaerungen<SQLHoleLErklaerungen>` dient als Basis für den Dialog.

Im Dialog werden die vom Benutzer gesetzten oder gelöschten teilespezifischen Präferenzkennungen mit der Abfrage
:ref:`UpdateLPfkInLErklaerungen<SQLUpdateLPfkInLErklaerungen>` in die Tabelle :ref:`LErklaerungen<TabLErklaerungen>` geschrieben.

Nach Schließen des Dialogs erfolgt eine Benutzerabfrage, ob die Bearbeitung des Lieferanten abgeschlossen ist.

Wenn ja, wird das aktuelle Datum als Erfassungsdatum "**StandTeile**" in die Tabelle :ref:`Lieferanten<tablieferanten>` geschrieben.

.. _FinaleAuswertung:

Finale Auswertung
-----------------

Es gibt zwei Möglichkeiten der Auswertung:

  - Bei der temporären Auswertung werden ab Januar regelmäßig die neuen Wareneingänge in UNIPPS mit der DigiLek-Datenbank verglichen.
    Enthält der Wareneingang Teile, deren PFK in UNIPPS, aber nicht in DigiLek gesetzt ist, muss das PFK in UNIPPS gelöscht werden.
    Für alle Teile, deren PFK in DigiLek gesetzt ist, muss das PFK auch in UNIPPS gesetzt werden.
    Zu diesem Zweck enthält die Tabelle :ref:`Export_PFK<tabexportpfk>` alle in UNIPPS zu ändernden Teile und deren PFK.
  - Bei der endgültigen Auswertung werden alle PFK in UNIPPS gelöscht und entsprechend der Tabelle :ref:`Teile<tabteile>` neu gesetzt.
    Dies kann erst erfolgen, wenn alle Rückmeldungen eingegangen sind.
    
Die Auswertung erfolgt in diesen Schritten:

1. Tabelle LErklaerungen
~~~~~~~~~~~~~~~~~~~~~~~~

Das Flag "LPfk_berechnet" wird zunächst generell False gesetzt.

Die Abfrage :ref:`Lekl Markiere Alle Teile<SQLLeklMarkiereAlleTeile>` setzt es für **alle** Teile dieses Lieferanten True, 
wenn es für diesen Lieferanten eine gültige Erlärung der Art "**alle** Teile" 
(s. Feld lekl in Tabelle :ref:`Lieferanten<TabLieferanten>`) gibt.

Die Abfrage :ref:`Lekl Markiere Einige Teile<SQLLeklMarkiereEinigeTeile>` setzt es für **einige** Teile dieses Lieferanten True, wenn es für diesen Lieferanten eine gültige Erlärung der Art "**einige** Teile" gibt.
Es wird dann für die jenigen Teile True, deren Flag "LPfk" zuvor vom Benutzer für die aktuelle Periode True gesetzt wurde 
(s. :ref:`Eingabe der teilebezogenen Lieferanten-Erklärungen<EingabeTeileLekl>`)

2. Tabelle Teile
~~~~~~~~~~~~~~~~

Setze das Flag "Pfk" zunächst generell True.

Die Abfrage :ref:`Update Teile Delete PFK<SQLUpdateTeileDeletePFK>` löscht das Flag bei Teilen 
mit mind. 1 Lieferanten in "LErklaerungen" mit "LPfk_berechnet" = False.

Es bleiben nur Teile, bei denen alle Lieferanten eine positive Lekl für dieses Teil abgaben.

3. Tabelle Export_PFK
~~~~~~~~~~~~~~~~~~~~~

Diese Tabelle erhält alle Teile, deren Präferenzkennzeichen in UNIPPS geändert werden muss.

zu löschende Kennungen eintragen:
.................................

Die Abfrage :ref:`Hole Wareneingaenge<SQLHoleWareneingaenge>` liest Wareneingänge 
seit Beginn des aktuellen Jahres aus UNIPPS
und speichert Teile / Lieferanten in der Tabelle tmp_wareneingang_mit_PFK, 
wenn sie in UNIPPS ein Präferenzkennzeichen haben.

Die Abfrage :ref:`Update PFK-Tabelle PFK0<SQLUpdatePFKTabellePFK0>` überträgt die Teile aus tmp_wareneingang_mit_PFK,
deren Teile/Lieferanten-Kombi in der Tabelle **LErklaerungen** LPfk_berechnet = False haben,
nach **Export_PFK** mit Flag Pfk=False. 

Die Präferenzkennzeichen dieser Teile sind in UNIPS zu löschen, 
da sie neu geliefert wurden, es für das neue Jahr aber noch keine gültige Lieferanten-Erklärung gibt.

zu setzende Kennungen eintragen:
................................

Die Abfrage :ref:`Update PFK-Tabelle PFK1<SQLUpdatePFKTabellePFK1>` überträgt 
alle Teile aus Tabelle **Teile** mit Flag Pfk=True 
nach **Export_PFK** mit Pfk=True.

Die Präferenzkennzeichen dieser Teile sind in UNIPPS zu setzen,
da für das aktuelle Jahr alle Lieferanten eine positive Lekl abgaben.
