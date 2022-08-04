unit Preiseingabe;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.StdCtrls, PumpenDataSet, Vcl.WinXCtrls;
type
  myGrid=class(TDBGrid);

type
  TPreisFrm = class(TForm)
    DataSource1: TDataSource;
    Label1: TLabel;
    Panel1: TPanel;
    PreisDS: TWDataSet;
    DBGrid1: TDBGrid;
    Button2: TButton;
    Button1: TButton;
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
