
unit Import;

interface

uses System.SysUtils, Data.DB,
     Init,Settings,ADOConnector,ADOQuery,QryUNIPPS,QrySQLite;

procedure BasisImportFromUNIPPS();
procedure BestellungenAusUnipps();
procedure TeileBenennungAusUnipps();

var
  LocalQry: TWQry;
  UnippsQry: TWQryUNIPPS;
  gefunden: Boolean;

implementation

procedure BestellungenAusUnipps();

begin

  gefunden := UnippsQry.SucheBestellungen(5*365);

  if not gefunden then
    raise Exception.Create('Keine Bestellungen gefunden.');

  LocalQry.RunExecSQLQuery('delete from Bestellungen;');
  LocalQry.RunExecSQLQuery('BEGIN TRANSACTION;');

  while not UnippsQry.Eof do
  begin
    LocalQry.InsertFields('Bestellungen', UnippsQry.Fields);
    UnippsQry.next;
  end;

  LocalQry.RunExecSQLQuery('COMMIT;');

end;

procedure TeileBenennungAusUnipps();
    var text:String;

begin

  gefunden := UnippsQry.SucheTeileBenennung;

  if not gefunden then
    raise Exception.Create('Keine TeileBenennung gefunden.');

  LocalQry.RunExecSQLQuery('delete from tmpTeileBenennung;');
  LocalQry.RunExecSQLQuery('BEGIN TRANSACTION;');

  while not UnippsQry.Eof do
  begin
    LocalQry.InsertFields('tmpTeileBenennung', UnippsQry.Fields);
//    text:=UnippsQry.FieldByName('Text').AsString;
    UnippsQry.next;
  end;

  LocalQry.RunExecSQLQuery('COMMIT;');

end;


procedure LieferantenLesen();
var
  OK: Boolean;

begin

  LocalQry.RunExecSQLQuery('delete from Lieferanten;');

  OK := LocalQry.HoleLieferanten()    ;

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

  LocalQry.RunExecSQLQuery('delete from Lieferanten;');
  LocalQry.RunExecSQLQuery('BEGIN TRANSACTION;');

  while not LocalQuery2.Eof do
  begin
//    ExportQry.InsertFields('Lieferanten', UnippsQry.Fields);
    IdLieferant:=LocalQuery2.FieldByName('IdLieferant').AsInteger;

    gefunden := UnippsQry.SucheZusatzInfoZuLieferant(IdLieferant);

    if not gefunden then
      raise Exception.Create('Keine ZusatzInfo zu Lieferant gefunden.');
    LocalQry.InsertFields('Lieferanten', UnippsQry.Fields);
    LocalQuery2.next;
  end;

  LocalQry.RunExecSQLQuery('COMMIT;');

end;

procedure TeileBenennungInTeileTabelle();
begin

  LocalQry.RunExecSQLQuery('delete from Teile;');

  gefunden := LocalQry.TeileName1InTabelle()    ;

  if not gefunden then
    raise Exception.Create('TeileBenennungInTabelle fehlgeschlagen.');

  gefunden := LocalQry.TeileName2InTabelle()    ;

  if not gefunden then
    raise Exception.Create('TeileBenennungInTabelle fehlgeschlagen.');

end;


procedure BasisImportFromUNIPPS();
var
  dbUnippsConn: TWADOConnector;

begin

  Init.start;

  //Qry fuer lokale DB anlegen
  LocalQry := Init.GetQuery;

  {$IFNDEF HOME}

  //mit UNIPPS verbinden
  dbUnippsConn:=TWADOConnector.Create(nil);
  dbUnippsConn.ConnectToUNIPPS();

  //Query fuer UNIPPS anlegen und Verbindung setzen
  //Qry anlegen und mit Connector versorgen
  UnippsQry:= TWQryUNIPPS.Create(nil);
  UnippsQry.Connector:=dbUnippsConn;

  BestellungenAusUnipps;
  TeileBenennungAusUnipps;
//  LieferantenLesen;
//  LieferantenZusatzInfoLesen();
  UnippsQry.Free;

{$ENDIF}

  TeileBenennungInTeileTabelle;

end;


end.
