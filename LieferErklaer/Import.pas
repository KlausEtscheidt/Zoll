
unit Import;

interface

uses System.SysUtils,classes, Data.DB, Data.Win.ADODB,DateUtils,
     Tools,Settings,ADOConnector,ADOQuery,QryUNIPPS,QrySQLite;

type TBasisImport = class(TThread)
     private
        var
          StatusAktRecord,StatusMaxRecord:Integer;
          StatusSchrittNr:Integer;
          StatusSchrittBenennung:String;
          counter:Integer;
        //Start eines Importschrittes anzeigen
        procedure SchrittAnfangAnzeigen(StepNr:Integer;SchrittBenennung:String);
        procedure SyncStatusNewStep;
        //Ende eines Importschrittes anzeigen
        procedure SchrittEndeAnzeigen;
        procedure SyncStatusFinishedStep;
        // alle 100 Records x von y gelesen anzeigen (Forced zeigt immer an)
        procedure RecNoStatusAnzeigen(akt:Integer;Forced:Boolean=False);
        procedure SyncRecNoStatusAnzeigen;

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
     end;

procedure LieferantenAdressdatenAusUnipps;
procedure Auswerten();

var
  LocalQry: TWQry;
  UnippsQry: TWQryUNIPPS;
  dbUnippsConn: TWADOConnector;
  gefunden: Boolean;

implementation

uses mainfrm, ImportStatusInfoDlg;

//----------- Synchronisieren der GUI zur Anzeige des Import-Fortschrittes
// Noetig, bei Ausführung in threads
//------------------------------------------------------------------------

//Anzeige des Fortschrittes: x von y Datensaetze gelesen
procedure TBasisImport.RecNoStatusAnzeigen(akt:Integer;Forced:Boolean=False);
const
  interval:Integer=50;
begin
  if akt=1 then
     counter:=interval; //Anzeige des ersten DS erzwingen
  if (counter=interval) or Forced then
    begin
     StatusAktRecord:=akt;
     Synchronize(SyncRecNoStatusAnzeigen);
     if counter=interval then
       counter:=1
    end
  else
    counter:=counter+1;
  if akt=1 then
    counter:=2;
end;
procedure TBasisImport.SyncRecNoStatusAnzeigen;
begin
  ImportStatusDlg.AnzeigeRecordsGelesen(StatusaktRecord,StatusmaxRecord);
end;


//Anzeige des Endes eines Import-Schrittes
procedure TBasisImport.SchrittEndeAnzeigen;
begin
  Synchronize(SyncStatusFinishedStep);
end;

procedure TBasisImport.SyncStatusFinishedStep;
begin
  ImportStatusDlg.AnzeigeEndeImportSchritt(StatusSchrittNr);
end;

//Anzeige des Anfangs eines Import-Schrittes
procedure TBasisImport.SchrittAnfangAnzeigen(StepNr:Integer;SchrittBenennung:String);
//var
begin
  counter:=1; //Fuer Recordanzeige
  StatusSchrittNr:=StepNr;
  StatusSchrittBenennung:=SchrittBenennung;
  Synchronize(SyncStatusNewStep);
end;

procedure TBasisImport.SyncStatusNewStep;
begin
  ImportStatusDlg.AnzeigeNeuerImportSchritt(StatusSchrittNr,
                                                    StatusSchrittBenennung);
end;

// --------------------- Import im Thread ------------------
// ---------------------------------------------------------


/// <summary>Liest alle noetigen Daten aus UNIPPS lesen </summary>
/// <remarks>
/// Liest Bestellungen seit xxx Tagen mit Zusatz-Info
/// aus UNIPPS in lokale Tabelle Bestellungen
/// </remarks>
procedure TBasisImport.Execute;
begin
  FreeOnTerminate:=True;

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

  Synchronize(ImportStatusDlg.ImportEnde);

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

  SchrittAnfangAnzeigen(1,'Bestellungen lesen');

  //Lies den BestellZeitraum
  BestellZeitraum:=LocalQry.LiesProgrammDatenWert('Bestellzeitraum');

  gefunden := UnippsQry.SucheBestellungen(Bestellzeitraum);

  if not gefunden then
    raise Exception.Create('Keine Bestellungen gefunden.');

  LocalQry.RunExecSQLQuery('delete from Bestellungen;');
  LocalQry.RunExecSQLQuery('BEGIN TRANSACTION;');

  StatusMaxRecord:=UnippsQry.n_records;
  while not UnippsQry.Eof do
  begin
    RecNoStatusAnzeigen(UnippsQry.RecNo);
    LocalQry.InsertFields('Bestellungen', UnippsQry.Fields);
    UnippsQry.next;
  end;

  RecNoStatusAnzeigen(StatusmaxRecord,True);
  SchrittEndeAnzeigen;

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
//  Bestellungen: TADOTable;
  Bestellungen: TWTable;
  ErrMsg:String;

