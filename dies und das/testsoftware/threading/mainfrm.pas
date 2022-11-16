unit mainfrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Worker;

type
  TmainForm = class(TForm)
    StartBtn: TButton;
    EndeBtn: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    StopBtn: TButton;
    procedure StartBtnClick(Sender: TObject);
    procedure EndeBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    stop:Boolean;
  end;

var
  mainForm: TmainForm;

implementation

{$R *.dfm}

procedure TmainForm.EndeBtnClick(Sender: TObject);
begin
  close;
end;

procedure TmainForm.StartBtnClick(Sender: TObject);
var
  myWorkerThread:TmyWorker;

begin
  stop:=False;
  myWorkerThread:=TmyWorker.Create(False);
end;

procedure TmainForm.StopBtnClick(Sender: TObject);
begin
  stop:=True;
end;

end.
