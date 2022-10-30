
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

uses mainfrm;

procedure StatusBarLeft(text:String);
begin
  mainForm.StatusBar1.Panels[0].Text := text;
  mainForm.StatusBar1.Panels[1].Text := '';
  mainForm.StatusBar1.Update;
end;

procedure StatusBar(akt,max: Integer);
begin
   mainForm.StatusBar1.Panels[1].Text :=
          IntToStr(akt) + ' von ' + IntToStr(max);
   mainForm.StatusBar1.Update;
end;

/// <summary>Bestellungen mit Zusatzinfo aus UNIPPS lesen </summary>
/// <remarks>
/// Erste Abfrage zur Erstellung der Datenbasis des Programms.
/// Liest Bestellungen seit xxx Tagen aus UNIPPS in lokale Tabelle Bestellungen.
/// Eindeutige Kombination aus IdLieferant, TeileNr.
/// Zusatzinfo zu Lieferant: Kurzname,LName1,LName2.
/// Zusatzinfo zum Teil  LTeileNr (Lieferanten-Teilenummer).
/// </remarks>
procedure BestellungenAusUnipps();

begin

  StatusBarLeft('Import Schritt 1: Lese Bestellungen');
  gefunden := UnippsQry.SucheBestellungen(5*365);

  if not gefunden then
    raise Exception.Create('Keine Bestellungen gefunden.');

  LocalQry.RunExecSQLQuery('delete from Bestellungen;');
  LocalQry.RunExecSQLQuery('BEGIN TRANSACTION;');

  while not UnippsQry.Eof do
  begin
    StatusBar(UnippsQry.RecNo, UnippsQry.n_records);
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
  ErrMsg:String;
  failed: Boolean;

begin

  StatusBarLeft('Import Schritt 2: Lese Lieferanten-Teilenummern');
  Bestellungen := Init.GetTable('Bestellungen');

  Bestellungen.Open;
  Bestellungen.First;

  while not Bestellungen.Eof do
  begin

    StatusBar(Bestellungen.RecNo, Bestellungen.RecordCount);

    IdLieferant:=Bestellungen.FieldByName('IdLieferant').AsString;
    try
      TeileNr:=Bestellungen.FieldByName('TeileNr').AsString;
    except on E: Exception do
      ErrMsg:=  E.Message;
    end;

    try
      gefunden := UnippsQry.SucheLieferantenTeilenummer(IdLieferant, TeileNr);
    except on E: Exception do
      ErrMsg:=  E.Message;
    end;

    if not gefunden then
      ErrMsg:= 'nix gfunne';

    if gefunden then
      begin
        try
          LTeileNr := UnippsQry.FieldByName('LTeileNr').AsString;
        except on E: Exception do
          begin
            ErrMsg:=  E.Message;
            LTeileNr :=  '---Importfehler';
          end;
        end;
        Bestellungen.Edit;
        Bestellungen.FieldByName('LTeileNr').AsString:= LTeileNr;
        Bestellungen.Post;
      end;
    Bestellungen.next;
  end;

end;

//Import Schritt 3: Lese Benennung zu Teilen
///<summary>Lese Benennung zu Teilen aus UNIPPS in temp Tabelle</summary>
procedure TeileBenennungAusUnipps();

begin

  StatusBarLeft('Import Schritt 3: Lese Benennung zu Teilen');

  //Zeitraum erhöhen um sicher alle Namen zu bekommen
  gefunden := UnippsQry.SucheTeileBenennung(5*365+5);

  if not gefunden then
    raise Exception.Create('Keine TeileBenennung gefunden.');

  LocalQry.RunExecSQLQuery('delete from tmpTeileBenennung;');
  LocalQry.RunExecSQLQuery('BEGIN TRANSACTION;');

  while not UnippsQry.Eof do
  begin
    StatusBar(UnippsQry.RecNo, UnippsQry.RecordCount);

    LocalQry.InsertFields('tmpTeileBenennung', UnippsQry.Fields);
    UnippsQry.next;
  end;

  LocalQry.RunExecSQLQuery('COMMIT;');

end;

//Import Schritt 4: Übertrage Benennung der Teile
///<summary>Uebernahme der Benennung zu Teilen in Tabelle Teile</summary>
procedure TeileBenennungInTeileTabelle();
begin

  StatusBarLeft('Import Schritt 4: Übertrage Benennung der Teile');

  LocalQry.RunExecSQLQuery('delete from Teile;');

  gefunden := LocalQry.TeileName1InTabelle()    ;

  if not gefunden then
    raise Exception.Create('TeileBenennungInTabelle fehlgeschlagen.');

  gefunden := LocalQry.TeileName2InTabelle()    ;

  if not gefunden then
    raise Exception.Create('TeileBenennungInTabelle fehlgeschlagen.');

end;

//Import Schritt 5: Test ob Teil Pumpenteil
///<summary>Markiere Pumpenteile in Tabelle Teile</summary>
procedure PumpenteileAusUnipps();
    var TeileNr:String;

begin

  StatusBarLeft('Import Schritt 5: Test ob Teil Pumpenteil');

  gefunden :=LocalQry.HoleTeile;

  while not LocalQry.Eof do
  begin

    StatusBar(LocalQry.RecNo, LocalQry.n_records);

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

//Import Schritt 6: Lieferanten-Tabelle
///<summary>Pflege Tabelle Lieferanten</summary>
procedure LieferantenTabelleUpdaten();
var
  OK: Boolean;
begin
  StatusBarLeft('Import Schritt 6: Lieferanten-Tabelle');
  //Markiere Lieferanten, neu waren und die noch aktuell sind als aktuell
  OK := LocalQry.MarkiereAktuelleLieferanten;
  //Uebertrage neue Lieferanten
  OK := LocalQry.NeueLieferantenInTabelle;
  //Markiere Lieferanten, die im Zeitraum nicht geliefert haben, als "entfallen"
  OK := LocalQry.MarkiereAlteLieferanten;
  // Markiere Lieferanten die mind. 1 Pumpenteil liefern
  OK := LocalQry.MarkierePumpenteilLieferanten;
end;

// Import Schritt 7: Lief-Erklaerungen
///<summary>Pflege Tabelle LErklaerungen</summary>
procedure LErklaerungenUpdaten();
var
  OK: Boolean;
begin
  StatusBarLeft('Import Schritt 7: Lief-Erklaerungen');
  OK := LocalQry.NeueLErklaerungenInTabelle;
  OK := LocalQry.AlteLErklaerungenLoeschen;
end;

///<summary>Lese alle Daten aus UNIPPS zum jährlichen Neustart.</summary>
procedure BasisImport();
var
  dbUnippsConn: TWADOConnector;

begin

  // Qry fuer lokale DB anlegen
  LocalQry := Init.GetQuery;

  {$IFNDEF HOME}
  BasisImportFromUNIPPS;
  {$ENDIF}

  // Tabelle Lieferanten updaten
  // Neue Lieferanten dazu, Alte (nicht in Bestellungen) löschen
     LieferantenTabelleUpdaten;

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
     BestellungenAusUnipps;
  // Liest Lieferanten-Teilenummer aus UNIPPS in lok. Tab Bestellungen
     LieferantenTeilenummerAusUnipps;

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
