unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Kundenauftraege;

type
  TmainFrm = class(TForm)
    Run_Btn: TButton;
    KA_id_ctrl: TEdit;
    Label1: TLabel;
    Ende_Btn: TButton;
    procedure Run_BtnClick(Sender: TObject);
    procedure Ende_BtnClick(Sender: TObject);
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
  Kundenauftraege.auswerten(ka_id);
  //Application.MessageBox(PChar(ka_id), 'Look', MB_OK);
end;

procedure TmainFrm.Ende_BtnClick(Sender: TObject);
begin
  close
end;

end.
