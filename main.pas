unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Kundenauftrag, Data.DB, Vcl.ComCtrls;

type
  TmainFrm = class(TForm)
    Run_Btn: TButton;
    KA_id_ctrl: TEdit;
    Label1: TLabel;
    Ende_Btn: TButton;
    DBGrid1: TDBGrid;
    procedure Run_BtnClick(Sender: TObject);
    procedure Ende_BtnClick(Sender: TObject);
    procedure KA_auswerten(ka_id:string);
    procedure RunIt(Sender: TObject);

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
  KA_auswerten(ka_id);
  //Application.MessageBox(PChar(ka_id), 'Look', MB_OK);
end;


procedure TmainFrm.Ende_BtnClick(Sender: TObject);
begin
  close
end;

procedure TmainFrm.RunIt(Sender: TObject);
begin
  //KA_auswerten('142591'); //Error
  KA_auswerten('142567'); //2Pumpen
end;

procedure TmainFrm.KA_auswerten(ka_id:string);
var ka:TZKundenauftrag;
begin
  ka:=TZKundenauftrag.Create(ka_id);
  ka.auswerten;
end;


end.
