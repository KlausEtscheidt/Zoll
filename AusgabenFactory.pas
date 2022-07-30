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
    procedure Append;
    procedure Post;
    procedure AddData(Feld:TField);
    constructor Create;

  end;

implementation

  uses main;

  constructor TWAusgabenFact.Create;
  begin
    CDS:=mainFrm.AusgabeDS;
  end;

  procedure TWAusgabenFact.Append();
  begin
    CDS.Active:=True;
    CDS.Append;
  end;

  procedure TWAusgabenFact.Post;
  begin
    CDS.Post;
  end;

  procedure TWAusgabenFact.AddData(Feld:TField);
  begin
    CDS.FieldByName(Feld.FieldName).Value:=Feld.Value;
  end;

  procedure TWAusgabenFact.ZuTabelle(Felder:TWWertliste);
  var
//    CDS:TClientDataSet;
    Wert:String;
    I:Integer;
    Feld:TField;
  begin


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
  CDS:=mainFrm.AusgabeDS;

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
