unit StuecklistenPosition;

interface
  uses System.RTTI, System.SysUtils, System.Generics.Collections,
       DBZugriff,Teil,Exceptions,Data.DB,Logger,Stueckliste;

  type
    TZValue = TValue; //alias
    TZStueli = TDictionary<String, TValue>;
    TZStueliPos = class(TObject)
      private
        procedure raiseNixGefunden();
      protected
      public
        PosTyp:String;
        id_stu : String;
        id_pos : String;
        besch_art : String;
        pos_nr : String;
        oa : Integer;
        t_tg_nr: String;
        unipps_typ: String;
        menge: Double;
        FA_Nr: String;
        verurs_art: String;
        ueb_s_nr:String;
        ds:String;
        set_block:String;

        Stueli: TDictionary<String, TValue>;
        hatTeil:Boolean;
        Teil: TZTeil;

        constructor Create(APosTyp:String);
        procedure PosDatenSpeichern(Qry: TZQry);
        procedure SucheTeilzurStueliPos();
        procedure holeKindervonEndKnoten();
        function holeKinderAusASTUELIPOS(): Boolean;
        function holeKinderAusTeileStu(): Boolean;
        function ToStr():String;
      end;

var
  EndKnotenListe: TZEndKnotenListe;

implementation

uses FertigungsauftragsKopf,TeilAlsStuPos;

constructor TZStueliPos.Create(APosTyp:String);
begin
  //Art des Eintrags
  //muss aus KA, KA_Pos, FA_Komm, FA_Serie, FA_Pos, Teil sein;

  PosTyp:=APosTyp;
  //untergeordenete Stueli anlegen
  Stueli:= TZStueli.Create;
  //noch kein Teil zugeordnet (Teil wird auch nicht fuer alle PosTyp gesucht)
  hatTeil:=False;

end;

//Überträgt allgemeingültige und typspezifische Daten aus Qry in Felder
procedure TZStueliPos.PosDatenSpeichern(Qry: TZQry);
begin

  try
    //Allgemeingültige Felder
    //-----------------------------------------------
    id_stu:=trim(Qry.FieldByName('id_stu').AsString);
    pos_nr:=trim(Qry.FieldByName('pos_nr').AsString);
    oa:=Qry.FieldByName('oa').AsInteger;
    t_tg_nr:=trim(Qry.FieldByName('t_tg_nr').AsString);
    unipps_typ:=trim(Qry.FieldByName('typ').AsString);

    //typspezifische Felder
    //-----------------------------------------------
    //vorbelegen
    id_pos:='';
    besch_art:='';
    menge:=1.;
    FA_Nr:='';
    verurs_art:='';
    ueb_s_nr:='';
    ds:='';
    set_block:='';

    if PosTyp='KA_Pos' then
    begin
      id_pos:=trim(Qry.FieldByName('id_pos').AsString);
      besch_art:=Qry.FieldByName('besch_art').AsString;
      menge:=Qry.FieldByName('menge').AsFloat;
      //Suche Teil zur Position
      SucheTeilzurStueliPos;
    end
    else
    if (PosTyp='FA_Serie') or (PosTyp='FA_Komm') then
    begin
       FA_Nr:=trim(Qry.FieldByName('FA_Nr').AsString);
       verurs_art:=trim(Qry.FieldByName('verurs_art').AsString);
    end
    else
    if PosTyp='FA_Pos' then
    begin
      id_pos:=trim(Qry.FieldByName('id_pos').AsString);
      ueb_s_nr:=trim(Qry.FieldByName('ueb_s_nr').AsString);
      ds:=trim(Qry.FieldByName('ds').AsString);
      set_block:=trim(Qry.FieldByName('set_block').AsString);
    end
    else
    if PosTyp='Teil' then
      //Suche Teil zur Position
      SucheTeilzurStueliPos
    else
      raise EStuBaumStueliPos.Create('Unbekannter Postyp '+PosTyp )

  except
    on E: EDatabaseError do
    begin
      Log.Log('EDatabaseError ' + E.Message);
      raise
    end
  else
     raise;
  end;

end;


procedure TZStueliPos.SucheTeilzurStueliPos();

var
  Qry: TZQry;
  gefunden: Boolean;

begin
    Qry:=DBConn.getQuery();
    gefunden:=Qry.SucheDatenzumTeil(t_tg_nr);
    if gefunden then
    begin
      Teil:= TZTeil.Create(Qry);
      hatTeil:=True;
      if   Teil.istKaufteil then
        Teil.holeMaxPreisAus3Bestellungen;
    end;

end;

