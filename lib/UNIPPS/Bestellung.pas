unit Bestellung;

interface

uses Data.Db, PumpenDataSet, Datenmodul;

type
  TWBestellung = class
  private

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
    procedure DatenInAusgabe(ZielDS:TWDataSet);

  end;

implementation

constructor TWBestellung.Create(myRecord: TFields);
begin

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

end;

procedure TWBestellung.DatenInAusgabe(ZielDS:TWDataSet);
begin
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
end;

end.
