﻿unit Bestellung;

interface

uses StueliEigenschaften,Data.Db, Datenspeicher, Datenmodul;

type
  TWBestellung = class
  private
    class var FFilter:TWFilter; //Filter zur Ausgabe der Eigenschaften
    class var FDaten:TWDatenspeicher;
    var Datensatz:TBookmark;
    function GetDruckDaten:TWWertliste;
    function GetDruckDatenAuswahl:TWWertliste;
    function GetDaten:TFields;

  protected

  public
    Ausgabe:TWEigenschaften;

    bestell_id: Integer;
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
    property DruckDaten:TWWertliste read GetDruckDaten;
    property DruckDatenAuswahl:TWWertliste read GetDruckDatenAuswahl;
    class property Filter:TWFilter read FFilter write FFilter;
    class property Daten:TWDatenspeicher read FDaten write FDaten;

  end;

implementation

constructor TWBestellung.Create(myRecord: TFields);
begin
    //Datenspeicher erzeugen, wenn noch nicht geschehen
    if FDaten=nil then
    begin
      FDaten:=TWDatenspeicher.Create(DataModule1.CDSBestellung);
    end;

    //Alle Daten in Ausgabespeicher
    Ausgabe:=TWEigenschaften.Create(myRecord);
    FDaten.Append;
    Datensatz:=FDaten.GetBookmark;

    FDaten.AddData('bestell_id',myRecord);
    FDaten.AddData('bestell_datum',myRecord);
    FDaten.AddData('preis',myRecord);
//    FDaten.AddData(myRecord);
    bestell_id := myRecord.FieldByName('bestell_id').AsInteger;
//    bestell_datum:= myRecord.FieldByName('bestell_datum').AsFloat;
//    preis:= myRecord.FieldByName('preis').AsFloat;
//    basis:= myRecord.FieldByName('basis').AsFloat;
//    pme:= myRecord.FieldByName('pme').AsInteger;
//    bme:= myRecord.FieldByName('bme').AsInteger;
//    faktlme_bme:= myRecord.FieldByName('faktlme_bme').AsFloat;
//    faktbme_pme:= myRecord.FieldByName('faktbme_pme').AsFloat;
//    netto_poswert:= myRecord.FieldByName('netto_poswert').AsFloat;
//    menge:= myRecord.FieldByName('menge').AsFloat;
//    we_menge:= myRecord.FieldByName('we_menge').AsFloat;
//    lieferant:= myRecord.FieldByName('lieferant').AsInteger;
//    kurzname:= myRecord.FieldByName('kurzname').AsString;
//    t_tg_nr:= myRecord.FieldByName('t_tg_nr').AsString;

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

function TWBestellung.GetDaten:TFields;
begin
  Daten.DataSet.GotoBookmark(Datensatz);
  Result:=Daten.DataSet.Fields;
end;

end.
