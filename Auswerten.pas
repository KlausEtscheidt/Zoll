unit Auswerten;

interface

uses  System.SysUtils, System.Dateutils, Vcl.Controls, Vcl.Dialogs, Windows,
      classes, Tools, Settings, Tests,
      Kundenauftrag,KundenauftragsPos, ADOQuery , ADOConnector,
      BaumQrySQLite, BaumQryUNIPPS, DatenModul, Preiseingabe;

type
    EStuBaumMainExc = class(Exception);

type
    TWZuordnung=record
      VaterPos:Integer;
      KindPos:Integer;
    end;
    TWZuordnungen=array of TWZuordnung;

type
    TWPraeFixThread=class(TThread)
      public
          procedure Execute; override;
          procedure OnTerminate(Sender: TWPraeFixThread);
    end;

procedure RunItGui;
procedure KaAuswerten(KaId:string);
function Preisabfrage(KA:TWKundenauftrag;var Zuordnungen:TWZuordnungen): Boolean;
procedure ZuordnungAendern(KA:TWKundenauftrag;Zuordnungen:TWZuordnungen);
procedure PräferenzKalkulationStep1(KaId:String);
procedure PräferenzKalkulationFinish;

//Zuordnungen von KA-Pos (z.B Motoren) zu übergeordneten KA-Pos
var
   Zuordnungen:TWZuordnungen;
   PraeFixKalkThread:TWPraeFixThread;

implementation

uses Hauptfenster,DruckBlatt;

procedure TWPraeFixThread.Execute;
begin
  Hauptfenster.Kundenauftrag.holeKinder;
  Synchronize(Auswerten.PräferenzKalkulationFinish);
end;


procedure TWPraeFixThread.OnTerminate(Sender: TWPraeFixThread);
begin
  ShowMessage('Fertig');
end;


procedure PräferenzKalkulationStep1(KaId:String);
var
  KA:TWKundenauftrag;
  msg:String;
  startzeit: TDateTime;

begin
  Tools.Init;
  Settings.GuiMode:=True;

  //Logger oeffnen
  Tools.Log.OpenNew(Settings.ApplicationBaseDir,'data\output\Log.txt');
  Tools.ErrLog.OpenNew(Settings.ApplicationBaseDir,'data\output\ErrLog.txt');

  mainfrm.langBtn.Enabled:=False;
  mainfrm.kurzBtn.Enabled:=False;
  mainfrm.Drucken.Enabled:=False;
  startzeit:= System.SysUtils.Now;

  //Einmalig die Felder der Gesamt-Tabelle anlegen
  //Könnte irgendwo passieren, aber erst nachdem  !!!! Datenmodul völlig "created"
  //DAS OnCreate Ereignis ist anscheinend zu früh
  KaDataModule.DefiniereGesamtErgebnisDataSet;

  //Kundenauftrag anlegen
  KA:=TWKundenauftrag.Create(KaId);
  Hauptfenster.Kundenauftrag:=KA;

  msg:='Starte Auswertung fuer: ' + KaId + ' um ' + DateTimeToStr(startzeit);
  Tools.Log.Log(msg);
  Tools.ErrLog.Log(msg);
  mainfrm.ActivityIndicator1.Animate:=True;

  //Lies Kundenauftrag mit seinen Positionen
  KA.liesKopfundPositionen;

  //Hole VK zu Neupumpen
    if not (Preisabfrage(KA,Zuordnungen)) then
      exit;


end;


procedure PräferenzKalkulationFinish;
var
  KA:TWKundenauftrag;
  startzeit,endzeit: TDateTime;
  delta:Double;
  msg:String;
begin

  KA:=Hauptfenster.Kundenauftrag;
  startzeit:= System.SysUtils.Now;

  try

    Tools.Log.Trennzeile('-',80);
    Tools.Log.Log('Hole Kinder zu KA-Pos');
    Tools.Log.Trennzeile('-',80);

