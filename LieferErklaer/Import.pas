
unit Import;

interface

uses System.SysUtils, Data.DB,
     Init,Settings,ADOConnector,ADOQuery,QryUNIPPS,QrySQLite;

procedure BasisImport();
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
//    var text:String;

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

procedure PumpenteileAusUnipps();
    var TeileNr:String;

begin

  gefunden :=LocalQry.HoleTeile;

  while not LocalQry.Eof do
  begin
    TeileNr:=LocalQry.FieldByName('TeileNr').AsString;

    gefunden := UnippsQry.SucheTeileInFA(TeileNr);
    if not gefunden then
      gefunden := UnippsQry.SucheTeileInKA(TeileNr);
    if not gefunden then
      gefunden := UnippsQry.SucheTeileInSTU(TeileNr);
    if not gefunden then
      gefunden := UnippsQry.SucheTeileInFAKopf(TeileNr);

    if gefunden then
    begin
      LocalQry.Edit;
      LocalQry.FieldByName('Pumpenteil').Value := True;
      LocalQry.Post;
    end;

    LocalQry.next;

  end;


end;

// Tabelle LErklaerungen aktualisieren
procedure LErklaerungenUpdaten();
var
  OK: Boolean;
  NRecordsVorher,NeueTeile : Integer;

begin
  LocalQry.RunSelectQuery('Select count() as n from LErklaerungen;');
  NRecordsVorher := LocalQry.FieldByName('n').AsInteger;

  OK := LocalQry.UpdateLErklaerungen()    ;
  if not OK then
    raise Exception.Create('Update LErklaerungen fehlgeschlagen.');

  LocalQry.RunSelectQuery('Select count() as n from LErklaerungen;');
  NeueTeile := LocalQry.FieldByName('n').AsInteger-NRecordsVorher;

  LocalQry.HoleStatuswert('neue_Teile');

  LocalQry.Edit;
//  LocalQry.FieldByName('Name').Value := 'neue_Teile';
  LocalQry.FieldByName('IntWert').Value := NeueTeile;
  LocalQry.Post;


end;

procedure LieferantenTabelleFuellen();
var
  OK: Boolean;

begin

  LocalQry.RunExecSQLQuery('delete from Lieferanten;');

  OK := LocalQry.FuelleLieferantenTabelle()    ;

  if not OK then
    raise Exception.Create('FuelleLieferantenTabelle fehlgeschlagen.');

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

procedure BasisImport();
var
  dbUnippsConn: TWADOConnector;

begin

  Init.start;

  //Qry fuer lokale DB anlegen
  LocalQry := Init.GetQuery;

  {$IFNDEF HOME}
//  BasisImportFromUNIPPS;
  {$ENDIF}

  // Tabelle Lieferanten leeren und neu befüllen
  // Eindeutige IdLieferant mit Zeile 1 und 2 der Benennung
     LieferantenTabelleFuellen;
                 { TODO :
Nur neue Lieferanten dazu, alte löschen oder deaktivieren.
Stand soll erhalten bleiben. }
 
  // Tabelle LErklaerungen aktualisieren
  // Neue Teile aus Bestellungen übernehmen
     LErklaerungenUpdaten;


end;

procedure BasisImportFromUNIPPS();
var
  dbUnippsConn: TWADOConnector;

begin

  //mit UNIPPS verbinden
  dbUnippsConn:=TWADOConnector.Create(nil);
  dbUnippsConn.ConnectToUNIPPS();

  //Query fuer UNIPPS anlegen und Verbindung setzen
  //Qry anlegen und mit Connector versorgen
  UnippsQry:= TWQryUNIPPS.Create(nil);
  UnippsQry.Connector:=dbUnippsConn;

  // Tabelle Bestellungen leeren und neu befüllen
  // Eindeutige Kombination aus Lieferant, TeileNr mit Zusatzinfo zu beiden
     BestellungenAusUnipps;

  // Tabelle tmpTeileBenennung leeren und neu befüllen
  // je Teil Zeile 1 und 2 der Benennung
     TeileBenennungAusUnipps;

  // Tabelle Teile leeren und neu befüllen
  // Eindeutige TeileNr mit Zeile 1 und 2 der Benennung
  // Flags Pumpenteil und PFk auf False
     TeileBenennungInTeileTabelle;

  // Prüfe ob Teil für Pumpen verwendet wird
  // Setzt Flag Pumpenteil in Tabelle Teile
     PumpenteileAusUnipps;

  UnippsQry.Free;


end;


end.
