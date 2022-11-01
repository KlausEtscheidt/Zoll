unit LocalDbQuerys;

interface

uses Tools,QrySQLite;

function HoleAnzahlTabelleneintraege(tablename:String):Integer;
function HoleAnzahlPumpenteile():Integer;
function HoleAnzahlPumpenteileMitPfk():Integer;

function HoleAnzahlLieferanten():Integer;
function HoleAnzahlLieferPumpenteile():Integer;
function HoleAnzahlLieferStatusUnbekannt():Integer;

implementation

function HoleAnzahlTabelleneintraege(tablename:String) :Integer;
var
  LocalQry: TWQry;
  SQL:string;

begin
  LocalQry:=Tools.GetQuery;
  SQL:='Select count() as n from ''' + tablename + ''';';
  LocalQry.RunSelectQuery(SQL);
  result:= LocalQry.FieldByName('n').AsInteger;
end;

function HoleAnzahlPumpenteile :Integer;
var
  LocalQry: TWQry;
  SQL:string;
begin
  LocalQry:=Tools.GetQuery;
  SQL:='Select count() as n from Teile where Pumpenteil=-1;';
  LocalQry.RunSelectQuery(SQL);
  result:= LocalQry.FieldByName('n').AsInteger;
end;

function HoleAnzahlPumpenteileMitPfk :Integer;
var
  LocalQry: TWQry;
  SQL:string;
begin
  LocalQry:=Tools.GetQuery;
  SQL := 'Select count() as n from Teile where Pumpenteil=-1 ' +
          'AND n_Lieferanten=n_LPfk;';
  LocalQry.RunSelectQuery(SQL);
  result:= LocalQry.FieldByName('n').AsInteger;
end;

function HoleAnzahlLieferanten():Integer;
var
  LocalQry: TWQry;
  SQL:string;
begin
  LocalQry:=Tools.GetQuery;
  SQL := 'Select count() as n from Lieferanten where Lieferstatus!="entfallen"; ';
  LocalQry.RunSelectQuery(SQL);
  result:= LocalQry.FieldByName('n').AsInteger;
end;

function HoleAnzahlLieferPumpenteile():Integer;
var
  LocalQry: TWQry;
  SQL:string;
begin
  LocalQry:=Tools.GetQuery;
  SQL := 'Select count() as n from Lieferanten where Pumpenteile=-1 '
       + 'and Lieferstatus!="entfallen" ; ';
  LocalQry.RunSelectQuery(SQL);
  result:= LocalQry.FieldByName('n').AsInteger;
end;

function HoleAnzahlLieferStatusUnbekannt():Integer;
var
  LocalQry: TWQry;
  SQL:string;
begin
  LocalQry:=Tools.GetQuery;
  SQL := 'Select count() as n from Lieferanten where Pumpenteile=-1 '
       + 'and Lieferstatus!="entfallen" and lekl=0; ';

  LocalQry.RunSelectQuery(SQL);
  result:= LocalQry.FieldByName('n').AsInteger;
end;

end.
