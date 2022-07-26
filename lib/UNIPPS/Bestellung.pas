unit Bestellung;

interface

uses StueliEigenschaften,Data.Db;

type
  TWBestellung = class
  private
    function GetDruckDaten:TWWertliste;
    function GetDruckDatenAuswahl:TWWertliste;
    class var FFilter:TWFilter; //Filter zur Ausgabe der Eigenschaften

  protected

  public
    Ausgabe:TWEigenschaften;

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
    property DruckDaten:TWWertliste read GetDruckDaten;
    property DruckDatenAuswahl:TWWertliste read GetDruckDatenAuswahl;
    class property Filter:TWFilter read FFilter write FFilter;


  end;

implementation

constructor TWBestellung.Create(myRecord: TFields);
begin
    //Alle Daten in Ausgabespeicher
    Ausgabe:=TWEigenschaften.Create(myRecord);

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

function TWBestellung.GetDruckDatenAuswahl:TWWertliste;
begin
  if length(Filter)=0 then
    //Alle ausgeben
    Result:=Ausgabe.Wertliste()
  else
    //gefiltert ausgeben
    Result:=Ausgabe.Wertliste(Filter);
end;

function TWBestellung.GetDruckDaten:TWWertliste;
begin
  //Alle ausgeben
  Result:=Ausgabe.Wertliste()
end;


end.
