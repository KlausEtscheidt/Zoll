unit DBDatamodule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Phys.MSAccDef, FireDAC.Phys.ODBCBase,
  FireDAC.Phys.MSAcc, Data.Win.ADODB;

type
  TKombiDataModule = class(TDataModule)
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDConnectionSQLite: TFDConnection;
    Query: TFDQuery;
    ADOQuery1: TADOQuery;
    ADOConnectionUnipps: TADOConnection;
    ADOQuery1Kunden_id: TIntegerField;
    //constructor Create;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

  var
  KombiDataModule: TKombiDataModule;

implementation


{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}


end.
