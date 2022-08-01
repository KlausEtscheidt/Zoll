unit UnippsStueliPos;

interface
  uses System.RTTI, System.SysUtils,System.Generics.Collections,
       System.Classes,System.StrUtils,
       Data.DB,Logger,
       Teil, Stueckliste, PumpenDataSet,Tools;

  type
    EWStueliPos=class(Exception);

  type
//    TWTeil= Teil.TWTeil;

    TWUniStueliPos = class(TWStueliPos)
      private
        procedure raiseNixGefunden();

      public

        PosTyp : String;
        //Daten direkt aus UNIPPS
        TeileNr:String;
        PosNr:String;
        OA:Integer;
        UnippsTyp:String;
        BeschaffungsArt:Integer;
//        Menge:Double;   geerbt
        FANr:Integer;
        VerursacherArt:Integer;
        UebergeordneteStueNr:Integer;
        Ds:Integer;
        SetBlock:Integer;
        //Ermittelte Daten
        SummeEU, SummeNonEU : Double;
        PreisEU, PreisNonEU : Double;
        VerkaufsPreisRabattiert : Double;
        VerkaufsPreisUnRabattiert : Double;
//        Ebene:Integer;
//        EbeneNice:String;

        //Teile-Objekt zu dieser Stueli-Pos
        Teil : TWTeil;

        constructor Create(einVater: TWUniStueliPos; APosTyp:String;
                      aIdStu:String;aIdPos: Integer;eMenge:Double);
        procedure PosDatenSpeichern(Qry: TWUNIPPSQry);
        procedure SucheTeilzurStueliPos();
        procedure holeKindervonEndKnoten();
        function holeKinderAusASTUELIPOS(): Boolean;
        function holeKinderAusTeileStu(): Boolean;
        procedure SummierePreise;
        procedure BerechnePreisDerPosition;
        function ToStr():String;
        procedure DatenInAusgabe(ZielDS:TWDataSet);
        procedure InGesamtTabelle(ZielDS:TWDataSet; FirstRun:Boolean=True);

      end;

  type
    TWEndKnotenListe = class(TList<TWUniStueliPos>)
        public
          function ToStr():String;
    end;

var
  EndKnotenListe: TWEndKnotenListe;

implementation

uses Kundenauftrag,KundenauftragsPos,FertigungsauftragsKopf,
     FertigungsauftragsPos,TeilAlsStuPos;

// Create
//---------------------------------------------------------------------
constructor TWUniStueliPos.Create(einVater: TWUniStueliPos; APosTyp:String;
                              aIdStu:String;aIdPos: Integer;eMenge:Double);
begin

  inherited Create(einVater, aIdStu, aIdPos,eMenge);

  //Art des Eintrags
  //muss aus KA, KA_Pos, FA_Komm, FA_Serie, FA_Pos, Teil sein;
  { TODO : Check Art der Pos }

  PosTyp:=APosTyp;

end;

// Speichert fuer die Ausgabe relevante Daten in Ausgabe
//---------------------------------------------------------------------
procedure TWUniStueliPos.PosDatenSpeichern(Qry: TWUNIPPSQry);
//var fieldnames:System.TArray<String>;

begin

    //Debuggen
//    fieldnames:=Qry.GetFieldNames; //zum Debuggen
//    if (IndexStr('unipps_typ', fieldnames) = -1) then
//      fieldnames:=Qry.GetFieldNames; //zum Debuggen


    //Allgemeingueltige Felder
    //-----------------------------------------------
    IdStu:=Qry.Fields.FieldByName('id_stu').AsString;
    PosNr:=Qry.Fields.FieldByName('pos_nr').AsString;
    TeileNr:=Qry.Fields.FieldByName('stu_t_tg_nr').AsString;
    OA:=Qry.Fields.FieldByName('stu_oa').AsInteger;
    UnippsTyp:=Qry.Fields.FieldByName('stu_unipps_typ').AsString;

    //typspezifische Felder
    //-----------------------------------------------
    if PosTyp='KA_Pos' then
    begin
      IdPos:=Qry.Fields.FieldByName('id_pos').AsInteger;
      BeschaffungsArt:=Qry.Fields.FieldByName('besch_art').AsInteger;
      Menge:=Qry.Fields.FieldByName('menge').AsFloat;

    end
    else
    if (PosTyp='FA_Serie') or (PosTyp='FA_Komm') then
    begin
      FANr:=Qry.Fields.FieldByName('FA_Nr').AsInteger;
      VerursacherArt:=Qry.Fields.FieldByName('verurs_art').AsInteger;
      Menge:=1.;
    end
    else
    if PosTyp='FA_Pos' then
    begin
      IdPos:=Qry.Fields.FieldByName('id_pos').AsInteger;
      UebergeordneteStueNr:=Qry.Fields.FieldByName('ueb_s_nr').AsInteger;
      Ds:=Qry.Fields.FieldByName('ds').AsInteger;
      SetBlock:=Qry.Fields.FieldByName('set_block').AsInteger;
      Menge:=Qry.Fields.FieldByName('menge').AsFloat;

    end
    else
    if PosTyp='Teil' then
      Menge:=Qry.Fields.FieldByName('menge').AsFloat
    else
      raise EWStueliPos.Create('Unbekannter Postyp '+PosTyp );

