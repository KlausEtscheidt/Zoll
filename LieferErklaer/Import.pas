
unit Import;

interface

uses System.SysUtils, Data.DB, Data.Win.ADODB,
     Tools,Settings,ADOConnector,ADOQuery,QryUNIPPS,QrySQLite;

procedure BasisImport();
procedure BasisImportFromUNIPPS();
procedure BestellungenAusUnipps();
procedure TeileBenennungAusUnipps;
procedure TeileUpdateZaehleLieferanten;
procedure Auswerten();
procedure LieferantenAdressdatenAusUnipps();

var
  LocalQry: TWQry;
  UnippsQry: TWQryUNIPPS;
  dbUnippsConn: TWADOConnector;
  gefunden: Boolean;

implementation

uses mainfrm;

/// <summary>Ausgabe in linkes panel des Statusbar </summary>
procedure StatusBarLeft(text:String);
begin
  mainForm.StatusBar1.Panels[0].Text := text;
  mainForm.StatusBar1.Panels[1].Text := '';
  mainForm.StatusBar1.Update;
end;

/// <summary>Ausgabe in rechtes panel des Statusbar </summary>
procedure StatusBar(akt,max: Integer);
begin
   mainForm.StatusBar1.Panels[1].Text :=
          IntToStr(akt) + ' von ' + IntToStr(max);
   mainForm.StatusBar1.Update;
end;


procedure Auswerten();
var
  minRestGueltigkeit:String;

begin
  StatusBarLeft('Beginne Auswertung');
  // Qry fuer lokale DB anlegen
  LocalQry := Tools.GetQuery;

  //Lies die Tage, die eine Lief.-Erklär. mindestens noch gelten muss
  minRestGueltigkeit:=LocalQry.LiesProgrammDatenWert('Gueltigkeit_Lekl');

  //Leere Zwischentabelle
  LocalQry.RunExecSQLQuery('delete from tmpLieferantTeilPfk;');

  //Fuege Teile von Lieferanten mit gültiger Erklärung "alle Teile" ein
  LocalQry.LeklAlleTeileInTmpTabelle(minRestGueltigkeit);

  //Fuege Teile von Lieferanten mit gültiger Erklärung "einige Teile" ein
  LocalQry.LeklEinigeTeileInTmpTabelle(minRestGueltigkeit);

  //Leere Zwischentabelle
  LocalQry.RunExecSQLQuery('delete from tmp_anz_xxx_je_teil;');

  //Anzahl der Lieferanten mit gültiger Erklaerung je Teil in tmp Tabelle
  LocalQry.UpdateTmpAnzErklaerungenJeTeil;

  //Anzahl der Lieferanten mit gültiger Erklaerung je Teil
  //in Tabelle Teile auf 0 setzen
  LocalQry.RunExecSQLQuery('UPDATE Teile SET n_LPfk= 0');

  //Anzahl der Lieferanten mit gültiger Erklaerung je Teil in Tabelle Teile
  LocalQry.UpdateTeileZaehleGueltigeLErklaerungen;

  StatusBarLeft('Auswertung fertig');
end;

/// <summary>Bestellungen mit Zusatzinfo aus UNIPPS in Tabelle
///          Bestellungen lesen </summary>
/// <remarks>
/// Erste Abfrage zur Erstellung der Datenbasis des Programms.
/// Liest Bestellungen seit xxx Tagen aus UNIPPS in lokale Tabelle Bestellungen.
/// Eindeutige Kombination aus IdLieferant, TeileNr.
/// Zusatzinfo zu Lieferant: Kurzname,LName1,LName2.
/// Zusatzinfo zum Teil  LTeileNr (Lieferanten-Teilenummer).
/// </remarks>
procedure BestellungenAusUnipps();
var
  BestellZeitraum:String;
begin

  StatusBarLeft('Import Schritt 1: Lese Bestellungen');

  //Lies den BestellZeitraum
  BestellZeitraum:=LocalQry.LiesProgrammDatenWert('Bestellzeitraum');

  gefunden := UnippsQry.SucheBestellungen(Bestellzeitraum);

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

/// <summary>Lieferanten-Teilenummer aus UNIPPS in Tabelle
///          Bestellungen lesen </summary>
/// <remarks>
/// Zweite Abfrage zur Erstellung der Datenbasis des Programms.
/// </remarks>
procedure LieferantenTeilenummerAusUnipps();