//    KaDataModule.ErgebnisDS.EmptyDataSet;
//    KaDataModule.ErgebnisDS.SaveToFile();

    //Evtl Motoren o.ä. umhängen
    ZuordnungAendern(KA,Zuordnungen);

    KA.SetzeEbenenUndMengen(0,1);
    KA.SummierePreise;
    KA.ErmittlePräferenzBerechtigung;

    //--------- Ausgabe voller Umfang zum Debuggen
    KA.SammleAusgabeDaten;
    //Fülle Ausgabe-Tabelle mit vollem Umfang (z Debuggen)
    KaDataModule.ErzeugeAusgabeVollFuerDebug;
    //Ausgabe als CSV
    KaDataModule.AusgabeAlsCSV(Settings.LogDir, KA.KaId + '_Struktur.csv');

    //--------- Ausgabe kurzer Umfang für Doku
    //Entferne FA aus Struktur
    KA.EntferneFertigungsaufträge;
    //Ebenen neu numerieren
    KA.SetzeEbenenUndMengen(0,1);
    //Daten neu sammeln
    KA.SammleAusgabeDaten;
    //Fülle AusgabeDS mit Teilumfang zur Ausgabe der Doku der Kalkulation
    KaDataModule.ErzeugeAusgabeKurzFuerDoku;
    //  KaDataModule.AusgabeDS.SaveToFile(Settings.LogDir+'\AusgabeKurz.xml');
    //Ausgabe als CSV !!Ueberschreibt z.T. Felddefinitionen
    KaDataModule.AusgabeAlsCSV(Settings.LogDir, KA.KaId + '_Kalk.csv');

    //KaDataModule.ErgebnisDS.SaveToFile(Settings.LogDir+'\Ergebnis.xml');
    mainfrm.ActivityIndicator1.Animate:=False;

    endzeit:=  System.SysUtils.Now;
    //oder MilliSecondSpan ??
    delta:=MilliSecondsBetween(startzeit,endzeit);

    msg:=Format('Auswertung fuer KA %s in %4.3f mSek beendet.' +
        #10 + '%d Datensaetze gefunden.',
        [KA.KaId, delta,KaDataModule.ErgebnisDS.RecordCount]);
    ShowMessage(msg);

  finally
    mainfrm.langBtn.Enabled:=True;
    mainfrm.kurzBtn.Enabled:=True;
    mainfrm.Drucken.Enabled:=True;
    mainfrm.ActivityIndicator1.Animate:=False;
    Tools.Log.Close;
    Tools.ErrLog.Close;
  end;

  //Daten anzeigen
  if Settings.GuiMode then
  begin
    //Belege DataSource1 mit dem Default AusgabeDS
    KaDataModule.AusgabeDS.First;
    mainfrm.DataSource1.DataSet:=KaDataModule.AusgabeDS;
  end;

end;


///<summary> Startet eine Komplettanalyse ueber TWKundenauftrag.auswerten
///<summary>
procedure KaAuswerten(KaId:string);
begin
  PräferenzKalkulationStep1(KaId);
  PraeFixKalkThread:=TWPraeFixThread.Create(True);
  PraeFixKalkThread.Start;
//  PraeFixKalkThread.WaitFor;

end;

// Abfrage der Preise fuer Neupumpen, da diese nicht im UNIPPS
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
      Result:=False;
      exit;
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
      KaPos.VerkaufsPreisRabattiert:=VkRabattiert;

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

///<summary> Einsprung fuer GUI Version fuer automatischen Testlauf
///</summary>
procedure RunItGui;
begin

//test;
//  Result:= Auswerten.KaAuswerten('142302'); //Ersatz
//  Result:= Auswerten.KaAuswerten('144729');
//  Result:= Auswerten.KaAuswerten('144927');
//  Result:= Auswerten.KaAuswerten('142567'); //2Pumpen
//  Tests.Bestellung;
    Auswerten.KaAuswerten('143740'); //Rep

//  Auswerten.KaAuswerten('144734'); //Error
//  Auswerten.KaAuswerten('142591'); //Error

end;


end.