end;

// Sucht die Informationen zu dem Teil auf der Stuecklistenpos
//------------------------------------------------------------
procedure TWUniStueliPos.SucheTeilzurStueliPos();

var
  Qry: TWUNIPPSQry;
  gefunden: Boolean;

begin
    Qry:=Tools.getQuery();
    gefunden:=Qry.SucheDatenzumTeil(TeileNr);
    if gefunden then
    begin
      //Teil anlegen
      Teil:= TWTeil.Create(Qry);
//      StueliTeil:=Teil;
      //merken das Pos Teil hat
      hatTeil:=True;

    end;
    Qry.Free;

end;

//--------------------------------------------------------------------------
// Struktur-Aufbau
//--------------------------------------------------------------------------

// Haupteinsprung für Suche von Kindern der bisherigen Endknoten
// prüft Teileart und sucht je nach Art und Suchstrategie
// in der Stückliste des Serien-FA zum Teil oder in der Teilestückliste
//--------------------------------------------------------------------------
procedure TWUniStueliPos.holeKindervonEndKnoten();
type
  TWStrategie = (nurTeil,FAzuerst);
var
  gefunden: Boolean;
  Strategie: TWStrategie;

begin

  // Strategie festlegen
  Strategie := FAzuerst;
  //Strategie := nurTeil;

  if Teil.istKaufteil then
  begin
      raise EWStueliPos.Create('Huch Kaufteile sollten hier nicht hinkommen >'
    + Teil.TeileNr + '< gefunden. (holeKindervonEndKnoten)');
    Tools.Log.Log('Kaufteil gefunden' + Self.ToStr)
  end
  else
  if Teil.istEigenfertigung then
  begin
    //Fuer die weitere Suche gibt es hier noch 2 Varianten, da unklar welche besser (richtig)
    //Die Suche erfolgt entweder �ber Ferftigungsauftr�ge oder �ber die Baukasten-St�ckliste des Teiles
    If Strategie = FAzuerst Then
    begin
      //Suche erst �ber FA
      gefunden := holeKinderAusASTUELIPOS();
      //Wenn im FA nix gefunden Suche �ber Teile-STU
      If Not gefunden Then
          //Immer noch nix gefunden: Wie bl�d
          If Not holeKinderAusTeileStu() Then
            raiseNixGefunden
    end
    Else
        //Suche nur �ber Teilestueckliste
        If Not holeKinderAusTeileStu() Then
          raiseNixGefunden
  end
  else
  if Teil.istFremdfertigung then
  begin
      //Suche nur �ber Teilestueckliste, da es normal keinen FA gibt
      If Not holeKinderAusTeileStu() Then
          raiseNixGefunden
  end
  else
    raise EWStueliPos.Create('Unbekannte Beschaffungsart für Teil>' + Teil.TeileNr + '<');

end;

// Sucht Kinder über die Stückliste eines Serien-FA
//--------------------------------------------------------------------------
function TWUniStueliPos.holeKinderAusASTUELIPOS(): Boolean;
var gefunden: Boolean;
var Qry: TWUNIPPSQry;
var FAKopf:TWFAKopf;

begin
  //Gibt es auftragsbezogene FAs zur Pos im Kundenauftrag
  Qry := Tools.getQuery;
  gefunden := Qry.SucheFAzuTeil(Teil.TeileNr);

  if not gefunden then
  begin
    //Suche hier abbrechen
    Result:=False;
    Qry.Free;
    Exit;
  end;

  //Serien-FA gefunden => Suche dessen Kinder in ASTUELIPOS
  //Zu Doku und Testzwecken wirden der FA-Kopf als Dummy-St�cklisten-Eintrag
  //in die St�ckliste mit aufgenommen

  try
    //Erzeuge Objekt fuer einen Serien FA
    FAKopf:=TWFAKopf.Create(Self,'FA_Serie', Qry);
    Tools.Log.Log(FAKopf.ToStr);

    // Da es nur den einen FA f�r die STU gibt, mit Index 1 in Stueck-Liste �bernehmen
    Stueli.Add(StrToInt (FAKopf.FA_Nr), FAKopf);

    // Kinder suchen
    FAKopf.holeKinderAusASTUELIPOS;
    Result:=True;

  finally
    Qry.Free;
  end;

