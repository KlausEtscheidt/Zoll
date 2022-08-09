unit DruckBlatt;

interface

  uses StrUtils, SysUtils, System.Classes,System.Types,  Vcl.Graphics, Printers;

  type TWAusrichtungsArten = (l,c,r,d);
  //getEnumName(TypeInfo(TZustand),ord(automat.GetZustand));
  type TWBlatt = class(TComponent)
    const
      //Freiräume, nicht zum Drucken
      DefBlattRaender: TRect=(Left:100; Top:200; Right:100; Bottom:200);
      DefDecimalSep:String=',';

    private
      P:TPrinter;
      FRaender: TRect;
      FInnen: TRect;
      FDecimalSep:String;
      function GetLeft:Integer;
      function GetRight:Integer;
      procedure SetRaender(Raender: TRect);

    public

      type
        TWDokumententeil = class
          private
            FFontSize: Integer;
            FCanvas:TCanvas;
            FBlatt:TWBlatt;
          public
            var CurrY:Integer;
            constructor Create(AParent:TWBlatt);
            procedure CurrYAdd(DeltaY:Integer);
            property FontSize:Integer read FFontSize write FFontSize;
            property Blatt:TWBlatt read FBlatt;
            property Canvas:TCanvas read FCanvas;
        end;

        //--------- Kopfzeile
        TWKopfzeile = class(TWDokumententeil)
          const
            DefFontSize: Integer=8;
            DefHoehe: Integer=100;
          private
            FHoehe: Integer;
          public
            constructor Create(AParent:TWBlatt);
            procedure Drucken;
            function Top:Integer;
            function Bottom:Integer;
            property Hoehe:Integer read FHoehe write FHoehe;
        end;

        //--------- Dokumentenkopf
        TWDokumentenkopf = class(TWDokumententeil)
          const
            DefFontSize: Integer=14;
            DefFreiraumOben: Integer=150;
          private
            FFreiraumOben: Integer;
          public
            var text:String;
            constructor Create(AParent:TWBlatt);
            function Top:Integer;
            function Bottom:Integer;
            procedure Drucken;
            property FreiraumOben:Integer read FFreiraumOben write FFreiraumOben;
        end;

        //--------- Inhalt
        TWInhalt = class(TWDokumententeil)
          const
            DefFontSize: Integer=8;
            DefFreiraumOben: Integer=50;
          private
            FFreiraumOben: Integer;
          public
            constructor Create(AParent:TWBlatt);
            function Top:Integer;
            function Bottom:Integer;
            procedure Drucken;
            property FreiraumOben:Integer read FFreiraumOben write FFreiraumOben;
        end;

        //--------- Fusszeile
        TWFusszeile = class(TWDokumententeil)
          const
            DefFontSize: Integer=10;
            DefHoehe: Integer=100;
          private
            FHoehe: Integer;
          public
            constructor Create(AParent:TWBlatt);
            function Top:Integer;
            function Bottom:Integer;
            procedure Drucken;
            property Hoehe:Integer read FHoehe write FHoehe;
        end;

      var
        Kopfzeile:TWKopfzeile;
        Dokumentenkopf:TWDokumentenkopf;
        Inhalt:TWInhalt;
        Fusszeile:TWFusszeile;

      function PosHorizAusgerichtet(Text:String;FeldBreite:Integer;
            Ausrichtung: TWAusrichtungsArten;NNachKomma:Integer):Integer;
      constructor Create(AOwner:TComponent;PrinterName:String);
      procedure Drucken(DruckJobName:String);
      property Drucker:TPrinter read P write P;
      property Raender: TRect  read FRaender write SetRaender;
      property Innen: TRect  read FInnen;
      property Left: Integer  read GetLeft;
      property Right: Integer  read GetRight;
      property DecimalSeparator:String read FDecimalSep write FDecimalSep;

    end;

implementation

function TWBlatt.PosHorizAusgerichtet(Text:String;FeldBreite:Integer;
            Ausrichtung: TWAusrichtungsArten;NNachKomma:Integer):Integer;
var
  bleibtFrei:Double;
  TextBreite:Integer;
  PosKomma:Integer;
  PlatzNachKomma:Integer;
  Nullen:String;
