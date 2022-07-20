                { TODO : Constructor einfuehren, der Verbindung übernimmt }
unit ADOQuery;
{Komfort-Funktionen fuer Abfragen auf Basis der TADOQuery
 Vor der ersten "Benutzung" einer neuen Instanz muss
 ein TZADOConnector für die Klasse gesetzt werden
 Beispiel (die Owner sind auf nil gesetzt)
 1. Connector erzeugen
   dbUniConn:=TZADOConnector.Create(nil);
 2. Verbinden mit Datenbank (hier UNIPPS)
   dbUniConn.ConnectToUNIPPS();
 3. Instanz anlegen
   QryUNIPPS:=TZADOQuery.Create(nil);
 4. Connector setzen
   QryUNIPPS.Connector:=dbUniConn;
 5. Qry benutzen
   QryUNIPPS.RunSelectQuery('Select * from tabellxy');

 Weitere Instanzen können direkt nach dem Erzeugen benutzt werden
   Qry2:=TZADOQuery.Create(nil);
   Qry2.RunExecSQLQuery('delete from tabellxy')

 RunSelectQuery
  Führt Abfragen aus, die Ergebnisse liefern (Select)
  gefunden wird True, wenn Daten gefunden
  n_records enthält, die Anzahl der gefundenen Datensätze
  Alles andere wird über die Ursprungs-Klasse erledigt

 RunExecSQLQuery
   Führt Abfragen aus, die keine Ergebnisse liefern (z.B Delete)
   gefunden wird True, wenn Abfrage erfolgreich
   n_records enthält, die Anzahl der betroffenen Datensätze

 InsertFields
   Fügt eine TFields-Liste in eine Tabelle
}
interface

  uses System.SysUtils, System.Classes,
            StrUtils,Data.DB,Data.Win.ADODB, ADOConnector;

  type
    TZADOQuery = class(TADOQuery)
    private
      FConnector:TZADOConnector;
//      FDatenbank: String;
//      FDatenbankpfad: String;
      procedure SetConnector(AConnector: TZADOConnector);
      function GetDatenbank():String;
      function GetDatenbankpfad():String;
      function GetIsConnected():Boolean;
    public
      { public declarations }
      function RunSelectQuery(sql:string):Boolean;
      function RunExecSQLQuery(sql:string):Boolean;
      function InsertFields(tablename: String; myFields:TFields):Boolean;
      function GetFieldValues(): System.TArray<String>;
      function GetFieldValuesAsText(): String;
      function GetFieldNames(): System.TArray<String>;
      function GetFieldNamesAsText(): String;
      var n_records: Integer;
      var gefunden: Boolean;
      property Connector:TZADOConnector write SetConnector;
      property IsConnected:Boolean read GetIsConnected;
      property Datenbank: String read GetDatenbank;
      property Datenbankpfad: String read GetDatenbankpfad;
    end;


implementation

//-----------------------------------------------------------
// Basis- Abfragen
//-----------------------------------------------------------

//Query mit Ergebnis ausführen (setzt Felder n_records und gefunden)
//-----------------------------------------------------------
function TZADOQuery.RunSelectQuery(sql:string):Boolean;
begin

  //Prüft of Datenbank verbunden
  Self.IsConnected;

  //Überträge die Klassen-Connection ins Objekt
  Self.Connection:=FConnector.Connection;

  //sql ins Qry-Objekt
  Self.SQL.Clear;
  Self.SQL.Add(sql);

  //Qry ausführen
  Self.Open;

  n_records:=self.GetRecordCount();
  gefunden:=n_records>0;
  Result:= gefunden;
end;

//Query ohne Ergebnis ausführen
//-----------------------------------------------------------
function TZADOQuery.RunExecSQLQuery(sql:string):Boolean;
var n_records:Integer;
begin
  //Prüft of Datenbank verbunden
  Self.IsConnected;

  //Überträge die Klassen-Connection ins Objekt
  Self.Connection:=FConnector.Connection;

  //sql ins Qry-Objekt
  Self.SQL.Clear;
  Self.SQL.Add(sql);

  //Qry ausführen
  n_records:=Self.ExecSQL();

  gefunden:=n_records>0;
  Result:= gefunden;
