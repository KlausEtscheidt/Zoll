unit SQL;

interface

uses Vcl.Forms,SQLite,FireDAC.Comp.Client;

procedure suche_Kundenauftragspositionen(ka_id:string);

implementation

procedure suche_Kundenauftragspositionen(ka_id:string);
begin
  var nrec: integer;
  var Qry : TFDQuery;
  var name: String;

  Qry := SQLite.SQLite_Reader.Query;
  Qry.Open('select * from stamm;')  ;
  nrec:=Qry.RowsAffected;

  while not Qry.EOF do
   begin
    // do something here with each record
    name := Qry.FieldByName('Name').AsString ;
    Qry.Next;
   end;
  Application.MessageBox(PChar(ka_id), 'in SQL');
  //Application.MessageBox(PChar(nrec), 'in SQL');
end;

end.
