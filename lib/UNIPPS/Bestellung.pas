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
    BestellTeileNr: String;
    BestellDatum: Double;
    Preis: Double;
    Basis: Double;
    Pme: Integer;
    Bme: Integer;
    FaktLmeBme: Double;
    FaktBmePme: Double;
    NettoPoswert: Double;
    BestMenge: Double;
    WeMenge: Double;
    Lieferant: Integer;
    Kurzname: String;

    constructor Create(myRecord: TFields);
    procedure HoleDatensatz(ZielDS:TWDataSet);
    class property Filter:TWFilter read FFilter write FFilter;
    class property Daten:TWDataSet read FDaten write FDaten;
    procedure DatenInAusgabe(ZielDS:TWDataSet);

  end;

implementation

constructor TWBestellung.Create(myRecord: TFields);
begin
    //Datenspeicher erzeugen, wenn noch nicht geschehen
    if FDaten=nil then
    begin
      FDaten:=KaDataModule.BestellungDS;
      FDaten.CreateDataSet;
      FDaten.Active:=True;
    end;

    //Alle Daten in Ausgabespeicher
    FDaten.Append;
    FDaten.AddData(myRecord);

    BestellId := myRecord.FieldByName('bestell_id').AsInteger;
    BestellTeileNr:= myRecord.FieldByName('best_t_tg_nr').AsString;
    BestellDatum:= myRecord.FieldByName('bestell_datum').AsFloat;
    Preis:= myRecord.FieldByName('preis').AsFloat;
    Basis:= myRecord.FieldByName('basis').AsFloat;
    Pme:= myRecord.FieldByName('pme').AsInteger;
    Bme:= myRecord.FieldByName('bme').AsInteger;
    FaktLmeBme:= myRecord.FieldByName('faktlme_bme').AsFloat;
    FaktBmePme:= myRecord.FieldByName('faktbme_pme').AsFloat;
    NettoPoswert:= myRecord.FieldByName('netto_poswert').AsFloat;
    BestMenge:= myRecord.FieldByName('best_menge').AsFloat;
    WeMenge:= myRecord.FieldByName('we_menge').AsFloat;
    Lieferant:= myRecord.FieldByName('lieferant').AsInteger;
    Kurzname:= myRecord.FieldByName('kurzname').AsString;

    FDaten.Post;
    DatensatzMerker:=FDaten.GetBookmark;

end;

procedure TWBestellung.DatenInAusgabe(ZielDS:TWDataSet);
begin
  //ZielDS.Append;
  ZielDS.AddData('bestell_id',BestellId);
  ZielDS.AddData('best_t_tg_nr',BestellTeileNr);
  ZielDS.AddData('bestell_datum',BestellDatum);
  ZielDS.AddData('preis',Preis);
  ZielDS.AddData('basis',Basis);
  ZielDS.AddData('pme',Pme);
  ZielDS.AddData('bme',Bme);
  ZielDS.AddData('faktlme_bme',FaktLmeBme);
  ZielDS.AddData('faktbme_pme',FaktBmePme);
  ZielDS.AddData('netto_poswert',NettoPoswert);
  ZielDS.AddData('best_menge',BestMenge);
  ZielDS.AddData('we_menge',WeMenge);
  ZielDS.AddData('lieferant',Lieferant);
  ZielDS.AddData('kurzname',Kurzname);

  //ZielDS.Post;
end;


procedure TWBestellung.HoleDatensatz(ZielDS:TWDataSet);
begin
  Daten.GotoBookmark(DatensatzMerker);
  ZielDS.AddData(Daten.Fields);
end;


end.
