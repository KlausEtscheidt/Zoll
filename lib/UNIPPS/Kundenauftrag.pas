/// <summary>Oberster Knoten der UNIPPS-Struktur</summary>
/// <remarks>
/// Die Klasse TWKundenauftrag bildet die oberste Ebene der auszulesenden
/// UNIPPS-Struktur ab. Sie ist vom Typ Stücklistenposition, da sie eine
/// untergeordnete Stückliste besitzt (geerbt von TWStueliPos). Diese enthält
/// die direkt untergeordneten Positionen des Kundenauftrags, die aus der
/// UNIPPS-Tabelle Auftragpos gelesen werden.
/// </remarks>
unit Kundenauftrag;

interface

uses Vcl.Forms, Vcl.Dialogs, System.SysUtils, System.Classes,
        System.Generics.Collections, System.TimeSpan, Windows,
        KundenauftragsPos, Stueckliste, Bestellung,Settings,
        PumpenDataSet, UnippsStueliPos, Tools, Datenmodul;

type
  /// <summary>Klasse für Exceptions dieser Unit</summary>
  EWKundenauftrag = class(Exception);

type
  /// <summary>Kundenauftrag: Oberster Knoten der UNIPPS-Struktur</summary>
  TWKundenauftrag = class(TWUniStueliPos)
  private
  public
    /// <summary>UNIPPS-Id des Kundenauftrages</summary>
    KaId: String;
    /// <summary>Kommissionsnummer des Kundenauftrages</summary>
    komm_nr: String;
    /// <summary>UNIPPS-Id des Kunden zu diesem Auftrag</summary>
    kunden_id: Integer;
    constructor Create(NewKaId: String);
    procedure liesKopfundPositionen;
    procedure holeKinder;
    procedure SammleAusgabeDaten;
    procedure ErmittlePraferenzBerechtigung;
  end;

implementation

/// <summary>Erzeugt über Basisklasse eine Stücklistenposition </summary>
/// <param name="NewKaId">UNIPPS-Id des Kundenauftrages</param>
constructor TWKundenauftrag.Create(NewKaId: String);
begin
  //Top-Knoten hat keine IdStuVater,IdStueliPos=NewKaId;Menge=1.
  inherited Create(nil, 'KA',NewKaId,1);
  KaId := NewKaId;
end;

/// <summary>Überträgt nach erfolgter Analyse rekursiv alle
///relevanten Daten in das DataSet ErgebnisDS.</summary>
procedure TWKundenauftrag.SammleAusgabeDaten;
begin

  //Erst mal leeren
  KaDataModule.ErgebnisDS.EmptyDataSet;

  //Oeffnen
  KaDataModule.ErgebnisDS.Active:=True;

  //Sammle rekursiv alle Daten ein
  StrukturInErgebnisTabelle(KaDataModule.ErgebnisDS, True);

end;

/// <summary>Liest die Kopfdaten und die direkt (1. Ebene) untergeordneten
///Positionen des Kundenauftrags aus UNIPPS.</summary>
/// <remarks>
/// Über die KundenId wird der prinzipielle Rabatt dieses Kunden gelesen.
/// Für die gefundenen Positionen werden Objekte des Typs TWKundenauftragsPos
/// erzeugt und in die eigene Stückliste eingetragen.
/// </remarks>
///:raises EWKundenauftrag: Wenn keine Kinder-Pos gefunden
procedure TWKundenauftrag.liesKopfundPositionen();

var
  gefunden: Boolean;
  Rabatt: Double;
  KAPos: TWKundenauftragsPos;
  KAQry, RabattQry: TWUNIPPSQry;

