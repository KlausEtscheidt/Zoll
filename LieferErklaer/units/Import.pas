
unit Import;

interface

uses System.SysUtils,classes,Vcl.Dialogs,
     Data.DB, Data.Win.ADODB,DateUtils,
     Tools,ADOConnector,ADOQuery,QryUNIPPS,QrySQLite;

type TBasisImport = class(TThread)
     private
        var
          //Lokale Query (Der Thread darf nicht die vom main-thread verwenden)
          LocalQry2: TWQry;
          //UNIPPS Query
          UnippsQry2: TWQryUNIPPS;
          //Statusanzeige
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

procedure Init;
function GetUNIPPSQry():TWQryUNIPPS;
procedure LieferantenAdressdatenAusUnipps;
procedure Auswerten();
procedure HoleWareneingänge;

var
  Initialized:Boolean;
  LocalQry1: TWQry;
  UnippsQry1: TWQryUNIPPS;

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
  LocalQry2:=Tools.GetQuery(True);
  UnippsQry2:=GetUNIPPSQry;
  if UnippsQry2=nil then
    exit;

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
  gefunden:Boolean;
begin

  SchrittAnfangAnzeigen(1,'Bestellungen lesen');

  //Lies den BestellZeitraum
  BestellZeitraum:=LocalQry2.LiesProgrammDatenWert('Bestellzeitraum');

  gefunden := UnippsQry2.SucheBestellungen(Bestellzeitraum);

  if not gefunden then
    raise Exception.Create('Keine Bestellungen gefunden.');

  LocalQry2.RunExecSQLQuery('delete from Bestellungen;');
  LocalQry2.RunExecSQLQuery('BEGIN TRANSACTION;');

  StatusMaxRecord:=UnippsQry2.n_records;
  while not UnippsQry2.Eof do
  begin
    RecNoStatusAnzeigen(UnippsQry2.RecNo);
    LocalQry2.InsertFields('Bestellungen', UnippsQry2.Fields);
    UnippsQry2.next;
  end;

  RecNoStatusAnzeigen(StatusmaxRecord,True);
  SchrittEndeAnzeigen;

  LocalQry2.RunExecSQLQuery('COMMIT;');

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
  Bestellungen: TWTable;
//  Bestellungen: TWQry;
  ErrMsg:String;
  gefunden:Boolean;
begin

  SchrittAnfangAnzeigen(2,'Lieferanten-Teilenummern lesen');
  Bestellungen := Tools.GetTable('Bestellungen');

//  Bestellungen := Tools.GetQuery;
//  Bestellungen.RunSelectQuery('SELECT * FROM Bestellungen');

  Bestellungen.Open;
  {$IFDEF FIREDAC}
  Bestellungen.FetchAll;
  {$ENDIF}
  Bestellungen.First;
  LocalQry2.RunExecSQLQuery('BEGIN TRANSACTION;');

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
      gefunden := UnippsQry2.SucheLieferantenTeilenummer(IdLieferant, TeileNr);
    except on E: Exception do
      ErrMsg:=  E.Message;
    end;

    if not gefunden then
      ErrMsg:= 'nix gfunne';

    if gefunden then
      begin
        try
          LTeileNr := UnippsQry2.FieldByName('LTeileNr').AsString;
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

  LocalQry2.RunExecSQLQuery('COMMIT;');

end;

///<summary>Lese Benennung zu Teilen aus UNIPPS in temp Tabelle</summary>
/// <remarks>
/// Dritte Abfrage zur Erstellung der Datenbasis des Programms.
/// </remarks>
procedure TBasisImport.TeileBenennungAusUnipps;
var
  BestellZeitraum:String;
  gefunden:Boolean;

begin
  SchrittAnfangAnzeigen(3,'Benennung zu Teilen lesen');

  //Lies den Bestellzeitraum
  BestellZeitraum:=LocalQry2.LiesProgrammDatenWert('Bestellzeitraum');

  //Zeitraum erhoehen um sicher alle Namen zu bekommen
  BestellZeitraum:=IntToStr(StrToInt(BestellZeitraum)+5);
  gefunden := UnippsQry2.SucheTeileBenennung(BestellZeitraum);

  if not gefunden then
    raise Exception.Create('Keine TeileBenennung gefunden.');

  LocalQry2.RunExecSQLQuery('delete from tmpTeileBenennung;');
  LocalQry2.RunExecSQLQuery('BEGIN TRANSACTION;');

  StatusmaxRecord:=UnippsQry2.RecordCount;
  while not UnippsQry2.Eof do
  begin
    RecNoStatusAnzeigen(UnippsQry2.RecNo);
