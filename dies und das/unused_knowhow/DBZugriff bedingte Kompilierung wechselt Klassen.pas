//Die Unit dient als Zwischenschicht zum Wechseln der Datenbank

//{$DEFINE UNIPPS}

{
   mit bedingter Kompilierung "$DEFINE UNIPPS" kann zwischen
   Informix und SQLite gewechselt werden.

   Das Objekt DBConn der hier defierten Klasse TWDBConnect liefert
   �ber DBConn.getQuery ein Abfrageergebnis vom generischen TyTWQryry

   TWQry ummantelt f�r
   UNIPPS eine aus TADOQuery abgeleitete TWQryUNIPPS
   oder f�r
   SQLite eine aus TFDQuery  abgeleitete TWQrySQLite

   Die Verbindung zur Datenbank erfolgt �ber die in der
   Unit DBDatamodule.pas in KombiDataModule definierten
   ADOConnectionUnipps bzw FDConnectionSQLite

   Anwendung
   z.B. Abfrage zum Lesen des Kundenauftrags und seiner Positionen
   Abfrage KAQry erzeugen
          KAQry := DBConn.getQuery;
   Abfrage ausf�hren
          gefunden := KAQry.SucheKundenAuftragspositionen(ka_id);

   KAQry.SucheKundenAuftragspositionen f�llt das TWQuery-Objekt KAQry
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
     TWQry =TWQryUNIPPS;
{$ELSE}
  uses DBDatamodule, DBQrySQLite;
  type
     TWQry =TWQrySQLite;
{$ENDIF}


type
   TWDBConnect = class
     public
       function getQuery():TWQry;
   end;

var DBConn : TWDBConnect;

implementation

//Liefert eine TFDQuery die �ber eine der beiden Connections mit einer Datenbank verbunden ist
function TWDBConnect.getQuery():TWQry;

begin
{$IFDEF UNIPPS}
    getQuery:=TWQry.Create(KombiDataModule,
                            KombiDataModule.ADOConnectionUnipps);
{$ELSE}
    getQuery:=TWQry.Create(KombiDataModule,
                            KombiDataModule.FDConnectionSQLite);
{$ENDIF}
end;


end.
