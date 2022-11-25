unit GesamtStatusFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

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

uses ADOQuery, Tools;

procedure TGesamtStatusFrm.InitFrame;

var
  Anzahl: Integer;
  LocalQry: TWQry;

begin
  LocalQry := Tools.GetQuery;

  Anzahl:= LocalQry.HoleAnzahlTabelleneintraege('Teile');
  nTeile.Caption:=IntToStr(Anzahl);
  Anzahl:= LocalQry.HoleAnzahlPumpenteile;
  nPumpenteile.Caption:=IntToStr(Anzahl);
  Anzahl:= LocalQry.HoleAnzahlPumpenteileMitPFK;
  nPfk.Caption:=IntToStr(Anzahl);
  Anzahl:= LocalQry.HoleAnzahlLieferanten;
  nLieferanten.Caption:=IntToStr(Anzahl);
  Anzahl:= LocalQry.HoleAnzahlLieferPumpenteile;
  nLieferPumpenteile.Caption:=IntToStr(Anzahl);
  Anzahl:= LocalQry.HoleAnzahlLieferStatusUnbekannt;
  nLieferStatusUnbekannt.Caption:=IntToStr(Anzahl);

end;

end.
