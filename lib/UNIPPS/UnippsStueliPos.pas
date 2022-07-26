unit UnippsStueliPos;

interface
  uses System.RTTI, System.SysUtils,System.Generics.Collections,
       System.Classes,System.StrUtils,
       Teil,Exceptions,Data.DB,Logger,Stueckliste,
       Tools;

  type
    TWTeil= Teil.TWTeil;
    TWUniStueliPos = class(TWStueliPos)
      private
        procedure raiseNixGefunden();
      protected

      public

        PosTyp:String;
        Teil: TWTeil;
        constructor Create(einVater: TWUniStueliPos; APosTyp:String;
                      aIdStu:String;aIdPos: Integer;eMenge:Double);
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
var fieldnames:System.TArray<String>;

begin

    //Debuggen
//    fieldnames:=Qry.GetFieldNames; //zum Debuggen
//    if (IndexStr('unipps_typ', fieldnames) = -1) then
//      fieldnames:=Qry.GetFieldNames; //zum Debuggen


    //Allgemeingueltige Felder
    //-----------------------------------------------
    Ausgabe.AddData('PosTyp', PosTyp);
    Ausgabe.AddData('id_stu', Qry.Fields);
    Ausgabe.AddData('pos_nr', Qry.Fields);
    Ausgabe.AddData('oa', Qry.Fields);
    Ausgabe.AddData('t_tg_nr', Qry.Fields);
    Ausgabe.AddData('unipps_typ', Qry.Fields);

    //typspezifische Felder
    //-----------------------------------------------
    if PosTyp='KA_Pos' then
    begin
      Ausgabe.AddData('id_pos', Qry.Fields);
      Ausgabe.AddData('besch_art', Qry.Fields);
      Ausgabe.AddData('menge', Qry.Fields);
    end
    else
    if (PosTyp='FA_Serie') or (PosTyp='FA_Komm') then
    begin
      Ausgabe.AddData('FA_Nr', Qry.Fields);
      Ausgabe.AddData('verurs_art', Qry.Fields);
      Ausgabe.AddData('menge', '1.');
    end
    else
    if PosTyp='FA_Pos' then
    begin
      Ausgabe.AddData('id_pos', Qry.Fields);
      Ausgabe.AddData('ueb_s_nr', Qry.Fields);
      Ausgabe.AddData('ds', Qry.Fields);
      Ausgabe.AddData('set_block', Qry.Fields);
      Ausgabe.AddData('menge', Qry.Fields);
    end
    else
    if PosTyp='Teil' then
      Ausgabe.AddData('menge', Qry.Fields)
    else
      raise EStuBaumStueliPos.Create('Unbekannter Postyp '+PosTyp );

end;

// Sucht die Informationen zu dem Teil auf der Stuecklistenpos
//------------------------------------------------------------
procedure TWUniStueliPos.SucheTeilzurStueliPos();

var
  Qry: TWUNIPPSQry;
  gefunden: Boolean;

begin
    Qry:=Tools.getQuery();
    try
      gefunden:=Qry.SucheDatenzumTeil(Ausgabe['t_tg_nr']);
      if gefunden then
      begin
        //Teil anlegen
        Teil:= TWTeil.Create(Qry);
        StueliTeil:=Teil;
        //merken das Pos Teil hat
        hatTeil:=True;

      end;
    finally
      Qry.Free;
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
    + Teil.TeilTeilenummer + '< gefunden. (holeKindervonEndKnoten)');
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
    raise EStuBaumStueliPos.Create('Unbekannte Beschaffungsart für Teil>' + Teil.TeilTeilenummer + '<');

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
  gefunden := Qry.SucheFAzuTeil(Teil.TeilTeilenummer);

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
    gefunden := Qry.SucheStuelizuTeil(Teil.TeilTeilenummer);

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
  + Teil.TeilTeilenummer + '< gefunden.')
end;


end.
