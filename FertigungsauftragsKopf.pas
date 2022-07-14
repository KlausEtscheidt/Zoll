unit FertigungsauftragsKopf;

interface

uses  System.SysUtils, FertigungsauftragsPos, StuecklistenPosition,
               DBZugriff, Exceptions,TextWriter;

type
  TZFAKopf = class(TZStueliPos)
    private
      Qry: TZQry;
    protected
      { protected declarations }
    public
      constructor Create(einTyp: String; AQry: TZQry);
      procedure holeKinderAusASTUELIPOS;

    end;

implementation

constructor TZFAKopf.Create(einTyp: String; AQry: TZQry);
begin
  inherited Create(einTyp);
  Qry:=AQry;
  //Speichere typunabhängige Daten über geerbte Funktion
  PosDatenSpeichern(Qry);

end;

procedure TZFAKopf.holeKinderAusASTUELIPOS;

var Qry: TZQry;
  gefunden:Boolean;
  FAPos:TZFAPos;
  msg : String;

begin
  //Hole die Positionen des FA's aus der Unipps-Tabelle ASTUELIPOS
  Qry := DBConn.getQuery;
  gefunden := Qry.SuchePosZuFA(FA_Nr);

  if not gefunden then
  begin
    msg:=Format('Keine Positionen zum FA >%s< gefunden.',[FA_Nr]);
    Log.Log(msg);
    Log.Close;
    raise EStuBaumFaKopfErr.Create(msg);
  end;


  //Daten lesen, zuerst nur Teile der obersten Ebene: ueb_s_nr=0
  while not Qry.Eof do
  begin

      //Erzeuge Objekt fuer eine FA-Position aus der Qry
      FAPos:=TZFAPos.Create(Qry);

      //Hier nur toplevel-KNoten berücksichtigen
      //d.h. alle die in ASTUELIPOS keine übergeordnete Stückliste haben: ueb_s_nr=0
      If FAPos.istToplevel Then
      begin
        Log.Log(FAPos.ToStr);
        // in Stueck-Liste übernehmen
        Stueli.Add(FAPos.id_pos, FAPos);

        //Rekursiv weiter in ASTUELIPOS suchen wenn Knoten Kinder hat (Feld ds=1)
        If FAPos.KinderInASTUELIPOSerwartet Then
            //Bearbeite Kindknoten
            FAPos.holeKinderAusASTUELIPOS(FAPos.id_pos)
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
