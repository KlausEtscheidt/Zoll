unit LeklTeileEingabeDlg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, LeklTeileEingabeFrame, Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TLeklTeileEingabeDialog = class(TForm)
    LeklTeileEingabeFrm: TLieferantenErklaerungenFrm;
    GridPanel1: TGridPanel;
    OKBtn: TButton;
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  LeklTeileEingabeDialog: TLeklTeileEingabeDialog;

implementation

{$R *.dfm}

procedure TLeklTeileEingabeDialog.FormShow(Sender: TObject);
begin
  LeklTeileEingabeFrm.Init;
  LeklTeileEingabeFrm.Show;
end;

end.
