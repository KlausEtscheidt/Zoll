unit Kundenauftrag;

interface

uses Vcl.Forms, System.SysUtils, System.Classes, System.Generics.Collections,
  KundenauftragsPos, StuecklistenPosition, DBZugriff;

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
  gefunden: Boolean;
  Rabatt: Double;
  NewStueliPos: TZKundenauftragsPos;
  KAQry, RabattQry: TZQry;

begin

  // Abfrage zum Lesen des Kundenauftrags und seiner Positionen
  KAQry := DBConn.getQuery;
  gefunden := KAQry.SucheKundenAuftragspositionen(ka_id);

  if gefunden then
  begin
    // Daten aus dem Auftragskopf
    komm_nr := trim(KAQry.FieldByName('klassifiz').AsString);
    kunden_id := KAQry.FieldByName('kunde').AsInteger;

    // Abfrage des Rabattes zu diesem Kunden
    Rabatt:=0;
    RabattQry := DBConn.getQuery;
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
    Stueli.Add(NewStueliPos.pos_nr, NewStueliPos);
    KAQry.next;
  end;

end;


//Schrittweise Suche aller untergeordneten Elemente
procedure TZKundenauftrag.holeKinder();
var StueliPos: TZValue;
var StueliPosKey: String;
var keyArray: System.TArray<System.string>;
//var StueliPos: TZStueliPos;
var KaPos: TZKundenauftragsPos;
//var I:Integer;

begin
  keyArray:=Stueli.Keys.ToArray;
  TArray.Sort<String>(keyArray);
  for StueliPosKey in Stueli.Keys  do
  begin
    //Schritt 1 nur ueber Kommissions-FA suchen. Diese haben Prio 1.
    //Fuer alle Pos, die kein Kaufteil sind, rekursiv in der UNIPPS-Tabelle ASTUELIPOS nach Kindern suchen
    //Alle Kinder, die in ASTUELIPOS selbst keine Kinder mehr haben werden in der Liste teile_ohne_stu vermerkt
    KaPos:= Stueli[StueliPosKey].AsType<TZKundenauftragsPos>;

    if not KaPos.Teil.istKaufteil then
      KaPos.holeKinderAusASTUELIPOS;

  end;

end;

end.