//    INSERT INTO tmpTeileBenennung ( TeileNr, Zeile, [Text] )
    LocalQry2.InsertFields('tmpTeileBenennung', UnippsQry2.Fields);
    UnippsQry2.next;
  end;

  RecNoStatusAnzeigen(StatusmaxRecord,True);
  SchrittEndeAnzeigen;

  LocalQry2.RunExecSQLQuery('COMMIT;');

end;

//Import Schritt 4: Übertrage Benennung der Teile
///<summary>Uebernahme der Benennung zu Teilen in Tabelle Teile</summary>
procedure TBasisImport.TeileBenennungInTeileTabelle();
var
  gefunden:Boolean;
begin

  SchrittAnfangAnzeigen(4,'Benennung der Teile übertragen');

  LocalQry2.RunExecSQLQuery('delete from Teile;');

  gefunden := LocalQry2.TeileName1InTabelle()    ;

  if not gefunden then
    raise Exception.Create('TeileBenennungInTabelle fehlgeschlagen.');

  gefunden := LocalQry2.TeileName2InTabelle()    ;

  if not gefunden then
    raise Exception.Create('TeileBenennungInTabelle fehlgeschlagen.');

 LocalQry2.RunExecSQLQuery('delete FROM Teile WHERE TeileNr Not In ' +
                           '(select TeileNr from Bestellungen)');

  SchrittEndeAnzeigen;
end;

//Import Schritt 5: Test ob Teil Pumpenteil
///<summary>Markiere Pumpenteile in Tabelle Teile</summary>
procedure TBasisImport.PumpenteileAusUnipps();
  var
    TeileNr:String;
    Ersatzteil:Boolean;
    gefunden:Boolean;

begin

  SchrittAnfangAnzeigen(5, 'Teste ob Teil Pumpenteil');

  gefunden :=LocalQry2.HoleTeile;
  {$IFDEF FIREDAC}
  LocalQry2.FetchAll;
  {$ENDIF}

  StatusmaxRecord:=LocalQry2.RecordCount;
  while not LocalQry2.Eof do
  begin

    RecNoStatusAnzeigen(LocalQry2.RecNo);

    TeileNr:=LocalQry2.FieldByName('TeileNr').AsString;

    gefunden := UnippsQry2.SucheTeileInKA(TeileNr);
    Ersatzteil:=gefunden;
    if not gefunden then
      gefunden := UnippsQry2.SucheTeileInFA(TeileNr);
    if not gefunden then
      gefunden := UnippsQry2.SucheTeileInSTU(TeileNr);
    if not gefunden then
      gefunden := UnippsQry2.SucheTeileInFAKopf(TeileNr);

    if gefunden then
    begin
      LocalQry2.Edit;
      LocalQry2.FieldByName('Pumpenteil').Value := True;
      if Ersatzteil then
        LocalQry2.FieldByName('Ersatzteil').Value := True;
      LocalQry2.Post;
    end;

    LocalQry2.next;

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
  LocalQry2.MarkiereAktuelleLieferanten;
  //Uebertrage neue Lieferanten
  LocalQry2.NeueLieferantenInTabelle;
  //Markiere Lieferanten, die im Zeitraum nicht geliefert haben, als "entfallen"
  LocalQry2.MarkiereAlteLieferanten;
  //Setze Markierung f Pumpen-/Ersatzteile zurück.
  LocalQry2.ResetPumpenErsatzteilMarkierungInLieferanten;
  // Markiere Lieferanten die mind. 1 Pumpenteil liefern
  LocalQry2.MarkierePumpenteilLieferanten;
  // Markiere Lieferanten die mind. 1 Ersatzteil liefern
  LocalQry2.MarkiereErsatzteilLieferanten;
  SchrittEndeAnzeigen;

end;

