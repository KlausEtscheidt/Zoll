unit Drucken;

interface

  uses SysUtils, System.Classes, Vcl.Graphics, Data.DB, Printers,
       DatenModul,DruckBlatt;

  const
    DefaultFeldHoehe=300;
    CellMargin=20;   //Abstand Text zum Rahmen drumrum

  type TWAlign = array of String;

  type TWDataSetPrinter = class(TWBlatt)
    private
      P:TPrinter;
      Daten:TDataSet;
      FeldBreiten:array of Integer; //Netto-Breiten der Spalten
      FeldX0:array of Integer;     //Start-Pos für Zell-Rahmen
      FFeldHoehe:Integer;
      FAlign:TWAlign;
      FFooterHoehe:Integer;
      Y0Footer:Integer;
      procedure DruckeTabellenFeld(Spalte:Integer;
                       Wert:String;Kopfzeile:Boolean=False);
      procedure DruckeTabellenKopf();
      procedure DruckeTabellenReihe(Felder:TFields);
      procedure DruckeTabelle();
//      procedure DruckeDokumentkopf;
//      procedure DruckeKopfzeile;
//      procedure DruckeFusszeile;
      procedure HoleBreiten();
      function FeldToStr(Feld:TField):String;
    public
      constructor Create(AOwner:TComponent);
      procedure Drucken(ADataSet:TDataSet);
      property DataSet:TDataSet read Daten write Daten;
      property FeldHoehe:Integer read FFeldHoehe write FFeldHoehe;
      property Ausrichtungen:TWAlign read FAlign write FAlign;

    end;

  procedure test1;

implementation

constructor TWDataSetPrinter.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FeldHoehe:=DefaultFeldHoehe;
  //Als Abkürzung
  P:=Drucker;

  //Y0Footer:=P.PageHeight-FooterHoehe;


end;

/////////////////////////////////////////////////////////////////////////

function TWDataSetPrinter.FeldToStr(Feld:TField):String;
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

procedure TWDataSetPrinter.HoleBreiten();
var
  Feld:TField;
  Breite,Hoehe,I:Integer;
  Wert:String;
begin

  setlength(FeldBreiten,Daten.Fields.Count);
  FeldHoehe:=0;
  P.Canvas.Font.Size := Inhalt.FontSize;

  //Bestimme Breiten der Header
  for I:=0 to Daten.Fields.Count-1 do
  begin
    Feld:=Daten.Fields.Fields[I];
    FeldBreiten[I]:=P.Canvas.TextWidth(Feld.DisplayName);
    Hoehe:=P.Canvas.TextHeight(Feld.DisplayName);
    if Hoehe> FeldHoehe then FeldHoehe:= Hoehe;
  end;

  //Bestimme Breiten der Inhalte
  while not Daten.Eof do
  begin
    for I:=0 to Daten.Fields.Count-1 do
    begin
      Feld:=Daten.Fields.Fields[I];
      Wert:=FeldToStr(Feld);
      Breite:=P.Canvas.TextWidth(Wert);
      Hoehe:=P.Canvas.TextHeight(Wert);
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
procedure TWDataSetPrinter.DruckeTabellenFeld(Spalte:Integer;
                       Wert:String;Kopfzeile:Boolean=False);
var
  Ausrichtung:String;
  X0,Y0,X1,Y1:Integer;
  XText:Integer;
  TextBreite:Integer;
  bleibtFrei:Double;
  FormatStr:String;
  FloatWert:Double;
  FloatWertStr:String;

