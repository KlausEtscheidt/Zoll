
unit Import;

interface

uses System.SysUtils, Data.DB,
     Init,Settings,ADOConnector,ADOQuery,QryUNIPPS,QrySQLite;

procedure BestellungenLesen();
procedure BestellPositionenLesen();
procedure BestellKopfLesen();

var
  ExportQry: TWQry;
  UnippsQry: TWQryUNIPPS;
  gefunden: Boolean;

implementation

procedure BestellKopfLesen();
  var
    IdBestellung: Integer;
    BestellDatum: TDateTime;

begin

  gefunden := UnippsQry.SucheBestellungen(5*365);

  if not gefunden then
    raise Exception.Create('Keine Bestellungen gefunden.');

  while not UnippsQry.Eof do
  begin
    BestellDatum := UnippsQry.FieldByName('BestDatum').AsDateTime;
    IdBestellung := UnippsQry.FieldByName('id').AsInteger;
    ExportQry.InsertFields('BestellKopf', UnippsQry.Fields);
    UnippsQry.next;
  end;

end;

procedure BestellPositionenLesen();
  var
    IdBestellung: Integer;
    TeileNr: String;

begin

  gefunden := UnippsQry.SucheBestellPositionen()    ;

  if not gefunden then
    raise Exception.Create('Keine Bestellungen gefunden.');

  while not UnippsQry.Eof do
  begin
    IdBestellung := UnippsQry.FieldByName('BestId').AsInteger;
    TeileNr:= trim(UnippsQry.FieldByName('t_tg_nr').AsString);
    ExportQry.InsertFields('BestellPos', UnippsQry.Fields);
    UnippsQry.next;
  end;

end;


procedure BestellungenLesen();
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

  BestellKopfLesen;
//  BestellPositionenLesen;
  UnippsQry.Free;

{$ENDIF}



end;


end.
