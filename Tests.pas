unit Tests;

interface

uses
Tools,Settings, UnippsStueliPos;

procedure Bestellung();

implementation

procedure Bestellung();
var StuPos: TWUniStueliPos;
begin

Tools.Init;
Tools.Log.OpenNew(Settings.ApplicationBaseDir,'data\output\TestLog.txt');
Tools.ErrLog.OpenNew(Settings.ApplicationBaseDir,'data\output\TestErrLog.txt');

//DUmmy Stueli
StuPos:=TWUniStueliPos.Create(nil, 'Teil','Test',1);

//StuPos.Ausgabe.AddData('t_tg_nr','EST�45D');
StuPos.TeileNr:='233D23538PERF03';

StuPos.SucheTeilzurStueliPos;
StuPos.MengeTotal:=1.0;
StuPos.BerechnePreisDerPosition;

Tools.Log.Close;
Tools.ErrLog.Close;

end;

end.
