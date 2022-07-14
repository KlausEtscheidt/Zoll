unit KundenauftragsPos;

interface

uses  System.SysUtils,FertigungsauftragsKopf, StuecklistenPosition,
         DBZugriff,TextWriter;

type
  TZKundenauftragsPos = class(TZStueliPos)
    private
      Rabatt:Double;
    public
      vk_brutto: Double;
      vk_netto: Double;
      constructor Create(Qry: TZQry; Kundenrabatt: Double);
      procedure holeKinderAusASTUELIPOS;
    end;

implementation

constructor TZKundenauftragsPos.Create(Qry: TZQry; Kundenrabatt: Double);
begin
  inherited Create('KA_Pos');
  //Speichere typunabhängige Daten über geerbte Funktion
  PosDatenSpeichern(Qry);
  //Speichere typabhängige Daten
  Rabatt:=Kundenrabatt;
  vk_brutto:=Qry.FieldByName('preis').AsFloat;
  vk_netto:=vk_brutto * (1 + Rabatt); //Rabbat hat Minuszeichen in UNIPPS
  AddPosData('vk_netto',FloatToStr(vk_netto));
  AddPosData('vk_brutto',FloatToStr(vk_brutto));
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
  gefunden := Qry.SucheFAzuKAPos(PosData['id_stu'],PosData['id_pos'] );

  if not gefunden then
  begin
    //Pos in EndKnoten zur spaeteren Suche merken
    EndKnotenListe.Add(Self);
    Exit;
  end;

  lfn:=1;
  //Ein oder mehrere FA gefunden => Suche deren Kinder in ASTUELIPOS
  //Zu Doku und Testzwecken werden die FA-Köpfe als Dummy-Stücklisten-Einträge
  //in die Stückliste mit aufgenommen
  while not Qry.Eof do
  begin
    //Erzeuge Objekt fuer einen auftragsbezogenen FA
    FAKopf:=TZFAKopf.Create('FA_Komm', Qry);
    Log.Log('-------FA Komm -----');
    Log.Log(FAKopf.ToStr);

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
