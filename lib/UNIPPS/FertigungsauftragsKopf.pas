﻿unit FertigungsauftragsKopf;

interface

uses  System.SysUtils, FertigungsauftragsPos, UnippsStueliPos,
                Exceptions,Tools, Logger;

type
  TWFAKopf = class(TWUniStueliPos)
    private
      Qry: TWUNIPPSQry;
    protected
      { protected declarations }
    public
      FA_Nr: String;     //f_auftragkopf.ident_nr
      FaIdStu: String;   //f_auftragkopf.auftr_nr  //nur f Debug
      FaIdPos: Integer;  //f_auftragkopf.auftr_pos
      constructor Create(einVater: TWUniStueliPos; einTyp: String; AQry: TWUNIPPSQry);
      procedure holeKinderAusASTUELIPOS;

    end;

implementation

constructor TWFAKopf.Create(einVater: TWUniStueliPos; einTyp: String;
                                                          AQry: TWUNIPPSQry);
var
  Menge:Double;
begin
  //UNIPPS-Mapping
  // f_auftragkopf.auftr_nr as id_stu, f_auftragkopf.auftr_pos as pos_nr,  f_auftragkopf.ident_nr as FA_Nr

  Qry:=AQry;  //merken fuer weitere Suche

  FA_Nr:=Qry.FieldByName('FA_Nr').AsString;

  FaIdStu:=Qry.FieldByName('id_stu').AsString;
  FaIdPos:=Qry.FieldByName('pos_nr').Value;
  Menge:=1; //bei FA immer 1
  inherited Create(einVater, einTyp, FaIdStu, FaIdPos, Menge);

  //Speichere typunabhängige Daten über geerbte Funktion
  PosDatenSpeichern(Qry);

end;

procedure TWFAKopf.holeKinderAusASTUELIPOS;

var Qry: TWUNIPPSQry;
  gefunden:Boolean;
  FAPos:TWFAPos;
  msg : String;

begin
  //Hole die Positionen des FA's aus der Unipps-Tabelle ASTUELIPOS
  Qry := Tools.getQuery;
  gefunden := Qry.SuchePosZuFA(FA_Nr);

  if not gefunden then
  begin
    msg:=Format('Keine Positionen zum FA >%s< gefunden.',[FA_Nr]);
    Tools.Log.Log(msg);
    Tools.Log.Close;
    raise EStuBaumFaKopfErr.Create(msg);
  end;


  //Daten lesen, zuerst nur Teile der obersten Ebene: ueb_s_nr=0
  while not Qry.Eof do
  begin

      //Erzeuge Objekt fuer eine FA-Position aus der Qry
      FAPos:=TWFAPos.Create(Self, Qry);

      //Hier nur toplevel-KNoten berücksichtigen
      //d.h. alle die in ASTUELIPOS keine übergeordnete Stückliste haben: ueb_s_nr=0
      If FAPos.istToplevel Then
      begin
        Tools.Log.Log(FAPos.ToStr);
        // in Stueck-Liste übernehmen
        Stueli.Add(FAPos.FaPosIdPos, FAPos);

        //Rekursiv weiter in ASTUELIPOS suchen wenn Knoten Kinder hat (Feld ds=1)
        If FAPos.KinderInASTUELIPOSerwartet Then
            //Bearbeite Kindknoten
            FAPos.holeKinderAusASTUELIPOS(FAPos.FaPosIdPos)
        Else
          //Pos hat keine weiteren Kinder im FA => merken fuer spaetere Suchl�ufe, wenn kein Kaufteil
           If Not FAPos.Teil.istKaufteil Then
              EndKnotenListe.Add(FAPos);

      end
      else
      {
        Die Sortierung in ASTUELIPOS und der Programmablauf (Es werden zuerst alle Kinder gesucht)
        'sollten dazu f�hren, das wir hier nie hinkommen.
        'Der erste Eintrag in ASTUELIPOS sollte immer ein toplevel-KNoten sein.
        'Danach kommen dessen Kinder und Kindeskinder, die alle abgearbeitet werden
        'Danach sollte der Zeiger des Recordsets fa_rs auf dem n�chsten toplevel-Knoten stehen.
       Logger.user_info "Unerwartete Datenstruktur in 'ASTUELIPOS'. Toplevelknoten mit Feld ueb_s_nr=0 erwartet.", level:=2
       }
       raise EStuBaumFaKopfErr.Create('Unerwartete Datenstruktur in ASTUELIPOS für FA: ' + FA_Nr  );

      //Hier erneut Endebedingung prüfen, da Recordzeiger verändert wurde
      If Not Qry.EOF Then
          Qry.Next;

    end; //while

end;

end.
