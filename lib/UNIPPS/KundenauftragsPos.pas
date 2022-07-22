unit KundenauftragsPos;

interface

uses  System.SysUtils,FertigungsauftragsKopf, UnippsStueliPos,
         Tools;

type
  TWKundenauftragsPos = class(TWUniStueliPos)
    private
      Rabatt:Double;
    public
      //Einige Felder mit eindeutigen Namen zur Unterscheidung von Basisklasse
      KaPosIdStu: String;   //nur f Debug, redundant in Posdaten
      KaPosIdPos: Integer;
      KaPosPosNr: String;  //hier nur zum Debuggen, redundant in Posdaten
      vk_brutto: Double;
      vk_netto: Double;
      constructor Create(einVater: TWUniStueliPos; Qry: TWUNIPPSQry; Kundenrabatt: Double);
      procedure holeKinderAusASTUELIPOS;
    end;

implementation

constructor TWKundenauftragsPos.Create(einVater: TWUniStueliPos; Qry: TWUNIPPSQry; Kundenrabatt: Double);
var
  Menge:Double;
begin
  //UNIPPS-Mapping  auftragpos.ident_nr1 as id_stu, auftragpos.ident_nr2 as id_pos
  // auftragpos.pos as pos_nr,
  KaPosIdStu:=Qry.FieldByName('id_stu').AsString;
  KaPosIdPos:=Qry.FieldByName('id_pos').Value;
  KaPosPosNr:=Qry.FieldByName('pos_nr').AsString;
  Menge:=Qry.FieldByName('menge').Value;
//  Menge:=0;
  inherited Create(einVater, 'KA_Pos', KaPosIdStu, KaPosIdPos, Menge);

  //Speichere typunabh�ngige Daten �ber geerbte Funktion
  PosDatenSpeichern(Qry);
  //Speichere typabh�ngige Daten
  Rabatt:=Kundenrabatt;
  vk_brutto:=Qry.FieldByName('preis').AsFloat;
  vk_netto:=vk_brutto * (1 + Rabatt); //Rabbat hat Minuszeichen in UNIPPS
  Ausgabe.AddData('vk_netto',FloatToStr(vk_netto));
  Ausgabe.AddData('vk_brutto',FloatToStr(vk_brutto));

  //Suche Teil zur Position  (ueber Vaterklasse TWUniStueliPos)
  SucheTeilzurStueliPos();

end;

procedure TWKundenauftragsPos.holeKinderAusASTUELIPOS;

var gefunden: Boolean;
var Qry: TWUNIPPSQry;
var FAKopf:TWFAKopf;
var FAStueliKey:String; //Stueli Key f�r FA's
var lfn: Integer;

begin
  //Gibt es auftragsbezogene FAs zur Pos im Kundenauftrag
  Qry := Tools.getQuery;
  gefunden := Qry.SucheFAzuKAPos(KaPosIdStu, KaPosIdPos );

  if not gefunden then
  begin
    //Pos in EndKnoten zur spaeteren Suche merken
    EndKnotenListe.Add(Self);
    Exit;
  end;

  lfn:=1;
  //Ein oder mehrere FA gefunden => Suche deren Kinder in ASTUELIPOS
  //Zu Doku und Testzwecken werden die FA-K�pfe als Dummy-St�cklisten-Eintr�ge
  //in die St�ckliste mit aufgenommen
  while not Qry.Eof do
  begin
    //Erzeuge Objekt fuer einen auftragsbezogenen FA
    FAKopf:=TWFAKopf.Create(Self, 'FA_Komm', Qry);
    Tools.Log.Log('-------FA Komm -----');
    Tools.Log.Log(FAKopf.ToStr);

    // in Stueck-Liste �bernehmen
    // Da FA keine sinnvolle Reihenfolge haben, werden sie fortlaufend numeriert
    { TODO 1 : Fa id inStueli pruefen evtl FAKopf.FaIdPos}
    Stueli.Add(lfn, FAKopf);
    lfn:=lfn+1;

    // Kinder suchen
    FAKopf.holeKinderAusASTUELIPOS;

    //Naechter Datensatz
    Qry.next;
  end;

end;

end.
