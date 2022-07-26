﻿unit mainNonGui;

interface

uses  System.SysUtils, Kundenauftrag,  Tools, ADOQuery ,  ADOConnector,
      BaumQrySQLite, BaumQryUNIPPS ;

procedure KaAuswerten(ka_id:string);
procedure KaNurAuswerten(ka_id:string);
procedure RunIt;
procedure check100;

implementation

procedure KaNurAuswerten(ka_id:string);
var ka:TWKundenauftrag;
begin

    try
      writeln(ka_id);
      Tools.Log.Log('------- Kundenauftrag: '+ka_id);
      Tools.ErrLog.Log('------- Kundenauftrag: '+ka_id);

      //Ka anlegen
      ka:=TWKundenauftrag.Create(ka_id);

      //Daten lesen und nach SQLite kopieren
      ka.liesKopfundPositionen;
      ka.holeKinder;
    except
      on E: Exception do
      begin
        Tools.ErrLog.Log(E.Message);
        Tools.ErrLog.Flush;
        ka.Free;
      end;
    end;


end;

procedure check100;
var
  dbSQLiteConn: TWADOConnector;
  QrySQLite: TWBaumQrySQLite;
  QryUNIPPS: TWBaumQryUNIPPS;
  gefunden:Boolean;
  Sql:String;
  ka_id: string;
  I: Integer;
  StartRecord: Integer;
  LastRecord: Integer;
  ka:TWKundenauftrag;

begin
  {$IFNDEF HOME}

  //Logger oeffnen
//  Tools.Log.OpenAppend(Tools.LogDir, 'FullLog.txt');
//  Tools.ErrLog.OpenAppend(Tools.logdir, 'ErrLog.txt');
  //Logger oeffnen
  Tools.Log.OpenNew(Tools.ApplicationBaseDir,'TestLog.txt');
  Tools.ErrLog.OpenNew(Tools.ApplicationBaseDir,'TestErrLog.txt');

  //SQLite-DB oeffnen  Pfad aus globaler Tools.SQLiteFile
  dbSQLiteConn:=TWADOConnector.Create(nil);
  dbSQLiteConn.ConnectToSQLite(Tools.SQLiteDBFileName);

  //Einige Einzelaufträge
  KaNurAuswerten('142591'); //Error
  KaNurAuswerten('144729');
  KaNurAuswerten('142567'); //2Pumpen
  KaNurAuswerten('142302'); //Ersatz

  //Query fuer UNIPPS anlegen und Verbindung setzen
  QryUNIPPS:=Tools.GetQuery;

  //Fuer Export nach SQLite
  //Flag und SQLite-Verbindung einmalig in Klassenvariable
  QryUNIPPS.Export2SQLite:=True;
  QryUNIPPS.SQLiteConnector:=dbSQLiteConn;

  //Abfragen ueber flex. Query: 200 Kundenaufträeg
  sql := 'select first 401 ident_nr as ka_id from auftragkopf order by ka_id desc;';
  gefunden := QryUNIPPS.RunSelectQuery(Sql);

  StartRecord :=200;
  LastRecord:=400;
  QryUNIPPS.MoveBy(StartRecord);
  for I:=StartRecord to LastRecord do
  begin
      try
        //Hole Id des Auftrags
        ka_id:=QryUNIPPS.FindField('ka_id').AsString;
        KaNurAuswerten(ka_id)

      except
        on E: Exception do
        begin
          Tools.ErrLog.Log(E.Message);
          Tools.ErrLog.Flush;
        end;
      end;

      Tools.Log.Log('--------- Kundenauftrag: '+ka_id + ' fertig.');
      Tools.ErrLog.Log('--------- Kundenauftrag: '+ka_id + ' fertig.');

      QryUNIPPS.Next;
  end;

  Tools.Log.Close;
  Tools.ErrLog.Close;
{$ENDIF}
end;

procedure RunIt;
begin
//  mainNonGui.KaAuswerten('142591'); //Error
//  mainNonGui.KaAuswerten('144729');
  mainNonGui.KaAuswerten('142567'); //2Pumpen
//  mainNonGui.KaAuswerten('144734');
//  mainNonGui.KaAuswerten('142302'); //Ersatz

end;


procedure KaAuswerten(ka_id:string);
var ka:TWKundenauftrag;
begin

  try

    //Globals setzen und initialiseren
    Tools.Init;

    //Ka anlegen
    ka:=TWKundenauftrag.Create(ka_id);

    //Logger oeffnen
    Tools.Log.OpenAppend(Tools.LogDir,'FullLog.txt');
    Tools.ErrLog.OpenAppend(Tools.logdir,'ErrLog.txt');

    //auswerten
    ka.auswerten;

  except
    //Logger schlie�en
    Tools.Log.Close;
    Tools.ErrLog.Close;

  end;

end;


end.
