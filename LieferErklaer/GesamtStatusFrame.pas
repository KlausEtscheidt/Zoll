unit GesamtStatusFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  LocalDbQuerys;

type
  TGesamtStatusFrm = class(TFrame)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    nTeile: TLabel;
    Label4: TLabel;
    nPumpenteile: TLabel;
    Label5: TLabel;
    nPfk: TLabel;
    Label6: TLabel;
    nLieferanten: TLabel;
    Label7: TLabel;
    nLieferPumpenteile: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    nLieferStatusUnbekannt: TLabel;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure InitFrame;
  end;

implementation

{$R *.dfm}

procedure TGesamtStatusFrm.InitFrame;

var
  Anzahl: Integer;

begin
  Anzahl:=HoleAnzahlTabelleneintraege('Teile');
  nTeile.Caption:=IntToStr(Anzahl);
  Anzahl:= HoleAnzahlPumpenteile;
  nPumpenteile.Caption:=IntToStr(Anzahl);
  Anzahl:= HoleAnzahlPumpenteileMitPFK;
  nPfk.Caption:=IntToStr(Anzahl);
  Anzahl:=HoleAnzahlLieferanten;
  nLieferanten.Caption:=IntToStr(Anzahl);
  Anzahl:=HoleAnzahlLieferPumpenteile;
  nLieferPumpenteile.Caption:=IntToStr(Anzahl);
  Anzahl:=HoleAnzahlLieferStatusUnbekannt;
  nLieferStatusUnbekannt.Caption:=IntToStr(Anzahl);

end;

end.
