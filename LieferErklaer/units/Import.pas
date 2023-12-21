
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
          DatensatzZaehlerText:String;
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
        //Setze Text für Datensatzzähler
        procedure SetzeDatensatzZaehlerText(text:String);
        procedure SyncSetRecordLabelCaption;


        procedure BestellungenAusUnipps;
        procedure LieferantenTeilenummerAusUnipps;
        procedure TeileBenennungAusUnipps;
        procedure TeileBenennungInTeileTabelle;
        procedure ErsatzteileAusUnipps();
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


//Setzt Text für Datensatzzähler
procedure TBasisImport.SetzeDatensatzZaehlerText(text:String);
begin
  DatensatzZaehlerText:=text;
  Synchronize(SyncSetRecordLabelCaption);
end;

procedure TBasisImport.SyncSetRecordLabelCaption;
begin
  ImportStatusDlg.SetRecordLabelCaption(DatensatzZaehlerText);
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

  // Prüfe ob Teil als Ersatzteil verwendet wird
  // Setzt Flag Ersatzteil in Tabelle Teile
  ErsatzteileAusUnipps;

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

/// <summary>Lieferanten-Teilenummer aus UNIPPS in temp Tabelle
///          tmp_LTeilenummern lesen </summary>
/// <remarks>
/// Zweite Abfrage zur Erstellung der Datenbasis des Programms.
///
/// Die Delphi-ODBC-Schnittstelle hat offensichtlich Probleme mit einigen Sonderzeichen
/// (zumindest mit dem €-Zeichen).
/// Die Daten werden zwar gelesen, aber schon die Abfrage von RecordCount
/// schlägt fehl.
/// Eine Schleife über ein solches Abfrageergebnis wirft beim Positionieren
/// auf einen solchen Datensatz eine Exception, die abgefangen werden muss.
/// Anschließend wird eine neue Abfrage gestartet,
/// wobei mittels "SELECT SKIP xxx"
/// erst hinter dem fehlerhaften Datensatz begonnen wird.
/// </remarks>
procedure TBasisImport.LieferantenTeilenummerAusUnipps;
var
  gefunden:Boolean;
  sql,ErrMsg:String;
  nTeile,skip:Integer;
//  tmpTable: TWTable;

begin
  SchrittAnfangAnzeigen(2,'Lieferanten-Benennung zu Teilen lesen');

  // Zuerst die Anzahl der Datensätze bestimmen
  // SELECT count(*) funktioniert offensichtlich ohne Probleme
  // Die fehlerhaften Datensätze werden mit gezählt
  gefunden := UnippsQry2.ZaehleAlleLieferantenTeilenummern();

  if not gefunden then
      raise Exception.Create('Keine Lieferanten-Teilenummern gefunden.');
  nTeile:=UnippsQry2.FieldByName('anzahl').AsInteger;

  //temp Tabelle leeren
  LocalQry2.RunExecSQLQuery('delete from tmp_LTeilenummern;');

  StatusmaxRecord:=nTeile;

  skip:=0;

  // In evtl mehreren Schritten so lange einlesen, bis letzter Datensatz erreicht.
  while skip<nTeile do
    begin
      //Diese Abfrage wirft eine Exception beim Lesen von RecordCount,
      //liefert aber trotzdem Daten
      try
        UnippsQry2.SucheAlleLieferantenTeilenummern(skip);
      except on E: Exception do
        //Wir ignorieren die Exception
        ErrMsg:=  E.Message; //nur zum Debuggen
      end;

      //Falls schon der erste Datensatz fehlerhaft ist, ist EOF TRUE
      if UnippsQry2.Eof then

        // Die Abfrage ist schon beim ersten Datensatz fehlerhaft
        // => einen Datensatz überspringen
        skip:=skip+1

      else

        // Es gibt mindestens einen i.O. Datensatz
        begin

          LocalQry2.RunExecSQLQuery('BEGIN TRANSACTION;');

          //Schleife über alle Records bricht ab,
          // wenn auf einen fehlerhaften Datensatz positioniert wird.
          while not UnippsQry2.Eof do
          begin

            RecNoStatusAnzeigen(UnippsQry2.RecNo+skip);
            //Übertrage Daten in tmp_LTeilenummern
            LocalQry2.InsertFields('tmp_LTeilenummern', UnippsQry2.Fields);

            try
              UnippsQry2.next;
            except on E: Exception do
              begin
                //Next ist fehlgeschlagen, weil der Datensatz n.i.o. ist
                //Enthält z.B "€"-Zeichen
                ErrMsg:=  E.Message;
                //Positioniere auf nächsten Datensatz
                //(wird unten noch mal um UnippsQry2.RecNo erhöht)
                skip := skip + 1;
                break;
              end;
            end;

          end;

          //Letzte Query nach Access übertragen
          LocalQry2.RunExecSQLQuery('COMMIT;');

          //In der letzten Schleife wurden UnippsQry2.RecNo Datensätze verarbeitet
          //Wir machen weiter mit skip+UnippsQry2.RecNo
          skip:=skip+UnippsQry2.RecNo ;

        end;


  end;

  RecNoStatusAnzeigen(StatusmaxRecord,True);
  SchrittEndeAnzeigen;

  //Übertrage Daten in Tabelle Bestellungen
  LocalQry2.LieferantenTeileNrInTabelle;

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
  SetzeDatensatzZaehlerText('warte auf UNIPPS');

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

