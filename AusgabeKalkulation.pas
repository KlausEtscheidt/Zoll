unit AusgabeKalkulation;

interface

  uses Data.DB,DruckeTabelle;

  type TWKalkAusgabe = class(TWDataSetPrinter)

    public
      type TWKalkTabelle = class(TWTabelle)
         public
            procedure DruckeTabellenReihe(Felder:TFields);
      end;

  end;


implementation

procedure TWKalkAusgabe.TWKalkTabelle.DruckeTabellenReihe(Felder:TFields);
var
  Feld:TField;
  I,IMax:Integer;
  Wert:String;

begin

  Self.Canvas.Font.Size := Self.FontSize;
  Feld:=Felder.Fields[0];

  if Feld.ToString='1' then
    IMax:=5
  else
    IMax:=Felder.Count-1;

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

end;

end.