// Import Schritt 7: Lief-Erklaerungen
///<summary>Pflege Tabelle LErklaerungen</summary>
procedure TBasisImport.LErklaerungenUpdaten();
begin
  SchrittAnfangAnzeigen(7,'Lief.-Erkl. ergaenzen');
  LocalQry2.NeueLErklaerungenInTabelle;
  LocalQry2.AlteLErklaerungenLoeschen;
  SchrittEndeAnzeigen;
end;

// Import Schritt 8
///<summary>Anzahl der Lieferanten je Teil in Tabelle Teile</summary>
procedure TBasisImport.TeileUpdateZaehleLieferanten();
begin
  SchrittAnfangAnzeigen(8,'Lieferanten je Teil zählen');
  // tmp Tabelle leeren
  LocalQry2.RunExecSQLQuery('delete from tmp_anz_xxx_je_teil;');
  //Anzahl der Lieferanten je Teil in tmp Tabelle tmp_anz_xxx_je_teil
  LocalQry2.UpdateTmpAnzLieferantenJeTeil;
  //Anzahl der Lieferanten je Teil in Tabelle Teile
  LocalQry2.UpdateTeileZaehleLieferanten;
  SchrittEndeAnzeigen;
end;

// ----------------------------------------------------------------------
// --------------------- Import ausserhalb des Threads ---------------
// ----------------------------------------------------------------------

/// <summary> Finale Auswertung und Erzeugen der UNIPPS-Export-Tabelle</summary>
procedure Auswerten();
var
  minRestGueltigkeit:String;

begin

  // Qry fuer lokale DB anlegen
  if not assigned(LocalQry1) then
    LocalQry1 := Tools.GetQuery;
  if not assigned(LocalQry1) then
    exit;

  StatusBarLeft('Beginne Auswertung');
  // Qry fuer lokale DB anlegen
  LocalQry1 := Tools.GetQuery;

  //Lies die Tage, die eine Lief.-Erklär. mindestens noch gelten muss
  minRestGueltigkeit:=LocalQry1.LiesProgrammDatenWert('Gueltigkeit_Lekl');

  // --------- Zwischentabelle tmpLieferantTeilPfk --------

  //Leere Zwischentabelle  tmpLieferantTeilPfk
//  LocalQry1.RunExecSQLQuery('delete from tmpLieferantTeilPfk;');
//
//  //Fuege Teile von Lieferanten mit gültiger Erklärung "alle Teile" ein
//  LocalQry1.LeklAlleTeileInTmpTabelle(minRestGueltigkeit);
//
//  //Fuege Teile von Lieferanten mit gültiger Erklärung "einige Teile" ein
//  LocalQry1.LeklEinigeTeileInTmpTabelle(minRestGueltigkeit);

  // ---------Markiere Teile von Lieferanten mit gültiger Lekl in LErklaerungen

  //Loesche Markierung in LErklaerungen
  LocalQry1.RunExecSQLQuery('UPDATE LErklaerungen SET LPfk_berechnet= 0');

  //Markiere Teile mit gültiger Lekl "alle Teile"
  LocalQry1.LeklMarkiereAlleTeile(minRestGueltigkeit);

  //Markiere Teile mit gültiger Lekl "einige Teile"
  LocalQry1.LeklMarkiereEinigeTeile(minRestGueltigkeit);

  // --------- Zwischentabelle tmp_anz_xxx_je_teil --------

  //Leere Zwischentabelle
//  LocalQry1.RunExecSQLQuery('delete from tmp_anz_xxx_je_teil;');

  //Anzahl der Lieferanten je Teil (mit gültiger Erklaerung) in tmp Tabelle
//  LocalQry1.UpdateTmpAnzErklaerungenJeTeil;

  //Anzahl der Lieferanten  je Teil (mit gültiger Erklaerung)
  //in Tabelle Teile auf 0 setzen
//  LocalQry1.RunExecSQLQuery('UPDATE Teile SET n_LPfk= 0');

  //Anzahl der Lieferanten mit gültiger Erklaerung je Teil
  // in Tabelle Teile setzen
//  LocalQry1.UpdateTeileZaehleGueltigeLErklaerungen;

  // ------ Flag PFK in Tabelle Teile setzen
