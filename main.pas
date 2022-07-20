unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Data.DB, Vcl.ComCtrls, Vcl.AppEvnts,
  Kundenauftrag, Tools;

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
    procedure FormCreate(Sender: TObject);

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
procedure TmainFrm.FormCreate(Sender: TObject);
begin
  //Tools initialisieren (einmalig nötig)
  //legt globale Variable und Objekte (wie Logger) an
  Tools.init;
end;

procedure TmainFrm.KA_auswerten(ka_id:string);
var ka:TZKundenauftrag;
var ld:string;
begin

  try

    //Logger oeffnen
    Tools.Log.OpenAppend(Tools.LogDir,'FullLog.txt');
    Tools.ErrLog.OpenAppend(Tools.logdir,'ErrLog.txt');

    //Ka anlegen
    ka:=TZKundenauftrag.Create(ka_id);
    //auswerten
    ka.auswerten;

  finally
    //Logger schließen
    Tools.Log.Close;
    Tools.ErrLog.Close;

  end;

end;


end.
