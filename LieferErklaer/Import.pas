
unit Import;

interface

uses System.SysUtils, Data.DB,
     Init,Settings,ADOConnector,ADOQuery,QryUNIPPS,QrySQLite;

procedure BasisImportFromUNIPPS();
procedure BestellungenLesen();
procedure LieferantenLesen();
procedure LieferantenZusatzInfoLesen();

var
  ExportQry: TWQry;
  UnippsQry: TWQryUNIPPS;
  gefunden: Boolean;

implementation

procedure BestellungenLesen();

begin

  gefunden := UnippsQry.SucheBestellungen(5*365);

  if not gefunden then
    raise Exception.Create('Keine Bestellungen gefunden.');

  ExportQry.RunExecSQLQuery('delete from Bestellungen;');
  ExportQry.RunExecSQLQuery('BEGIN TRANSACTION;');

  while not UnippsQry.Eof do
  begin
    ExportQry.InsertFields('Bestellungen', UnippsQry.Fields);
    UnippsQry.next;
  end;

  ExportQry.RunExecSQLQuery('COMMIT;');

end;

procedure LieferantenLesen();
var
  OK: Boolean;

begin

  ExportQry.RunExecSQLQuery('delete from Lieferanten;');

  OK := ExportQry.HoleLieferanten()    ;

  if not OK then
    raise Exception.Create('HoleLieferanten fehlgeschlagen.');

end;

procedure LieferantenZusatzInfoLesen();
var
  IdLieferant: Integer;
  LocalQuery2: TWQry;

begin

  //Weiter lokale Query anlegen
  LocalQuery2 := Init.GetQuery;
  gefunden := LocalQuery2.HoleLieferantenLokal()    ;

  if not gefunden then
    raise Exception.Create('HoleLieferanten fehlgeschlagen.');

  ExportQry.RunExecSQLQuery('delete from Lieferanten;');
  ExportQry.RunExecSQLQuery('BEGIN TRANSACTION;');

  while not LocalQuery2.Eof do
  begin
//    ExportQry.InsertFields('Lieferanten', UnippsQry.Fields);
    IdLieferant:=LocalQuery2.FieldByName('IdLieferant').AsInteger;

    gefunden := UnippsQry.SucheZusatzInfoZuLieferant(IdLieferant);

    if not gefunden then
      raise Exception.Create('Keine ZusatzInfo zu Lieferant gefunden.');
    ExportQry.InsertFields('Lieferanten', UnippsQry.Fields);
    LocalQuery2.next;
  end;

  ExportQry.RunExecSQLQuery('COMMIT;');

end;



procedure BasisImportFromUNIPPS();
var
  dbUnippsConn: TWADOConnector;

begin
  Init.start;
{$IFNDEF HOME}

  //mit UNIPPS verbinden
  dbUnippsConn:=TWADOConnector.Create(nil);
  dbUnippsConn.ConnectToUNIPPS();

  //Query fuer UNIPPS anlegen und Verbindung setzen
  //Qry anlegen und mit Connector versorgen
  UnippsQry:= TWQryUNIPPS.Create(nil);
  UnippsQry.Connector:=dbUnippsConn;

  //Qry fuer lokale DB anlegen
  ExportQry := Init.GetQuery;

//  BestellungenLesen;
  LieferantenLesen;
  LieferantenZusatzInfoLesen();
  UnippsQry.Free;

{$ENDIF}



end;


end.
