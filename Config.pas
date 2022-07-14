unit Config;

interface

uses Vcl.Forms, System.SysUtils,System.IOUtils ;

procedure cfg_init();

var
  basedir:string;
  logdir:string;

implementation

procedure cfg_init();
//  var
//  basedir: TPath;
begin
  basedir:= TPath.GetDirectoryName(Application.Exename);
  basedir:= TDirectory.GetParent(TDirectory.GetParent(basedir));
  logdir:=basedir + '\output';
end;
end.
