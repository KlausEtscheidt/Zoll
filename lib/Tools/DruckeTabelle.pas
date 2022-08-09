unit DruckeTabelle;

interface

  uses SysUtils, System.Classes,  System.Generics.Collections,
        Vcl.Graphics, Data.DB, Printers,
       DatenModul,DruckBlatt;

  type
//     TWAusrichtung = TWAusrichtungsArten;  #
     TWColumnAlignment = record
        C:Integer;  //Spalte
        case J: TWAusrichtungsArten of   //Kenner für Ausrichtung
          d: (P:Integer) ;         //Nachkommastellen
      end;

    TWColumnAlignments = array of TWColumnAlignment;

  type TWDataSetPrinter = class(TWBlatt)
    private
    public
      type
        //Überschreibe Unterklasse "Inhalts-Bereich" der Basisklasee
        TWTabelle = class(TWInhalt)
          const
            CellMargin=20;   //Abstand Text zum Rahmen drumrum
            DefaultFeldHoehe=300;
          private
            Daten:TDataSet;
            FeldBreiten:array of Integer; //Netto-Breiten der Spalten
            FeldX0:array of Integer;     //Start-Pos für Zell-Rahmen
            FFeldHoehe:Integer;
            FAlign:TWColumnAlignments;
            procedure DruckeTabellenFeld(Spalte:Integer;
                             Wert:String;Kopfzeile:Boolean=False);
            procedure DruckeTabellenKopf();
            procedure DruckeTabellenReihe(Felder:TFields);
            procedure Drucke;
            procedure HoleBreiten();
            procedure HoleAusrichtungen();
            function FeldToStr(Feld:TField):String;
          public
            procedure SetAusrichtungen(ColAligns:array of TWColumnAlignment);
            property DataSet:TDataSet read Daten;
            property FeldHoehe:Integer read FFeldHoehe write FFeldHoehe;
            property Ausrichtungen:TWColumnAlignments read FAlign;

        end;

      var Tabelle:TWTabelle;
      constructor Create(AOwner:TComponent;PrinterName:String;DS:TDataSet);
      procedure Drucken();

    end;

implementation

constructor TWDataSetPrinter.Create(AOwner:TComponent;PrinterName:String;
                                                              DS:TDataSet);
begin
  inherited Create(AOwner,PrinterName);
  //Der Inhalts-Bereich des Blattes wird durch die Tabelle dargestellt
  Tabelle:=TWTabelle.Create(Self);
  Tabelle.FeldHoehe:=Tabelle.DefaultFeldHoehe;
  Tabelle.Daten:=DS;
  Tabelle.HoleAusrichtungen;

end;

/////////////////////////////////////////////////////////////////////////
procedure TWDataSetPrinter.TWTabelle.HoleAusrichtungen();
var
  I:Integer;
  rec:TWColumnAlignment;

begin
  setlength(FAlign,Daten.FieldCount);

  for I := 0 to Daten.FieldCount-1 do
  begin
    rec.C:=-1;rec.P:=2; //Column uninteressant;default 2 Nachkommastellen
    case Daten.Fields.Fields[I].Alignment of
      taLeftJustify: rec.J:=l;
      taCenter: rec.J:=c;
      taRightJustify: rec.J:=r;
    end;

  FAlign[I]:=rec;

  end;

end;


procedure TWDataSetPrinter.TWTabelle.SetAusrichtungen(
                                   ColAligns:array of TWColumnAlignment);
var
  I:Integer;
begin
  //Sonderfälle aus ColAligns in Gesamt-Array aller Spalten eintragen
  for I:=0 to length(ColAligns)-1 do
    Self.FAlign[ColAligns[I].C]:=ColAligns[I];
end;

function TWDataSetPrinter.TWTabelle.FeldToStr(Feld:TField):String;
var
  FloatFeld:TFloatField;
begin
    if (Feld.DataType=ftFloat) then
      begin
        FloatFeld:=TFloatField(Feld);
        Result:=FormatFloat(FloatFeld.DisplayFormat,FloatFeld.AsFloat);
      end
    else
    if (Feld.DataType=ftCurrency) then
      begin
        FloatFeld:=TFloatField(Feld);
        Result:=FormatFloat('0.00 €',FloatFeld.AsFloat);
      end
    else
      Result:=Feld.AsString;

end;

procedure TWDataSetPrinter.TWTabelle.HoleBreiten();
var
  Feld:TField;
  Breite,Hoehe,I:Integer;
  Wert:String;
