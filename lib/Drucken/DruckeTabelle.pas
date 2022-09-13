unit DruckeTabelle;

interface

  uses SysUtils, System.Classes,  System.Generics.Collections,
        Vcl.Graphics, Data.DB, Printers,
       DatenModul,DruckBlatt;

  type TWDataSetPrinter = class(TWBlatt)
    private
    public
      type
        //Überschreibe Unterklasse "Inhalts-Bereich" der Basisklasee
        TWTabelle = class(TWInhalt)
          const
            CellMargin=20;   //Abstand Text zum Rahmen drumrum
            DefaultFeldHoehe=300;
          protected
            Daten:TDataSet;
            FFeldHoehe:Integer;
            FeldBreiten:array of Integer; //Netto-Breiten der Spalten
            FeldX0:array of Integer;     //Start-Pos für Zell-Rahmen
            FAlign:array of TWAusrichtungsArten;
            FNNachkomma:array of Integer;
            FNullDrucken:Boolean;
            procedure DruckeTabellenFeld(Spalte:Integer;
                             Wert:String;Kopfzeile:Boolean=False);
            procedure DruckeTabellenKopf();
            procedure DruckeTabellenReihe(Felder:TFields);virtual;
            procedure HoleBreiten();
            procedure HoleAusrichtungenAusFeldDef();
            function FeldToStr(Feld:TField):String;
            procedure SetAlign(Spalte:Integer; Art:TWAusrichtungsArten);
            function GetAlign(Spalte:Integer):TWAusrichtungsArten;
            procedure SetNNachkomma(Spalte,N:Integer);
            function GetNNachkomma(Spalte:Integer):Integer;
          public
            procedure Drucken;
            property DataSet:TDataSet read Daten;
            property FeldHoehe:Integer read FFeldHoehe write FFeldHoehe;
            property Ausrichtung[Spalte:Integer]:TWAusrichtungsArten
              read GetAlign write SetAlign;
            property NachkommaStellen[Spalte:Integer]:Integer
              read GetNNachkomma write SetNNachkomma;
            property NullDrucken:Boolean read FNullDrucken write FNullDrucken;

        end;
      //--------------------Ende Inner Class

      var Tabelle:TWTabelle;
      constructor Create(AOwner:TComponent;PrinterName:String;DS:TDataSet);
      procedure DruckeInhalt; reintroduce;  override;
//      procedure Drucken();

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
  Tabelle.HoleAusrichtungenAusFeldDef;
  //Tabelle in Basisklasse als Inhalt registrieren,
  //damit Pos-Berechnungen die sich auf Inhalt beziehen weiter funktionieren
  Inhalt:=Tabelle;

end;

/////////////////////////////////////////////////////////////////////////
procedure TWDataSetPrinter.TWTabelle.SetAlign(Spalte:Integer;
                                                 Art:TWAusrichtungsArten);
begin
  FAlign[Spalte]:=Art;
end;

function TWDataSetPrinter.TWTabelle.GetNNachkomma(Spalte:Integer):Integer;
begin
  Result:=FNNachkomma[Spalte];
end;

procedure TWDataSetPrinter.TWTabelle.SetNNachkomma(Spalte,N:Integer);
begin
  FNNachkomma[Spalte]:=N;
end;

function TWDataSetPrinter.TWTabelle.GetAlign(Spalte:Integer):TWAusrichtungsArten;
begin
  Result:=FAlign[Spalte];
end;

///<summary>Besetzt die Spaltenausrichtungen aus den Feldinformationen
///</summary>
///<remarks>Die Ausrichtung kann bei Bedarf für einzelne Spalten geändert werden.
///Dies macht z.B. für Ausrichtung am Komma Sinn, welche bei TField unbekannt ist.
///Nur hierzu wird dann auch die Anzahl der Nachkommastellen benötigt.
///</remarks>
procedure TWDataSetPrinter.TWTabelle.HoleAusrichtungenAusFeldDef();
var
  Spalte:Integer;

