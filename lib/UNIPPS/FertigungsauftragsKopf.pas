unit FertigungsauftragsKopf;

interface

uses  System.SysUtils, FertigungsauftragsPos, UnippsStueliPos,
                Tools, Logger;

type EWFAKopf = class(Exception);

type
  TWFAKopf = class(TWUniStueliPos)
    private
      Qry: TWUNIPPSQry;
    protected
      { protected declarations }
    public
      FA_Nr: String;     //f_auftragkopf.ident_nr
      constructor Create(einVater: TWUniStueliPos; einTyp: String;
                                        AQry: TWUNIPPSQry);
      function IstReparatur:Boolean;
      function ToStr():String;
      procedure holeKinderAusASTUELIPOS;

    end;

implementation

constructor TWFAKopf.Create(einVater: TWUniStueliPos; einTyp: String;
                                          AQry: TWUNIPPSQry);
var
  Menge:Double;
begin
  {UNIPPS-Mapping
  Komm-FA
  f_auftragkopf.auftr_nr as id_stu, f_auftragkopf.auftr_pos as pos_nr,
  f_auftragkopf.ident_nr as FA_Nr
  Serien-FA
  auftr_nr und auftr_pos sind 0 daher:
  f_auftragkopf.t_tg_nr as id_stu, 1 as pos_nr
  }

  Qry:=AQry;  //merken fuer weitere Suche

  FA_Nr:=Qry.FieldByName('FA_Nr').AsString;

  Menge:=1; //bei FA immer 1
  //FA_Nr als eigene ID_StuPos
  inherited Create(einVater, einTyp, FA_Nr, Menge);

  //Speichere typunabhängige Daten über geerbte Funktion
  PosDatenSpeichern(Qry);

end;

function TWFAKopf.IstReparatur:Boolean;
var
  Start:Integer;
begin
    Start:=pos('Rep',self.TeileNr);
    Result:=Start=1;
end;

//Liefert zum Debuggen wichtige Eigenschaften in einem String verkettet
function TWFAKopf.ToStr():String;
begin
  Result:=Format('%s zu Stu %s FA %s zu Teil %s',[PosTyp, IdStueliPosVater, FA_Nr, TeileNr ]);
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
    if Self.IstReparatur then
       msg:=Format('%s ist Rep-FA zu Teil %s.',[FA_Nr,Self.TeileNr])
    else
      msg:=Format('Keine Positionen zum FA >%s< gefunden. Teil: %s',
                                                  [FA_Nr,Self.TeileNr]);
    Tools.Log.Log(msg);
    Tools.ErrLog.Log(msg);
    Tools.ErrLog.Flush;

    if Self.IstReparatur then
      exit
    else
      raise EWFAKopf.Create(msg);

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
        StueliAdd(FAPos);

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
       raise EWFAKopf.Create('Unerwartete Datenstruktur in ASTUELIPOS für FA: ' + FA_Nr  );

      //Hier erneut Endebedingung prüfen, da Recordzeiger verändert wurde
      If Not Qry.EOF Then
          Qry.Next;

    end; //while

      Qry.Free;

end;

end.
