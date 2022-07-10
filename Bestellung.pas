unit Bestellung;

interface

uses Data.Db, DBZugriff;

type
  TZBestellung = class
  private

  protected

  public
    bestell_id: Integer;
    bestell_datum: Double;
    preis: Double;
    basis: Double;
    pme: Integer;
    bme: Integer;
    faktlme_bme: Double;
    faktbme_pme: Double;
    netto_poswert: Double;
    menge: Double;
    we_menge: Double;
    lieferant: Integer;
    kurzname: String;
    t_tg_nr: String;
    constructor Create(myRecord: TFields);

  published

  end;

implementation

constructor TZBestellung.Create(myRecord: TFields);
begin
    bestell_id := myRecord.FieldByName('bestell_id').AsInteger;
    bestell_datum:= myRecord.FieldByName('bestell_datum').AsFloat;
    preis:= myRecord.FieldByName('preis').AsFloat;
    basis:= myRecord.FieldByName('basis').AsFloat;
    pme:= myRecord.FieldByName('pme').AsInteger;
    bme:= myRecord.FieldByName('bme').AsInteger;
    faktlme_bme:= myRecord.FieldByName('faktlme_bme').AsFloat;
    faktbme_pme:= myRecord.FieldByName('faktbme_pme').AsFloat;
    netto_poswert:= myRecord.FieldByName('netto_poswert').AsFloat;
    menge:= myRecord.FieldByName('menge').AsFloat;
    we_menge:= myRecord.FieldByName('we_menge').AsFloat;
    lieferant:= myRecord.FieldByName('lieferant').AsInteger;
    kurzname:= myRecord.FieldByName('kurzname').AsString;
    t_tg_nr:= myRecord.FieldByName('t_tg_nr').AsString;
end;

end.
