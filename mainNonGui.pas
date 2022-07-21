unit mainNonGui;

interface

uses   Kundenauftrag, Tools;

procedure KaAuswerten(ka_id:string);

implementation

procedure KaAuswerten(ka_id:string);
var ka:TWKundenauftrag;
begin

  try

    //Globals setzen und initialiseren
    Tools.Init;

    //Ka anlegen
    ka:=TWKundenauftrag.Create(ka_id);

    //Logger oeffnen
    Tools.Log.OpenAppend(Tools.LogDir,'FullLog.txt');
    Tools.ErrLog.OpenAppend(Tools.logdir,'ErrLog.txt');

    //auswerten
    ka.auswerten;

  finally
    //Logger schlie�en
    Tools.Log.Close;
    Tools.ErrLog.Close;

  end;

end;


end.
