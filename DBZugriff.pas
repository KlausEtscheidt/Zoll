//Die Unit dient als Zwischenschicht
// zum Wechseln der Datenbank (Informix/SQLIte)

unit DBZugriff;

interface

uses SQLite, DBQrySQLite;

type
   TZQry =TZQrySQLite;
   TZDBConnect = class
     published
       function getQuery():TZQry;
   end;

var DBConn : TZDBConnect;

implementation

//Liefert eine TFDQuery die über diese TFDConnection mit einer Datenbank verbunden ist
function TZDBConnect.getQuery():TZQry;

begin
    getQuery:=TZQry.Create(SQLiteDataModule,
                            SQLiteDataModule.DBConnection);
end;


end.
