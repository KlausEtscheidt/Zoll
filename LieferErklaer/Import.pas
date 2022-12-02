
unit Import;

interface

uses System.SysUtils,classes, Data.DB, Data.Win.ADODB,DateUtils,
     Tools,Settings,ADOConnector,ADOQuery,QryUNIPPS,QrySQLite;

type TBasisImport = class(TThread)
     private
        var
          StatusTxtL:String;
          StatusaktRecord,StatusmaxRecord:Integer;
          counter:Integer;
        procedure InitStatusanzeige(Text:String);
        procedure RecNoStatusAnzeigen(akt:Integer);
        procedure BestellungenAusUnipps;
        procedure LieferantenTeilenummerAusUnipps;
        procedure TeileBenennungAusUnipps;
        procedure TeileBenennungInTeileTabelle;
        procedure PumpenteileAusUnipps;

        procedure LieferantenTabelleUpdaten;
        procedure LErklaerungenUpdaten;
        procedure TeileUpdateZaehleLieferanten();

     public
       procedure Execute; override;
       procedure TestRun;
       procedure SyncStatusAnzeigen;
     end;

procedure LieferantenAdressdatenAusUnipps;
procedure Auswerten();

var
  LocalQry: TWQry;
  UnippsQry: TWQryUNIPPS;
  dbUnippsConn: TWADOConnector;
  gefunden: Boolean;

implementation

uses mainfrm;

procedure TBasisImport.SyncStatusAnzeigen;
begin
  StatusBarLeft(StatusTxtL);
  if StatusmaxRecord>0 then
    StatusBar(StatusaktRecord, StatusmaxRecord);
end;

//Alle x Datensaetze Statusanzeige aktualisieren
procedure TBasisImport.RecNoStatusAnzeigen(akt:Integer);
begin
   if counter=100 then
     begin
       StatusaktRecord:=akt;
       SyncStatusAnzeigen;
       counter:=1
     end
   else
      counter:=counter+1;
end;

procedure TBasisImport.InitStatusanzeige(Text:String);
begin
  counter:=1;
  StatusTxtL:=Text;
  StatusmaxRecord:=0;
  StatusaktRecord:=0;
  Synchronize(SyncStatusAnzeigen);
end;

procedure TBasisImport.TestRun;
var
  Start:TDateTime;
  Minuten:Double;
begin
  Minuten:=MinuteSpan(Start,Now);
  sleep(20000);
  InitStatusanzeige(Format('Auswertung fertig in %3.1f Minuten',[Minuten]) );
end;

/// <summary>Liest alle noetigen Daten aus UNIPPS lesen </summary>
/// <remarks>
/// Liest Bestellungen seit xxx Tagen mit Zusatz-Info
/// aus UNIPPS in lokale Tabelle Bestellungen
/// </remarks>
procedure TBasisImport.Execute;
var
  Start:TDateTime;
  Minuten:Double;
begin
  FreeOnTerminate:=True;

  Start:=Now;
  {IFDEF HOME}
  TestRun;
  exit;
  {ENDIF}
  // Tabelle Bestellungen leeren und neu befuellen
  // Eindeutige Kombination aus Lieferant, TeileNr mit Zusatzinfo zu beiden
  BestellungenAusUnipps;
  // Liest Lieferanten-Teilenummer aus UNIPPS in lok. Tab Bestellungen
  LieferantenTeilenummerAusUnipps;
  // Tabelle tmpTeileBenennung leeren und neu befuellen
  // je Teil Zeile 1 und 2 der Benennung
  TeileBenennungAusUnipps;
  // Tabelle Teile leeren und neu bef�llen
  // Eindeutige TeileNr mit Zeile 1 und 2 der Benennung
  // Flags Pumpenteil und PFk auf False
  TeileBenennungInTeileTabelle;

  // Prüfe ob Teil für Pumpen verwendet wird
  // Setzt Flag Pumpenteil in Tabelle Teile
  PumpenteileAusUnipps;

  // Hole Adressdaten in eigene Tabelle
  LieferantenAdressdatenAusUnipps;

  // Tabelle Lieferanten updaten
  // Neue Lieferanten dazu, Alte (nicht in Bestellungen) l�schen
  LieferantenTabelleUpdaten;

  // Tabelle LErklaerungen aktualisieren
  // Neue Teile aus Bestellungen �bernehmen
  LErklaerungenUpdaten;

  // Tabelle Teile updaten: Anzahl der Lieferanten je Teil
  TeileUpdateZaehleLieferanten;

  Minuten:=MinuteSpan(Start,Now);
  InitStatusanzeige(Format('Auswertung fertig in %3.1f Minuten',[Minuten]) );

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
procedure TBasisImport.BestellungenAusUnipps;
var
  BestellZeitraum:String;
