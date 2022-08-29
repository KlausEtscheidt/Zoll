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
  ZielDS.AddValue('bestell_id',BestellId);
  ZielDS.AddValue('best_t_tg_nr',BestellTeileNr);
  ZielDS.AddValue('bestell_datum',BestellDatum);
  ZielDS.AddValue('preis',Preis);
  ZielDS.AddValue('basis',Basis);
  ZielDS.AddValue('pme',Pme);
  ZielDS.AddValue('bme',Bme);
  ZielDS.AddValue('faktlme_bme',FaktLmeBme);
  ZielDS.AddValue('faktbme_pme',FaktBmePme);
  ZielDS.AddValue('netto_poswert',NettoPoswert);
  ZielDS.AddValue('best_menge',BestMenge);
  ZielDS.AddValue('we_menge',WeMenge);
  ZielDS.AddValue('lieferant',Lieferant);
  ZielDS.AddValue('kurzname',Kurzname);
end;

end.
