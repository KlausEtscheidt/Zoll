unit tests;

interface

uses SysUtils, Tools, Logger, Data.DB, DBQrySQLite;

procedure RunTests();

implementation

procedure RunTests();
var qry: TZQrySQLite;
var gefunden:Boolean;
var field:TField;
var text:String;

begin

  //Globale Var init
  Tools.Init;
  //Pfad zur DB setzen
  TZQrySQLite.DbFilePath:=Tools.SQLiteFile;
  //Logger oeffnen
  Tools.Log.OpenNew(Tools.ApplicationBaseDir,'FullLog.txt');
  Qry:=TZQrySQLite.Create();
  gefunden := Qry.SucheKundenRabatt('1120840');

  Tools.Log.WriteLine('Test-Lauf vom '+DateTimeToStr(Now));
  while not Qry.Eof do
  begin
      text:='';
      for field in Qry.Fields do
      begin
          text:=text + field.FieldName +': ' + field.AsString + '; ';
      end;
      Tools.Log.WriteLine(text);
      Qry.Next;
      Tools.Log.WriteLine(Qry.FieldByName('datum_von').AsString);
  end;

Tools.Log.Close;

end;


end.
