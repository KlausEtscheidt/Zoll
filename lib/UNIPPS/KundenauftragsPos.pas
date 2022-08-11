﻿unit KundenauftragsPos;

interface

uses  System.SysUtils,FertigungsauftragsKopf, UnippsStueliPos,
         Tools;

type
  TWKundenauftragsPos = class(TWUniStueliPos)
    private
      Rabatt:Double;
    public
      //Einige Felder mit eindeutigen Namen zur Unterscheidung von Basisklasse
      KaPosIdStuVater: String;   //nur f Debug, redundant in Posdaten
      KaPosIdPos: Integer;
      KaPosPosNr: String;  //hier nur zum Debuggen, redundant in Posdaten
      constructor Create(einVater: TWUniStueliPos; Qry: TWUNIPPSQry; Kundenrabatt: Double);
      procedure holeKinderAusASTUELIPOS;
    end;

implementation

constructor TWKundenauftragsPos.Create(einVater: TWUniStueliPos; Qry: TWUNIPPSQry; Kundenrabatt: Double);
var
  Menge:Double;
  IdStuPos:String;
begin
  //UNIPPS-Mapping SucheKundenAuftragspositionen
  // auftragpos.ident_nr1 as id_stu, auftragpos.ident_nr2 as id_pos
  // auftragpos.pos as pos_nr,
  { TODO : einiges doppelt hier ? }
  KaPosIdStuVater:=Qry.FieldByName('id_stu').AsString;
  KaPosIdPos:=Qry.FieldByName('id_pos').Value;
  KaPosPosNr:=Trim(Qry.FieldByName('pos_nr').AsString);
  IdStuPos:=KaPosIdStuVater+'_'+ KaPosPosNr;  //Eigene ID
  Menge:=Qry.FieldByName('menge').Value;
  inherited Create(einVater, 'KA_Pos', IdStuPos, Menge);

  //Speichere typunabh�ngige Daten �ber geerbte Funktion
  PosDatenSpeichern(Qry);
  //Speichere typabh�ngige Daten
  Rabatt:=Kundenrabatt;
  VerkaufsPreisUnRabattiert:=Qry.FieldByName('preis').AsFloat;
  VerkaufsPreisRabattiert:=VerkaufsPreisUnRabattiert * (1 + Rabatt); //Rabbat hat Minuszeichen in UNIPPS

  //Suche Teil zur Position  (ueber Vaterklasse TWUniStueliPos)
  SucheTeilzurStueliPos();

end;

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
  //Zu Doku und Testzwecken werden die FA-K�pfe als Dummy-St�cklisten-Eintr�ge
  //in die Stückliste mit aufgenommen
  while not Qry.Eof do
  begin
    //Erzeuge Objekt fuer einen auftragsbezogenen FA
    //die id_pos aus der Qry ist die des KA macht daher keinen Sinn
    FAKopf:=TWFAKopf.Create(Self, 'FA_Komm', Qry);
    Tools.Log.Log('-------FA Komm -----');
    Tools.Log.Log(FAKopf.ToStr);

    // in Stueck-Liste �bernehmen
    StueliAdd(FAKopf);

    // Kinder suchen
    FAKopf.holeKinderAusASTUELIPOS;

    //Naechter Datensatz
    Qry.next;
  end;

end;

end.