//Import Schritt 5: Test ob Teil Ersatzteil
///<summary>Markiere Ersatzteile in Tabelle Teile</summary>
procedure TBasisImport.ErsatzteileAusUnipps();
  var
    TeileNr:String;
    gefunden:Boolean;
    BestellZeitraum:String;

begin

  SchrittAnfangAnzeigen(5, 'Teste ob Teil Ersatzteil');
  SetzeDatensatzZaehlerText('warte auf UNIPPS');

  //Lies den Bestellzeitraum
  BestellZeitraum:=LocalQry2.LiesProgrammDatenWert('Bestellzeitraum');

  //Zeitraum erhoehen um sicher alle Daten zu bekommen
  BestellZeitraum:=IntToStr(StrToInt(BestellZeitraum)+5);

  gefunden := UnippsQry2.TesteAufErsatzteil(BestellZeitraum);

  LocalQry2.RunExecSQLQuery('delete * from tmpTeileVerwendung') ;

  StatusmaxRecord:=UnippsQry2.RecordCount;
  while not UnippsQry2.Eof do
  begin
    RecNoStatusAnzeigen(UnippsQry2.RecNo);
    LocalQry2.InsertFields('tmpTeileVerwendung', UnippsQry2.Fields);
    UnippsQry2.next;
  end;

  RecNoStatusAnzeigen(StatusmaxRecord,True);

  //Übertrage das Ergebnis aus tmpTeileVerwendung nach Teile
  LocalQry2.UpdateTeilErsatzteile;

  SchrittEndeAnzeigen;

 end;

 //Import Schritt 6: Test ob Teil Pumpenteil
///<summary>Markiere Pumpenteile in Tabelle Teile</summary>
procedure TBasisImport.PumpenteileAusUnipps();
  var
    TeileNr:String;
    gefunden:Boolean;
    BestellZeitraum:String;

begin

  SchrittAnfangAnzeigen(6, 'Teste ob Teil Pumpenteil');
  SetzeDatensatzZaehlerText('warte auf UNIPPS');

  //Lies den Bestellzeitraum
  BestellZeitraum:=LocalQry2.LiesProgrammDatenWert('Bestellzeitraum');

  //Zeitraum erhoehen um sicher alle Daten zu bekommen
  BestellZeitraum:=IntToStr(StrToInt(BestellZeitraum)+5);

  gefunden := UnippsQry2.TesteAufPumpenteil(BestellZeitraum);

  LocalQry2.RunExecSQLQuery('delete * from tmpTeileVerwendung') ;

  StatusmaxRecord:=UnippsQry2.RecordCount;
  while not UnippsQry2.Eof do
  begin
    RecNoStatusAnzeigen(UnippsQry2.RecNo);
    LocalQry2.InsertFields('tmpTeileVerwendung', UnippsQry2.Fields);
    UnippsQry2.next;
  end;

  RecNoStatusAnzeigen(StatusmaxRecord,True);

  //Übertrage das Ergebnis aus tmpTeileVerwendung nach Teile
  LocalQry2.UpdateTeilPumpenteile;

  SchrittEndeAnzeigen;

 end;



//Import Schritt 7: Lieferanten-Tabelle
///<summary>Pflege Tabelle Lieferanten</summary>
procedure TBasisImport.LieferantenTabelleUpdaten();
begin
  SchrittAnfangAnzeigen(7,'Lieferanten-Tabelle erzeugen');
  SetzeDatensatzZaehlerText('warte auf UNIPPS');
  //Markiere alle Lieferanten als aktuell
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

// Import Schritt 8: Lief-Erklaerungen
///<summary>Pflege Tabelle LErklaerungen</summary>
procedure TBasisImport.LErklaerungenUpdaten();
begin
  SchrittAnfangAnzeigen(8,'Lief.-Erkl. ergaenzen');
  LocalQry2.NeueLErklaerungenInTabelle;
  LocalQry2.AlteLErklaerungenLoeschen;
  SchrittEndeAnzeigen;
end;

