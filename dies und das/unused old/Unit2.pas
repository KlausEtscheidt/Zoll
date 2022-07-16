unit Unit2;

interface

uses DBZugriff, DBQryUNIPPS;

procedure db_test();

implementation
procedure db_test();
var
  gefunden: Boolean;
  KAQry: TZQryUNIPPS;
  ka_id: String;
begin
  ka_id:='142591';
  KAQry := DBConn.getQuery;
  gefunden := KAQry.SucheKundenAuftragspositionen(ka_id);
end;
end.
