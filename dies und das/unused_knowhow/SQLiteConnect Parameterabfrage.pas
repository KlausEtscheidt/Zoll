unit SQLiteConnect;

interface

  uses System.Classes,FireDAC.Phys.SQLite ,FireDAC.Stan.Def,FireDAC.Stan.Param
       ,FireDAC.Comp.Client,StrUtils,
        DBQrySQLite,Data.DB, Tools;

  type
    TWDbConnector = class
      dbconn : TFDConnection;
      mQry: TFDQuery;
      constructor Create();
      function getQuery():TFDQuery;
      function Exec(sql:string):Boolean;
      procedure Store(tablename: String; myFields:TFields);
    protected
    end;

implementation
uses DBQryUNIPPS;

constructor TWDbConnector.Create();

//var driver:TFDPhysSQLiteDriverLink;

begin

  dbconn:=TFDConnection.Create(nil);

  dbconn.Close;
  // create temporary connection definition
  with dbconn.Params do begin
    Clear;
    Add('DriverID=SQLite');
    Add('Database=C:\Users\Etscheidt\Documents\Embarcadero\Studio\Projekte\Zoll\db\zoll.sqlite');
    Add('LockingMode=Normal');
  end;
  dbconn.LoginPrompt := False;
  dbconn.Open;
  getQuery;
end;

//Liefert eine TFDQuery die �ber diese TFDConnection mit einer Datenbank verbunden ist
function TWDbConnector.getQuery():TFDQuery;
var aQry: TFDQuery;
begin
  aQry:= TFDQuery.Create(nil);
  aQry.Connection:=dbconn;
  mQry:=aQry;
  Result := aQry;
end;

function TWDbConnector.Exec(sql:string):Boolean;
var n_records:Integer;
begin
  mQry.ExecSQL(sql);
  n_records:=mQry.RowsAffected;
  Result:= True;
end;

procedure TWDbConnector.Store(tablename: String; myFields:TFields);
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

  //Ausf�hren
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
