program AE;

uses
  Vcl.Forms,
  mainfrm in 'mainfrm.pas' {mainform};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tmainform, mainform);
  Application.Run;
end.
