unit DruckBlatt;

interface

  uses SysUtils, System.Classes,System.Types,  Vcl.Graphics, Printers;

  type TWBlatt = class(TComponent)
    const
      //Freir�ume, nicht zum Drucken
      DefBlattRaender: TRect=(Left:100; Top:200; Right:100; Bottom:200);
    private
      P:TPrinter;
      FRaender: TRect;
      FInnen: TRect;
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

        TWKopfzeile = class(TWDokumententeil)
          const
            DefFontSize: Integer=8;
            DefHoehe: Integer=100;
          private
            FHoehe: Integer;
          public
            procedure Drucken;
            function Top:Integer;
            function Bottom:Integer;
            property Hoehe:Integer read FHoehe write FHoehe;
        end;

        TWDokumentenkopf = class(TWDokumententeil)
          const
            DefFontSize: Integer=14;
            DefFreiraumOben: Integer=150;
            DefFreiraumUnten: Integer=50;
          private
            FFreiraumOben: Integer;
            FFreiraumUnten: Integer;
          public
            var text:String;
            function Top:Integer;
            function Bottom:Integer;
            procedure Drucken;
            property FreiraumOben:Integer read FFreiraumOben write FFreiraumOben;
            property FreiraumUnten:Integer read FFreiraumUnten write FFreiraumUnten;
        end;

        TWInhalt = class(TWDokumententeil)
          const
            DefFontSize: Integer=8;
          private
          public
            function Top:Integer;
            function Bottom:Integer;
            procedure Drucken;
        end;

        TWFusszeile = class(TWDokumententeil)
          const
            DefFontSize: Integer=10;
            DefHoehe: Integer=100;
          private
            FHoehe: Integer;
          public
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

      constructor Create(AOwner:TComponent;PrinterName:String);
      procedure Drucken(DruckJobName:String);
      property Drucker:TPrinter read P write P;
      property Raender: TRect  read FRaender write SetRaender;
      property Innen: TRect  read FInnen;
      property Left: Integer  read GetLeft;
      property Right: Integer  read GetRight;

    end;

implementation

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
            PrinterName + 'konnte nicht ge�ffnet werden.');
  end;

  Drucker:=Printer;

  //Bestandteile des Blattes anlegen
  Kopfzeile:=TWKopfzeile.Create(Self);
  Kopfzeile.FontSize:=Kopfzeile.DefFontSize;

  Dokumentenkopf:=TWDokumentenkopf.Create(Self);
  Dokumentenkopf.FontSize:=Dokumentenkopf.DefFontSize;
  Dokumentenkopf.FFreiraumOben:=Dokumentenkopf.DefFreiraumOben;
  Dokumentenkopf.FFreiraumUnten:=Dokumentenkopf.DefFreiraumUnten;

  Inhalt:=TWInhalt.Create(Self);
  Inhalt.FontSize:=Inhalt.DefFontSize;
  Fusszeile:=TWFusszeile.Create(Self);
  Fusszeile.FontSize:=Fusszeile.DefFontSize;

  //Setze Blattraender,Blattinneres und die Y0 und Hoehen von Kopf,Fuss,Inhalt
  Raender:=TRect(DefBlattRaender);

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
function TWBlatt.TWDokumentenkopf.Top:Integer;
begin
  Result:= Blatt.Innen.Top + Blatt.Kopfzeile.Hoehe+1;
end;

function TWBlatt.TWDokumentenkopf.Bottom:Integer;
begin
  Result:= Self.CurrY+Self.FFreiraumUnten+1;
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
  txt:='Pr�ferenzkalkulation';
  Canvas.TextOut(Blatt.Left, Top+FreiraumOben, txt);
  CurrY:=Top+FreiraumOben + Canvas.TextHeight(txt);
  Canvas.Brush.Style := bsClear;
//  Canvas.Rectangle(Blatt.Left+1510, Top+1,Blatt.Left+1540, Top+80);
//  Canvas.Rectangle(Blatt.Innen);
end;

//##########################################################################
// Inhalt
//##########################################################################
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
