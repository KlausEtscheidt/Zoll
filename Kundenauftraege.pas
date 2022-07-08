unit Kundenauftraege;

interface

uses Vcl.Forms, SQL, SQLite;

procedure auswerten(ka_id:string);

implementation


procedure auswerten(ka_id:string);


begin
  SQL.suche_Kundenauftragspositionen(ka_id);
  //SQLite.DataModule1.FDQuery1.Open('select * from stamm;')  ;
  //SQLite.TDataModule1.FDQuery1.
  //Application.MessageBox(PChar(ka_id), 'in KA');

end;

end.
