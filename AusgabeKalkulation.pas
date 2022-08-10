unit AusgabeKalkulation;

interface

  uses Data.DB,System.Classes,DruckeTabelle;

  type TWKalkAusgabe = class(TWDataSetPrinter)

    public
      type TWKalkTabelle = class(TWTabelle)
         public
            procedure DruckeTabellenReihe(Felder:TFields);override;
      end;

      var KalkTabelle:TWKalkTabelle;
      constructor Create(AOwner:TComponent;PrinterName:String;
                                                        DS:TDataSet);
      procedure DruckeInhalt; reintroduce;  override;


  end;


implementation

constructor TWKalkAusgabe.Create(AOwner:TComponent;PrinterName:String;
                                                              DS:TDataSet);
begin
  inherited Create(AOwner,PrinterName,DS);
  //Der Inhalts-Bereich des Blattes wird durch die Tabelle dargestellt
  KalkTabelle:=TWKalkTabelle.Create(Self);
  KalkTabelle.Daten:=DS;
  KalkTabelle.HoleAusrichtungenAusFeldDef;

  //Tabelle in Basisklasse als Inhalt registrieren,
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

begin

  Self.Canvas.Font.Size := Self.FontSize;
  Feld:=Felder.Fields[0];
  testtxt:=Feld.AsString;


  if Feld.AsString<>'1' then
    IMax:=6
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
