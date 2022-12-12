Zweck
=====

Das Programm dient zur digitalen Erfassung von Lieferantenerklärungen.
Dies ist Vorraussetzung für die Kalkulation der Präferenzberechtigung unserer Produkte.

Hierzu wird in UNIPPS bei Teilen mit durch den Lieferanten bestätigtem EU-Ursprung 
das Flag Präferenzkennzeichen (PFK) gesetzt.

Bei Teilen mit mehreren Lieferanten müssen alle Lieferanten den EU-Ursprung
durch eine Lieferantenerklärung bestätigen.

DigiLek dient also dazu, Lieferantenerklärungen von allen relevanten Lieferanten zu erfassen
und anhand dieser Informationen zu bestimmen, für welche Teile im UNIPPS das PFK-Flag gesetzt werden darf. 

Die abgegebenen Erklärungen gelten meist für 1 Jahr.
Die Erfassung muss daher jährlich zum Jahresende stattfinden,
damit in neuen Jahr die PFK-Flags auf aktuellem Stand sind.

.. index::
   single: Ablauf

Ablauf im Überblick
===================

Der Ablauf gliedert sich in 5 Schritte:

1. Datenimport

Aus UNIPPS werden die Bestellungen der letzten 5 Jahre eingelesen 
und hieraus die bestellten Teile und die relevanten Lieferanten ermittelt.

Für die Teile wird geprüft, ob sie in Pumpen verbaut oder als Ersatzteile geliefert werden.

Lieferanten, die im Erfassungszeitraum mindestens 1 Pumpen- oder Ersatzteil geliefert haben,
werden als Pumpen- oder Ersatzteil-Lieferanten gekennzeichnet.

2. Anforderung von Lieferantenerklärungen

Zuerst müssen die relevanten Lieferanten aufgefordert werden, eine Langzeit-Lieferantenerklärung
abzugeben.

Dabei sind Ersatzteil-Lieferanten bevorzugt abzuarbeiten.

3. Erfassung der Rückmeldung der Lieferanten

Für jeden Lieferanten wird ein Status gesetzt, der seinen generellen Zustand bzgl. 
der Lieferantenerklärung dokumentiert.

4. Erfassen der teilespezifischen Lieferantenerklärungen

Falls der Lieferant den EU-Ursprung nicht für alle, sondern nur bestimmte, von ihm gelieferten 
Teile bestätigt, muss dies für jedes einzelne Teil dokumentiert werden. 

5. Bereitstellung der Daten zum Export

Sind alle Erklärungen erfasst, muss abschließend eine Auswertung gestartet werden, 
die auch die Daten für den Export nach UNIPPS erzeugt. 


