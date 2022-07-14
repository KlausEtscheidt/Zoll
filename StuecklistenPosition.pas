unit StuecklistenPosition;

interface
  uses System.RTTI, System.SysUtils, System.Generics.Collections,
       System.Classes,
       DBZugriff,Teil,Exceptions,Data.DB,TextWriter,Stueckliste,
       Config;

  type
    TZValue = TValue; //alias
    TZStueli = TDictionary<String, TValue>;
    //TZFeldListe = TDictionary<String, String>;

    TZStueliPos = class(TSStueliPos)
      private
        FeldListeKompl: String;
        function GetFeldListeKomplett():String ;
        procedure raiseNixGefunden();
      protected

      public

        PosTyp:String;
//        id_stu : String;
//        id_pos : String;
//        besch_art : String;
//        pos_nr : String;
//        oa : Integer;
//        t_tg_nr: String;
//        unipps_typ: String;
//        menge: Double;
//        FA_Nr: String;
//        verurs_art: String;
//        ueb_s_nr:String;
//        ds:String;
//        set_block:String;
//        Stueli: TZStueli;
//        hatTeil:Boolean;
        Teil: TZTeil;

        property FeldListeKomplett: String read GetFeldListeKomplett ;

        constructor Create(APosTyp:String);
        procedure PosDatenSpeichern(Qry: TZQry);
        procedure SucheTeilzurStueliPos();
        procedure holeKindervonEndKnoten();
        function holeKinderAusASTUELIPOS(): Boolean;
        function holeKinderAusTeileStu(): Boolean;
        function ToStrKurz():String;
        class procedure InitTextFile(filename:string);
        procedure ToTextFile;

      end;

var
  EndKnotenListe: TZEndKnotenListe;
  CSVLang,CSVKurz: TZTextFile;

implementation

uses FertigungsauftragsKopf,TeilAlsStuPos;

constructor TZStueliPos.Create(APosTyp:String);
begin

  inherited Create;

  //Art des Eintrags
  //muss aus KA, KA_Pos, FA_Komm, FA_Serie, FA_Pos, Teil sein;

  PosTyp:=APosTyp;
  AddPosData('PosTyp', APosTyp);
  //Liste zur Ausgabe der Eigenschaften anlegen
  //FeldListeKompl:=TSFeldListe.Create;

  //untergeordenete Stueli anlegen
  //Stueli:= TZStueli.Create;

  //noch kein Teil zugeordnet (Teil wird auch nicht fuer alle PosTyp gesucht)
  //hatTeil:=False;

end;

//Überträgt allgemeingültige und typspezifische Daten aus Qry in Felder
procedure TZStueliPos.PosDatenSpeichern(Qry: TZQry);
begin

  try
    //Allgemeingültige Felder
    //-----------------------------------------------
    AddPosData('id_stu', Qry.Fields);
    AddPosData('pos_nr', Qry.Fields);
    AddPosData('oa', Qry.Fields);
    AddPosData('t_tg_nr', Qry.Fields);
    AddPosData('typ', Qry.Fields);

    //typspezifische Felder
    //-----------------------------------------------
    //vorbelegen
//    id_pos:='';
//    besch_art:='';
//    FA_Nr:='';
//    verurs_art:='';
//    ueb_s_nr:='';
//    ds:='';
//    set_block:='';

    if PosTyp='KA_Pos' then
    begin
      AddPosData('id_pos', Qry.Fields);
      AddPosData('besch_art', Qry.Fields);
      AddPosData('menge', Qry.Fields);
      //Suche Teil zur Position
      SucheTeilzurStueliPos;
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
    gefunden:=Qry.SucheDatenzumTeil(PosData['t_tg_nr']);
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

function TZStueliPos.ToStrKurz():String;
const trenn = ' ; ' ;
  meineFelder: TSDictKeys = ['id_stu','pos_nr','t_tg_nr'];
begin
  Result := ToSTr(meineFelder);
end;

class procedure TZStueliPos.InitTextFile(filename:string);
begin

  CSVLang:=TZTextFile.Create(Config.logdir+'\' + filename + '_Stu.txt');
  CSVLang.Open;
  CSVLang.ClearContent;
  CSVKurz:=TZTextFile.Create(Config.logdir+'\' + filename + '_Kalk.txt' );
  CSVKurz.Open;
  CSVKurz.ClearContent;


end;

procedure TZStueliPos.ToTextFile;

var StueliPos: TZStueliPos;
var StueliPosKey: String;
var keyArray: System.TArray<System.string>;

begin

  //Ausgeben und zurueck, wenn keine Kinder
  if Stueli.Count=0 then
  begin
    CSVLang.Log(ToStr());
    CSVKurz.Log(ToStrKurz());
    exit;
  end;

  //Wenn Kinder da, gehen wir tiefer; vorher Stuli sortieren

  //Unsortierte Zugriffs-Keys in sortiertes Array wandeln
  keyArray:=Stueli.Keys.ToArray;
  TArray.Sort<String>(keyArray);

  for StueliPosKey in keyArray  do
  begin
    StueliPos:= Stueli[StueliPosKey].AsType<TZStueliPos>;
    StueliPos.ToTextFile;
  end;

end;

function TZStueliPos.GetFeldListeKomplett():String ;
begin

end;

end.