end;

//-----------------------------------------------------------
// komplexere Abfragen
//-----------------------------------------------------------

//Insert-Statement für "tablename" anhand einer Feldliste ausführen
//-----------------------------------------------------------
function TZADOQuery.InsertFields(tablename: String; myFields:TFields):Boolean;
var
  felder,werte,sql:String;
  myfield : TField;
begin

  //Prüft of Datenbank verbunden
  Self.IsConnected;

  try

    //SQL aus FEldnamen
    felder:='';
    werte:='';
    for myField in myFields do
    begin
        felder:=felder + myField.FieldName + ', ';
        werte:=werte +':'+ myField.FieldName + ', ';
//        werte:=werte +'"'+ myField.AsString + '", ';
    end;

    System.delete(felder,length(felder)-1,5);
    System.delete(werte,length(werte)-1,5);
    sql:= 'INSERT INTO ' + tablename + '(' + felder +
            ') VALUES(' + werte + ');';

    //Überträge die Klassen-Connection ins Objekt
    //
    // !!! Muss vor dem Ändern des SQL erfolgen damit Parameter angelegt werden.
    //
    Self.Connection:=FConnector.Connection;

    //SQL in Query (erst leeren)
    Self.SQL.BeginUpdate;
    Self.SQL.Clear;
    Self.SQL.Add(sql);
    Self.SQL.EndUpdate;

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

    //Ausführen
    n_records:=Self.ExecSQL();
    gefunden:=n_records>0;
    Result:= gefunden;

  except

    on E: Exception do
    begin
  //          Tools.ErrLog.Log('in SQLiteConnect.Store' + E.Message);
        if ContainsText(E.Message, 'UNIQUE constraint failed') then
            writeln('Doppelte')
        else
            raise
//            if ContainsText(E.Message, 'database is locked') then
//              raise
    end;

  end;

end;

//-----------------------------------------------------------
function TZADOQuery.GetFieldValuesAsText(): String;
var
  Werte : System.TArray<String>;
  Wert, Text : String;
  I:Integer;
begin
  Werte:=GetFieldValues();
  Text:='';
  for I := 0 to length(Werte)-2 do
  begin
    Text:=Text+Werte[I]+'; ' ;
  end;
  Text:=Text+Werte[I];
  Result:=Text;
end;

//-----------------------------------------------------------
function TZADOQuery.GetFieldValues(): System.TArray<String>;
var
  felder,werte,sql:String;
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

//-----------------------------------------------------------
function TZADOQuery.GetFieldNamesAsText(): String;
var
  Werte : System.TArray<String>;
  Wert, Text : String;
  I:Integer;
begin
  Werte:=GetFieldNames();
  Text:='';
  for I := 0 to length(Werte)-2 do
  begin
    Text:=Text+Werte[I]+'; ' ;
  end;
  Text:=Text+Werte[I];
  Result:=Text;
end;

//-----------------------------------------------------------
function TZADOQuery.GetFieldNames(): System.TArray<String>;
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

//Prüft of Datenbank korrekt verbunden, raises error wenn nicht
//-----------------------------------------------------------
function TZADOQuery.GetIsConnected():Boolean;
  var ok:Boolean;
begin
  ok:=False;
  //Schritt 1 wurde FConnector erzeugt
  if not assigned(FConnector) then
    raise Exception.Create('Vor Erstbenutzung von ADOQuery Connector setzen.' );
  //Schritt 2 ist FConnector verbunden
  try
    ok:=FConnector.Connection.Connected;
  except
    raise Exception.Create('Vor Erstbenutzung von ADOQuery Connector setzen.' );
  end;
  Result:=ok;
end;

//Besetzt die Connector-Eigenschaft, der eine Verbindung zur DB hält
//-----------------------------------------------------------
procedure TZADOQuery.SetConnector(AConnector: TZADOConnector);
begin
  FConnector:=AConnector;
end;
//Infos zur verbundenen DB
function TZADOQuery.GetDatenbank():String;
begin
  Result:= FConnector.Datenbank;
end;
//Infos zur verbundenen DB
function TZADOQuery.GetDatenbankpfad():String;
begin
  Result:= FConnector.Datenbankpfad;
end;

end.