var
  IdLieferant: String;
  TeileNr, LTeileNr: String;
  Bestellungen: TADOTable;
  ErrMsg:String;

begin

  StatusBarLeft('Import Schritt 2: Lese Lieferanten-Teilenummern');
  Bestellungen := Tools.GetTable('Bestellungen');

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

///<summary>Lese Benennung zu Teilen aus UNIPPS in temp Tabelle</summary>
/// <remarks>
/// Dritte Abfrage zur Erstellung der Datenbasis des Programms.
/// </remarks>
procedure TeileBenennungAusUnipps();
var
  BestellZeitraum:String;

begin

  StatusBarLeft('Import Schritt 3: Lese Benennung zu Teilen');

  //Lies den Bestellzeitraum
  BestellZeitraum:=LocalQry.LiesProgrammDatenWert('Bestellzeitraum');

  //Zeitraum erhoehen um sicher alle Namen zu bekommen
  BestellZeitraum:=IntToStr(StrToInt(BestellZeitraum)+5);
  gefunden := UnippsQry.SucheTeileBenennung(BestellZeitraum);

  if not gefunden then
    raise Exception.Create('Keine TeileBenennung gefunden.');

  LocalQry.RunExecSQLQuery('delete from tmpTeileBenennung;');
  LocalQry.RunExecSQLQuery('BEGIN TRANSACTION;');

  while not UnippsQry.Eof do
  begin
    StatusBar(UnippsQry.RecNo, UnippsQry.RecordCount);

//    INSERT INTO tmpTeileBenennung ( TeileNr, Zeile, [Text] )
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
    var Ersatzteil:Boolean;

begin

  StatusBarLeft('Import Schritt 5: Test ob Teil Pumpenteil');

  gefunden :=LocalQry.HoleTeile;

  while not LocalQry.Eof do
  begin

    StatusBar(LocalQry.RecNo, LocalQry.n_records);

    TeileNr:=LocalQry.FieldByName('TeileNr').AsString;

    gefunden := UnippsQry.SucheTeileInKA(TeileNr);
    Ersatzteil:=gefunden;
    if not gefunden then
      gefunden := UnippsQry.SucheTeileInFA(TeileNr);
    if not gefunden then
      gefunden := UnippsQry.SucheTeileInSTU(TeileNr);
    if not gefunden then
      gefunden := UnippsQry.SucheTeileInFAKopf(TeileNr);

    if gefunden then
    begin
      LocalQry.Edit;
      LocalQry.FieldByName('Pumpenteil').Value := True;
      if Ersatzteil then
        LocalQry.FieldByName('Ersatzteil').Value := True;
      LocalQry.Post;
    end;

    LocalQry.next;

  end;


end;

//Import Schritt 6: Lieferanten-Tabelle
///<summary>Pflege Tabelle Lieferanten</summary>
procedure LieferantenTabelleUpdaten();

begin
  StatusBarLeft('Import Schritt 6: Lieferanten-Tabelle');
  //Markiere Lieferanten, neu waren und die noch aktuell sind als aktuell
  LocalQry.MarkiereAktuelleLieferanten;
  //Uebertrage neue Lieferanten
  LocalQry.NeueLieferantenInTabelle;
  //Markiere Lieferanten, die im Zeitraum nicht geliefert haben, als "entfallen"
  LocalQry.MarkiereAlteLieferanten;
  //Setze Markierung f Pumpen-/Ersatzteile zurück.
  LocalQry.ResetPumpenErsatzteilMarkierungInLieferanten;
  // Markiere Lieferanten die mind. 1 Pumpenteil liefern
  LocalQry.MarkierePumpenteilLieferanten;
  // Markiere Lieferanten die mind. 1 Ersatzteil liefern
  LocalQry.MarkiereErsatzteilLieferanten;
end;

