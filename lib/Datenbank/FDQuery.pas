///<summary>Komfort-Funktionen fuer Abfragen auf Basis der TADOQuery
///</summary>
///<remarks>
///| Komfort-Funktionen fuer Abfragen auf Basis der TADOQuery
///| Vor der eigentlichen Abfrage muss ein TWADOConnector gesetzt werden.
///| Beispiel (die Owner sind auf nil gesetzt)
///| 1. Connector erzeugen
///|   dbUniConn:=TWADOConnector.Create(nil);
///| 2. Verbinden mit Datenbank (hier UNIPPS)
///|   dbUniConn.ConnectToUNIPPS();
///| 3. Instanz anlegen
///|   QryUNIPPS:=TWADOQuery.Create(nil);
///| 4. Connector setzen
///|   QryUNIPPS.Connector:=dbUniConn;
///| 5. Qry benutzen
///|   QryUNIPPS.RunSelectQuery('Select * from tabellxy');
///</remarks>
unit FDQuery;

interface

  uses System.SysUtils, System.Classes,Vcl.Dialogs,
            StrUtils,Data.DB,Data.Win.ADODB,
            FireDAC.Comp.DataSet, FireDAC.Comp.Client,
            FDConnector;

  /// <summary>Fehler, wenn Datenbank nicht verbunden.</summary>
  type EWQueryErr = class(Exception);

  type
    TWParamlist = array of String;
    ///<summary>Funktionen fuer Abfragen auf Basis der TADOQuery.
    ///</summary>
    ///<remarks>
    /// Vor der eigentlichen Abfrage einer neuen Instanz muss
    /// ein TWADOConnector gesetzt werden.
    ///</remarks>
    TWFDQuery = class(TFDQuery)
    private
      FConnector:TWFDConnector;
      procedure SetConnector(AConnector: TWFDConnector);
      function GetDatenbank():String;
      function GetDatenbankpfad():String;
      function GetFieldValues(): System.TArray<String>;
      //Hier mit error-raise (nur intern anwenden um Programmierfehler zu entdecken)
      function IsConnected():Boolean;
      procedure PrepareQuery(SQL:String);
      procedure ExecuteQuery(WithResult:Boolean);
      procedure Meldung(Text:String);
    public
      var
        /// <summary>Anzahl der gefundenen Records  </summary>
        n_records: Integer;
        /// <summary>True, wenn Datensaetze gefunden </summary>
        gefunden: Boolean;
        /// <summary>Ausgabe von Meldungen in Fenster oder Konsole</summary>
        GuiMode: Boolean;

      //Hier um fehlenden Zugriff auf Datenbank während Laufzeit zu entdecken
      function Connected():Boolean;

      function RunSelectQuery(sql:string):Boolean;
      function RunSelectQueryWithParam(sql:string;paramlist:TWParamlist): Boolean;
      function RunExecSQLQuery(sql:string):Boolean;
      function InsertFields(tablename: String; myFields:TFields):Boolean;

      function GetFieldValuesAsText(): String;
      function GetFieldNames(): System.TArray<String>;reintroduce;
      function GetFieldNamesAsText(): String;

      /// <summary>Objekt, welches Datenbankverbindung hält.  </summary>
      property Connector:TWFDConnector write SetConnector;
//      property IsConnected:Boolean read GetIsConnected;
      /// <summary>Name, der verbundenen Datenbank</summary>
      property Datenbank: String read GetDatenbank;
      /// <summary>Pfad, zur verbundenen Datenbank</summary>
      property Datenbankpfad: String read GetDatenbankpfad;

    end;

implementation

//-----------------------------------------------------------
// Basis- Abfragen
//-----------------------------------------------------------

/// <summary>Führt Abfragen aus, die Ergebnisse liefern (Select).</summary>
/// <remarks>
/// gefunden wird True, wenn Daten gefunden.
/// n_records enthält, die Anzahl der gefundenen Datensätze.
/// </remarks>
/// <param name="sql">SQL-String der Abfrage</param>
/// <returns>True, wenn Datensätze gefunden.</returns>
function TWFDQuery.RunSelectQuery(sql:string):Boolean;
begin
  //Verbinden und SQL befuellen
  PrepareQuery(sql);

  //Ausfuehren per Open da Ergebnis geliefert wird
  Self.ExecuteQuery(True);

  Result:= gefunden;
