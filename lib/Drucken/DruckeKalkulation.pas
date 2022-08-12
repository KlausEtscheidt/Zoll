unit DruckeKalkulation;

interface

  uses Data.DB,System.Classes,Windows,System.SysUtils,VCL.Graphics,
        DruckBlatt, DruckeTabelle;

  type TWKalkAusgabe = class(TWDataSetPrinter)

    public
      //Tabellenbereich ableiten (TWTabelle erbt von TWBlatt.TWInhalt)
      type TWKalkTabelle = class(TWTabelle)
         public
            // DruckeTabellenReihe überschreiben
            procedure DruckeTabellenReihe(Felder:TFields);override;
      end;
      //Instanz von TWKalkTabelle zu TWKalkAusgabe dazu
      var KalkTabelle:TWKalkTabelle;
      constructor Create(AOwner:TComponent;PrinterName:String;
                                                        DS:TDataSet);
      procedure DruckeInhalt; reintroduce;  override;

  end;

  procedure PraeferenzKalkulationDrucken(DS: TDataSet;KaId:String);

implementation

constructor TWKalkAusgabe.Create(AOwner:TComponent;PrinterName:String;
                                                              DS:TDataSet);
begin
  inherited Create(AOwner,PrinterName,DS);
  //Der Inhalts-Bereich des Blattes wird durch die Tabelle dargestellt
  KalkTabelle:=TWKalkTabelle.Create(Self);
  KalkTabelle.Daten:=DS;
  KalkTabelle.HoleAusrichtungenAusFeldDef;

  //Tabelle in Basisklassen als Inhalt registrieren,
  //damit Pos-Berechnungen die sich auf Inhalt beziehen weiter funktionieren
  Inhalt:=KalkTabelle;
  Tabelle:=KalkTabelle;

end;

procedure TWKalkAusgabe.DruckeInhalt;
begin
  inherited DruckeInhalt;
end;

procedure TWKalkAusgabe.TWKalkTabelle.DruckeTabellenReihe(Felder:TFields);
var
  Feld:TField;
  I,IMax:Integer;
  Wert:String;
  testtxt:String;
  OldBrushColor,OldFontColor:TColor;
begin

  Self.Canvas.Font.Size := Self.FontSize;
  Feld:=Felder.Fields[0];

  OldBrushColor:=Canvas.Brush.Color;
  OldFontColor:=Canvas.Font.Color;

  if Feld.AsString<>'1' then
    IMax:=6
  else
  begin
    IMax:=Felder.Count-1;
    Canvas.Brush.Color:=clLtGray;
    Feld:=Felder.Fields[10];
    if Feld.AsFloat>=4 then
    begin
      Canvas.Font.Color:=clRed;
      Canvas.Brush.Style:=bsFDiagonal;
    end;
  end;


  for I:=0 to Felder.Count-1 do
  begin
    if I>IMax then
      Wert:=''
    else begin
      Feld:=Felder.Fields[I];
      Wert:=FeldToStr(Feld);
    end;
    DruckeTabellenFeld(I, Wert);
  end;

  Canvas.Brush.Color:= OldBrushColor;
  Canvas.Font.Color:= OldFontColor;
  Canvas.Brush.Style:=bsSolid;

end;

function GetUsername: String;
var
  Buffer: array[0..256] of Char; // UNLEN (= 256) +1 (definiert in Lmcons.h)
  Size: DWord;
begin
  Size := length(Buffer); // length stat SizeOf, da Anzahl in TChar und nicht BufferSize in Byte
   if not Windows.GetUserName(Buffer, Size) then
    RaiseLastOSError;
  SetString(Result, Buffer, Size - 1);

end;


/// <summary>Einsprung zum Drucken nach Setzen gewünschter Eigenschaften</summary>
procedure PraeferenzKalkulationDrucken(DS: TDataSet;KaId:String);
var
  Ausgabe:TWKalkAusgabe;
  txt:String;
begin

  Ausgabe:=TWKalkAusgabe.Create(nil,'Microsoft Print to PDF',
                                            DS);
  Ausgabe.Tabelle.Ausrichtung[3]:=d;
  Ausgabe.Tabelle.NachkommaStellen[3]:=2;

  Ausgabe.Kopfzeile.TextLinks:='Präferenzkalkulation';
  Ausgabe.Dokumentenkopf.TextLinks:='Präferenzkalkulation';
  Ausgabe.Kopfzeile.TextMitte:=  'Auftragsnr: ' + KaId;
  Ausgabe.Dokumentenkopf.TextMitte:=  'Auftragsnr: ' + KaId;
  DateTimeToString(txt, 'dd.mm.yy hh:mm', System.SysUtils.Now);
  Ausgabe.Kopfzeile.TextRechts:=txt;
  Ausgabe.Fusszeile.TextLinks:=GetUsername;


  try
  Ausgabe.Drucken('Auftragsnr: ' + KaId);
  finally
    if Ausgabe.Drucker.Printing then
      Ausgabe.Drucker.EndDoc;
  end;


end;


end.