begin

  SchrittAnfangAnzeigen(2,'Lieferanten-Teilenummern lesen');
  Bestellungen := Tools.GetTable('Bestellungen');

//  Bestellungen := Tools.GetQuery;
//  Bestellungen.RunSelectQuery('SELECT * FROM Bestellungen');

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

  RecNoStatusAnzeigen(StatusmaxRecord,True);
  SchrittEndeAnzeigen;

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
  SchrittAnfangAnzeigen(3,'Benennung zu Teilen lesen');

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

  RecNoStatusAnzeigen(StatusmaxRecord,True);
  SchrittEndeAnzeigen;

  LocalQry.RunExecSQLQuery('COMMIT;');

end;

//Import Schritt 4: Übertrage Benennung der Teile
///<summary>Uebernahme der Benennung zu Teilen in Tabelle Teile</summary>
procedure TBasisImport.TeileBenennungInTeileTabelle();
begin

  SchrittAnfangAnzeigen(4,'Benennung der Teile übertragen');

  LocalQry.RunExecSQLQuery('delete from Teile;');

  gefunden := LocalQry.TeileName1InTabelle()    ;

  if not gefunden then
    raise Exception.Create('TeileBenennungInTabelle fehlgeschlagen.');

  gefunden := LocalQry.TeileName2InTabelle()    ;

  if not gefunden then
    raise Exception.Create('TeileBenennungInTabelle fehlgeschlagen.');

  SchrittEndeAnzeigen;
end;

//Import Schritt 5: Test ob Teil Pumpenteil
///<summary>Markiere Pumpenteile in Tabelle Teile</summary>
procedure TBasisImport.PumpenteileAusUnipps();
    var TeileNr:String;
    var Ersatzteil:Boolean;

begin

  SchrittAnfangAnzeigen(5, 'Teste ob Teil Pumpenteil');

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

  RecNoStatusAnzeigen(StatusmaxRecord,True);
  SchrittEndeAnzeigen;

end;

//Import Schritt 6: Lieferanten-Tabelle
///<summary>Pflege Tabelle Lieferanten</summary>
procedure TBasisImport.LieferantenTabelleUpdaten();
begin
  SchrittAnfangAnzeigen(6,'Lieferanten-Tabelle erzeugen');
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
  SchrittEndeAnzeigen;

end;

// Import Schritt 7: Lief-Erklaerungen
///<summary>Pflege Tabelle LErklaerungen</summary>
procedure TBasisImport.LErklaerungenUpdaten();
begin
  SchrittAnfangAnzeigen(7,'Lief.-Erkl. ergaenzen');
  LocalQry.NeueLErklaerungenInTabelle;
  LocalQry.AlteLErklaerungenLoeschen;
  SchrittEndeAnzeigen;
end;

// Import Schritt 8
///<summary>Anzahl der Lieferanten je Teil in Tabelle Teile</summary>
procedure TBasisImport.TeileUpdateZaehleLieferanten();
begin
  SchrittAnfangAnzeigen(8,'Lieferanten je Teil zählen');
  // tmp Tabelle leeren
  LocalQry.RunExecSQLQuery('delete from tmp_anz_xxx_je_teil;');
  //Anzahl der Lieferanten je Teil in tmp Tabelle tmp_anz_xxx_je_teil
  LocalQry.UpdateTmpAnzLieferantenJeTeil;
  //Anzahl der Lieferanten je Teil in Tabelle Teile
  LocalQry.UpdateTeileZaehleLieferanten;
  SchrittEndeAnzeigen;
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

  // Flag PFK in Teile setzen
  LocalQry.UpdateTeileResetPFK;
  LocalQry.UpdateTeileSetPFK;

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