begin

//  StatusBarLeft('Import Schritt 1: Lese Bestellungen');
  InitStatusanzeige('Import Schritt 1: Lese Bestellungen');

  //Lies den BestellZeitraum
  BestellZeitraum:=LocalQry.LiesProgrammDatenWert('Bestellzeitraum');

  gefunden := UnippsQry.SucheBestellungen(Bestellzeitraum);

  if not gefunden then
    raise Exception.Create('Keine Bestellungen gefunden.');

  LocalQry.RunExecSQLQuery('delete from Bestellungen;');
  LocalQry.RunExecSQLQuery('BEGIN TRANSACTION;');

  StatusmaxRecord:=UnippsQry.n_records;
  while not UnippsQry.Eof do
  begin
    RecNoStatusAnzeigen(UnippsQry.RecNo);
    LocalQry.InsertFields('Bestellungen', UnippsQry.Fields);
    UnippsQry.next;
  end;

  StatusaktRecord:=UnippsQry.RecNo;
  SyncStatusAnzeigen;

  LocalQry.RunExecSQLQuery('COMMIT;');

end;

/// <summary>Lieferanten-Teilenummer aus UNIPPS in Tabelle
///          Bestellungen lesen </summary>
/// <remarks>
/// Zweite Abfrage zur Erstellung der Datenbasis des Programms.
/// </remarks>
procedure TBasisImport.LieferantenTeilenummerAusUnipps();

var
  IdLieferant: String;
  TeileNr, LTeileNr: String;
  Bestellungen: TADOTable;
  ErrMsg:String;

begin

  InitStatusanzeige('Import Schritt 2: Lese Lieferanten-Teilenummern');
  Bestellungen := Tools.GetTable('Bestellungen');

  Bestellungen.Open;
  Bestellungen.First;
  LocalQry.RunExecSQLQuery('BEGIN TRANSACTION;');

  StatusmaxRecord:=Bestellungen.RecordCount;
  while not Bestellungen.Eof do
  begin

    RecNoStatusAnzeigen(Bestellungen.RecNo);

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

  StatusaktRecord:=Bestellungen.RecNo;
  SyncStatusAnzeigen;

  LocalQry.RunExecSQLQuery('COMMIT;');

end;

///<summary>Lese Benennung zu Teilen aus UNIPPS in temp Tabelle</summary>
/// <remarks>
/// Dritte Abfrage zur Erstellung der Datenbasis des Programms.
/// </remarks>
procedure TBasisImport.TeileBenennungAusUnipps;
var
  BestellZeitraum:String;

begin
  InitStatusanzeige('Import Schritt 3: Lese Benennung zu Teilen');

  //Lies den Bestellzeitraum
  BestellZeitraum:=LocalQry.LiesProgrammDatenWert('Bestellzeitraum');

  //Zeitraum erhoehen um sicher alle Namen zu bekommen
  BestellZeitraum:=IntToStr(StrToInt(BestellZeitraum)+5);
  gefunden := UnippsQry.SucheTeileBenennung(BestellZeitraum);

  if not gefunden then
    raise Exception.Create('Keine TeileBenennung gefunden.');

  LocalQry.RunExecSQLQuery('delete from tmpTeileBenennung;');
  LocalQry.RunExecSQLQuery('BEGIN TRANSACTION;');

  StatusmaxRecord:=UnippsQry.RecordCount;
  while not UnippsQry.Eof do
  begin
    RecNoStatusAnzeigen(UnippsQry.RecNo);
