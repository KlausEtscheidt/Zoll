unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Kundenauftrag, Data.DB, Vcl.ComCtrls, Vcl.AppEvnts,
  Tools  ;

type
  TmainFrm = class(TForm)
    Run_Btn: TButton;
    KA_id_ctrl: TEdit;
    Label1: TLabel;
    Ende_Btn: TButton;

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

//Zum Testen, wird automatisch von OnShow gestartet
procedure TmainFrm.RunIt(Sender: TObject);
begin
//  KA_auswerten('142591'); //Error
  KA_auswerten('142567'); //2Pumpen
//  KA_auswerten('142302'); //Ersatz

end;

//Haupteinsprung zum Auswerten eines Kundenauftrages
procedure TmainFrm.KA_auswerten(ka_id:string);
var ka:TZKundenauftrag;

begin
  //Logger oeffnen
  Wkz.Log.FileDir:=Tools.logdir;
  if not Wkz.Log.opened then
    Wkz.Log.Open;
  Wkz.Log.ClearContent;
  Wkz.ErrLog.FileDir:=Tools.logdir;
  Wkz.ErrLog.Open;
  Wkz.ErrLog.ClearContent;

  //Ka anlegen
  ka:=TZKundenauftrag.Create(ka_id);
  //auswerten
  ka.auswerten;

  //Logger schlieﬂen
  Wkz.Log.Close;
  Wkz.ErrLog.Close;

end;


end.
