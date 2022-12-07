unit ExportFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TGesamtStatusFrm = class(TFrame)
    Label1: TLabel;
    Label2: TLabel;
    TeilePanel: TPanel;
    Panel5: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label14: TLabel;
    Panel4: TPanel;
    nTeile: TLabel;
    nPumpenteile: TLabel;
    nErsatzteile: TLabel;
    nPfk: TLabel;
    LieferantenPanel: TPanel;
    Panel1: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel2: TPanel;
    nLIeferanten: TLabel;
    nLieferErsatzteile: TLabel;
    dummyLabel12: TLabel;
    nLieferStatusUnbekannt: TLabel;
    Label10: TLabel;
    nLieferPumpenteile: TLabel;
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
//  Anzahl: Integer;
  LocalQry: TWQry;

begin
  LocalQry := Tools.GetQuery;

  // Zaehle alle Teile
  LocalQry.HoleTeile;
  nTeile.Caption:=IntToStr(LocalQry.RecordCount);

  // Zaehle Untermengen
  LocalQry.Filter := 'Pumpenteil=-1';
  LocalQry.Filtered := True;
  nPumpenteile.Caption:=IntToStr(LocalQry.RecordCount);

  LocalQry.Filter := 'Ersatzteil=-1';
  nErsatzteile.Caption:=IntToStr(LocalQry.RecordCount);

  LocalQry.Filter := 'Ersatzteil=-1 AND PFK=-1';
  nPfk.Caption:=IntToStr(LocalQry.RecordCount);
  LocalQry.Filtered := False;

  // Zaehle alle Teile Lieferanten
  LocalQry.HoleLieferanten;
  nLieferanten.Caption:=IntToStr(LocalQry.RecordCount);

  // Zaehle alle Teile Untermengen
  LocalQry.Filter := 'Pumpenteile=-1';
  LocalQry.Filtered := True;
  nLieferPumpenteile.Caption:=IntToStr(LocalQry.RecordCount);

  LocalQry.Filter := 'Ersatzteile=-1';
  nLieferErsatzteile.Caption:=IntToStr(LocalQry.RecordCount);

  LocalQry.Filter := 'Ersatzteile=-1 AND Lekl=0';
  nLieferStatusUnbekannt.Caption:=IntToStr(LocalQry.RecordCount);
  LocalQry.Filtered := False;


end;

end.