begin
  setlength(FAlign,Daten.FieldCount);
  setlength(FNNachkomma,Daten.FieldCount);

  for Spalte := 0 to Daten.FieldCount-1 do
  begin
    case Daten.Fields.Fields[Spalte].Alignment of
      taLeftJustify:  FAlign[Spalte]:=l;
      taCenter:   FAlign[Spalte]:=c;
      taRightJustify: FAlign[Spalte]:=r;
    end;
    FNNachkomma[Spalte]:=2; //Default immer 2
  end;

end;

function TWDataSetPrinter.TWTabelle.FeldToStr(Feld:TField):String;
var
  FloatFeld:TFloatField;
begin
    if (Feld.DataType=ftFloat) then
      begin
        FloatFeld:=TFloatField(Feld);
        if NullDrucken or ((FloatFeld.AsFloat)<>0) then
          Result:=FormatFloat(FloatFeld.DisplayFormat,FloatFeld.AsFloat)
        else
          Result:='';
      end
    else
    if (Feld.DataType=ftCurrency) then
      begin
        FloatFeld:=TFloatField(Feld);
        if NullDrucken or ((FloatFeld.AsFloat)<>0) then
          Result:=FormatFloat('0.00 €',FloatFeld.AsFloat)
        else
          Result:='';
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
  Adjust:TWAusrichtungsArten;
  X0,Y0,X1,Y1:Integer;
  X0Text:Integer;
  AnzNachkomma:Integer;

begin
    Y0:=Self.CurrY;
    Y1:=Y0+FeldHoehe;
    X0:=FeldX0[Spalte]+Self.Blatt.Left ;
    X1:=X0+FeldBreiten[Spalte]+2*CellMargin;

    //Rahmen der Zelle drucken
    Self.Canvas.Rectangle(X0,Y0,X1,Y1);

    if Kopfzeile then   //Spaltenüberschriften immer zentriert
      Adjust:=c
    else
      Adjust:=Ausrichtung[Spalte];

    AnzNachkomma:=NachkommaStellen[Spalte];
    X0Text:=Blatt.PosHorizAusgerichtet(Wert,FeldBreiten[Spalte],
                Adjust,AnzNachkomma);

    Self.Canvas.TextOut(X0+CellMargin+X0Text, Self.CurrY + CellMargin, Wert);
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


procedure TWDataSetPrinter.TWTabelle.Drucken;
begin
  HoleBreiten;
  Self.ZeilenHoehe:=FeldHoehe;
  Self.FreiraumUnten:=FeldHoehe+100;

  //  //Starte unter Dokumentenkopf (inkl Freiraum)
  Self.CurrY:=Self.TopNachDokukopf;

  DruckeTabellenKopf;
  Self.CurrYZeileVor;

  Daten.First;
  while not Daten.Eof do
  begin
    DruckeTabellenReihe(Daten.Fields);
    Self.CurrYZeileVor;

    //Prüfe ob Seite voll und erzeuge Umbruch wenn nötig,
    //CurrY wird dann auf TopMitFreiraum gesetzt
    if Blatt.NeueSeite() then
    begin
      DruckeTabellenKopf;
      Self.CurrYZeileVor;
    end;
    Daten.Next;
  end;
end;

procedure TWDataSetPrinter.DruckeInhalt;
begin
  Tabelle.Drucken;
end;

//procedure TWDataSetPrinter.Drucken();
//begin
//  Drucker.Title := 'Druckauftrag 1';
//  Drucker.BeginDoc;
//  Kopfzeile.Drucken;
//  Dokumentenkopf.Drucken; //einmalig je Druckvorgang
//  //Starte unter Dokumentenkopf (inkl Freiraum)
//  Tabelle.CurrY:=Dokumentenkopf.Bottom+Tabelle.FreiraumOben;
//  Tabelle.Drucke;
//  Fusszeile.TextRechts:=IntToStr(Drucker.PageNumber);
//  Fusszeile.Drucken;
//  Drucker.EndDoc;
//end;


end.