//    INSERT INTO tmpTeileBenennung ( TeileNr, Zeile, [Text] )
    LocalQry.InsertFields('tmpTeileBenennung', UnippsQry.Fields);
    UnippsQry.next;
  end;

  StatusaktRecord:=UnippsQry.RecNo;
  SyncStatusAnzeigen;

  LocalQry.RunExecSQLQuery('COMMIT;');

end;

//Import Schritt 4: Übertrage Benennung der Teile
///<summary>Uebernahme der Benennung zu Teilen in Tabelle Teile</summary>
procedure TBasisImport.TeileBenennungInTeileTabelle();
begin

  InitStatusanzeige('Import Schritt 4: Übertrage Benennung der Teile');

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
procedure TBasisImport.PumpenteileAusUnipps();
    var TeileNr:String;
    var Ersatzteil:Boolean;

begin

  InitStatusanzeige('Import Schritt 5: Test ob Teil Pumpenteil');

  gefunden :=LocalQry.HoleTeile;

  StatusmaxRecord:=LocalQry.RecordCount;
  while not LocalQry.Eof do
  begin

    RecNoStatusAnzeigen(LocalQry.RecNo);

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

  StatusaktRecord:=LocalQry.RecNo;
  SyncStatusAnzeigen;

end;

//Import Schritt 6: Lieferanten-Tabelle
///<summary>Pflege Tabelle Lieferanten</summary>
procedure TBasisImport.LieferantenTabelleUpdaten();
begin
  InitStatusanzeige('Import Schritt 6: Erzeuge Lieferanten-Tabelle');
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

// Import Schritt 7: Lief-Erklaerungen
///<summary>Pflege Tabelle LErklaerungen</summary>
procedure TBasisImport.LErklaerungenUpdaten();
begin
  InitStatusanzeige('Import Schritt 7: Lief-Erklaerungen');
  LocalQry.NeueLErklaerungenInTabelle;
  LocalQry.AlteLErklaerungenLoeschen;
end;

// Import Schritt 8
///<summary>Anzahl der Lieferanten je Teil in Tabelle Teile</summary>
procedure TBasisImport.TeileUpdateZaehleLieferanten();
begin
  InitStatusanzeige('Import Schritt 8: Zähle Lieferanten je Teil');
  // tmp Tabelle leeren
  LocalQry.RunExecSQLQuery('delete from tmp_anz_xxx_je_teil;');
  //Anzahl der Lieferanten je Teil in tmp Tabelle tmp_anz_xxx_je_teil
  LocalQry.UpdateTmpAnzLieferantenJeTeil;
  //Anzahl der Lieferanten je Teil in Tabelle Teile
  LocalQry.UpdateTeileZaehleLieferanten;
  InitStatusanzeige('Import abgeschlossen');
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

///<summary>Hole Adressdaten aus UNIPPS in eigene Tabelle</summary>
procedure LieferantenAdressdatenAusUnipps();
begin
//  InitStatusanzeige('Lies Adressdaten');
  gefunden := UnippsQry.HoleLieferantenAdressen;

  if not gefunden then
    raise Exception.Create('Keine Lieferanten-Adressen gefunden.');

  LocalQry.RunExecSQLQuery('delete from Lieferanten_Adressen;');
  LocalQry.RunExecSQLQuery('BEGIN TRANSACTION;');

  while not UnippsQry.Eof do
  begin
//    RecNoStatusAnzeigen(UnippsQry.RecNo);
    LocalQry.InsertFields('Lieferanten_Adressen', UnippsQry.Fields);
    UnippsQry.next;
  end;

//  StatusaktRecord:=UnippsQry.RecNo;
//  SyncStatusAnzeigen;

  LocalQry.RunExecSQLQuery('COMMIT;');

end;

initialization

  // Qry fuer lokale DB anlegen
  LocalQry := Tools.GetQuery;

  //mit UNIPPS verbinden, falls wir in der Firma sind
{$IFNDEF HOME}
  dbUnippsConn:=TWADOConnector.Create(nil);
  dbUnippsConn.ConnectToUNIPPS();

  //Query fuer UNIPPS anlegen und Verbindung setzen
  //Qry anlegen und mit Connector versorgen
  UnippsQry:= TWQryUNIPPS.Create(nil);
  UnippsQry.Connector:=dbUnippsConn;
{$ENDIF}


end.
