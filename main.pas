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
    TestBtn: TButton;

    procedure Run_BtnClick(Sender: TObject);
    procedure Ende_BtnClick(Sender: TObject);
    procedure RunIt(Sender: TObject);
    procedure kurzBtnClick(Sender: TObject);
    procedure langBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TestBtnClick(Sender: TObject);

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

procedure TmainFrm.FormDestroy(Sender: TObject);
begin
  //Logger schließen
  Tools.Log.Close;
  Tools.ErrLog.Close;
end;

procedure TmainFrm.TestBtnClick(Sender: TObject);
begin
  //Fülle Tabelle mit Teilumfang zur Ausgabe von Testinfos
  KaDataModule.ErzeugeAusgabeTestumfang;
  DataSource1.DataSet:=KaDataModule.AusgabeDS;

end;


procedure TmainFrm.kurzBtnClick(Sender: TObject);
begin
  //Fülle Tabelle mit Teilumfang zur Ausgabe der Doku der Kalkulation
  KaDataModule.ErzeugeAusgabeKurzFuerDoku;
  DataSource1.DataSet:=KaDataModule.AusgabeDS;
end;

procedure TmainFrm.langBtnClick(Sender: TObject);
begin
  //Fülle Tabelle mit vollem Umfang (z Debuggen)
  KaDataModule.ErzeugeAusgabeVollFuerDebug;
  DataSource1.DataSet:=KaDataModule.AusgabeDS;

end;

//Nur zum Testen, wird automatisch von OnActivate gestartet
//und erspart CLick auf Button;
procedure TmainFrm.RunIt(Sender: TObject);
begin
  Tools.Init;
  Tools.GuiMode:=True;
  //Logger oeffnen
  Tools.Log.OpenNew(Tools.ApplicationBaseDir,'data\output\Log.txt');
  Tools.ErrLog.OpenNew(Tools.ApplicationBaseDir,'data\output\ErrLog.txt');
  mainfrm.langBtn.Enabled:=True;
  mainfrm.TestBtn.Enabled:=True;
  mainfrm.kurzBtn.Enabled:=True;
  mainNonGui.RunItGui;
end;



end.