begin

  setlength(FeldBreiten,Daten.Fields.Count);
  FeldHoehe:=0;
  Self.Canvas.Font.Size := Self.FontSize;

  //Bestimme Breiten der Header
  for I:=0 to Daten.Fields.Count-1 do
  begin
    Feld:=Daten.Fields.Fields[I];
    FeldBreiten[I]:=Self.Canvas.TextWidth(Feld.DisplayName);
    Hoehe:=Self.Canvas.TextHeight(Feld.DisplayName);
    if Hoehe> FeldHoehe then FeldHoehe:= Hoehe;
  end;

  //Bestimme Breiten der Inhalte
  while not Daten.Eof do
  begin
    for I:=0 to Daten.Fields.Count-1 do
    begin
      Feld:=Daten.Fields.Fields[I];
      Wert:=FeldToStr(Feld);
      Breite:=Self.Canvas.TextWidth(Wert);
      Hoehe:=Self.Canvas.TextHeight(Wert);
      if Breite>FeldBreiten[I] then
        FeldBreiten[I]:=Breite;
      if Hoehe> FeldHoehe then FeldHoehe:= Hoehe;
    end;
    Daten.Next;
  end;

  //Berechne die Startposition der Texte in den Zellen
  setlength(FeldX0,Daten.Fields.Count);
  FeldX0[0]:=0;
  for I := 1 to Daten.Fields.Count-1 do
     FeldX0[I]:=FeldX0[I-1]+FeldBreiten[I-1]+2*CellMargin;
  FeldHoehe:=FeldHoehe+2*CellMargin;
end;

//####################################################################
procedure TWDataSetPrinter.TWTabelle.DruckeTabellenFeld(Spalte:Integer;
                       Wert:String;Kopfzeile:Boolean=False);
var
  Ausrichtung:TWAusrichtungsArten;
  X0,Y0,X1,Y1:Integer;
  XText:Integer;
  TextBreite:Integer;
  FormatStr:String;
  FloatWert:Double;
  FloatWertStr:String;

begin
    Y0:=Self.CurrY;
    Y1:=Y0+FeldHoehe;
    X0:=FeldX0[Spalte]+Self.Blatt.Left ;
    X1:=X0+FeldBreiten[Spalte]+2*CellMargin;

    //Rahmen der Zelle drucken
    Self.Canvas.Rectangle(X0,Y0,X1,Y1);

    if Kopfzeile then
      Ausrichtung:=c
    else
      Ausrichtung:=Ausrichtungen[Spalte].J;

    XText:=Blatt.PosHorizAusgerichtet(Wert,FeldBreiten[Spalte],
                Ausrichtung,3);

    Self.Canvas.TextOut(X0+CellMargin+XText, Self.CurrY + CellMargin, Wert);
end;

//######################################################################
procedure TWDataSetPrinter.TWTabelle.DruckeTabellenKopf();
var
  Feld:TField;
  I:Integer;
begin
  Self.Canvas.Font.Size := Self.FontSize;

  for I:=0 to Daten.Fields.Count-1 do
  begin
    Feld:=Daten.Fields.Fields[I];
    DruckeTabellenFeld(I, Feld.DisplayName, True);
  end;

end;

//#######################################################################
procedure TWDataSetPrinter.TWTabelle.DruckeTabellenReihe(Felder:TFields);
var
  Feld:TField;
  FloatFeld:TFloatField;
  I:Integer;
  Wert:String;

begin
  Self.Canvas.Font.Size := Self.FontSize;

  for I:=0 to Felder.Count-1 do
  begin
    Feld:=Felder.Fields[I];
    Wert:=FeldToStr(Feld);
    DruckeTabellenFeld(I, Wert);
  end;
end;

procedure TWDataSetPrinter.TWTabelle.Drucke;
var
  Y:Integer;
begin
  HoleBreiten;
//  HoleAusrichtungen;

  DruckeTabellenKopf;
  Self.CurrYAdd(FeldHoehe); //Ueberschriften beruecksictigen

  Daten.First;
  while not Daten.Eof do
  begin
    DruckeTabellenReihe(Daten.Fields);
    Self.CurrYAdd(FeldHoehe);
    var bot:integer;
    bot:=Self.Bottom;
    if Self.CurrY+FeldHoehe>Self.Bottom then
    begin
      Blatt.Fusszeile.Drucken;
      Blatt.Drucker.NewPage;
      Blatt.Kopfzeile.Drucken;
      Self.CurrY:=Self.Top+Self.FreiraumOben;
      DruckeTabellenKopf;
      Self.CurrYAdd(FeldHoehe); //Ueberschriften beruecksictigen
    end;
    Daten.Next;
  end;
end;

procedure TWDataSetPrinter.Drucken();
begin
  Drucker.Title := 'Druckauftrag 1';
  Drucker.BeginDoc;
  Kopfzeile.Drucken;
  Dokumentenkopf.Drucken; //einmalig je Druckvorgang
  //Starte unter Dokumentenkopf (inkl Freiraum)
  Tabelle.CurrY:=Dokumentenkopf.Bottom+Tabelle.FreiraumOben;
  Tabelle.Drucke;
//  printer.canvas.Canvas.StretchDraw(rect1,bmp);
  Fusszeile.Drucken;
  Drucker.EndDoc;
end;


end.
