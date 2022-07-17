program GuiTestLogger;

uses
  Vcl.Forms,
  Testform in '..\Testform.pas' {Form1},
  Tools in '..\..\..\lib\Tools\Tools.pas' {Wkz: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
