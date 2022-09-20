///<summary>Position eines Kundenauftrags</summary>
///<remarks>Die Unit bildet über die Klasse TWKundenauftragsPos die Position eines Kundenauftrags ab.
///In der Basisklasse TWUniStueliPos werden alle Eigenschaften abgelegt, die auch für andere
///Stücklisten-Typen (z.B Fertigungsauftrag) relevant sind.
///</remarks>
unit KundenauftragsPos;

interface

uses  System.SysUtils,FertigungsauftragsKopf, UnippsStueliPos,
         Tools;

type
  ///<summary>Klasse zur Abbildung einer Kundenauftrags-Position</summary>
  TWKundenauftragsPos = class(TWUniStueliPos)
    private
      Rabatt:Double;
    public
      //Einige Felder mit eindeutigen Namen zur Unterscheidung von Basisklasse
      ///<summary>Id der Vater-Stueli aus UNIPPS auftragpos.ident_nr1</summary>
      KaPosIdStuVater: String;
      ///<summary>Id der Position in der Vater-Stueli aus UNIPPS auftragpos.ident_nr2</summary>
      KaPosIdPos: Integer;
      ///<summary>Positionsnr der Position in der Vater-Stueli aus UNIPPS auftragpos.pos</summary>
      KaPosPosNr: String;
      constructor Create(einVater: TWUniStueliPos; Qry: TWUNIPPSQry; Kundenrabatt: Double);
      procedure holeKinderAusASTUELIPOS;
    end;

implementation

///<summary>Erzeugt eine Kundenauftrags-Position</summary>
///<remarks>Die Position wird aus den übergebenen Daten der in "Kundenauftrag" ausgeführten Abfrage
/// "SucheKundenAuftragspositionen" erzeugt.
/// |Mit UnippsStueliPos.PosDatenSpeichern werden diejenigen Daten aus der Qry in Objekt-Felder
/// übernommen, welche auch für die anderen Stücklistentypen (z.B FA) relevant sind.
/// |Mit UnippsStueliPos.SucheTeilzurStueliPos wird das UNIPPS-Teil zu dieser Stücklisten-Position gesucht.
///</remarks>
/// <param name="einVater">Vaterknoten Objekt</param>
/// <param name="Qry">Aus den Daten der Abfrage wird die Position erzeugt.</param>
/// <param name="Kundenrabatt">Rabatt, der dem Kunden gewährt wird.</param>
constructor TWKundenauftragsPos.Create(einVater: TWUniStueliPos; Qry: TWUNIPPSQry; Kundenrabatt: Double);
var
  Menge:Double;
  IdStuPos:String;
begin
  //UNIPPS-Mapping aus Abfrage SucheKundenAuftragspositionen:
  // auftragpos.ident_nr1 as id_stu, auftragpos.ident_nr2 as id_pos, auftragpos.pos as pos_nr
  { TODO : einiges doppelt hier ? }
  KaPosIdStuVater:=Qry.FieldByName('id_stu').AsString;
  KaPosIdPos:=Qry.FieldByName('id_pos').Value;
  KaPosPosNr:=Trim(Qry.FieldByName('pos_nr').AsString);
  //Die Id der Stuecklistenpos in der Basisklasse
  IdStuPos:=KaPosIdStuVater+'_'+ KaPosPosNr;  //Eigene ID
  Menge:=Qry.FieldByName('menge').Value;
  inherited Create(einVater, 'KA_Pos', IdStuPos, Menge);

  //Speichere typunabhängige Daten über geerbte Funktion
  PosDatenSpeichern(Qry);
  //Speichere typabhängige Daten
  Rabatt:=Kundenrabatt;
  VerkaufsPreisUnRabattiert:=Qry.FieldByName('preis').AsFloat;
  VerkaufsPreisRabattiert:=VerkaufsPreisUnRabattiert * (1 + Rabatt); //Rabbat hat Minuszeichen in UNIPPS

  //Suche Teil zur Position  (ueber Vaterklasse TWUniStueliPos)
  SucheTeilzurStueliPos();

end;

///<summary>Sucht kommissionsbezogene Fertigungsaufträge und deren Kinder</summary>
procedure TWKundenauftragsPos.holeKinderAusASTUELIPOS;

var gefunden: Boolean;
var Qry: TWUNIPPSQry;
var FAKopf:TWFAKopf;

begin
  //Gibt es auftragsbezogene FAs zur Pos im Kundenauftrag
  Qry := Tools.getQuery;
  gefunden := Qry.SucheFAzuKAPos(KaPosIdStuVater, KaPosIdPos );
  Tools.Log.Log('Fand '+ IntToStr(Qry.n_records)+ ' FAs');

  if not gefunden then
  begin
    //Pos in EndKnoten zur spaeteren Suche merken
    EndKnotenListe.Add(Self);
    Exit;
  end;

  //Ein oder mehrere FA gefunden => Suche deren Kinder in ASTUELIPOS
  //Zu Doku und Testzwecken werden die FA-Köpfe als Dummy-Stücklisten-Einträge
  //in die Stückliste mit aufgenommen
  while not Qry.Eof do
  begin
    //Erzeuge Objekt fuer einen auftragsbezogenen FA
    //die id_pos aus der Qry ist die des KA macht daher keinen Sinn
    FAKopf:=TWFAKopf.Create(Self, 'FA_Komm', Qry);
    Tools.Log.Log('-------FA Komm -----');
    Tools.Log.Log(FAKopf.ToStr);

    // in Stueck-Liste übernehmen
    StueliAdd(FAKopf);

    // Kinder suchen
    FAKopf.holeKinderAusASTUELIPOS;

    //Naechter Datensatz
    Qry.next;
  end;

end;

end.