//  LocalQry1.UpdateTeileResetPFK;
  //Erst alle true
  LocalQry1.RunExecSQLQuery('UPDATE Teile SET Pfk=-1;');
  //Wenn ein Lieferant des Teils ohne positive Lekl, dann False
  LocalQry1.UpdateTeileDeletePFK;

  //Ermittle anhand der Wareneingänge, zu löschende PFK-Flags im UNIPPS
  HoleWareneingänge;
  StatusBarLeft('Auswertung fertig');

end;

//Hole Wareneingaenge in tmp Tabelle
procedure HoleWareneingänge;
var
  gefunden:Boolean;
begin
  LocalQry1.RunExecSQLQuery('BEGIN TRANSACTION;');

  LocalQry1.RunExecSQLQuery('delete from tmp_wareneingang_mit_PFK;');

  gefunden := UnippsQry1.HoleWareneingaenge;

  while not UnippsQry1.Eof do
  begin
//    INSERT INTO tmpTeileBenennung ( TeileNr, Zeile, [Text] )
    LocalQry1.InsertFields('tmp_wareneingang_mit_PFK', UnippsQry1.Fields);
    UnippsQry1.next;
  end;


  LocalQry1.RunExecSQLQuery('delete from Export_PFK;');
  LocalQry1.UpdatePFKTabellePFK0;
  LocalQry1.UpdatePFKTabellePFK1;

  LocalQry1.RunExecSQLQuery('COMMIT;');

end;
///<summary>Hole Adressdaten und Ansprechpartner
/// aus UNIPPS in eigene Tabellen</summary>
procedure LieferantenAdressdatenAusUnipps();
var
  gefunden:Boolean;

begin
  Init;
  if not Initialized then
    exit;

  //------------  Erst Firmen-Daten lesen
  gefunden := UnippsQry1.HoleLieferantenAdressen;

  if not gefunden then
    raise Exception.Create('Keine Lieferanten-Adressen gefunden.');

  LocalQry1.RunExecSQLQuery('delete from Lieferanten_Adressen;');
  LocalQry1.RunExecSQLQuery('BEGIN TRANSACTION;');

  while not UnippsQry1.Eof do
  begin
    LocalQry1.InsertFields('Lieferanten_Adressen', UnippsQry1.Fields);
    UnippsQry1.next;
  end;
  LocalQry1.RunExecSQLQuery('COMMIT;');

  //------------  Dann Ansprechpartner für LEKL falls vorhanden lesen
  gefunden := UnippsQry1.HoleLieferantenAnspechpartner;

  LocalQry1.RunExecSQLQuery('delete from Lieferanten_Ansprechpartner;');
  LocalQry1.RunExecSQLQuery('BEGIN TRANSACTION;');
  var text:string;
  while not UnippsQry1.Eof do
  begin
//    text:=UnippsQry1.GetFieldNamesAsText;
//    text:=UnippsQry1.GetFieldValuesAsText;
    LocalQry1.InsertFields('Lieferanten_Ansprechpartner', UnippsQry1.Fields);
    UnippsQry1.next;
  end;
  LocalQry1.RunExecSQLQuery('COMMIT;');

  //------------  Zuletzt Ansprechpartner übertragen
  LocalQry1.UpdateLieferantenAnsprechpartner;

end;

// ----------------------------------------------------------------------
// --------------------- Helper
// ----------------------------------------------------------------------

function GetUNIPPSQry():TWQryUNIPPS;
var
  dbUnippsConn: TWADOConnector;
  myQry:TWQryUNIPPS;
begin
  myQry:=nil;
  //mit UNIPPS verbinden
  try
    dbUnippsConn:=TWADOConnector.Create(nil);
    dbUnippsConn.ConnectToUNIPPS();

    //Query fuer UNIPPS anlegen und Verbindung setzen
    //Qry anlegen und mit Connector versorgen
    myQry:= TWQryUNIPPS.Create(nil);
    myQry.Connector:=dbUnippsConn;
  except
    on E: Exception do
         ShowMessage(E.Message);
  end;
  Result:=myQry;
end;

procedure Init;

begin
  //Wir wollen das hier nur 1 mal ausführen
  if Initialized then
    exit;

  // Qry fuer lokale DB anlegen
  LocalQry1 := Tools.GetQuery;

  //Unipps-Query
  UnippsQry1:=GetUNIPPSQry;
  if UnippsQry1=nil then
    exit;

  Initialized:=True;

end;

initialization
  Init;

end.
