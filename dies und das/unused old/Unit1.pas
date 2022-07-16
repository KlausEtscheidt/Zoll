unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SQLite, Data.Win.ADODB, Vcl.StdCtrls,
  Data.DB, DBZugriff;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var qry:TADOQuery;
var qry2:TZQry;

var sql:String;
var f: TFields;
var erg:String;
begin
   if true then
      begin
       qry2:=DBconn.getQuery;
       qry2.SucheKundenAuftragspositionen('142591');
       f:=qry2.Fields;
      end
   else
   begin
      qry:=TADOQuery.Create(Self);
     qry.Connection:=SQLiteDataModule.ADOConnectionUnipps;
     sql:='Select * from auftragkopf where ident_nr = "142591";';
     //sql:='Select count(ident_nr) as n from auftragkopf;';
     qry.SQL.Add(sql);
     //qry.ExecSQL();
     qry.Open();
     f:=qry.Fields;
   end;
   erg:=f.FieldByName('klassifiz').AsString;
end;
end.
