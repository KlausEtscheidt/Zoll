program Batchlauf;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,StrUtils,DateUtils,
  ActiveX,
  Logger in '..\lib\Tools\Logger.pas',
  ADOConnector in '..\lib\Datenbank\ADOConnector.pas',
  ADOQuery in '..\lib\Datenbank\ADOQuery.pas',
  BaumQrySQLite in '..\lib\Datenbank\BaumQrySQLite.pas',
  BaumQryUNIPPS in '..\lib\Datenbank\BaumQryUNIPPS.pas',
  PumpenDataSet in '..\lib\Datenbank\PumpenDataSet.pas',
  Bestellung in '..\lib\UNIPPS\Bestellung.pas',
  FertigungsauftragsKopf in '..\lib\UNIPPS\FertigungsauftragsKopf.pas',
  FertigungsauftragsPos in '..\lib\UNIPPS\FertigungsauftragsPos.pas',
  Kundenauftrag in '..\lib\UNIPPS\Kundenauftrag.pas',
  KundenauftragsPos in '..\lib\UNIPPS\KundenauftragsPos.pas',
  Teil in '..\lib\UNIPPS\Teil.pas',
  TeilAlsStuPos in '..\lib\UNIPPS\TeilAlsStuPos.pas',
  Stueckliste in '..\lib\Stueli\Stueckliste.pas',
  UnippsStueliPos in '..\lib\UNIPPS\UnippsStueliPos.pas',
  Settings in '..\lib\Tools\Settings.pas',
  DatenModul in '..\DatenModul.pas' {KaDataModule: TDataModule},
  Tools in '..\lib\Tools\Tools.pas';

//Nutzt aus TWKundenauftrag nur .liesKopfundPositionen und .holeKinder
//Alle Exceptions gekapselt fuer Batchlauf ohne Abbruch
procedure KaNurAuswerten(KaId:string);
var ka:TWKundenauftrag;
begin

    Tools.Log.Log('------- Kundenauftrag: '+KaId);
    Tools.ErrLog.Log('------- Kundenauftrag: '+KaId);

    //Ka anlegen
    ka:=TWKundenauftrag.Create(KaId);

    try
      //Daten lesen und nach SQLite kopieren
      ka.liesKopfundPositionen;
      ka.holeKinder;

      KA.SetzeEbenenUndMengen(0,1);
      KA.SummierePreise;

    //--------- Ausgabe voller Umfang zum Debuggen
    KA.SammleAusgabeDaten;
    //Fülle Ausgabe-Tabelle mit vollem Umfang (z Debuggen)
    KaDataModule.ErzeugeAusgabeVollFuerDebug;
    //Ausgabe als CSV
    KaDataModule.AusgabeAlsCSV(Settings.LogDir, KA.KaId + '_Struktur.csv');

    except
      on E: Exception do
      begin
        Tools.ErrLog.Log(E.Message);
        Tools.ErrLog.Flush;
        ka.Free;
      end;
    end;


end;

/// <summary> Initialisiert den Kopiermodus von UNIPPS nach SQLite
/// </summary>
///<remarks>  Öffnet SQLite-Connection und übergibt diese
/// an die UNIPPS-Query.
///</remarks>
procedure InitCopyUNI2SQLite;
var
  dbSQLiteConn: TWADOConnector;
//  QryUNIPPS: TWBaumQryUNIPPS;

begin
{$IFNDEF SQLITE}
{$IFNDEF HOME}

  //SQLite-DB oeffnen  Pfad aus globaler Tools.SQLiteFile
  dbSQLiteConn:=TWADOConnector.Create(nil);
  dbSQLiteConn.ConnectToSQLite(Settings.SQLiteDBFileName);

  //Query fuer UNIPPS anlegen und Verbindung setzen
//  QryUNIPPS:=Tools.GetQuery;

  //Fuer Export nach SQLite
  //Flag und SQLite-Verbindung einmalig in Klassenvariable
  TWBaumQryUNIPPS.Export2SQLite:=True;
  TWBaumQryUNIPPS.SQLiteConnector:=dbSQLiteConn;
{$ENDIF}
{$ENDIF}

end;

/// <summary> Analysiert im Batchmodus eine VIelzahl von Aufträgen
/// </summary>
procedure Check100(Startdatum:String);
var
  QryUNIPPS: TWBaumQryUNIPPS;
  Sql:String;
  KaId: string;
  I: Integer;
  StartRecord: Integer;
  LastRecord: Integer;

begin
{$IFNDEF SQLITE}
{$IFNDEF HOME}

  KaDataModule.DefiniereGesamtErgebnisDataSet;

  //Query fuer UNIPPS anlegen
  QryUNIPPS:=Tools.GetQuery;

  //Abfragen ueber flex. Query: 200 Kundenaufträeg
  sql := 'select first 400 ident_nr as KaId,erstanlage from auftragkopf ' +
         'where erstanlage<TO_DATE(?, "%d.%m.%Y") and status >1 order by KaId desc;';
  QryUNIPPS.RunSelectQueryWithParam(Sql,[Startdatum]);

  StartRecord :=0;
  LastRecord:=202;
  QryUNIPPS.MoveBy(StartRecord);
  for I:=StartRecord to LastRecord do
  begin
      try
        //Hole Id des Auftrags
        KaId:=QryUNIPPS.FindField('KaId').AsString;
        Startdatum:=QryUNIPPS.FindField('erstanlage').AsString;
        writeln(Format('%.3d Auftrag %s vom %s.',[I+1,KaId,Startdatum]));

        KaNurAuswerten(KaId)

      except
        on E: Exception do
        begin
          Tools.ErrLog.Log(E.Message);
          Tools.ErrLog.Flush;
        end;
      end;

      QryUNIPPS.Next;
  end;

{$ENDIF}
{$ENDIF}
end;

///<summary> Einsprung fuer Konsolen-Version </summary>
///<remarks> Was hier steht, wird automatisch ausgeführt.
///Ablaufänderungen also hier vornehmen.
///</remarks>
procedure RunItKonsole;
begin

  //Logger oeffnen
  Tools.Log.OpenNew(Settings.LogDir,'BatchLog.txt');
  Tools.ErrLog.OpenNew(Settings.LogDir,'BatchErrLog.txt');

  InitCopyUNI2SQLite;
  //Einige Einzelaufträge
//  KaNurAuswerten('142591'); //Error  Keine Positionen zum FA >616451< gefunden.
//  KaNurAuswerten('144729');
//  KaNurAuswerten('142567'); //2Pumpen
//  KaNurAuswerten('142302'); //Ersatz
//  KaNurAuswerten('144734');   //Fehler
//  KaNurAuswerten('142120');   //Fehler


  Check100('1.5.2022');

  Tools.Log.Close;
  Tools.ErrLog.Close;

end;


begin
var answer:string;
  try

    CoInitialize(nil);

    //Datenmodul initialiseren
    DatenModul.KaDataModule := TKaDataModule.Create(nil);

    //Globals setzen und initialiseren
    Tools.Init;
    Settings.GuiMode:=False;

    RunItKonsole;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  Writeln('Fertig');
  Readln(answer);

end.
