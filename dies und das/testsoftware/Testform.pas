unit Testform;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,Tools;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Tools.init();
  Log.OpenNew(Tools.LogDir, 'testlog.txt');
  Log.Log('11111 gui 1111111111');
  Log.Close;
  Log.OpenAppend(Tools.LogDir, 'testlog.txt');
  Log.Log('1111 222222222 11111111111');
  Log.Log('111111 3333333 111111111');
  Log.Close;
end;

end.
