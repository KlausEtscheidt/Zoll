unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Data.DB, Vcl.ComCtrls, Vcl.AppEvnts,
  FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf,
  FireDAC.Comp.UI, Datasnap.DBClient,
  Vcl.WinXCtrls, Kundenauftrag,
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
    Drucken: TButton;
    ActivityIndicator1: TActivityIndicator;

    procedure Run_BtnClick(Sender: TObject);
    procedure Ende_BtnClick(Sender: TObject);
    procedure RunIt(Sender: TObject);
    procedure kurzBtnClick(Sender: TObject);
    procedure langBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DruckenClick(Sender: TObject);

  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  mainFrm: TmainFrm;
  Kundenauftrag: TWKundenauftrag;

implementation

{$R *.dfm}

procedure TmainFrm.Run_BtnClick(Sender: TObject);
var KaId:string;
begin
  KaId := KA_id_ctrl.Text;
  //
  Kundenauftrag:=mainNonGui.KaAuswerten(KaId);
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

procedure TmainFrm.DruckenClick(Sender: TObject);
begin
  KaDataModule.ErzeugeAusgabeKurzFuerDoku;
  mainNonGui.ErgebnisDrucken(Kundenauftrag);
end;

//Nur zum Testen, wird automatisch von OnActivate gestartet
//und erspart CLick auf Button;
procedure TmainFrm.RunIt(Sender: TObject);
begin
  Kundenauftrag:=mainNonGui.RunItGui;

end;



end.
