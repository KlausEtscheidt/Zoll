unit KundenauftragsPos;

interface

uses  System.SysUtils,FertigungsauftragsKopf, UnippsStueliPos,
         Tools;

type
  TWKundenauftragsPos = class(TWUniStueliPos)
    private
      Rabatt:Double;
    public
      vk_brutto: Double;
      vk_netto: Double;
      constructor Create(Qry: TWUNIPPSQry; Kundenrabatt: Double);
      procedure holeKinderAusASTUELIPOS;
    end;

implementation

constructor TWKundenauftragsPos.Create(Qry: TWUNIPPSQry; Kundenrabatt: Double);
begin
  inherited Create('KA_Pos');
  //Speichere typunabh�ngige Daten �ber geerbte Funktion
  PosDatenSpeichern(Qry);
  //Speichere typabh�ngige Daten
  Rabatt:=Kundenrabatt;
  vk_brutto:=Qry.FieldByName('preis').AsFloat;
  vk_netto:=vk_brutto * (1 + Rabatt); //Rabbat hat Minuszeichen in UNIPPS
  AddPosData('vk_netto',FloatToStr(vk_netto));
  AddPosData('vk_brutto',FloatToStr(vk_brutto));

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
  gefunden := Qry.SucheFAzuKAPos(PosData['id_stu'],PosData['id_pos'] );

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
    FAKopf:=TWFAKopf.Create('FA_Komm', Qry);
    Tools.Log.Log('-------FA Komm -----');
    Tools.Log.Log(FAKopf.ToStr);

    // in Stueck-Liste �bernehmen
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
