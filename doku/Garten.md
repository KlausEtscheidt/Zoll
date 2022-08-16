Doku des Programmpaketes Garten                         {#mainpage}
===============================

Sinn
----
Das Gesamtpaket dient zum Erfassen von Sensorwerten und zum Ansteuern von Aktoren.
Die Sensoren erfassen hauptsächlich Wetterdaten. 
Die Aktoren dienen der Bewässerung oder steuern Funksteckdosen.
Die Aufgaben sind wie nachfolgend beschrieben, auf mehrere Hard- und Software-Ebenen verteilt. 

Aufbau
------
Das System besteht aus 4 Ebenen:
- Benutzeroberfläche: Eine GUI in Python und diversen andere Steuerprogrammen.
- Hauptprogramm: Dem Python-Programm **Garten**, lauffähig auf Raspberry und PC. 
  Auf dem Raspberry läuft außerdem ein Webserver zur Ausgabe von Daten und als einfache GUI.
  Der Server sendet Befehle per Socket an das Hauptprogramm. 
- Bus-Master: ESP32, programmiert unter Arduino.
- Bus-Slaves: Diverse attiny-Microprozessoren (AVR-GCC) und ein Arduino-Micro.

[s. auch Arduino-Lib](@ref ardi_libs)

Aufgabenverteilung und Kommunikationsstruktur
---------------------------------------------

###Hauptprogamm
Das Python-Hauptprogamm steuert sämtliche Abläufe. Es läuft im Normalfall ohne Benutzereingaben.
Die zyklisch abzuarbeitenden Aufgaben werden aus XML-Dateien gelesen 
und in mehreren Aufgabenwarteschlangen zu parallelen Abarbeitung (multithreading) abgelegt.
Dabei wird unterschieden zwischen:
+ kurzfristig zu erledigenden Aufgaben: Kurze Bearbeitungsdauer.
Sollten möglichst nahe am geplanten Zeitpunt ausgeführt werden.
+ langfristig zu erledigenden Aufgaben: Lange Bearbeitungsdauer. Exakter Ausführungszeitpunkt unkritisch.

Zeitpunkt der ersten Ausführung und Wiederholzyklus jeder Aufgabe sind in XML-Dateien abgelegt.
Als weitere Aufgabenwarteschlange kommen sofort zu erledigenden Aufgaben dazu. Diese werden interaktiv vom Benutzer eingesteuert, 
z.B. Ausgabe eines Sensorwertes oder ein Sonderbewässerungslauf.

Nebenaufgaben des Hauptprogramms sind:
- Abspeichern der Sensorwerte in einer Datenbank
- Berechnen von Diagrammen (definiert in XML) aus den Sensorwerten
- Konsolidieren von Datenbankwerten (Stunden-,Tages-,Monatsmittel etc)
- Hochladen von Diagrammen auf Webserver
- Bereitstellen eines Socketservers zur Ankopplung diverser GUI-Programme per TCIP-Socket
- Senden von Befehlen an den Busmaster per Socketclient

###Busmaster
Der Busmaster leitet lediglich die per WLAN-Socket von Hauptprogramm empfangenen Befehle		
zur Ausführung über einen drahtgebundenen Bus an die Slaves weiter.
Die vom Slave erhaltene Antwort wird per Socket an das Hauptprogramm zurückgeliefert.
Der Bussmaster dient also lediglich als Brücke zwischen WLAN und Sensorbus.
Dabei werden die empfangenen Telegramme aber Plausibilitätsprüfungen unterzogen.
Im Fehlerfall oder bei timeouts werden entsprechende Fehlertelegramme zurückgeliefert.

###Busslaves
Busslaves empfangen Befehle per drahtgebundenem Bus vom Master und steuern Sensoren/Aktoren an.
In der Regel handelt es sich um einfache Attiny-Mikroprozessoren 

Protokolle
----------

###Sensorbus
####Bitebene
####Telegramme
####Befehle

###Sockets

Kommunikationsfehlerhandling
----------------------------

