///<summary>Komplettanalyse eines Kundenauftrages mit Berechnung der Präferenzberechtigung.</summary>
///<remarks>
///Die Unit enthält die übergeordneten Funktionen zur Analyse eines
/// Kundenauftrages inkl. der Ermittlung der Präferenzberechtigung.
/// Hierzu dient die Prozedur Auswerten.KaAuswerten .
///</remarks>
unit Auswerten ;

interface

uses  System.SysUtils, System.Dateutils, Vcl.Controls, Vcl.Dialogs, Windows,
      classes, Tools, Settings,
      Kundenauftrag,KundenauftragsPos, ADOQuery , ADOConnector,
      BaumQrySQLite, BaumQryUNIPPS, DatenModul, Preiseingabe;

type
/// <summary> Ausnahmen während der Ausführung des Threads</summary>
    EAuswerten = class(Exception);

type

    ///<summary> Zuordnung von Positionen des Kundenauftrags zu anderen Positionen</summary>
    TWZuordnung=record
      ///<summary>Id der neuen übergeordneten Position.</summary>
      VaterPos:Integer;
      ///<summary>Id der Position, die umgehängt wird.</summary>
      KindPos:Integer;
    end;
    TWZuordnungen=array of TWZuordnung;

type
/// <summary>Ausführung der UNIPPS-Analyse im thread</summary>
    TWPraeFixThread=class(TThread)
      public
          ///<summary>Speichert Meldungen zu Fehlern, die während der Thread-Ausführung entstehen.</summary>
          ErrMsg:String;
          ///<summary>True, wenn Thread-Ausführung fehlerfrei.</summary>
          Success:Boolean;
          procedure Execute; override;
    end;

procedure RunItGui;
procedure KaAuswerten(KaId:string);
function Preisabfrage(KA:TWKundenauftrag;var Zuordnungen:TWZuordnungen): Boolean;
procedure ZuordnungAendern(KA:TWKundenauftrag;Zuordnungen:TWZuordnungen);
function PraeferenzKalkBeginn(KaId:String):Boolean;
procedure PraeferenzKalkAbschluss;

var
   //Zuordnungen von KA-Pos (z.B Motoren) zu übergeordneten KA-Pos
   Zuordnungen:TWZuordnungen;
   PraeFixKalkThread:TWPraeFixThread;
   startzeit: TDateTime;

implementation

uses Hauptfenster,DruckBlatt;

///<summary>Sucht alle Kinder-Positionen zu einem Kundenauftrag.</summary>
procedure TWPraeFixThread.Execute;
begin
  Success:=True;
  try
    Hauptfenster.Kundenauftrag.holeKinder;
  except
    on E: Exception do
    begin
       ErrMsg:=E.Message;
       Success:=False;
    end;
  end;
end;


///<summary>Startet eine Komplettanalyse eines Kundeaufrages.</summary>
/// <remarks>
/// Nach der Ermittlung der Positionen des Kundenauftrages
/// werden die Verkaufspreise vom Anwender erfragt.
/// Anschließend wird in separatem Thread die kompl. Auftragstruktur ermittelt.
/// </remarks>
/// <param name="KaId">Id des Kundenauftrages</param>
procedure KaAuswerten(KaId:string);
begin
  //Erster Teil der Auswertung inkl Preisabfrage
  if not PraeferenzKalkBeginn(KaId) then
    exit;

  startzeit:= System.SysUtils.Now;
  mainfrm.ActivityIndicator1.Animate:=True;
  Tools.Log.Trennzeile('-',80);
  Tools.Log.Log('Hole Kinder zu KA-Pos');
  Tools.Log.Trennzeile('-',80);

  //Rest der Auswertung in Thread
  PraeFixKalkThread:=TWPraeFixThread.Create(True);
  PraeFixKalkThread.OnTerminate:= mainfrm.FinishPraefKalk;
  PraeFixKalkThread.Priority:=tpHigher;
//  PraeFixKalkThread.FreeOnTerminate := True;
  PraeFixKalkThread.Resume;
