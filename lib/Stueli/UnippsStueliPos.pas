unit UnippsStueliPos;

interface
  uses System.RTTI, System.SysUtils, System.Generics.Collections,
       System.Classes,
       Teil,Exceptions,Data.DB,Logger,Stueckliste,
       Tools;

  type

    TWUniStueliPos = class(TWStueliPos)
      private
        procedure raiseNixGefunden();
      protected

      public

        PosTyp:String;
        Teil: TWTeil;

        constructor Create(APosTyp:String);
        procedure PosDatenSpeichern(Qry: TWUNIPPSQry);
        procedure SucheTeilzurStueliPos();
        procedure holeKindervonEndKnoten();
        function holeKinderAusASTUELIPOS(): Boolean;
        function holeKinderAusTeileStu(): Boolean;

      end;

var
  EndKnotenListe: TWEndKnotenListe;
//  CSVLang,CSVKurz: TLogFile;

implementation

uses FertigungsauftragsKopf,TeilAlsStuPos;

// Create
//---------------------------------------------------------------------
constructor TWUniStueliPos.Create(APosTyp:String);
begin

  inherited Create;

  //Art des Eintrags
  //muss aus KA, KA_Pos, FA_Komm, FA_Serie, FA_Pos, Teil sein;
  { TODO : Check Art der Pos }

  PosTyp:=APosTyp;

end;

//Uebertraegt allgemeingueltige und typspezifische Daten in die PosData
//---------------------------------------------------------------------
procedure TWUniStueliPos.PosDatenSpeichern(Qry: TWUNIPPSQry);
begin

  try
    //Allgemeingueltige Felder
    //-----------------------------------------------
    AddPosData('PosTyp', PosTyp);

    AddPosData('id_stu', Qry.Fields);
    AddPosData('pos_nr', Qry.Fields);
    AddPosData('oa', Qry.Fields);
    AddPosData('t_tg_nr', Qry.Fields);
    AddPosData('typ', Qry.Fields);

    //typspezifische Felder
    //-----------------------------------------------
    if PosTyp='KA_Pos' then
    begin
      AddPosData('id_pos', Qry.Fields);
      AddPosData('besch_art', Qry.Fields);
      AddPosData('menge', Qry.Fields);
    end
    else
    if (PosTyp='FA_Serie') or (PosTyp='FA_Komm') then
    begin
      AddPosData('FA_Nr', Qry.Fields);
      AddPosData('verurs_art', Qry.Fields);
      AddPosData('menge', '1.');
    end
    else
    if PosTyp='FA_Pos' then
    begin
      AddPosData('id_pos', Qry.Fields);
      AddPosData('ueb_s_nr', Qry.Fields);
      AddPosData('ds', Qry.Fields);
      AddPosData('set_block', Qry.Fields);
    end
    else
    if PosTyp='Teil' then
    else
      raise EStuBaumStueliPos.Create('Unbekannter Postyp '+PosTyp )

  except
    on E: EDatabaseError do
    begin
      Tools.Log.Log('EDatabaseError ' + E.Message);
      raise
    end
  else
     raise;
  end;

end;

// Sucht die Informationen zu dem Teil auf der Stuecklistenpos
//------------------------------------------------------------
procedure TWUniStueliPos.SucheTeilzurStueliPos();

var
  Qry: TWUNIPPSQry;
  gefunden: Boolean;
//  meinTeil: TWTeil;
  props:String;

begin
    Qry:=Tools.getQuery();
    gefunden:=Qry.SucheDatenzumTeil(PosData['t_tg_nr']);
    if gefunden then
    begin
      //Teil anlegen
      Teil:= TWTeil.Create(Qry);
      //Werte aus Query zum Drucken speichern
      TeileEigenschaften:=Qry.Fields  ;
      //Teil zusätzlich in Vaterklasse
      StueliTeil:=Teil;
      //merken das Pos Teil hat
      hatTeil:=True;
      TeileEigenschaften.Add(Teil.BezFeld)
//      props:=GetTeileEigenschaften;
    end;

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
      raise EStuBaumStueliPos.Create('Huch Kaufteile sollten hier nicht hinkommen >'
    + Teil.t_tg_nr + '< gefunden. (holeKindervonEndKnoten)');
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
    raise EStuBaumStueliPos.Create('Unbekannte Beschaffungsart für Teil>' + Teil.t_tg_nr + '<');

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
  gefunden := Qry.SucheFAzuTeil(Teil.t_tg_nr);

  if not gefunden then
  begin
    //Suche hier abbrechen
    Result:=False;
    Exit;
  end;

  //Serien-FA gefunden => Suche dessen Kinder in ASTUELIPOS
  //Zu Doku und Testzwecken wirden der FA-Kopf als Dummy-St�cklisten-Eintrag
  //in die St�ckliste mit aufgenommen

  //Erzeuge Objekt fuer einen auftragsbezogenen FA
  FAKopf:=TWFAKopf.Create('FA_Serie', Qry);
  Tools.Log.Log(FAKopf.ToStr);

  // Da es nur den einen FA f�r die STU gibt, mit Index 1 in Stueck-Liste �bernehmen
  Stueli.Add(FAKopf.FA_Nr, FAKopf);

  // Kinder suchen
  FAKopf.holeKinderAusASTUELIPOS;

  Result:=True;

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
    gefunden := Qry.SucheStuelizuTeil(Teil.t_tg_nr);

    if not gefunden then
    begin
      //Suche hier abbrechen
      Result:=False;
      Exit;
    end;


    //Wenn Stu gefunden
    While Not Qry.EOF do
    begin

        //aktuellen Datensatz in StueliPos-Objekt wandeln
        TeilInStu:=TWTeilAlsStuPos.Create(Qry);
        Tools.Log.Log(TeilInStu.ToStr);

        //in Stueck-Liste �bernehmen
        Stueli.Add(TeilInStu.pos_nr, TeilInStu);

        //merken als Teil noch ohne Kinder fuer weitere Suchl�ufe
        if not TeilInStu.Teil.istKaufteil then
          EndKnotenListe.Add(TeilInStu);

        //Naechster Datensatz
        Qry.Next;

    end;

    Result:=True;

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
    raise EStuBaumStueliPos.Create('Oh je. Keine Kinder zum Nicht-Kaufteil>'
  + Teil.t_tg_nr + '< gefunden.')
end;


end.
