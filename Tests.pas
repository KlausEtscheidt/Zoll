unit Tests;

interface

uses Tools, UnippsStueliPos;

procedure Bestellung();

implementation

procedure Bestellung();
var StuPos: TWUniStueliPos;
begin

Tools.Init;
Tools.Log.OpenNew(Tools.ApplicationBaseDir,'data\output\TestLog.txt');
Tools.ErrLog.OpenNew(Tools.ApplicationBaseDir,'data\output\TestErrLog.txt');

//DUmmy Stueli
StuPos:=TWUniStueliPos.Create(nil,'Test','1',1,1);

StuPos.Ausgabe.AddData('t_tg_nr','ESTØ45D');
StuPos.SucheTeilzurStueliPos;

Tools.Log.Close;
Tools.ErrLog.Close;

end;

end.
