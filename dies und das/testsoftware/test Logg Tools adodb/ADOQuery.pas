unit ADOQuery;

interface

  uses System.SysUtils, System.Classes,
            Data.DB,Data.Win.ADODB, ADOConnector;
//      StrUtils,
  type
    TZADOQuery = class(TADOQuery)
    private
      class var FConnector:TZADOConnector;
      procedure SetConnector(AConnector: TZADOConnector);
    public
      { public declarations }
      function RunSelectQuery(sql:string):Boolean;
      function RunExecSQLQuery(sql:string):Boolean;
      procedure InsertFields(tablename: String; myFields:TFields);
      var n_records: Integer;
      var gefunden: Boolean;
      property Connector:TZADOConnector write SetConnector;
    end;


implementation

procedure TZADOQuery.SetConnector(AConnector: TZADOConnector);
begin
  FConnector:=AConnector;
end;

//Fuehrt SQL aus und setzt Felder n_records und gefunden
function TZADOQuery.RunSelectQuery(sql:string):Boolean;
  var ok:Boolean;
begin

  //Test ob mit DB verbunden
  //Schritt 1 wurde FConnector erzeugt
  if not assigned(FConnector) then
    raise Exception.Create('Vor Erstbenutzung von ADOQuery Connector setzen.' );

  try
    ok:=FConnector.Connection.Connected;
  except
    raise Exception.Create('Vor Erstbenutzung von ADOQuery Connector setzen.' );
  end;

  //Verbindung ins Query-Objekt eintragen
  Self.Connection:=FConnector.Connection;

  //sql ins Qry-Objekt
  Self.SQL.Add(sql);
  //Qry ausführen
  Self.Open;

//  SQL.Add(sqlqry);
  n_records:=self.GetRecordCount();
  gefunden:=n_records>0;
  Result:= gefunden;
end;

function TZADOQuery.RunExecSQLQuery(sql:string):Boolean;
var n_records:Integer;
begin
  mQry.ExecSQL(sql);
  n_records:=mQry.RowsAffected;
  Result:= True;
end;

procedure TZADOQuery.InsertFields(tablename: String; myFields:TFields);
var
  sql:String;
  myfield : TField;
//  myparam :TFDParam; //nur zum kucken

begin

  try

    //SQL aus FEldnamen
    sql := 'INSERT INTO ' + tablename + ' VALUES(';
    for myField in myFields do
    begin
        sql:=sql +':'+ myField.FieldName + ', ';
    end;

    delete(sql,length(sql)-1,5);
    sql:= sql + ');';

    //SQL  in Query (erst leeren)
    mQry.SQL.Clear;
    mQry.SQL.Add(sql);

    //Daten als Parameter in Query
    for myField in myFields do
    begin
        mQry.ParamByName(myField.FieldName).AsString := myField.AsString;
        //myparam:=mQry.ParamByName(myField.FieldName);
    end;

  //Ausführen
    mQry.Prepare;
    mQry.ExecSQL(sql);
  except

    on E: EDatabaseError do
      if not ContainsText(E.Message, 'UNIQUE constraint failed') then
      begin
          Tools.ErrLog.Log('in SQLiteConnect.Store' + E.Message);
          if ContainsText(E.Message, 'database is locked') then
            raise
      end;
  end;


end;

end.
