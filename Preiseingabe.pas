unit Preiseingabe;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.StdCtrls, PumpenDataSet;

type
  TPreisFrm = class(TForm)
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    PreisDS: TWDataSet;
    PreisDSid_pos: TIntegerField;
    PreisDSmenge: TFloatField;
    PreisDSt_tg_nr: TStringField;
    PreisDSBezeichnung: TStringField;
    PreisDSvk_brutto: TFloatField;
    PreisDSvk_netto: TFloatField;
    PreisDSZuKAPos: TIntegerField;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  PreisFrm: TPreisFrm;

implementation

{$R *.dfm}

end.
