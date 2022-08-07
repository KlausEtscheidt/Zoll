unit Drucken;

interface

  uses SysUtils, System.Classes, Vcl.Graphics, Data.DB, Printers, DatenModul;

  const
    FontSizeTableRow = 8;
    DefaultFeldHoehe= 300;
    LeftMargin=150;
    CellMargin=20;   //Abstand Text in zum Rahmen drumrum
    Y0Header=50;
    Y0Content=250;
    DefaultFooterHoehe=500;

  type TWAlign = array of String;

  type TWDataSetPrinter = class(TComponent)
    private
      P:TPrinter;
      Daten:TDataSet;
      FeldBreiten:array of Integer; //Netto-Breiten der Spalten
      FeldX0:array of Integer;     //Start-Pos für Zell-Rahmen
      FFeldHoehe:Integer;
      FAlign:TWAlign;
      FFooterHoehe:Integer;
      Y0Footer:Integer;
      procedure DruckeTabellenFeld(Spalte,Y:Integer;
                       Wert:String;Kopfzeile:Boolean=False);
      procedure DruckeTabellenKopf();
      procedure DruckeTabellenReihe(Y:Integer; Felder:TFields);
      procedure DruckeTabelle();
      procedure DruckeSeitenkopf();
      procedure HoleBreiten();
      function FeldToStr(Feld:TField):String;
    public
      constructor Create(AOwner:TComponent);
      procedure Drucken(ADataSet:TDataSet);
      property Drucker:TPrinter read P write P;
      property DataSet:TDataSet read Daten write Daten;
      property FeldHoehe:Integer read FFeldHoehe write FFeldHoehe;
      property FooterHoehe:Integer read FFooterHoehe write FFooterHoehe;
      property Ausrichtungen:TWAlign read FAlign write FAlign;

    end;

  procedure test1;

implementation

constructor TWDataSetPrinter.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FeldHoehe:=DefaultFeldHoehe;
  FooterHoehe:=DefaultFooterHoehe;
  //Default-Printer setzen
  Printer.PrinterIndex:=1;
  Drucker:=Printer;

  Y0Footer:=P.PageHeight-FooterHoehe;

end;

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

procedure TWDataSetPrinter.DruckeSeitenkopf;
begin
  P.Canvas.Font.Size := 16;
  P.Canvas.TextOut(LeftMargin, Y0Header, 'Hallo, Welt!');
  P.Canvas.Brush.Style := bsClear;
  P.Canvas.Rectangle(5,5,P.PageWidth-10,P.PageHeight-10);
end;

procedure TWDataSetPrinter.HoleBreiten();
var
  Feld:TField;
  Breite,Hoehe,I:Integer;
  Wert:String;
begin

  setlength(FeldBreiten,Daten.Fields.Count);
  FeldHoehe:=0;
  P.Canvas.Font.Size := FontSizeTableRow;

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


procedure TWDataSetPrinter.DruckeTabellenFeld(Spalte,Y:Integer;
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
    Y0:=Y-CellMargin;
    Y1:=Y0+FeldHoehe;
    X0:=FeldX0[Spalte]+LeftMargin;
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
    P.Canvas.TextOut(XText, Y, Wert);
end;

procedure TWDataSetPrinter.DruckeTabellenKopf();
var
  Feld:TField;
  I:Integer;
begin
  P.Canvas.Font.Size := FontSizeTableRow;

  for I:=0 to Daten.Fields.Count-1 do
  begin
    Feld:=Daten.Fields.Fields[I];
    DruckeTabellenFeld(I, Y0Content, Feld.DisplayName, True);
  end;

end;

procedure TWDataSetPrinter.DruckeTabellenReihe(Y:Integer; Felder:TFields);
var
  Feld:TField;
  FloatFeld:TFloatField;
  I:Integer;
  Wert:String;
begin
  P.Canvas.Font.Size := FontSizeTableRow;

  for I:=0 to Felder.Count-1 do
  begin
    Feld:=Felder.Fields[I];
    Wert:=FeldToStr(Feld);
    DruckeTabellenFeld(I, Y, Wert);
  end;
end;

procedure TWDataSetPrinter.DruckeTabelle();
var
  Y:Integer;
begin
  HoleBreiten;
  DruckeTabellenKopf;
  Y:=Y0Content+FeldHoehe; //Ueberschriften beruecksictigen
  Daten.First;
  while not Daten.Eof do
  begin
    DruckeTabellenReihe(Y,Daten.Fields);
    Y:=Y+FFeldHoehe;
    if Y>Y0Footer then
    begin
      P.NewPage;
      DruckeTabellenKopf;
      Y:=Y0Content+FeldHoehe; //Ueberschriften beruecksictigen
    end;
    Daten.Next;
  end;
end;

procedure TWDataSetPrinter.Drucken(ADataSet:TDataSet);
begin
  Daten:= ADataSet;
  P.Title := 'Druckauftrag 1';
  P.BeginDoc;
  DruckeSeitenkopf;
  DruckeTabelle;
  P.EndDoc;
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

{
procedure TForm1.BtnDruckenClick(Sender: TObject);
var
    rect,rect1: TRect;
    bmp:TBitMap;
begin
   bmp:=TBitMap.Create;
   bmp.Width := DBGrid1.clientwidth;
   bmp.Height := DBGrid1.Clientheight;
   try
   rect:=bounds(0,0,DBGrid1.clientwidth,DBgrid1.Clientheight);
   // >> wobei hier noch verhältnisanpassungen fehlen
   rect1:=bounds(10,10,Printer.PageHeight,Printer.PageWidth);
   bmp.canvas.CopyRect(rect,DBGrid1.Canvas,rect);
      if printdialog1.Execute then
      begin

      printer.begindoc;
      printer.canvas.Canvas.StretchDraw(rect1,bmp);
      printer.enddoc;

      end;
   finally
     bmp.Free;
   end;
end;
}
end.
