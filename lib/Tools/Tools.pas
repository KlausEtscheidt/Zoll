//Die unit dient zum Abspeichern globaler Werte und nicht visueller Komponenten
unit Tools;

interface

uses
  Vcl.Forms, System.SysUtils, System.IOUtils, System.Classes, Logger;

type
  TWkz = class(TDataModule)
    Log: TLogFile;
    ErrLog: TLogFile;
    CSVKurz: TLogFile;
    CSVLang: TLogFile;
    //Dient zum Vorbelegen globaler Werte beim Programmstart
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Wkz: TWkz;
  basedir:String;
  logdir:String;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TWkz.DataModuleCreate(Sender: TObject);
begin
  basedir:= TPath.GetDirectoryName(Application.Exename);
  basedir:= TDirectory.GetParent(TDirectory.GetParent(basedir));
  logdir:=basedir + '\data\output';
end;

end.