end;

///<summary>
/// Vorbereitung der Präferenzkalkulation mit Abfrage der Preise der Kundenauftragspositionen
///</summary>
///<remarks>
/// Bereitet Ergebniss und Ausgabe-Dataset vor, legt TWKundenauftrag an,
/// liest den Kopf und die Positionen des Kundenauftrags ein
/// und erfragt die Preise zu den Positionen
///</remarks>
/// <param name="KaId">Id des Kundenauftrages</param>
/// <returns>True, wenn die Auswertung erfolgreich war und alle Preise eingegeben wurden.</returns>
function PraeferenzKalkBeginn(KaId:String):Boolean;
var
  KA:TWKundenauftrag;
  msg:String;

begin
  Tools.Init;
  Settings.GuiMode:=True;

  //Logger oeffnen
  Tools.Log.OpenNew(Settings.ApplicationBaseDir,'data\output\Log.txt');
  Tools.ErrLog.OpenNew(Settings.ApplicationBaseDir,'data\output\ErrLog.txt');

  mainfrm.langBtn.Enabled:=False;
  mainfrm.kurzBtn.Enabled:=False;
  mainfrm.Drucken.Enabled:=False;

  //Einmalig die Felder der Gesamt-Tabelle anlegen
  //Könnte irgendwo passieren, aber erst nachdem  !!!! Datenmodul völlig "created"
  //DAS OnCreate Ereignis ist anscheinend zu früh
  KaDataModule.DefiniereGesamtErgebnisDataSet;

  KaDataModule.AusgabeDS.EmptyDataSet;

  //Kundenauftrag anlegen
  KA:=TWKundenauftrag.Create(KaId);
  Hauptfenster.Kundenauftrag:=KA;

  msg:='Starte Auswertung fuer: ' + KaId + ' um ' + DateTimeToStr(startzeit);
  Tools.Log.Log(msg);
  Tools.ErrLog.Log(msg);

  //Lies Kundenauftrag mit seinen Positionen
  try
    KA.liesKopfundPositionen;
  except
    on E: Exception do
    begin
      Tools.Log.close;
      Tools.ErrLog.close;
      ShowMessage(E.Message+#10+'Programmabbruch.');
      exit(False);
    end;
  end;

  //Hole VK zu Neupumpen
  if not (Preisabfrage(KA,Zuordnungen)) then
  begin
    Tools.Log.close;
    Tools.ErrLog.close;
    exit(False);
  end;

  Result:=True;
end;

///<summary>
/// Abschliesssen der Berechnung einer Präferenzberechtigung
///</summary>
///<remarks>
/// Diese Funktion wird von mainfrm.FinishPraefKalk gerufen,
/// welche wiederum vom OnTerminate-Ereignis des Threads getriggert wird.
/// Falls der Thread nicht fehlerfrei ablief, bricht die Funktion ab.
/// |
/// Sonst werden zuerst entsprechend der Benutzerangaben bei der Preisabfrage
/// Positionen des Kundenauftrags (z.B. Motoren) umgehängt.
/// Dann werden für den Gesamtbaum die Mengen der Positionen aufmultipliziert
/// und die Ebene der Pos. im Baum bestimmt.
/// |
/// Es werden die Preise aufsummiert und dann die PräferenzBerechtigung berechnet.
/// Daten für die Ausgabe im Vollumfang werden gesammelt und als CSV ausgegeben.
/// Für die komprimierte Ausgabe werden dann die Einträge der Fertigungsauftragsköpfe
/// (nicht die Positionen) aus der Struktur entfernt.
/// Die Ebene werden neu numeriert, Daten zur Ausgabe erneut gesammelt.
/// Die Daten werden als CSV ausgegeben und im Hauptfenster angezeigt.
///</remarks>
procedure PraeferenzKalkAbschluss;
var
  KA:TWKundenauftrag;
  endzeit: TDateTime;
  delta:Double;
  msg:String;
  Success:Boolean;

begin

  KA:=Hauptfenster.Kundenauftrag;

  try

    try

      msg:=PraeFixKalkThread.ErrMsg ;
      Success:=PraeFixKalkThread.Success;
      if not Success then
        raise EAuswerten.Create(msg);

      //Evtl Motoren o.ä. umhängen
      ZuordnungAendern(KA,Zuordnungen);

      KA.SetzeEbenenUndMengen(0,1);
      KA.SummierePreise;
      KA.ErmittlePraferenzBerechtigung;

      //--------- Ausgabe voller Umfang zum Debuggen
      KA.SammleAusgabeDaten;
      //Fülle Ausgabe-Tabelle mit vollem Umfang (z Debuggen)
      KaDataModule.ErzeugeAusgabeVollFuerDebug;
      //Ausgabe als CSV
      KaDataModule.AusgabeAlsCSV(Settings.LogDir, KA.KaId + '_Struktur.csv');

      //--------- Ausgabe kurzer Umfang für Doku
      //Entferne FA aus Struktur
      KA.EntferneFertigungsauftraege;
      //Ebenen neu numerieren
      KA.SetzeEbenenUndMengen(0,1);
      //Daten neu sammeln
      KA.SammleAusgabeDaten;
      //Fülle AusgabeDS mit Teilumfang zur Ausgabe der Doku der Kalkulation
      KaDataModule.ErzeugeAusgabeKurzFuerDoku;
      //Ausgabe als CSV !!Ueberschreibt z.T. Felddefinitionen
      KaDataModule.AusgabeAlsCSV(Settings.LogDir, KA.KaId + '_Kalk.csv');

      //KaDataModule.ErgebnisDS.SaveToFile(Settings.LogDir+'\Ergebnis.xml');
      mainfrm.ActivityIndicator1.Animate:=False;

      endzeit:=  System.SysUtils.Now;
      delta:=SecondSpan(startzeit,endzeit);

      msg:=Format('Auswertung fuer KA %s in %4.3f mSek beendet.' +
          #10 + '%d Datensaetze gefunden.',
          [KA.KaId, delta,KaDataModule.ErgebnisDS.RecordCount]);
      ShowMessage(msg);
      mainfrm.Drucken.Enabled:=True;

      //Daten anzeigen
      if Settings.GuiMode then
      begin
        //Belege DataSource1 mit dem Default AusgabeDS
        KaDataModule.AusgabeDS.First;
        mainfrm.DataSource1.DataSet:=KaDataModule.AusgabeDS;
      end;

    except
      on E: Exception do
      begin
        ShowMessage(E.Message+#10+'Programmabbruch.');
      end;

    end;

  finally
    mainfrm.langBtn.Enabled:=True;
    mainfrm.kurzBtn.Enabled:=True;
    mainfrm.ActivityIndicator1.Animate:=False;
    Tools.Log.Close;
    Tools.ErrLog.Close;
  end;


end;

///<summary>
/// Abfrage der Preise und Zuordnungen mittels Formular
///</summary>
/// <remarks>
/// Die bisher ermittelten Daten werden gesammelt, in das Datenset PreisDS
/// übertragen und damit im Formular angezeigt.
/// Der Anwender ergänzt ALLE Preise und gibt evtl an,
/// das Positionen des Kundenauftrags (z.B. Motoren) anderen Positionen untergeordnet werden sollen.
/// </remarks>
/// <param name="KA">Kundenauftrag</param>
/// <param name="Zuordnungen">array mit Zuordnungen</param>
/// <returns>True, wenn alle Preise eingegeben wurden.</returns>
function Preisabfrage(KA:TWKundenauftrag;var Zuordnungen:TWZuordnungen): Boolean;
var
  VkRabattiert: Double;
  I,IdPos,ZuPos:Integer;
  KaPos:TWKundenauftragsPos;
  Zuordnung:TWZuordnung;

begin

    //Daten einsammeln; bis hier nur Kundenauftrag mit Positionen
    KA.SammleAusgabeDaten;

    //User fragen
    //Dataset fuellen und als DataSource setzen
    KaDataModule.ErzeugeAusgabeFuerPreisabfrage(PreisFrm.PreisDS);
    PreisFrm.DataSource1.DataSet:=PreisFrm.PreisDS;

    //User-Abfrage
    if not (PreisFrm.ShowModal=mrOK) then
    begin
      ShowMessage('Keine VK-netto-Preise eingegeben.' +
        #10 + 'Programmabbruch.');
      exit(False);
    end;

    //Preise ins Objekt schreiben und Zuordnungsliste erstellen
    PreisFrm.PreisDS.First;
    while not PreisFrm.PreisDS.Eof do
    begin
      VkRabattiert:=PreisFrm.PreisDS.FieldByName('vk_netto').AsFloat;
      IdPos:=PreisFrm.PreisDS.FieldByName('id_pos').AsInteger;
      //Hole KAPos aus Stueli des KA
      KaPos:=TWKundenauftragsPos(KA.Stueli[IdPos]);
      //VK eintragen
      if VkRabattiert<>0 then
        KaPos.VerkaufsPreisRabattiert:=VkRabattiert
      else
      begin
      { TODO : !!! Unbedingt nach Entwicklung raus nehmen }
        {$IFDEF DEBUG}
        KaPos.VerkaufsPreisRabattiert:= 1;
        {$ELSE}
        ShowMessage('Nicht für alle Positionen VK-netto-Preise eingegeben.' +
        #10 + 'Programmabbruch.');
        exit(False);
        {$ENDIF}
      end;

      ZuPos:=PreisFrm.PreisDS.FieldByName('ZuKAPos').AsInteger;
      if ZuPos<>0 then
      begin
        I:=length(Zuordnungen);
        setlength(Zuordnungen,I+1);
        Zuordnung.VaterPos:=ZuPos;
        Zuordnung.KindPos:=IdPos;
        Zuordnungen[I]:=Zuordnung;
      end;

      PreisFrm.PreisDS.next;
    end;

    Result:=True;

end;

///<summary>Umhängen von Positionen des Kundenauftrages</summary>
/// <remarks>
/// Auf Basis der Eingaben im Formular Preiseingabe, werden Positionen des
/// Kundenauftrags (z.B. Motoren) anderen Positionen untergeordnet.
/// </remarks>
/// <param name="KA">Kundenauftrag</param>
/// <param name="Zuordnungen">array mit Vater-Sohn-Zuordnungen</param>
procedure ZuordnungAendern(KA:TWKundenauftrag;Zuordnungen:TWZuordnungen);
var
  I:Integer;
  KindKaPos,VaterKaPos:TWKundenauftragsPos;
  Zuordnung:TWZuordnung;

begin

    //Positionen die zu anderen Positionen zaehlen sollen (z.B. Motoren) umhaengen
    for I := 0 to length(Zuordnungen)-1 do
    begin
      Zuordnung:=Zuordnungen[I];
        //Hole Vater-KAPos aus Stueli des KA
        VaterKaPos:=TWKundenauftragsPos(KA.Stueli[Zuordnung.VaterPos]);
        //Hole Unter-KAPos aus Stueli des KA
        KindKaPos:=TWKundenauftragsPos(KA.Stueli[Zuordnung.KindPos]);
        VaterKaPos.StueliTakePosFrom(KindKaPos);
    end;

end;

///<summary>Testlauf: Automatischer Start beim Laden des Hauptformulars.
///</summary>
procedure RunItGui;
begin

//test;
//  Auswerten.KaAuswerten('142302'); //Ersatz
//  Result:= Auswerten.KaAuswerten('144729');
//  Result:= Auswerten.KaAuswerten('144927');
   Auswerten.KaAuswerten('142567'); //2Pumpen
//    Auswerten.KaAuswerten('143740'); //Rep

//  Auswerten.KaAuswerten('144734'); //Error
//  Auswerten.KaAuswerten('142591'); //Error

end;


end.
