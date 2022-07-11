unit KundenauftragsPos;

interface

uses  System.SysUtils,FertigungsauftragsKopf, StuecklistenPosition, DBZugriff;

type
  TZKundenauftragsPos = class(TZStueliPos)
    private
      Rabatt:Double;
    protected
      { protected declarations }
    public
      vk_brutto: Double;
      vk_netto: Double;
    published
      constructor Create(Qry: TZQry; Kundenrabatt: Double);
      procedure holeKinderAusASTUELIPOS;

    end;

implementation

constructor TZKundenauftragsPos.Create(Qry: TZQry; Kundenrabatt: Double);
begin
  inherited Create(KA_Pos);
  //Speichere typunabhängige Daten über geerbte Funktion
  PosDatenSpeichern(Qry);
  //Speichere typabhängige Daten
  Rabatt:=Kundenrabatt;
  vk_brutto:=Qry.FieldByName('preis').AsFloat;
  vk_netto:=vk_brutto * (1 + Rabatt) //Rabbat hat Minuszeichen in UNIPPS
end;

procedure TZKundenauftragsPos.holeKinderAusASTUELIPOS;

var gefunden: Boolean;
var Qry: TZQry;
var FAKopf:TZFAKopf;
var FAStueliKey:String; //Stueli Key für FA's
var lfn: Integer;

begin
  //Gibt es auftragsbezogene FAs zur Pos im Kundenauftrag
  Qry := DBConn.getQuery;
  gefunden := Qry.SucheFAzuKAPos(id_stu, id_pos);

  lfn:=1;
  while not Qry.Eof do
  begin
    //Erzeuge Objekt fuer einen auftragsbezogenen FA
    FAKopf:=TZFAKopf.Create(FA_Komm, Qry);

    // in Stueck-Liste übernehmen
    // Da FA keine sinnvolle Reihenfolge haben, werden sie fortlaufend numeriert
    FAStueliKey:=inttostr(lfn);
    Stueli.Add(FAStueliKey, FAKopf);
    lfn:=lfn+1;

    // Kinder suchen
    FAKopf.holeKinderAusASTUELIPOS;

    //Naechter Datensatz
    Qry.next;
  end;

end;

end.