begin

  // Abfrage zum Lesen des Kundenauftrags und seiner Positionen
  KAQry := Tools.getQuery;
  gefunden := KAQry.SucheKundenAuftragspositionen(KaId);

  if not gefunden then
    raise Exception.Create('Keine Positionen zu KA '+KaId + ' gefunden.');

  // Daten aus dem Auftragskopf
  komm_nr := trim(KAQry.FieldByName('klassifiz').AsString);
  kunden_id := KAQry.FieldByName('kunde').AsInteger;

  // Abfrage des Rabattes zu diesem Kunden
  // SQL muss mit Datum aus allen Rabatten den gueltigen filtern
  RabattQry := Tools.getQuery;
  RabattQry.SucheKundenRabatt(inttostr(kunden_id));

  //Sollte nie vorkommen, wenn Abfrage stimmt => Abbruch
  if RabattQry.n_records > 1 then
    raise Exception.Create('Fuer Kunden-Id ' + IntToStr(kunden_id) +
                         ' wurde mehr als ein Rabatt gefunden.');

  Rabatt:=0;
  if RabattQry.n_records = 1 then
    Rabatt := RabattQry.FieldByName('zu_ab_proz').AsFloat / 100;

  //Positionen beabeiten
  while not KAQry.Eof do
  begin
    //KundenauftragsPos erzeugen; Übertrage relevante Daten aus Qry in Felder
    KAPos := TWKundenauftragsPos.Create(Self, KAQry, Rabatt);
    Tools.Log.Log('--------- KA-Pos -----------');
    Tools.Log.Log(KAPos.ToStr);

    //neue Pos in Stückliste aufnehmen
    StueliAdd(KAPos);
    KAQry.next;
  end;
  KAQry.Free;
end;


/// <summary>Schrittweise Suche aller untergeordneten Elemente </summary>
/// <remarks>
/// |Kommissions-FA haben bei der Suche Priorität. Daher zuerst:
/// |Fuer alle Stüli-Pos, die kein Kaufteil sind,
/// rekursiv in der UNIPPS-Tabelle ASTUELIPOS nach Kindern suchen.
/// |Gefundene Kinder werden in die zugehörige Stückliste aufgenommen.
/// |Alle Kinder, die in ASTUELIPOS selbst keine Kinder mehr haben,
/// werden in der Liste EndKnoten vermerkt, wenn es keine Kaufteile sind.
/// |
/// |In EndKnoten sollten jetzt nur noch Serien- und Fremd-Fertigungsteile sein.
/// |Mit TWUniStueliPos.holeKindervonEndKnoten wird nun nach Kindern
/// der Endknoten gesucht.
/// |Gefundene Kinder werden in die zugehörige Stückliste aufgenommen.
/// |Kinder, die nicht Kaufteil sind, werden in eine neue EndKnoten-Liste übernommen.
/// |Dies wird wiederholt, bis die neue EndKnoten-Liste leer bleibt.
/// </remarks>
procedure TWKundenauftrag.holeKinder();

var
 StueliPos: TWUniStueliPos;
 StueliPosKey: Integer;
 KaPos: TWKundenauftragsPos;
 alteEndKnotenListe: TWEndKnotenListe;
 EndKnoten: TWUniStueliPos;
 txt:String;

begin
  //Schritt 1 nur ueber Kommissions-FA suchen. Diese haben Prio 1.
  //Fuer alle Pos, die kein Kaufteil sind, rekursiv in der UNIPPS-Tabelle ASTUELIPOS nach Kindern suchen
  //Alle Kinder, die in ASTUELIPOS selbst keine Kinder mehr haben werden in der Liste EndKnoten vermerkt
  //---------------------------------------------------------------------------------------------

  //Liste fuer "Kinderlose" erzeugen:
  EndKnotenListe:=TWEndKnotenListe.Create;
  alteEndKnotenListe:=TWEndKnotenListe.Create;

  //Loop über alle Pos des Kundenauftrages
  //StueliKeys ist Eigenschaft von Basisklasse TWStulipos und enthält
  //die Keys zur Stueckliste sortierter Reihenfolge
  for StueliPosKey in StueliKeys do
  begin
