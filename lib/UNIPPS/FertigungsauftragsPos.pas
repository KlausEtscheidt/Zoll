unit FertigungsauftragsPos;

interface

uses  System.SysUtils,UnippsStueliPos, Tools,Logger;

type
  TWFAPos = class(TWUniStueliPos)
    private
      Qry: TWUNIPPSQry;
    protected
      { protected declarations }
    public
      ueb_s_nr:Integer;
      pos_nr:Integer;
      set_block:Integer;
      istToplevel:Boolean;
      KinderInASTUELIPOSerwartet:Boolean;

      FaPosIdStuVater: String;
      FaPosIdPos: Integer;
      FaPosPosNr: String;  //nur zum Debuggen
      constructor Create(einVater: TWUniStueliPos; AQry: TWUNIPPSQry);
      procedure holeKinderAusASTUELIPOS(id_pos_vater:Integer);
    end;

implementation

constructor TWFAPos.Create(einVater: TWUniStueliPos; AQry: TWUNIPPSQry);
var
  IdStuPos:String;
begin
  Qry:=AQry;
  {UNIPPS-Mapping
   gesucht über: "where astuelipos.ident_nr1 =  FA_Nr"
   astuelipos.ident_nr1 AS id_stu, astuelipos.ident_nr2 as id_pos
  astuelipos.pos_nr, astuelipos.t_tg_nr}

  FaPosIdStuVater:=Trim(Qry.FieldByName('id_stu').AsString);
  FaPosIdPos:=Qry.FieldByName('id_pos').AsInteger;
  FaPosPosNr:=Qry.FieldByName('pos_nr').AsString;
  Menge:=Qry.FieldByName('menge').Value;
   //Eigene ID aus FA-Nr und UNIPPS id_pos
  IdStuPos:=FaPosIdStuVater+'_'+ IntToStr(FaPosIdPos);
  inherited Create(einVater, 'FA_Pos', IdStuPos, Menge);

  //Speichere typunabhängige Daten über geerbte Funktion
  PosDatenSpeichern(Qry);

  //Felder die zur weiteren Auswertung gebraucht werden,
  // zusätzlich als Feld ablegen
  ueb_s_nr:=Qry.FieldByName('ueb_s_nr').AsInteger;
  pos_nr:=Qry.FieldByName('pos_nr').AsInteger;
  set_block:=Qry.FieldByName('set_block').AsInteger;

  istToplevel:= (ueb_s_nr=0);
  KinderInASTUELIPOSerwartet:=(set_block=1);

  //Suche Teil zur Position  (ueber Vaterklasse TWUniStueliPos)
  SucheTeilzurStueliPos();

end;

procedure TWFAPos.holeKinderAusASTUELIPOS(id_pos_vater:Integer);

var FAPos:TWFAPos;

begin
  // !!!! Beachte: Hier wird der selbe Recordset verwendet,
  // wie in der aufrufenden Funktion, mit der selben Positionierung
  Qry.Next; //gehe auf naechsten Datensatz

  while not Qry.Eof do
  begin

    //Erzeuge Objekt fuer einen auftragsbezogenen FA
    FAPos:=TWFAPos.Create(Self, Qry);

    //Gehört der Eintrag zur übergeordneten Stückliste => speichern; sonst rücksprung
    //Achtung auch hier verlassen wir uns auf die korrekte Reihenfolge in ASTUELIPOS
    If FAPos.ueb_s_nr = id_pos_vater Then
    begin

      // in Stueck-Liste übernehmen
//      Stueli.Add(FAPos.FaPosIdPos, FAPos);
      StueliAdd(FAPos);

      //------------------ Suche Kinder
      If FAPos.KinderInASTUELIPOSerwartet Then
         //Teile mit ds=1 sind schon von UNIPPS aufgelöst => Kinder direkt in Tabelle ASTUELIPOS des FA suchen
          //!!! -----------   Rekursion: Bearbeite Kindknoten
         FAPos.holeKinderAusASTUELIPOS(FAPos.FaPosIdPos)
//         FAPos.holeKinderAusASTUELIPOS(FAPos.id_pos)
      Else
         //Pos hat keine weiteren Kinder im FA => merken fuer spaetere Suchl�ufe, wenn kein Kaufteil
         If Not FAPos.Teil.istKaufteil Then
//         var meinTeil:TWTeil;
//         If Not FAPos.Teil.AsType<TWTeil>.istKaufteil Then
            EndKnotenListe.Add(FAPos);

    end
    else
    begin
      //Der aktuelle Eintrag ist kein Kind des in der Tabelle ASTUELIPOS dar�ber stehenden Eintrags
      //=> Rücksprung in der Rekursion, also eine Ebene höher und dort recordzeiger um 1 zurücksetzen
      Qry.Prior;
      Exit;
    end;

  //Hier erneut Endebedingung prüfen, da Recordzeiger verändert wurde
  If Not Qry.EOF Then
      Qry.Next;

  end;  //while

end;

end.
