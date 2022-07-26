                { TODO : Constructor einfuehren, der Verbindung �bernimmt }
unit ADOQuery;
{Komfort-Funktionen fuer Abfragen auf Basis der TADOQuery
 Vor der ersten "Benutzung" einer neuen Instanz muss
 ein TWADOConnector f�r die Klasse gesetzt werden
 Beispiel (die Owner sind auf nil gesetzt)
 1. Connector erzeugen
   dbUniConn:=TWADOConnector.Create(nil);
 2. Verbinden mit Datenbank (hier UNIPPS)
   dbUniConn.ConnectToUNIPPS();
 3. Instanz anlegen
   QryUNIPPS:=TWADOQuery.Create(nil);
 4. Connector setzen
   QryUNIPPS.Connector:=dbUniConn;
 5. Qry benutzen
   QryUNIPPS.RunSelectQuery('Select * from tabellxy');

 Weitere Instanzen k�nnen direkt nach dem Erzeugen benutzt werden
   Qry2:=TWADOQuery.Create(nil);
   Qry2.RunExecSQLQuery('delete from tabellxy')

 RunSelectQuery
  F�hrt Abfragen aus, die Ergebnisse liefern (Select)
  gefunden wird True, wenn Daten gefunden
  n_records enth�lt, die Anzahl der gefundenen Datens�tze
  Alles andere wird �ber die Ursprungs-Klasse erledigt

 RunExecSQLQuery
   F�hrt Abfragen aus, die keine Ergebnisse liefern (z.B Delete)
   gefunden wird True, wenn Abfrage erfolgreich
   n_records enth�lt, die Anzahl der betroffenen Datens�tze

 InsertFields
   F�gt eine TFields-Liste in eine Tabelle
}
interface

  uses System.SysUtils, System.Classes,
            StrUtils,Data.DB,Data.Win.ADODB, ADOConnector;

  type
    TWADOQuery = class(TADOQuery)
    private
      FConnector:TWADOConnector;
//      FDatenbank: String;
//      FDatenbankpfad: String;
      procedure SetConnector(AConnector: TWADOConnector);
      function GetDatenbank():String;
      function GetDatenbankpfad():String;
      function GetIsConnected():Boolean;
    public
      var n_records: Integer;
      var gefunden: Boolean;

      destructor Destroy; override;

      function RunSelectQuery(sql:string):Boolean;
      function RunExecSQLQuery(sql:string):Boolean;
      function InsertFields(tablename: String; myFields:TFields):Boolean;

      function GetFieldValues(): System.TArray<String>;
      function GetFieldValuesAsText(): String;
      function GetFieldNames(): System.TArray<String>;reintroduce;
      function GetFieldNamesAsText(): String;

      property Connector:TWADOConnector write SetConnector;
      property IsConnected:Boolean read GetIsConnected;
      property Datenbank: String read GetDatenbank;
      property Datenbankpfad: String read GetDatenbankpfad;

    end;

implementation

destructor TWADOQuery.Destroy;
begin
  inherited;
end;

//-----------------------------------------------------------
// Basis- Abfragen
//-----------------------------------------------------------

//Query mit Ergebnis ausf�hren (setzt Felder n_records und gefunden)
//-----------------------------------------------------------
function TWADOQuery.RunSelectQuery(sql:string):Boolean;
begin

  //Pr�ft of Datenbank verbunden
  Self.IsConnected;

  //�bertr�ge die Klassen-Connection ins Objekt
  Self.Connection:=FConnector.Connection;

  //sql ins Qry-Objekt
  Self.SQL.Clear;
  Self.SQL.Add(sql);

  //Qry ausf�hren
  Self.Open;

  n_records:=self.GetRecordCount();
  gefunden:=n_records>0;
  Result:= gefunden;
end;

//Query ohne Ergebnis ausf�hren
//-----------------------------------------------------------
function TWADOQuery.RunExecSQLQuery(sql:string):Boolean;
var n_records:Integer;
begin
  //Pr�ft of Datenbank verbunden
  Self.IsConnected;

  //�bertr�ge die Klassen-Connection ins Objekt
  Self.Connection:=FConnector.Connection;

  //sql ins Qry-Objekt
  Self.SQL.Clear;
  Self.SQL.Add(sql);

  //Qry ausf�hren
  n_records:=Self.ExecSQL();

  gefunden:=n_records>0;
  Result:= gefunden;
end;

//-----------------------------------------------------------
// komplexere Abfragen
//-----------------------------------------------------------

//Insert-Statement f�r "tablename" anhand einer Feldliste ausf�hren
//-----------------------------------------------------------
function TWADOQuery.InsertFields(tablename: String; myFields:TFields):Boolean;
var
  felder,werte,sql:String;
  myfield : TField;
begin

  Result:=False;

  //Pr�ft of Datenbank verbunden
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

    //�bertr�ge die Klassen-Connection ins Objekt
    //
    // !!! Muss vor dem �ndern des SQL erfolgen damit Parameter angelegt werden.
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

    //Ausf�hren
    n_records:=Self.ExecSQL();
    gefunden:=n_records>0;
    Result:= gefunden;

  except

    on E: Exception do
    begin
  //          Tools.ErrLog.Log('in SQLiteConnect.Store' + E.Message);
        if not ContainsText(E.Message, 'UNIQUE constraint failed') then
            raise
    end;

  end;

end;

//-----------------------------------------------------------
function TWADOQuery.GetFieldValuesAsText(): String;
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
  Text:=Text+Werte[length(Werte)-1];
  Result:=Text;
end;

//-----------------------------------------------------------
function TWADOQuery.GetFieldValues(): System.TArray<String>;
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
function TWADOQuery.GetFieldNamesAsText(): String;
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
  Text:=Text+Werte[length(Werte)-1];
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

//Pr�ft of Datenbank korrekt verbunden, raises error wenn nicht
//-----------------------------------------------------------
function TWADOQuery.GetIsConnected():Boolean;
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