end;

/// <summary>Führt parametrisierte Abfragen aus, die Ergebnisse liefern (Select)</summary>
/// <remarks>
/// gefunden wird True, wenn Daten gefunden wurde.
///  n_records enthält, die Anzahl der gefundenen Datensätze.
/// </remarks>
function TWFDQuery.RunSelectQueryWithParam(sql:string;paramlist:TWParamlist):Boolean;
var NParam,I:Integer;
begin

  //Verbinden und SQL befuellen
  PrepareQuery(sql);
  Params.Clear;
  for I := 0 to length(paramlist) -1 do
  begin
    with Params.Add do begin
        DataType := ftString;
        Value:= paramlist[I];
    end;

  end;

//  NParam:=length(paramlist) ;

//  if Self.Params.Count<>NParam then
//    raise EWQueryErr.Create(Format(
//          '>%d< Parameter übergeben; >%d< Parameter verlangt vom SQL: >%s<',
//                       [NParam,Params.Count,SQL]));

  //Ausfuehren per Open da Ergebnis geliefert wird
  Self.ExecuteQuery(True);

  Result:= gefunden;
end;

///<summary>Führt Abfragen aus, die keine Ergebnisse liefern (z.B Delete).</summary>
/// <remarks>
/// gefunden wird True, wenn Daten gefunden.
/// n_records enthält, die Anzahl der gefundenen Datensätze.
/// </remarks>
function TWFDQuery.RunExecSQLQuery(sql:string):Boolean;
begin
  //Verbinden und SQL befuellen
  PrepareQuery(sql);

  //Ausfuehren per ExecSQL da kein Ergebnis geliefert wird
  Self.ExecuteQuery(False);

  Result:= gefunden;
end;

//-----------------------------------------------------------
// komplexere Abfragen
//-----------------------------------------------------------

///<summary>
/// Mittels SQL-Insert werden Daten in "tablename" eingefügt.
///</summary>
//-----------------------------------------------------------
function TWFDQuery.InsertFields(tablename: String; myFields:TFields):Boolean;
var
  felder,werte,sql:String;
  myfield : TField;
begin

  Result:=False;

  //SQL aus FEldnamen erzeugen
  felder:='';
  werte:='';
  for myField in myFields do
  begin
      felder:=felder + myField.FieldName + ', ';
      werte:=werte +':'+ myField.FieldName + ', ';
  end;

  System.delete(felder,length(felder)-1,5);
  System.delete(werte,length(werte)-1,5);
  sql:= 'INSERT INTO ' + tablename + '(' + felder +
          ') VALUES(' + werte + ');';

  //Verbinden und SQL befuellen
  PrepareQuery(sql);

  try
      Params.Clear;
      //Daten als Parameter in Query
      for myField in myFields do
      begin
  //        myparam:=Self.Parameters.CreateParameter(myField.FieldName,
  //                         myField.DataType,pdInput,20,myField.Value) ;
  //        myparam:=Self.Parameters.AddParameter;
  //        myparam.Name:=myField.FieldName;
  //        myparam.DataType:= myField.DataType; // ftString;
  //        myparam.Value:= myField.Value; // .AsString;
          with Params.Add do begin
              Name:=myField.FieldName;
              DataType := myField.DataType;
              Value:= myField.Value;
          end;
      end;

    //Ausfuehren
    ExecuteQuery(False);

  except

    on E: Exception do
    begin
  //          Tools.ErrLog.Log('in SQLiteConnect.Store' + E.Message);
        if not ContainsText(E.Message, 'UNIQUE constraint failed') then
            raise
    end;

  end;

end;

//Bereitet Query zum Ausführen vor
procedure TWFDQuery.PrepareQuery(SQL:String);
begin
  //Pr�ft of Datenbank verbunden
  Self.IsConnected;

  //�bertr�ge die Klassen-Connection ins Objekt
  Self.Connection:=FConnector.Connection;

  //sql ins Qry-Objekt
  Self.SQL.BeginUpdate;
  Self.SQL.Clear;
  Self.SQL.Add(sql);
  Self.SQL.EndUpdate;

end;