begin
    if Ausrichtung=l then
      Exit (0);

    //X0 fuer Text in Abhängigkeit der Ausrichtung berechnen
    TextBreite:=Self.Drucker.Canvas.TextWidth(Text);

    if Ausrichtung=c then
    begin
      bleibtFrei:=Double(FeldBreite-TextBreite)/2;
      Exit (Trunc(bleibtFrei));
    end;

    if Ausrichtung=r then
      Exit (FeldBreite-TextBreite);  //X1 ist rechter Zellrand

    //Ausgabe nach Komma ausgerichtet bei unterschiedlichen Nachkommastellen
    if Ausrichtung=d then
    begin
      //Wie viel Platz brauchen die Nachkommastellen
      Nullen:=Self.DecimalSeparator + DupeString('0',NNachKomma);
      PlatzNachKomma:=Self.Drucker.Canvas.TextWidth(Nullen);
      //Wie viel Platz braucht der Wert vor dem Komma
      PosKomma:=Pos(Self.DecimalSeparator,Text);
      if PosKomma>0 then
        Delete(Text, PosKomma,500);
      TextBreite:=Self.Drucker.Canvas.TextWidth(Text);
      //Wo starten wir also
      Exit (FeldBreite-TextBreite-PlatzNachKomma);
    end;

    Self.Drucker.EndDoc;
    raise Exception.Create('Unbekannte Ausrichtung '
                            +' in TWBlatt.DruckeTabellenFeld');

end;

constructor TWBlatt.Create(AOwner:TComponent;PrinterName:String);
var
  PIndex:Integer;
begin
  inherited Create(AOwner);

  PIndex:=Printer.Printers.IndexOf(PrinterName);
  if PIndex=-1 then
    raise Exception.Create('Drucker mit Namen '+
            PrinterName + 'konnte nicht gefunden werden.');

  try
    Printer.PrinterIndex:=PIndex;
  Except
    raise Exception.Create('Drucker mit Namen '+
            PrinterName + 'konnte nicht geöffnet werden.');
  end;

  Drucker:=Printer;

  //Bestandteile des Blattes anlegen
  Kopfzeile:=TWKopfzeile.Create(Self);
  Dokumentenkopf:=TWDokumentenkopf.Create(Self);
  Inhalt:=TWInhalt.Create(Self);
  Fusszeile:=TWFusszeile.Create(Self);

  //Setze Blattraender,Blattinneres und die Y0 und Hoehen von Kopf,Fuss,Inhalt
  Raender:=TRect(DefBlattRaender);

  //Weiter Default-Werte in Felder übenehmen
  FDecimalSep:=DefDecimalSep;


end;

procedure TWBlatt.SetRaender(Raender: TRect);
begin
  //Raender (das was abgeschnitten wird
  FRaender:=Raender;
  //Rest der bedruckt werden kann
  FInnen.Left:=Raender.Left;
  FInnen.Top:=Raender.Top;
  FInnen.Right:=P.PageWidth-Raender.Right;
  FInnen.Bottom:=P.PageHeight-Raender.Bottom;
  Kopfzeile.Hoehe:=Kopfzeile.DefHoehe;
  Fusszeile.Hoehe:=Fusszeile.DefHoehe;

end;

function TWBlatt.GetLeft:Integer;
begin
  Result:=Finnen.Left;
end;

function TWBlatt.GetRight:Integer;
begin
  Result:=Finnen.Right;
end;

//##########################################################################

constructor TWBlatt.TWDokumententeil.Create(AParent:TWBlatt);
begin
  FBlatt:=AParent;
  FCanvas:=Blatt.Drucker.Canvas;
end;

procedure TWBlatt.TWDokumententeil.CurrYAdd(DeltaY:Integer);
begin
  CurrY:=CurrY+DeltaY;
end;

//##########################################################################
// Kopfzeile
//##########################################################################
constructor TWBlatt.TWKopfzeile.Create(AParent:TWBlatt);
begin
  inherited Create(AParent);
  FontSize:=DefFontSize;
end;

function TWBlatt.TWKopfzeile.Top:Integer;
begin
  Result:= Blatt.Innen.Top;
end;