end;

// Sucht Kinder über die Stückliste des Teils
//--------------------------------------------------------------------------
function TWUniStueliPos.holeKinderAusTeileStu(): Boolean;
  var
   gefunden:  Boolean;
   TeilInStu: TWTeilAlsStuPos;
   Qry: TWUNIPPSQry;

begin
    //Gibt es eine St�ckliste zum Teil
    Qry := Tools.getQuery;
    gefunden := Qry.SucheStuelizuTeil(Teil.TeileNr);

    if not gefunden then
    begin
      //Suche hier abbrechen
      Result:=False;
      Qry.Free;
      Exit;
    end;


  try
      //Wenn Stu gefunden
      While Not Qry.EOF do
      begin

          //aktuellen Datensatz in StueliPos-Objekt wandeln
          TeilInStu:=TWTeilAlsStuPos.Create(Self, Qry);
          Tools.Log.Log(TeilInStu.ToStr);

          //in Stueck-Liste �bernehmen
          Stueli.Add(TeilInStu.TeilIdPos, TeilInStu);

          //merken als Teil noch ohne Kinder fuer weitere Suchl�ufe
          if not TeilInStu.Teil.istKaufteil then
            EndKnotenListe.Add(TeilInStu);

          //Naechster Datensatz
          Qry.Next;

      end;

      Result:=True;

  finally
    Qry.Free;
  end;

end;

//--------------------------------------------------------------------------
// Struktur Loops
//--------------------------------------------------------------------------

{Summiere Preise fuer ein Teil
 aus der Summe der Kosten aller Teile in seiner Stueckliste
 und einem evtl zusaetzlich vorhandenen eigenen Preis

'Beispiel Laufraeder: wir kaufen 233I26543PERF03 bei Ottenstein
in der Stueckliste ist aber die Gewindebuchse 544D26265NKM019, die wir auch kaufen
Der Gesatmpreis ist also Summe aller Teile in der Stueckliste + eigener Preis
}
procedure TWUniStueliPos.SummierePreise;
var
  StueliPos: TWUniStueliPos;
  StueliPosKey: Integer;

begin

    SummeEU:=0; SummeNonEU:=0;
    {Fa's mit verursacher_art <> 1 sind untergeordnete FA z.B zu einer Pumpenmontage
     Deren Teile sind schon im Haupt-FA enthalten und d�rfen daher hier nicht nochmals in die Preissumme einflie�en
     Sie sollen zum debuggen aber in der Struktur enthalten sein }
      If PosTyp='FA_Komm' Then
          If VerursacherArt <> 1 Then
              Exit;

  //Preise der Unterpositionen summieren
  for StueliPosKey in SortedKeys  do
  begin
//    StueliPos:= Stueli[StueliPosKey].AsType<TWUniStueliPos>;
    StueliPos:= Stueli[StueliPosKey] As TWUniStueliPos;

    //Rekursion
    StueliPos.SummierePreise;

    //Gesamtsumme ist Summe der Summen aller Kinder
    SummeEU := SummeEU + StueliPos.SummeEU;
    SummeNonEU := SummeNonEU + StueliPos.SummeNonEU;

  end;

  // Eigen-Preis der Position ermitteln
  // Umrechnung mit Gesamtmenge und Einheiten
  BerechnePreisDerPosition;

  //Eigenen Preis dazu
  SummeEU := SummeEU + PreisEU;
  SummeNonEU := SummeNonEU + PreisNonEU;

end;

// rechnet den Einzelpreis aus der Bestellung mit Gesamtmenge
// und dem  Faktor faktlme_sme (Stuecklistenmengeneinheit zu Lagermengeneinheit)
// um auf den Preis der konkreten Stuecklistenposition
procedure TWUniStueliPos.BerechnePreisDerPosition;
var
  Preis : Double;

