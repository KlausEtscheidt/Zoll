unit TeileAnzeigenDlg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
//  Data.Win.ADODB,
  Tools, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TTeileListeForm = class(TForm)
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Panel1: TPanel;
    OKBtn: TButton;
    procedure FormShow(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    IdLieferant: String;
  end;

var
  TeileListeForm: TTeileListeForm;
  LocalQry: TWQry;

implementation

{$R *.dfm}

procedure TTeileListeForm.FormShow(Sender: TObject);
begin
  LocalQry := Tools.GetQuery;
  LocalQry.HoleTeileZumLieferanten(IdLieferant);
  DataSource1.DataSet := LocalQry;

end;

procedure TTeileListeForm.OKBtnClick(Sender: TObject);
begin
  close;
end;

end.
