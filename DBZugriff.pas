//Die Unit dient als Zwischenschicht zum Wechseln der Datenbank

{$DEFINE UNIPPS}

{
   mit bedingter Kompilierung "$DEFINE UNIPPS" kann zwischen
   Informix und SQLite gewechselt werden.

   Das Objekt DBConn der hier defierten Klasse TZDBConnect liefert
   �ber DBConn.getQuery ein Abfrageergebnis vom generischen Typ TZQry

   TZQry ummantelt f�r
   UNIPPS eine aus TADOQuery abgeleitete TZQryUNIPPS
   oder f�r
   SQLite eine aus TFDQuery  abgeleitete TZQrySQLite

   Die Verbindung zur Datenbank erfolgt �ber die in der
   Unit DBDatamodule.pas in KombiDataModule definierten
   ADOConnectionUnipps bzw FDConnectionSQLite

   Anwendung
   z.B. Abfrage zum Lesen des Kundenauftrags und seiner Positionen
   Abfrage KAQry erzeugen
          KAQry := DBConn.getQuery;
   Abfrage ausf�hren
          gefunden := KAQry.SucheKundenAuftragspositionen(ka_id);

   KAQry.SucheKundenAuftragspositionen f�llt das TZQuery-Objekt KAQry
   mit einem f�r die Aufgabe geeigneten SQL-String und f�hrt sie aus.

   KAQry kann dann im weiteren Ablauf mit den BEINAHE identischen Methoden
   von TADOQuery bzw. TFDQuery verwendet werden.

   SucheKundenAuftragspositionen und alle �hnlichen Suche_xxx
   m�ssen f�r beide Datenbanken in den units DBQryUNIPPS bzw DBQrySQLite
   definiert werden.
}


unit DBZugriff;

interface

{$IFDEF UNIPPS}
  uses DBDatamodule, DBQryUNIPPS;
  type
     TZQry =TZQryUNIPPS;
{$ELSE}
  uses DBDatamodule, DBQrySQLite;
  type
     TZQry =TZQrySQLite;
{$ENDIF}


type
   TZDBConnect = class
     public
       function getQuery():TZQry;
   end;

var DBConn : TZDBConnect;

implementation

//Liefert eine TFDQuery die �ber eine der beiden Connections mit einer Datenbank verbunden ist
function TZDBConnect.getQuery():TZQry;

begin
{$IFDEF UNIPPS}
    getQuery:=TZQry.Create(KombiDataModule,
                            KombiDataModule.ADOConnectionUnipps);
{$ELSE}
    getQuery:=TZQry.Create(KombiDataModule,
                            KombiDataModule.FDConnectionSQLite);
{$ENDIF}
end;


end.