function TWBlatt.TWKopfzeile.Bottom:Integer;
begin
  Result:= Blatt.Innen.Top+ Self.Hoehe;
end;

procedure TWBlatt.TWKopfzeile.Drucken;
var
  myTop,myBot:Integer;
begin
  myTop:=Top;
  myBot:=Bottom;
  Canvas.Font.Size := FontSize;
  Canvas.TextOut(Blatt.Left, Top, 'Kopfzeile');
//  Canvas.MoveTo(Blatt.Left, Top);
//  Canvas.LineTo(Blatt.Right, Top);
//  Canvas.Pen.Width:=5;
  Canvas.MoveTo(Blatt.Left, Bottom-Canvas.Pen.Width);
  Canvas.LineTo(Blatt.Right, Bottom-Canvas.Pen.Width);

end;

//##########################################################################
// Dokumentenkopf
//##########################################################################
constructor TWBlatt.TWDokumentenkopf.Create(AParent:TWBlatt);
begin
  inherited Create(AParent);
  FontSize:=DefFontSize;
  FFreiraumOben:=DefFreiraumOben;
end;

function TWBlatt.TWDokumentenkopf.Top:Integer;
begin
  Result:= Blatt.Innen.Top + Blatt.Kopfzeile.Hoehe+1;
end;

function TWBlatt.TWDokumentenkopf.Bottom:Integer;
begin
  Result:= Self.CurrY+1;
end;

//Max einmal je Druckauftrag
procedure TWBlatt.TWDokumentenkopf.Drucken;
var
  myTop,myBot:Integer;
  txt:String;
begin
  myTop:=Top;
  myBot:=Bottom;

  Canvas.Font.Size := FontSize;
  txt:='Präferenzkalkulation';
  Canvas.TextOut(Blatt.Left, Top+FreiraumOben, txt);
  CurrY:=Top+FreiraumOben + Canvas.TextHeight(txt);
//  Canvas.Brush.Style := bsClear;
//  Canvas.Rectangle(Blatt.Left+1510, Top+1,Blatt.Left+1540, Top+80);
//  Canvas.Rectangle(Blatt.Innen);
end;

//##########################################################################
// Inhalt
//##########################################################################
constructor TWBlatt.TWInhalt.Create(AParent:TWBlatt);
begin
  inherited Create(AParent);
  FontSize:=DefFontSize;
  FFreiraumOben:=DefFreiraumOben;
end;

function TWBlatt.TWInhalt.Top:Integer;
begin
  Result:= Blatt.Innen.Top + Blatt.Kopfzeile.Hoehe+1;
end;

function TWBlatt.TWInhalt.Bottom:Integer;
begin
  Result:= Blatt.Innen.Bottom- Blatt.Fusszeile.Hoehe-1;
end;

procedure TWBlatt.TWInhalt.Drucken;
begin

end;

//##########################################################################
// Fusszeile
//##########################################################################
constructor TWBlatt.TWFusszeile.Create(AParent:TWBlatt);
begin
  inherited Create(AParent);
  FontSize:=DefFontSize;
end;

function TWBlatt.TWFusszeile.Top:Integer;
begin
  Result:= Blatt.Innen.Bottom- Self.Hoehe;
end;

function TWBlatt.TWFusszeile.Bottom:Integer;
begin
  Result:= Blatt.Innen.Bottom;
end;


procedure TWBlatt.TWFusszeile.Drucken;
begin
  Canvas.Font.Size := FontSize;
  Canvas.TextOut(Blatt.Left, Top+5, 'Fusszeile');
  Canvas.MoveTo(Blatt.Left, Top);
  Canvas.LineTo(Blatt.Right, Top);
  Canvas.MoveTo(Blatt.Left, Bottom);
  Canvas.LineTo(Blatt.Right, Bottom);

end;

//##########################################################################

procedure TWBlatt.Drucken(DruckJobName:String);
begin
  P.Title := DruckJobName;
  P.BeginDoc;
  Kopfzeile.Drucken;
  Dokumentenkopf.Drucken; //einmalig je Druckvorgang
//  printer.canvas.Canvas.StretchDraw(rect1,bmp);
  P.EndDoc;
end;


end.