// Import Schritt 9
///<summary>Anzahl der Lieferanten je Teil in Tabelle Teile</summary>
procedure TBasisImport.TeileUpdateZaehleLieferanten();
begin
  SchrittAnfangAnzeigen(9,'Lieferanten je Teil zählen');
  // tmp Tabelle leeren
  LocalQry2.RunExecSQLQuery('delete from tmp_anz_xxx_je_teil;');
  //Anzahl der Lieferanten je Teil in tmp Tabelle tmp_anz_xxx_je_teil
  LocalQry2.UpdateTmpAnzLieferantenJeTeil;
  //Anzahl der Lieferanten je Teil in Tabelle Teile
  LocalQry2.UpdateTeileZaehleLieferanten;
  SchrittEndeAnzeigen;
end;

// ----------------------------------------------------------------------
// ------------- Finale Auswertung ausserhalb des Threads ---------------
// ----------------------------------------------------------------------

/// <summary> Finale Auswertung und Erzeugen der UNIPPS-Export-Tabelle</summary>
/// <remarks> Ablauf
/// 1. Tabelle LErklaerungen
/// 1.1 Das Flag LPfk_berechnet wird generell False gesetzt
/// 1.2 es wird True bei Lieferanten mit einer gültigen Lekl und
/// 1.2.1 Status "alle Teile" fuer alle Teile dieses Lieferanten
/// 1.2.2 Status "einige Teile" fuer alle Teile dieses Lieferanten, deren
///        Flag LPfk zuvor vom Benutzer für die aktuelle Periode gesetzt wurde
/// 2. Tabelle Teile
/// 2.1 Setze das Flag Pfk generell True
/// 2.2 Loesche Flag bei Teilen mit mind. 1 Lieferanten in LErklaerungen mit
///     LPfk_berechnet = False. Es bleiben nur Teile, bei denen alle Liefer.
///     eine positive Lekl für dieses Teil abgaben.
/// 3. Tabelle Export_PFK
///    Diese Tabelle erhält alle Teile, deren Präferenzkennzeichen in UNIPPS
///    geändert werden muss
/// 3.1 zu löschende Kennungen
/// 3.1.1 Lese Wareneingänge seit Beginn des akt. Jahres aus UNIPPS und
///       speichere Teile / Lieferanten in der Tabelle tmp_wareneingang_mit_PFK,
///       wenn sie in UNIPPS ein Präferenzkennzeichen haben.
/// 3.1.2 Übertrage die Teile/Lieferanten-Kombi aus tmp_wareneingang_mit_PFK,
///       die in LErklaerungen LPfk_berechnet = False haben, nach Export_PFK.
///       Setze das Flag Pfk dieser Teile auf False.
///       Die Präferenzkennzeichen dieser Teile sind in UNIPPS zu löschen,
///       da sie neu geliefert wurden, für das neue Jahr und den konkreten
///       Lieferanten, aber in Digilek noch keine gültige Lekl erfasst wurde.
/// 3.2 zu setzende Kennungen
///     Übertrage alle Teile aus Tabelle Teile mit Flag Pfk=True nach
///     Export_PFK und setze dort deren Flag Pfk=True.
///     Die Präferenzkennzeichen dieser Teile sind in UNIPPS zu setzen,
///     da für das aktuelle Jahr alle Lieferanten eine positive Lekl abgaben.

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

  // ---------Markiere Teile von Lieferanten mit gültiger Lekl in LErklaerungen

  //Loesche Markierung in LErklaerungen
  LocalQry1.RunExecSQLQuery('UPDATE LErklaerungen SET LPfk_berechnet= 0');

  //Markiere Teile mit gültiger Lekl "alle Teile"
  LocalQry1.LeklMarkiereAlleTeile(minRestGueltigkeit);

  //Markiere Teile mit gültiger Lekl "einige Teile"
  //Es werden nur Teile berücksichtigt,
  // deren Status "aktuell" (nicht im Vorjahr) erfasst wurde
  LocalQry1.LeklMarkiereEinigeTeile(minRestGueltigkeit);

  // ------ Flag PFK in Tabelle Teile setzen
  //Erst alle true
  LocalQry1.RunExecSQLQuery('UPDATE Teile SET Pfk=-1;');
  //Wenn ein Lieferant des Teils ohne positive Lekl, dann False
  LocalQry1.UpdateTeileDeletePFK;

  // ------ in UNIPPS zu aendernden Teile in Tabelle Export_PFK

  //Ermittle Wareneingänge seit Jahresbeginn
  HoleWareneingänge;

  LocalQry1.RunExecSQLQuery('BEGIN TRANSACTION;');
  // Leere Tabelle
  LocalQry1.RunExecSQLQuery('DELETE from Export_PFK;');
  //zu löschende PFK-Flags im UNIPPS in Tabelle
  LocalQry1.UpdatePFKTabellePFK0;
  //zu setzende PFK-Flags im UNIPPS in Tabelle
  LocalQry1.UpdatePFKTabellePFK1;

  LocalQry1.RunExecSQLQuery('COMMIT;');

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
    LocalQry1.InsertFields('tmp_wareneingang_mit_PFK', UnippsQry1.Fields);
    UnippsQry1.next;
  end;

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
