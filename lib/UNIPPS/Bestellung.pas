unit Bestellung;

interface

uses StueliEigenschaften,Data.Db, PumpenDataSet,
      AusgabenFactory,Datenmodul;

type
  TWBestellung = class
  private
    class var FFilter:TWFilter; //Filter zur Ausgabe der Eigenschaften
    class var FDaten:TWDataSet;
    var DatensatzMerker:TBookmark;

  protected

  public

    BestellId: Integer;
//    bestell_datum: Double;
//    preis: Double;
//    basis: Double;
//    pme: Integer;
//    bme: Integer;
//    faktlme_bme: Double;
//    faktbme_pme: Double;
//    netto_poswert: Double;
//    menge: Double;
//    we_menge: Double;
//    lieferant: Integer;
//    kurzname: String;
//    t_tg_nr: String;
    constructor Create(myRecord: TFields);
    procedure HoleDatensatz(ZielDS:TWDataSet);
    class property Filter:TWFilter read FFilter write FFilter;
    class property Daten:TWDataSet read FDaten write FDaten;

  end;

implementation

constructor TWBestellung.Create(myRecord: TFields);
begin
    //Datenspeicher erzeugen, wenn noch nicht geschehen
    if FDaten=nil then
    begin
      FDaten:=DataModule1.BestellungDS;
      FDaten.CreateDataSet;
      FDaten.Active:=True;
    end;

    //Alle Daten in Ausgabespeicher
    FDaten.Append;
    FDaten.AddData(myRecord);
    BestellId := myRecord.FieldByName('bestell_id').AsInteger;

    FDaten.Post;
    DatensatzMerker:=FDaten.GetBookmark;

end;

procedure TWBestellung.HoleDatensatz(ZielDS:TWDataSet);
begin
  Daten.GotoBookmark(DatensatzMerker);
  ZielDS.AddData(Daten.Fields);
end;


end.
