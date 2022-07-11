//Die Unit dient als Zwischenschicht
// zum Wechseln der Datenbank (Informix/SQLIte)

{$DEFINE UNIPPS}

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
     published
       function getQuery():TZQry;
   end;

var DBConn : TZDBConnect;

implementation

//Liefert eine TFDQuery die über eine der beiden Connections mit einer Datenbank verbunden ist
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
