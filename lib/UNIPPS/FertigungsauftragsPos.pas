﻿unit FertigungsauftragsPos;

interface

uses  StuecklistenPosition, Tools,Logger;

type
  TZFAPos = class(TZStueliPos)
    private
      Qry: TZUNIPPSQry;
    protected
      { protected declarations }
    public
      ueb_s_nr:String;
      id_pos:String;
      set_block:String;
      istToplevel:Boolean;
      KinderInASTUELIPOSerwartet:Boolean;
      constructor Create(AQry: TZUNIPPSQry);
      procedure holeKinderAusASTUELIPOS(id_pos_vater:String);
    end;

implementation

constructor TZFAPos.Create(AQry: TZUNIPPSQry);
begin
  inherited Create('FA_Pos');
  Qry:=AQry;
  //Speichere typunabhängige Daten über geerbte Funktion
  PosDatenSpeichern(Qry);
  //Key zum Ablegen in der Stückliste
  //Muss eindeutig sein und dient zum Sortieren beim Ausgeben
  //Felder die zur weiteren Auswertung gebraucht werden,
  // zusätzlich als Feld ablegen
  ueb_s_nr:=Self.PosData['ueb_s_nr'];
  id_pos:=Self.PosData['id_pos'];
  set_block:=Self.PosData['set_block'];

  istToplevel:= ueb_s_nr='0';
  KinderInASTUELIPOSerwartet:=Self.PosData['set_block']='1';
  //Suche Teil zur Position
  SucheTeilzurStueliPos();

end;

procedure TZFAPos.holeKinderAusASTUELIPOS(id_pos_vater:String);

var FAPos:TZFAPos;

begin
  // !!!! Beachte: Hier wird der selbe Recordset verwendet,
  // wie in der aufrufenden Funktion, mit der selben Positionierung
  Qry.Next; //gehe auf naechsten Datensatz

  while not Qry.Eof do
  begin

    //Erzeuge Objekt fuer einen auftragsbezogenen FA
    FAPos:=TZFAPos.Create(Qry);

    //Gehört der Eintrag zur übergeordneten Stückliste => speichern; sonst rücksprung
    //Achtung auch hier verlassen wir uns auf die korrekte Reihenfolge in ASTUELIPOS
    If FAPos.ueb_s_nr = id_pos_vater Then
    begin

      // in Stueck-Liste übernehmen
      Stueli.Add(FAPos.id_pos, FAPos);

      //------------------ Suche Kinder
      If FAPos.KinderInASTUELIPOSerwartet Then
         //Teile mit ds=1 sind schon von UNIPPS aufgelöst => Kinder direkt in Tabelle ASTUELIPOS des FA suchen
          //!!! -----------   Rekursion: Bearbeite Kindknoten
         FAPos.holeKinderAusASTUELIPOS(FAPos.id_pos)
      Else
         //Pos hat keine weiteren Kinder im FA => merken fuer spaetere Suchl�ufe, wenn kein Kaufteil
         If Not FAPos.Teil.istKaufteil Then
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