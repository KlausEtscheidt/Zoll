unit LieferantenErklaerungenFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB, Vcl.DBCtrls, Vcl.DBCGrids,
  datenmodul, Vcl.ExtCtrls, Data.Bind.EngExt, Vcl.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Vcl.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope, Init;

type
  TLieferantenErklaerungenFrm = class(TFrame)
    DBCtrlGrid1: TDBCtrlGrid;
    PFK: TDBCheckBox;
    TeileNr: TDBText;
    TName1: TDBText;
    TName2: TDBText;
    LTeileNr: TDBText;
    DataSource1: TDataSource;
    BackBtn: TButton;
    Label1: TLabel;
    LKurznameLbl: TLabel;
    IdLieferantLbl: TLabel;
    SortLTeileNrBtn: TButton;
    SortTeilenrBtn: TButton;
    SortLTNameBtn: TButton;
    procedure BackBtnClick(Sender: TObject);
    procedure SortLTeileNrBtnClick(Sender: TObject);
    procedure SortLTNameBtnClick(Sender: TObject);
    procedure SortTeilenrBtnClick(Sender: TObject);
  private
    { Private-Deklarationen }
    OldFrame: TFrame;
  public
    LocalQry: TWQry;
    IdLieferant: String;
    procedure ShowFrame(myOldFrame: TFrame);
    procedure HideFrame();

  end;

implementation

{$R *.dfm}

procedure TLieferantenErklaerungenFrm.ShowFrame(myOldFrame: TFrame);
var
  SQL : String;

begin
    OldFrame := myOldFrame;
    LocalQry := Init.GetQuery;
    SQL := 'select *, TName1, TName2, Pumpenteil '
         + 'from LErklaerungen '
         + 'join Teile on LErklaerungen.TeileNr=Teile.TeileNr '
         + 'where IdLieferant= ' + IdLieferant ;
    LocalQry.RunSelectQuery(SQL);
    DataSource1.DataSet := LocalQry;
    Self.Visible := True;
end;

procedure TLieferantenErklaerungenFrm.SortLTeileNrBtnClick(Sender: TObject);
begin
   LocalQry.Sort := 'LTeileNr';
end;

procedure TLieferantenErklaerungenFrm.SortTeilenrBtnClick(Sender: TObject);
begin
   LocalQry.Sort := 'TeileNr';
end;

procedure TLieferantenErklaerungenFrm.SortLTNameBtnClick(Sender: TObject);
begin
   LocalQry.Sort := 'TName1,TName1';
end;

procedure TLieferantenErklaerungenFrm.BackBtnClick(Sender: TObject);
begin
    Self.HideFrame;
    OldFrame.Visible := True;
end;

procedure TLieferantenErklaerungenFrm.HideFrame();
begin
  if assigned(LocalQry) then
    LocalQry.Close;
  Self.Visible := False;
end;

end.