//      KaPos:= Stueli[StueliPosKey].AsType<TWKundenauftragsPos>;
    KaPos:= Stueli[StueliPosKey] As TWKundenauftragsPos;
    Tools.Log.Log('.....................................................');
    Tools.Log.Log('Suche Kinder zu '+KaPos.ToStr);
    Tools.Log.Log('.....................................................');

    //Fuer Kaufteile muss nicht weiter gesucht werden
    if not KaPos.Teil.istKaufteil then
      //Falls ein Komm-Fa zur Pos vorhanden, werden dessen Kinder aus
      //Unipps-Tabelle ASTUELIPOS geholt
      //Falls kein Komm-Fa zur Pos vorhanden, landet der Knoten in EndKnoten
      KaPos.holeKinderAusASTUELIPOS;

  end;


  // Weitere Schritte wiederholen, bis EndKnoten leer
  //-----------------------------------------------------------------

  while EndKnotenListe.Count>0 do
  begin
    //Liste kopieren und leeren
    alteEndKnotenListe.Clear;
    alteEndKnotenListe.AddRange(EndKnotenListe);
    EndKnotenListe.Clear;
    //Zum Debuggen loggen
    txt:=alteEndKnotenListe.ToStr();
    Tools.Log.Log(txt);

    //Suche weiter
    //Bisherige Endknoten müssten Serien- und Fremd-Fertigungsteile sein
    for EndKnoten in alteEndKnotenListe do
    begin
      StueliPos:= EndKnoten As TWUniStueliPos;
      Tools.Log.Log('------Suche fuer Endknoten ----------');
      txt:=StueliPos.ToStr;
      Tools.Log.Log(txt);
      StueliPos.holeKindervonEndKnoten;
    end;

  end;

  EndKnotenListe.Free;
  alteEndKnotenListe.Free;

end;

/// <summary>Ermittelt die Präferenz-Berechtigung für alle Positionen
///des Kundenauftrages.</summary>
/// <remarks>
/// Vorraussetzungen: Für alle Pos sind Verkaufspreise bekannt und die Kosten
/// der untergeordneten Kaufteile wurden für die Pos aufsummiert.
/// Dabei fließen die Preise der Teile, die in UNIPPS kein Flag praeferenzkennung
/// besitzen, in den Wert SummeNonEU ein.
/// |Bei Positionen, die aus einem Kauf- oder Fremdfertigungs-Teil bestehen und
/// bei denen SummeNonEU nicht Null ist, war dieses Flag nicht gesetzt. Sie sind
/// daher selbst auch nicht "Präferenz berechtigt".
/// |Für alle anderen Pos wird das Verhältnis aus SummeNonEU zum Verkaufspreis
/// gebildet. Überschreitet dieses den Grenzwert MaxAnteilNonEU aus Settings.pas,
/// ist die Pos nicht "Präferenz berechtigt".
/// </remarks>
procedure TWKundenauftrag.ErmittlePraferenzBerechtigung;
var
  StueliPosKey: Integer;
  KaPos: TWKundenauftragsPos;

begin
  //Loop Über alle Pos des Kundenauftrages
  for StueliPosKey in StueliKeys do
  begin
    KaPos:= Stueli[StueliPosKey] As TWKundenauftragsPos;

    with KaPos do
    begin

      PraefBerechtigt:='Nein';

      //Erst Exceptions checken
      if VerkaufsPreisRabattiert=0 then
        raise  EWKundenauftrag.Create('Kein Verkaufspreis bekannt für ' + ToStr);
      if MengeTotal=0 then
        raise  EWKundenauftrag.Create('MengeTotal ist 0 für ' +ToStr);

      //Anteil ausser EU am VK berechnen (VerkaufsPreisRabattiert ist Stückpreis)
      AnteilNonEU:= 100*SummeNonEU/VerkaufsPreisRabattiert/MengeTotal;

      PraefBerechtigt:='ja';

      //Wenn Kaufteil
      if Teil.istKaufteil or Teil.IstFremdfertigung then
        //und Kosten ausserhalb EU
        if SummeNonEU>0 then
          PraefBerechtigt:='nein'
      else
        if AnteilNonEU>MaxAnteilNonEU then
          PraefBerechtigt:='nein';

      end;

  end;
end;


end.
