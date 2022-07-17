unit testfrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient,
//  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
//  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
//  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
//  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
//  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
//  FireDAC.Phys.SQLiteWrapper.Stat,
  Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB,
  Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.StdCtrls,DBQrySQLite,tests;

type
  TForm1 = class(TForm)
    ADOQuery1: TADOQuery;
    ADOConnection1: TADOConnection;
    ADOQuery1KUNDEN_ID: TLargeintField;
    ADOQuery1ZU_AB_PROZ: TFloatField;
    ADOQuery1DATUM_VON: TFloatField;
    ADOQuery1DATUM_BIS: TFloatField;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Button1: TButton;
    RunTest: TButton;
    Ende: TButton;
    procedure Button1Click(Sender: TObject);
    procedure EndeClick(Sender: TObject);
    procedure RunTestClick(Sender: TObject);
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

begin

ADOQuery1.Open;

end;


procedure TForm1.EndeClick(Sender: TObject);
begin
  close;
end;

procedure TForm1.RunTestClick(Sender: TObject);
begin
  RunTests;
end;

end.