///<summary>Hole Adressdaten aus UNIPPS in eigene Tabelle</summary>
procedure LieferantenAdressdatenAusUnipps();
begin
  gefunden := UnippsQry.HoleLieferantenAdressen;

  if not gefunden then
    raise Exception.Create('Keine Lieferanten-Adressen gefunden.');

  LocalQry.RunExecSQLQuery('delete from Lieferanten_Adressen;');
  LocalQry.RunExecSQLQuery('BEGIN TRANSACTION;');

  while not UnippsQry.Eof do
  begin
    StatusBar(UnippsQry.RecNo, UnippsQry.n_records);
    LocalQry.InsertFields('Lieferanten_Adressen', UnippsQry.Fields);
    UnippsQry.next;
  end;

  LocalQry.RunExecSQLQuery('COMMIT;');

end;
// Import Schritt 7: Lief-Erklaerungen
///<summary>Pflege Tabelle LErklaerungen</summary>
procedure LErklaerungenUpdaten();
begin
  StatusBarLeft('Import Schritt 7: Lief-Erklaerungen');
  LocalQry.NeueLErklaerungenInTabelle;
  LocalQry.AlteLErklaerungenLoeschen;
end;

// Import Schritt 8
///<summary>Anzahl der Lieferanten je Teil in Tabelle Teile</summary>
procedure TeileUpdateZaehleLieferanten();
begin
  // tmp Tabelle leeren
  LocalQry.RunExecSQLQuery('delete from tmp_anz_lieferanten_je_teil;');
  //Anzahl der Lieferanten je Teil in tmp Tabelle tmp_anz_lieferanten_je_teil
  LocalQry.UpdateTmpAnzLieferantenJeTeil;
  //Anzahl der Lieferanten je Teil in Tabelle Teile
  LocalQry.UpdateTeileZaehleLieferanten;
  StatusBarLeft('Import fertig gestellt');

end;

///<summary>Lese alle Daten aus UNIPPS zum j�hrlichen Neustart.</summary>
procedure BasisImport();

begin

  {$IFNDEF HOME}
  BasisImportFromUNIPPS;
  {$ENDIF}

  // Tabelle Lieferanten updaten
  // Neue Lieferanten dazu, Alte (nicht in Bestellungen) l�schen
     LieferantenTabelleUpdaten;

  // Tabelle LErklaerungen aktualisieren
  // Neue Teile aus Bestellungen �bernehmen
     LErklaerungenUpdaten;

  // Tabelle Teile updaten: Anzahl der Lieferanten je Teil
     TeileUpdateZaehleLieferanten;

end;

/// <summary>Liest alle noetigen Daten aus UNIPPS lesen </summary>
/// <remarks>
/// Liest Bestellungen seit xxx Tagen mit Zusatz-Info
/// aus UNIPPS in lokale Tabelle Bestellungen
/// </remarks>
procedure BasisImportFromUNIPPS();

begin

  // Tabelle Bestellungen leeren und neu bef�llen
  // Eindeutige Kombination aus Lieferant, TeileNr mit Zusatzinfo zu beiden
     BestellungenAusUnipps;
  // Liest Lieferanten-Teilenummer aus UNIPPS in lok. Tab Bestellungen
     LieferantenTeilenummerAusUnipps;

  // Tabelle tmpTeileBenennung leeren und neu bef�llen
  // je Teil Zeile 1 und 2 der Benennung
     TeileBenennungAusUnipps;

  // Tabelle Teile leeren und neu bef�llen
  // Eindeutige TeileNr mit Zeile 1 und 2 der Benennung
  // Flags Pumpenteil und PFk auf False
     TeileBenennungInTeileTabelle;

  // Pr�fe ob Teil f�r Pumpen verwendet wird
  // Setzt Flag Pumpenteil in Tabelle Teile
     PumpenteileAusUnipps;

  // Hole Adressdaten in eigene Tabelle
     LieferantenAdressdatenAusUnipps;

  UnippsQry.Free;


end;

initialization
    Tools.init;
  // Qry fuer lokale DB anlegen
  LocalQry := Tools.GetQuery;

  //mit UNIPPS verbinden
{$IFNDEF HOME}
  dbUnippsConn:=TWADOConnector.Create(nil);
  dbUnippsConn.ConnectToUNIPPS();

  //Query fuer UNIPPS anlegen und Verbindung setzen
  //Qry anlegen und mit Connector versorgen
  UnippsQry:= TWQryUNIPPS.Create(nil);
  UnippsQry.Connector:=dbUnippsConn;
{$ENDIF}


end.