begin
    Y0:=Inhalt.CurrY;
    Y1:=Y0+FeldHoehe;
    X0:=FeldX0[Spalte]+Self.Left ;
    X1:=X0+FeldBreiten[Spalte]+2*CellMargin;

    //Rahmen der Zelle
    P.Canvas.Rectangle(X0,Y0,X1,Y1);

    //X0 fuer Text in Abhängigkeit der Ausrichtung berechnen
    TextBreite:=P.Canvas.TextWidth(Wert);

    if Kopfzeile then
      Ausrichtung:='c'
    else if (Spalte>length(Ausrichtungen)-1) then
      Ausrichtung:='l'
    else
      Ausrichtung:=Ausrichtungen[Spalte];


    if Ausrichtung='l' then
      XText:=X0+CellMargin

    else if Ausrichtung='c' then
    begin
      bleibtFrei:=Double(FeldBreiten[Spalte]-TextBreite)/2;
      XText:=X0+CellMargin+Trunc(bleibtFrei);
    end

    else if Ausrichtung='r' then
      XText:=X1-CellMargin-TextBreite  //X1 ist rechter Zellrand

    //Ausgabe nach Komma ausgerichtet bei unterschiedlichen Nachkommastellen
    else if Ausrichtung.SubString(0,1)='d' then
    begin
      FloatWert:=StrToFloat(Wert);
      FormatStr:=Ausrichtungen[Spalte].SubString(1);
      FloatWertStr:=FormatFloat(FormatStr,FloatWert);
      TextBreite:=P.Canvas.TextWidth(FloatWertStr);
      XText:=X1-CellMargin-TextBreite;  //X1 ist rechter Zellrand
    end
    else
    begin
      P.EndDoc;
      raise Exception.Create('Unbekannte Ausrichtung ' + Ausrichtung
                              +' in TWDataSetPrinter.DruckeTabellenFeld');
    end;
    P.Canvas.TextOut(XText, Inhalt.CurrY + CellMargin, Wert);
end;

//######################################################################
procedure TWDataSetPrinter.DruckeTabellenKopf();
var
  Feld:TField;
  I:Integer;
begin
  P.Canvas.Font.Size := Inhalt.FontSize;

  for I:=0 to Daten.Fields.Count-1 do
  begin
    Feld:=Daten.Fields.Fields[I];
    DruckeTabellenFeld(I, Feld.DisplayName, True);
  end;

end;

//#######################################################################
procedure TWDataSetPrinter.DruckeTabellenReihe(Felder:TFields);
var
  Feld:TField;
  FloatFeld:TFloatField;
  I:Integer;
  Wert:String;

begin
  P.Canvas.Font.Size := Inhalt.FontSize;

  for I:=0 to Felder.Count-1 do
  begin
    Feld:=Felder.Fields[I];
    Wert:=FeldToStr(Feld);
    DruckeTabellenFeld(I, Wert);
  end;
end;

procedure TWDataSetPrinter.DruckeTabelle();
var
  Y:Integer;
begin
  HoleBreiten;

  DruckeTabellenKopf;
  Inhalt.CurrYAdd(FeldHoehe); //Ueberschriften beruecksictigen

  Daten.First;
  while not Daten.Eof do
  begin
    DruckeTabellenReihe(Daten.Fields);
    Inhalt.CurrYAdd(FeldHoehe);
    var bot:integer;
    bot:=Inhalt.Bottom;
    if Inhalt.CurrY+FeldHoehe>Inhalt.Bottom then
    begin
      Fusszeile.Drucken;
      P.NewPage;
      Kopfzeile.Drucken;
      Inhalt.CurrY:=Inhalt.Top;
      DruckeTabellenKopf;
      Inhalt.CurrYAdd(FeldHoehe); //Ueberschriften beruecksictigen
    end;
    Daten.Next;
  end;
end;

procedure TWDataSetPrinter.Drucken(ADataSet:TDataSet);
begin
  Daten:= ADataSet;
  Drucker.Title := 'Druckauftrag 1';
  Drucker.BeginDoc;
  Kopfzeile.Drucken;
  Dokumentenkopf.Drucken; //einmalig je Druckvorgang
  Inhalt.CurrY:=Inhalt.Top+200;
  DruckeTabelle;
//  printer.canvas.Canvas.StretchDraw(rect1,bmp);
  Fusszeile.Drucken;
  Drucker.EndDoc;
end;

procedure test1;
var
  Ausgabe:TWDataSetPrinter;
  x:String;

begin
  for x in Printer.Printers do
  begin
      writeln(x);
  end;
  //Der erste Drucker aus Printer.Printers wird gewaehlt
  Printer.PrinterIndex:=1;

  Ausgabe:=TWDataSetPrinter.Create(nil);
  Ausgabe.Drucker:= Printer;
  Ausgabe.Drucken(KaDataModule.AusgabeDS);

end;

end.
