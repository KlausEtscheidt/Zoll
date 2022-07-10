unit Kundenauftraege;

interface

uses Vcl.Forms, System.SysUtils, System.Classes, DBConnect, DBQry,
  KundenauftragsPos, StuecklistenPosition;

type
  TZKundenauftrag = class(TZStueliPos)
  private
  protected
    { protected declarations }
  public
    ka_id: String;
    komm_nr: String;
    kunden_id: Integer;
    procedure liesKopfundPositionen;
    procedure holeKinder;
  published
    constructor Create(new_ka_id: String);
    procedure auswerten;
  end;

implementation

constructor TZKundenauftrag.Create(new_ka_id: String);
begin
  inherited Create(KA);
  ka_id := new_ka_id;
end;

procedure TZKundenauftrag.auswerten();
begin
  liesKopfundPositionen;
  holeKinder;
end;

procedure TZKundenauftrag.liesKopfundPositionen();

var
  conn: TZDbConnector;

begin
  var
    gefunden: Boolean;
  var
    Rabatt: Double;
  var
    NewStueliPos: TZKundenauftragsPos;
  var
    KAQry, RabattQry: TZQry;
    // DatenbankConnector anlegen und oeffnen
  conn := TZDbConnector.Create(nil);

  // Abfrage zum Lesen des Kundenauftrags und seiner Positionen
  KAQry := conn.getQuery;
  gefunden := KAQry.SucheKundenAuftragspositionen(ka_id);

  if gefunden then
  begin
    // Daten aus dem Auftragskopf
    komm_nr := trim(KAQry.FieldByName('klassifiz').AsString);
    kunden_id := KAQry.FieldByName('kunde').AsInteger;

    // Abfrage des Rabattes zu diesem Kunden
    RabattQry := conn.getQuery;
    RabattQry.SucheKundenRabatt(ka_id);
    { TODO :
      Else-Zweig bearbeiten
      SQL muss auf aktuelles Datum filtern }
    if RabattQry.n_records = 1 then
      Rabatt := RabattQry.FieldByName('zu_ab_proz').AsFloat / 100
    else
      Rabatt := RabattQry.FieldByName('zu_ab_proz').AsFloat / 100;
  end;

  //Positionen beabeiten
  while not KAQry.Eof do
  begin
    //KundenauftragsPos erzeugen; übertrage relevante Daten aus Qry in Felder
    NewStueliPos := TZKundenauftragsPos.Create(KAQry, Rabatt);
    //neue Pos in Stückliste aufnehmen
    Stueli.Add(NewStueliPos.id_pos, NewStueliPos);
    KAQry.next;
  end;

end;

//Schrittweise Suche aller untergeordneten Elemente
procedure TZKundenauftrag.holeKinder();
begin
  var StueliPos: TZStueliPos;

  for StueliPos in Stueli.Values do
  begin

  end;

end;

end.
