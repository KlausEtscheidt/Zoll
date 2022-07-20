unit UnippsStueliPos;

interface
  uses System.RTTI, System.SysUtils, System.Generics.Collections,
       System.Classes,
       Teil,Exceptions,Data.DB,Logger,Stueckliste,
       Tools;

  type
    TWValue = TValue; //alias
//    TWStueli = TDictionary<String, TValue>;
    //TWFeldListe = TDictionary<String, String>;

    TWUniStueliPos = class(TWStueliPos)
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
//        Stueli: TWStueli;
//        hatTeil:Boolean;
        Teil: TWTeil;

        property FeldListeKomplett: String read GetFeldListeKomplett ;

        constructor Create(APosTyp:String);
        procedure PosDatenSpeichern(Qry: TWUNIPPSQry);
        procedure SucheTeilzurStueliPos();
        procedure holeKindervonEndKnoten();
        function holeKinderAusASTUELIPOS(): Boolean;
        function holeKinderAusTeileStu(): Boolean;
        function ToStrKurz():String;
        class procedure InitOutputFiles(filename:string);
        procedure ToTextFile;

      end;

var
  EndKnotenListe: TWEndKnotenListe;
  CSVLang,CSVKurz: TLogFile;

implementation

uses FertigungsauftragsKopf,TeilAlsStuPos;

constructor TWUniStueliPos.Create(APosTyp:String);
begin

  inherited Create;

  //Art des Eintrags
  //muss aus KA, KA_Pos, FA_Komm, FA_Serie, FA_Pos, Teil sein;

  PosTyp:=APosTyp;
  AddPosData('PosTyp', APosTyp);
  //Liste zur Ausgabe der Eigenschaften anlegen
  //FeldListeKompl:=TSFeldListe.Create;

  //untergeordenete Stueli anlegen
  //Stueli:= TWStueli.Create;

  //noch kein Teil zugeordnet (Teil wird auch nicht fuer alle PosTyp gesucht)
  //hatTeil:=False;

end;

//�bertr�gt allgemeing�ltige und typspezifische Daten aus Qry in Felder
procedure TWUniStueliPos.PosDatenSpeichern(Qry: TWUNIPPSQry);
begin

  try
    //Allgemeing�ltige Felder
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
      Tools.Log.Log('EDatabaseError ' + E.Message);
      raise
    end
  else
     raise;
  end;

end;


procedure TWUniStueliPos.SucheTeilzurStueliPos();

var
  Qry: TWUNIPPSQry;
  gefunden: Boolean;

begin
    Qry:=Tools.getQuery();
    gefunden:=Qry.SucheDatenzumTeil(PosData['t_tg_nr']);
    if gefunden then
    begin
      Teil:= TWTeil.Create(Qry);
      hatTeil:=True;
      if   Teil.istKaufteil then
        Teil.holeMaxPreisAus3Bestellungen;
    end;

end;

procedure TWUniStueliPos.holeKindervonEndKnoten();
var
  gefunden: Boolean;

begin

  if Teil.istKaufteil then
  begin
      raise EStuBaumStueliPos.Create('H��h Kaufteile sollten hier nicht hinkommen >'
    + Teil.t_tg_nr + '< gefunden. (holeKindervonEndKnoten)');
    Tools.Log.Log('Kaufteil gefunden' + Self.ToStr)
  end
  else
  if Teil.istEigenfertigung then
  begin
    //Fuer die weitere Suche gibt es hier noch 2 Varianten, da unklar welche besser (richtig)
    //Die Suche erfolgt entweder �ber Ferftigungsauftr�ge oder �ber die Baukasten-St�ckliste des Teiles
    If 1 = 1 Then
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
    raise EStuBaumStueliPos.Create('Unbekannte Beschaffungsart f�r Teil>' + Teil.t_tg_nr + '<');

end;

//Suche in Serien-FA
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

procedure TWUniStueliPos.raiseNixGefunden();
begin
  exit;
    raise EStuBaumStueliPos.Create('Oh je. Keine Kinder zum Nicht-Kaufteil>'
  + Teil.t_tg_nr + '< gefunden.')
end;

function TWUniStueliPos.ToStrKurz():String;
const trenn = ' ; ' ;
  meineFelder: TwDictKeys = ['id_stu','pos_nr','t_tg_nr'];
begin
  Result := ToSTr(meineFelder);
end;

class procedure TWUniStueliPos.InitOutputFiles(filename:string);
begin
  Tools.CSVLang.OpenNew(Tools.LogDir,filename + '_Struktur.txt');
  Tools.CSVKurz.OpenNew(Tools.LogDir,filename + '_Kalk.txt');
end;

procedure TWUniStueliPos.ToTextFile;

var StueliPos: TWUniStueliPos;
var StueliPosKey: String;
var keyArray: System.TArray<System.string>;

begin

  //Ausgeben und zurueck, wenn keine Kinder
  if Stueli.Count=0 then
  begin
    Tools.CSVLang.Log(ToStr());
    Tools.CSVKurz.Log(ToStrKurz());
    exit;
  end;

  //Wenn Kinder da, gehen wir tiefer; vorher Stuli sortieren

  //Unsortierte Zugriffs-Keys in sortiertes Array wandeln
  keyArray:=Stueli.Keys.ToArray;
  TArray.Sort<String>(keyArray);

  for StueliPosKey in keyArray  do
  begin
    StueliPos:= Stueli[StueliPosKey].AsType<TWUniStueliPos>;
    StueliPos.ToTextFile;
  end;

end;

function TWUniStueliPos.GetFeldListeKomplett():String ;
begin

end;

end.
