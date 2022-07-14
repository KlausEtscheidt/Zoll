unit SQLiteConnect;

interface

  uses System.Classes,FireDAC.Phys.SQLite ,FireDAC.Stan.Def,FireDAC.Stan.Param
       ,FireDAC.Comp.Client,
        DBQrySQLite,Data.DB;

  type
    TZDbConnector = class
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

constructor TZDbConnector.Create();

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

//Liefert eine TFDQuery die über diese TFDConnection mit einer Datenbank verbunden ist
function TZDbConnector.getQuery():TFDQuery;
var aQry: TFDQuery;
begin
  aQry:= TFDQuery.Create(nil);
  aQry.Connection:=dbconn;
  mQry:=aQry;
  Result := aQry;
end;

function TZDbConnector.Exec(sql:string):Boolean;
var n_records:Integer;
begin
  mQry.ExecSQL(sql);
  n_records:=mQry.RowsAffected;
  Result:= True;
end;

procedure TZDbConnector.Store(tablename: String; myFields:TFields);
var txt, sql:String;
  myfield : TField;
  myparams : TFDParams;
  myparam :TFDParam;

begin
  txt:='"';

  sql := 'INSERT INTO ' + tablename + ' VALUES(';
  for myField in myFields do
  begin
      sql:=sql +':'+ myField.FieldName + ', ';
  end;

  delete(sql,length(sql)-1,5);
  sql:= sql + ');';
  //erste NEUE Query erzeugen oder SQL leeren
  mQry.SQL.Clear;
  mQry.SQL.Add(sql);
  myparams:=mQry.Params;
  for myField in myFields do
  begin
      myparam:=mQry.ParamByName(myField.FieldName);
      mQry.ParamByName(myField.FieldName).AsString := myField.AsString;
      myparam:=mQry.ParamByName(myField.FieldName);
  end;
  myparam:=mQry.ParamByName('id_stu');
  try
    mQry.Prepare;
    mQry.ExecSQL(sql);
  except
    on E: EDatabaseError do
      txt:=''
  end;


end;


end.
