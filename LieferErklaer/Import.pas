
unit Import;

interface

uses System.SysUtils, Data.DB, Data.Win.ADODB,
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

/// <summary>Bestellungen mit Zusatzinfo aus UNIPPS lesen </summary>


uses mainfrm;/// <remarks>
/// Erste Abfrage zur Erstellung der Datenbasis des Programms
/// Liest Bestellungen seit xxx Tagen aus UNIPPS in lokale Tabelle Bestellungen
/// Eindeutige Kombination aus IdLieferant, TeileNr
/// Zusatzinfo zu Lieferant: Kurzname,LName1,LName2
/// Zusatzinfo zum Teil  LTeileNr (Lieferanten-Teilenummer)
/// </remarks>
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

/// <summary>Lieferanten-Teilenummer aus UNIPPS lesen </summary>
/// <remarks>
/// Wird von BasisImportFromUNIPPS benutzt,
/// um LTeileNr in lokale Tabelle Bestellungen zu schreiben.
/// </remarks>
procedure LieferantenTeilenummerAusUnipps();

var
  IdLieferant: String;
  TeileNr, LTeileNr: String;
  Bestellungen: TADOTable;
  NRec,cRecNo : Integer;
  xx:String;
  failed: Boolean;

begin

  Bestellungen := Init.GetTable('Bestellungen');

  Bestellungen.Open;
  NRec:=Bestellungen.RecordCount;

  Bestellungen.First;

//  LocalQry.RunExecSQLQuery('delete from tmpLTeileNr;');

  while not Bestellungen.Eof do
  begin

//    LocalQry.RunExecSQLQuery('BEGIN TRANSACTION;');

    cRecNo:=Bestellungen.RecNo;
    IdLieferant:=Bestellungen.FieldByName('IdLieferant').AsString;
    TeileNr:=Bestellungen.FieldByName('TeileNr').AsString;

    try
      gefunden := UnippsQry.xSucheLieferantenTeilenummer(IdLieferant,TeileNr);
    except on E: Exception do
      xx:= 'nix';
    end;

    if not gefunden then
      xx:= 'nix';

//      raise Exception.Create('nix gefunden.');

//    LTeileNr := UnippsQry.FieldByName('LTeileNr').AsString;

//    while not UnippsQry.Eof do
//    begin
//      failed := False;
//      try
//        TeileNr := UnippsQry.FieldByName('TeileNr').AsString;
//      except on E: Exception do
//        xx:= 'nix' + E.Message;
//      end;
//      try
//        LTeileNr := UnippsQry.FieldByName('LTeileNr').AsString;
//      except on E: Exception do
//        xx:= 'nix' + E.Message;
//      end;
//      try
//        LocalQry.InsertFields('tmpLTeileNr', UnippsQry.Fields);
//        xx:= UnippsQry.GetFieldValuesAsText;
//      except on E: Exception do
//        xx:= 'nix' + E.Message;
//      end;
//      try
//        UnippsQry.next;
//      finally
//        failed := True;
//      end;
//
//      if failed then
//        break;
//
//    end;

//    LocalQry.RunExecSQLQuery('COMMIT;');
    if gefunden then
      begin
        try
          LTeileNr := UnippsQry.FieldByName('LTeileNr').AsString;
        except on E: Exception do
          xx:= 'nix' + E.Message;
        end;
        Bestellungen.Edit;
        Bestellungen.FieldByName('LTeileNr').AsString:= LTeileNr;
        Bestellungen.Post;
      end;
    Bestellungen.next;
  end;

end;


procedure TeileBenennungAusUnipps();
var
    cRecNo: Integer;
begin

  gefunden := UnippsQry.SucheTeileBenennung;

  if not gefunden then
    raise Exception.Create('Keine TeileBenennung gefunden.');

  LocalQry.RunExecSQLQuery('delete from tmpTeileBenennung;');
  LocalQry.RunExecSQLQuery('BEGIN TRANSACTION;');

  while not UnippsQry.Eof do
  begin
    cRecNo:=UnippsQry.RecNo;
    mainForm.StatusBar1.Panels[0].Text := IntToStr(cRecNo) + ' von '
        + IntToStr(UnippsQry.n_records);

    LocalQry.InsertFields('tmpTeileBenennung', UnippsQry.Fields);
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

//  Init.start;

  //Qry fuer lokale DB anlegen
  LocalQry := Init.GetQuery;

  {$IFNDEF HOME}
  BasisImportFromUNIPPS;
  {$ENDIF}

  // Tabelle Lieferanten leeren und neu befüllen
  // Eindeutige IdLieferant mit Zeile 1 und 2 der Benennung
//     LieferantenTabelleFuellen;
                 { TODO :
Nur neue Lieferanten dazu, alte löschen oder deaktivieren.
Stand soll erhalten bleiben. }
 
  // Tabelle LErklaerungen aktualisieren
  // Neue Teile aus Bestellungen übernehmen
     LErklaerungenUpdaten;

end;

/// <summary>Liest alle noetigen Daten aus UNIPPS lesen </summary>
/// <remarks>
/// Liest Bestellungen seit xxx Tagen mit Zusatz-Info
/// aus UNIPPS in lokale Tabelle Bestellungen
/// </remarks>
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
//     BestellungenAusUnipps;
  // Liest Lieferanten-Teilenummer aus UNIPPS in lok. Tab Bestellungen
//     LieferantenTeilenummerAusUnipps;

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
