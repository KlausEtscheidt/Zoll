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
unit ADOQuery;

interface

  uses System.SysUtils, System.Classes,Vcl.Dialogs,
            StrUtils,Data.DB,Data.Win.ADODB, ADOConnector;

  /// <summary>Fehler, wenn Datenbank nicht verbunden.</summary>
  type EWADOQuery = class(Exception);

  type
    TWParamlist = array of String;
    ///<summary>Funktionen fuer Abfragen auf Basis der TADOQuery.
    ///</summary>
    ///<remarks>
    /// Vor der eigentlichen Abfrage einer neuen Instanz muss
    /// ein TWADOConnector gesetzt werden.
    ///</remarks>
    TWADOQuery = class(TADOQuery)
    private
      FConnector:TWADOConnector;
      procedure SetConnector(AConnector: TWADOConnector);
      function GetDatenbank():String;
      function GetDatenbankpfad():String;
      function GetFieldValues(): System.TArray<String>;
      //Hier mit error-raise (nur intern anwenden; Programmierfehler entdecken)
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
      property Connector:TWADOConnector write SetConnector;
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
function TWADOQuery.RunSelectQuery(sql:string):Boolean;
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
function TWADOQuery.RunSelectQueryWithParam(sql:string;paramlist:TWParamlist):Boolean;
var NParam,I:Integer;
begin

  //Verbinden und SQL befuellen
  PrepareQuery(sql);

  NParam:=length(paramlist) ;

  if Self.Parameters.Count<>NParam then
    raise EWADOQuery.Create(Format(
          '>%d< Parameter übergeben; >%d< Parameter verlangt vom SQL: >%s<',
                       [NParam,Parameters.Count,SQL]));

  //Parameter in Qry-Objekt uebernehmen
  for I := 0 to NParam-1 do
  begin
    Self.Parameters.Items[I].DataType := ftString;
    Self.Parameters.Items[I].Value := paramlist[I];
  end;

  //Ausfuehren per Open da Ergebnis geliefert wird
  Self.ExecuteQuery(True);

  Result:= gefunden;
end;

///<summary>Führt Abfragen aus, die keine Ergebnisse liefern (z.B Delete).</summary>
/// <remarks>
/// gefunden wird True, wenn Daten gefunden.
/// n_records enthält, die Anzahl der gefundenen Datensätze.
/// </remarks>
function TWADOQuery.RunExecSQLQuery(sql:string):Boolean;
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
function TWADOQuery.InsertFields(tablename: String; myFields:TFields):Boolean;
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

    //Daten als Parameter in Query
    for myField in myFields do
    begin
//        myparam:=Self.Parameters.CreateParameter(myField.FieldName,
//                         myField.DataType,pdInput,20,myField.Value) ;
//        myparam:=Self.Parameters.AddParameter;
//        myparam.Name:=myField.FieldName;
//        myparam.DataType:= myField.DataType; // ftString;
//        myparam.Value:= myField.Value; // .AsString;
        Self.Parameters.ParamByName(myField.FieldName).DataType := myField.DataType;
        Self.Parameters.ParamByName(myField.FieldName).Value := myField.Value;
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
procedure TWADOQuery.PrepareQuery(SQL:String);
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
procedure TWADOQuery.ExecuteQuery(WithResult:Boolean);
begin
  //Ausf�hren
  if WithResult then
  begin
    //Qry ausf�hren
    Self.Open;
    n_records:=self.GetRecordCount();
  end
  else
    n_records:=Self.ExecSQL();

  gefunden:=n_records>0;

end;

//-----------------------------------------------------------
// Zusatzinfo zu Query-Inhalt
//-----------------------------------------------------------

///<summary>Zum Debuggen: Liefert alle Ergebnis-Felder eines Datensatzes als CSV-String.</summary>
function TWADOQuery.GetFieldValuesAsText(): String;
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
function TWADOQuery.GetFieldValues(): System.TArray<String>;
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
function TWADOQuery.GetFieldNamesAsText(): String;
var
  Werte : System.TArray<String>;
  Text : String;
  I:Integer;
begin
  Werte:=GetFieldNames();
  Text:='';
  if length(Werte)>0 then
  begin
    for I := 0 to length(Werte)-2 do
    begin
      Text:=Text+Werte[I]+'; ' ;
    end;
    Text:=Text+Werte[length(Werte)-1];
  end
  else
    Text:='Keine Felder in Abfrage gefunden';
  Result:=Text;
end;

//-----------------------------------------------------------
function TWADOQuery.GetFieldNames(): System.TArray<String>;
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
procedure TWADOQuery.Meldung(Text:String);
begin
  if GuiMode then
    ShowMessage(Text);
end;

//Prüft of Datenbank korrekt verbunden, raises error wenn nicht
//-----------------------------------------------------------
function TWADOQuery.IsConnected():Boolean;
  var ok:Boolean;
begin
//  ok:=False;
  //Schritt 1 wurde FConnector erzeugt
  if not assigned(FConnector) then
    raise EWADOQuery.Create('Vor Erstbenutzung von ADOQuery Connector setzen.' );
  //Schritt 2 ist FConnector verbunden
  try
    ok:=FConnector.Connection.Connected;
  except
    raise EWADOQuery.Create('Vor Erstbenutzung von ADOQuery Connector setzen.' );
  end;
  Result:=ok;
end;

//Prüft of Datenbank korrekt verbunden, Ohne raise error
//Ermöglicht fehenden DB-Zugriff während Laufzeit zu entdecken
//-----------------------------------------------------------
function TWADOQuery.Connected():Boolean;
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
procedure TWADOQuery.SetConnector(AConnector: TWADOConnector);
begin
  FConnector:=AConnector;
end;
//Infos zur verbundenen DB
function TWADOQuery.GetDatenbank():String;
begin
  Result:= FConnector.Datenbank;
end;
//Infos zur verbundenen DB
function TWADOQuery.GetDatenbankpfad():String;
begin
  Result:= FConnector.Datenbankpfad;
end;

end.