//Fuehrt ExecSQL oder Open (bei WithResult:=True) aus
procedure TWFDQuery.ExecuteQuery(WithResult:Boolean);
begin
  //Ausf�hren
  n_records:=0;
  try
    if WithResult then
    begin
      //Qry ausf�hren
      Self.Open;
      n_records:=self.GetRecordCount();
    end
    else
      begin
       Self.ExecSQL;
       n_records:=1;
      end;
  except
    on e:Exception do
    begin
      Meldung(e.Message);
      n_records:=0;
    end;

  end;
  gefunden:=n_records>0;

end;

//-----------------------------------------------------------
// Zusatzinfo zu Query-Inhalt
//-----------------------------------------------------------

///<summary>Zum Debuggen: Liefert alle Ergebnis-Felder eines Datensatzes als CSV-String.</summary>
function TWFDQuery.GetFieldValuesAsText(): String;
var
  Werte : System.TArray<String>;
  Text : String;
  I:Integer;
begin
  Werte:=GetFieldValues();
  Text:='';
  for I := 0 to length(Werte)-2 do
  begin
    Text:=Text+Werte[I]+'; ' ;
  end;
  Text:=Text+Werte[length(Werte)-1];
  Result:=Text;
end;

///<summary>Liefert alle Ergebnis-Felder eines Datensatzes als String-Array.</summary>
function TWFDQuery.GetFieldValues(): System.TArray<String>;
var
  felder,werte:String;
  myfield : TField;
  Names: TStringList;
begin
    felder:='';
    werte:='';
    Names:= TStringList.Create;
    for myField in Self.Fields do
    begin
        Names.Add(myField.AsString)
    end;

    Result:=Names.ToStringArray;

end;

///<summary>Liefert alle FeldNamen einer Abfrage als CSV-String.</summary>
function TWFDQuery.GetFieldNamesAsText(): String;
var
  Werte : System.TArray<String>;
  Text : String;
  I:Integer;
begin
  Werte:=GetFieldNames();
  Text:='';
  for I := 0 to length(Werte)-2 do
  begin
    Text:=Text+Werte[I]+'; ' ;
  end;
  Text:=Text+Werte[length(Werte)-1];
  Result:=Text;
end;

//-----------------------------------------------------------
function TWFDQuery.GetFieldNames(): System.TArray<String>;
var
  Names: TStringList;
begin
     Names:= TStringList.Create;
     Self.Fields.GetFieldNames(Names);
     Result:=Names.ToStringArray;
end;


//-----------------------------------------------------------
//Helper
//-----------------------------------------------------------

//Ausgabe von Meldungen
procedure TWFDQuery.Meldung(Text:String);
begin
  if GuiMode then
    ShowMessage(Text);
end;

//Prüft of Datenbank korrekt verbunden, raises error wenn nicht
//-----------------------------------------------------------
function TWFDQuery.IsConnected():Boolean;
  var ok:Boolean;
begin
//  ok:=False;
  //Schritt 1 wurde FConnector erzeugt
  if not assigned(FConnector) then
    raise EWQueryErr.Create('Vor Erstbenutzung von FDQuery Connector setzen.' );
  //Schritt 2 ist FConnector verbunden
  try
    ok:=FConnector.Connection.Connected;
  except
    raise EWQueryErr.Create('Vor Erstbenutzung von FDQuery Connector setzen.' );
  end;
  Result:=ok;
end;

//Prüft of Datenbank korrekt verbunden, Ohne raise error
//Ermöglicht fehenden DB-Zugriff während Laufzeit zu entdecken
//-----------------------------------------------------------
function TWFDQuery.Connected():Boolean;
begin
  Result:=False;
  //Schritt 1 wurde FConnector erzeugt
  if not assigned(FConnector) then
    exit;
  //Schritt 2 ist FConnector verbunden
  try
    Result:=FConnector.Connection.Connected;
  except
    Result:=False;
  end;
end;

//Besetzt die Connector-Eigenschaft, der eine Verbindung zur DB h�lt
//-----------------------------------------------------------
procedure TWFDQuery.SetConnector(AConnector: TWFDConnector);
begin
  FConnector:=AConnector;
end;
//Infos zur verbundenen DB
function TWFDQuery.GetDatenbank():String;
begin
  Result:= FConnector.Datenbank;
end;
//Infos zur verbundenen DB
function TWFDQuery.GetDatenbankpfad():String;
begin
  Result:= FConnector.Datenbankpfad;
end;

end.

