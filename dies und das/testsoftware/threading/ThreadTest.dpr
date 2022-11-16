program ThreadTest;

uses
  Vcl.Forms,
  mainfrm in 'mainfrm.pas' {mainForm},
  Worker in 'Worker.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TmainForm, mainForm);
  Application.Run;
end.
