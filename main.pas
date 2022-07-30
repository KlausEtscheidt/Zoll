unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Data.DB, Vcl.ComCtrls, Vcl.AppEvnts,
  mainNonGui, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf,
  FireDAC.Comp.UI, Datasnap.DBClient, Tools, DatenModul, PumpenDataSet;

type
  TmainFrm = class(TForm)
    Run_Btn: TButton;
    KA_id_ctrl: TEdit;
    Label1: TLabel;
    Ende_Btn: TButton;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    AusgabeDS: TWDataSet;
    langBtn: TButton;
    kurzBtn: TButton;

    procedure Run_BtnClick(Sender: TObject);
    procedure Ende_BtnClick(Sender: TObject);
    procedure RunIt(Sender: TObject);
    procedure kurzBtnClick(Sender: TObject);
    procedure langBtnClick(Sender: TObject);

  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  mainFrm: TmainFrm;

implementation

{$R *.dfm}

procedure TmainFrm.Run_BtnClick(Sender: TObject);
var ka_id:string;
begin
  ka_id := KA_id_ctrl.Text;
  //
  mainNonGui.KaAuswerten(ka_id);
  //Application.MessageBox(PChar(ka_id), 'Look', MB_OK);
end;


procedure TmainFrm.Ende_BtnClick(Sender: TObject);
begin
  close
end;

//Zum Testen, wird automatisch von OnShow gestartet
procedure TmainFrm.kurzBtnClick(Sender: TObject);
begin
  //F�lle Tabelle mit Teilumfang zur Ausgabe der Doku der Kalkulation
  KaDataModule.ErzeugeAusgabeKurzFuerDoku;
  DataSource1.DataSet:=KaDataModule.AusgabeDS;
end;

procedure TmainFrm.langBtnClick(Sender: TObject);
begin
  //F�lle Tabelle mit vollem Umfang (z Debuggen)
  KaDataModule.ErzeugeAusgabeVollFuerDebug;
  DataSource1.DataSet:=KaDataModule.AusgabeDS;

end;

procedure TmainFrm.RunIt(Sender: TObject);
begin
Tools.Init;
Tools.GuiMode:=True;
mainfrm.langBtn.Enabled:=True;
mainfrm.kurzBtn.Enabled:=True;
mainNonGui.RunItGui;
end;



end.