begin

    PreisEU := 0;
    PreisNonEU := 0;

    if Self.hatTeil then
      If Teil.PreisErmittelt Then
      begin
          Preis := Teil.StueliPosGesamtPreis(MengeTotal,Teil.FaktorLmeSme);
          If Teil.IstPraeferenzberechtigt Then
              PreisEU := Preis
          Else
              PreisNonEU := Preis
      end;

end;

// Ergebnis in DataSet ausgeben
//--------------------------------------------------------------------------
procedure TWUniStueliPos.DatenInAusgabe(ZielDS:TWDataSet);

begin
  //ZielDS.Append;

  ZielDS.AddData('id_stu',IdStu);  //In Basisklasse
  ZielDS.AddData('pos_nr',PosNr);
  ZielDS.AddData('stu_t_tg_nr',TeileNr);
  ZielDS.AddData('stu_oa',OA);
  ZielDS.AddData('stu_unipps_typ',UnippsTyp);
  //'KA POs'
  ZielDS.AddData('id_pos',IdPos); //In Basisklasse
  ZielDS.AddData('besch_art',BeschaffungsArt);
  ZielDS.AddData('menge',Menge);
  //'FA_Serie' oder 'FA_Komm'
  ZielDS.AddData('FA_Nr',FANr);
  ZielDS.AddData('verurs_art',VerursacherArt);
 //FA_POs
  ZielDS.AddData('ueb_s_nr',UebergeordneteStueNr);
  ZielDS.AddData('ds',Ds);
  ZielDS.AddData('set_block',SetBlock);
 //Teil in STU

 //ermittelt
  ZielDS.AddData('PosTyp',PosTyp);
  ZielDS.AddData('PreisEU',PreisEU);
  ZielDS.AddData('PreisNonEU',PreisNonEU);
  ZielDS.AddData('SummeEU',SummeEU);
  ZielDS.AddData('SummeNonEU',SummeNonEU);
  ZielDS.AddData('vk_netto',VerkaufsPreisRabattiert);
  ZielDS.AddData('vk_brutto',VerkaufsPreisUnRabattiert);
  ZielDS.AddData('MengeTotal',MengeTotal);
  ZielDS.AddData('Ebene',Ebene);
  ZielDS.AddData('EbeneNice',EbeneNice);

  ZielDS.AddData('AnteilNonEU',0);
  ZielDS.AddData('ZuKAPos',0);
  //ZielDS.Post;
end;

//Liefert alle Eigenschaften in Werte in einem String verkettet
function TWUniStueliPos.ToStr():String;
begin
  Result:=Format('%s Stu %s Pos %d',[PosTyp, IdStu, IdPos ]);
end;


procedure TWUniStueliPos.InGesamtTabelle(ZielDS:TWDataSet; FirstRun:Boolean=True);
var
  StueliPosKey: Integer;
begin
  //Position (Self) ausgeben; aber nicht fuer Topknoten
  if not FirstRun then
  begin
    ZielDS.Append;
    //Erst Werte zur Position in Tabelle
    Self.DatenInAusgabe(ZielDS);
    //Evtl Daten des Teils dazu
    if hatTeil Then
      Teil.DatenInAusgabe(ZielDS);
    ZielDS.Post;
  end;

  //Zurueck, wenn Pos keine Kinder hat
  if Stueli.Count=0 then
    exit;

  //Wenn Kinder da, gehen wir tiefer; vorher Stuli sortieren

  //In sortierter Reihenfolge
  for StueliPosKey in SortedKeys  do
  begin
      TWUniStueliPos(Stueli[StueliPosKey]).InGesamtTabelle(ZielDS, False);
  end;

end;

//--------------------------------------------------------------------------
// Hilfs-Funktionen
//--------------------------------------------------------------------------

//Helper bricht mit Fehler ab, wenn Kinder vorhanden sein müssten,
// aber nicht gefunden wurden
procedure TWUniStueliPos.raiseNixGefunden();
begin
                                { TODO : kein Abbruch im Batchmodus }
  exit;
    raise EWStueliPos.Create('Oh je. Keine Kinder zum Nicht-Kaufteil>'
  + Teil.TeileNr + '< gefunden.')
end;

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

function TWEndKnotenListe.ToStr():String;
var
  txt:String;
//  Member:TWValue;
  StueliPos: TWUniStueliPos;

begin
  txt:= 'EndknotenListe: ';
  for StueliPos in Self do
  begin
//    StueliPos:= Member.AsType<TWUniStueliPos>;
    txt:= txt + '<' + StueliPos.ToStr +  '>'  ;
  end;
  Result := txt;
end;

end.