procedure TZStueliPos.holeKindervonEndKnoten();
var
  gefunden: Boolean;

begin

  if Teil.istKaufteil then
  begin
      raise EStuBaumStueliPos.Create('Hääh Kaufteile sollten hier nicht hinkommen >'
    + Teil.t_tg_nr + '< gefunden. (holeKindervonEndKnoten)');
    Log.Log('Kaufteil gefunden' + Self.ToStr)
  end
  else
  if Teil.istEigenfertigung then
  begin
    //Fuer die weitere Suche gibt es hier noch 2 Varianten, da unklar welche besser (richtig)
    //Die Suche erfolgt entweder über Ferftigungsaufträge oder über die Baukasten-Stückliste des Teiles
    If 1 = 1 Then
    begin
      //Suche erst über FA
      gefunden := holeKinderAusASTUELIPOS();
      //Wenn im FA nix gefunden Suche über Teile-STU
      If Not gefunden Then
          //Immer noch nix gefunden: Wie blöd
          If Not holeKinderAusTeileStu() Then
            raiseNixGefunden
    end
    Else
        //Suche nur über Teilestueckliste
        If Not holeKinderAusTeileStu() Then
          raiseNixGefunden
  end
  else
  if Teil.istFremdfertigung then
  begin
      //Suche nur über Teilestueckliste, da es normal keinen FA gibt
      If Not holeKinderAusTeileStu() Then
          raiseNixGefunden
  end
  else
    raise EStuBaumStueliPos.Create('Unbekannte Beschaffungsart für Teil>' + Teil.t_tg_nr + '<');

end;

//Suche in Serien-FA
function TZStueliPos.holeKinderAusASTUELIPOS(): Boolean;
var gefunden: Boolean;
var Qry: TZQry;
var FAKopf:TZFAKopf;

begin
  //Gibt es auftragsbezogene FAs zur Pos im Kundenauftrag
  Qry := DBConn.getQuery;
  gefunden := Qry.SucheFAzuTeil(Teil.t_tg_nr);

  if not gefunden then
  begin
    //Suche hier abbrechen
    Result:=False;
    Exit;
  end;

  //Serien-FA gefunden => Suche dessen Kinder in ASTUELIPOS
  //Zu Doku und Testzwecken wirden der FA-Kopf als Dummy-Stücklisten-Eintrag
  //in die Stückliste mit aufgenommen

  //Erzeuge Objekt fuer einen auftragsbezogenen FA
  FAKopf:=TZFAKopf.Create('FA_Serie', Qry);
  Log.Log(FAKopf.ToStr);

  // Da es nur den einen FA für die STU gibt, mit Index 1 in Stueck-Liste übernehmen
  Stueli.Add(FAKopf.FA_Nr, FAKopf);

  // Kinder suchen
  FAKopf.holeKinderAusASTUELIPOS;

  Result:=True;

end;


function TZStueliPos.holeKinderAusTeileStu(): Boolean;
  var
   gefunden:  Boolean;
   TeilInStu: TZTeilAlsStuPos;
   Qry: TZQry;

begin
    //Gibt es eine Stückliste zum Teil
    Qry := DBConn.getQuery;
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
        TeilInStu:=TZTeilAlsStuPos.Create(Qry);
        Log.Log(TeilInStu.ToStr);

        //in Stueck-Liste übernehmen
        //INdex ???
        Stueli.Add(TeilInStu.pos_nr, TeilInStu);

        //merken als Teil noch ohne Kinder fuer weitere Suchläufe
        if not TeilInStu.Teil.istKaufteil then
          EndKnotenListe.Add(TeilInStu);

        //Naechster Datensatz
        Qry.Next;

    end;

    Result:=True;

end;

procedure TZStueliPos.raiseNixGefunden();
begin
  exit;
    raise EStuBaumStueliPos.Create('Oh je. Keine Kinder zum Nicht-Kaufteil>'
  + Teil.t_tg_nr + '< gefunden.')
end;

function TZStueliPos.ToStr():String;
  var trenn :String;
begin
    trenn:= ' ; ';
    ToStr:=PosTyp
    + trenn + id_stu
    + trenn + id_pos
    + trenn + besch_art
    + trenn + pos_nr
    //oa : Integer;
    + trenn + t_tg_nr
    //unipps_typ: String;
    + trenn + FloatToStr(menge)
    + trenn + FA_Nr;
    //verurs_art: String;
    //ueb_s_nr:String;
    //ds:String;
    //set_block:String;

    //Stueli: TDictionary<String, TValue>;
    //hatTeil:Boolean;
    //Teil: TZTeil;
end;

end.
