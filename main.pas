unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Data.DB, Vcl.ComCtrls, Vcl.AppEvnts,
  FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf,
  FireDAC.Comp.UI, Datasnap.DBClient,
  Vcl.WinXCtrls, DruckeTabelle,
  Settings, Tools, DatenModul,Preiseingabe,  PumpenDataSet, mainNonGui ;

type
  TmainFrm = class(TForm)
    Run_Btn: TButton;
    KA_id_ctrl: TEdit;
    Label1: TLabel;
    Ende_Btn: TButton;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    langBtn: TButton;
    kurzBtn: TButton;
    TestBtn: TButton;
    Drucken: TButton;
    ActivityIndicator1: TActivityIndicator;

    procedure Run_BtnClick(Sender: TObject);
    procedure Ende_BtnClick(Sender: TObject);
    procedure RunIt(Sender: TObject);
    procedure kurzBtnClick(Sender: TObject);
    procedure langBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TestBtnClick(Sender: TObject);
    procedure DruckenClick(Sender: TObject);

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
  //Logger schlie�en
  Tools.Log.Close;
  Tools.ErrLog.Close;
end;

procedure TmainFrm.TestBtnClick(Sender: TObject);
begin
  //F�lle Tabelle mit Teilumfang zur Ausgabe von Testinfos
  KaDataModule.ErzeugeAusgabeTestumfang;
  DataSource1.DataSet:=KaDataModule.AusgabeDS;

end;


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

procedure TmainFrm.DruckenClick(Sender: TObject);
var
  Ausgabe:TWDataSetPrinter;
  Index:Integer;
begin

  Ausgabe:=TWDataSetPrinter.Create(nil,'Microsoft Print to PDF');
  Ausgabe.Ausrichtungen:=['l','c','l','d#.00','l','r','r','r','r','r'];

  try
  Ausgabe.Drucken(KaDataModule.AusgabeDS);
  finally
    if Ausgabe.Drucker.Printing then
      Ausgabe.Drucker.EndDoc;
  end;

end;

//Nur zum Testen, wird automatisch von OnActivate gestartet
//und erspart CLick auf Button;
procedure TmainFrm.RunIt(Sender: TObject);
begin
  mainNonGui.RunItGui;
end;



end.
