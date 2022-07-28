unit AusgabenFactory;

interface

uses StueliEigenschaften,Data.DB, Datasnap.DBClient;

type
  TWAusgabenFact=class
  private

  public
    CDS:TClientDataSet;
    procedure DefiniereTabelle(FeldNamen:TWFilter;Clear:Boolean;Create:Boolean);
    procedure ZuTabelle(Felder:TWWertliste);

  end;

implementation

  uses main;


  procedure TWAusgabenFact.ZuTabelle(Felder:TWWertliste);
  var
//    CDS:TClientDataSet;
    Wert:String;
    I:Integer;
    Feld:TField;
  begin

    CDS:=mainFrm.ClientDataSet;
    CDS.Active:=True;
    CDS.Append;
    for I := 0 to Felder.Count -1 do
    begin
      Feld:=CDS.Fields[I];
      Feld.AsString:=Felder[I];
    end;


  end;

  procedure TWAusgabenFact.DefiniereTabelle(FeldNamen:TWFilter;
                                                Clear:Boolean;Create:Boolean);
  var
//    MyCDS:TClientDataSet;
    FeldName:String;
  begin
  CDS:=mainFrm.ClientDataSet;

  if Clear then CDS.FieldDefs.Clear;

  for FeldName in FeldNamen do
  begin

    with CDS.FieldDefs.AddFieldDef do
    begin
      DataType := ftString;
      Size := 10;
      Name := FeldName;
    end;


  end;

  if Create then CDS.CreateDataSet;

end;


end.
