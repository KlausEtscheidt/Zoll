VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "FA"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'Eigenschaften fuer alle Eintraege
Public pos_typ$
Public id_stu$ 'Id der Stückliste zu der die Position gehört
'Public t_tg_nr$ 'Teilenummer des Teils auf der Position
Public pos_nr$
Public unipps_typ$
Public menge As Double
Public teile_daten As Teiledaten 'Daten zum Teil auf der Position, bleibt hier leer
Public stueli As Collection 'VBA-Stueckliste dieser Position

'Besondere Eigenschaften fuer diesen Typ
Public FA_Nr$
Public verurs_art%
Public auftragsart%

Public Sub init(record As Fields)
    pos_typ = "FA_Komm"
    menge = 1 'bei FA Menge ignorieren
    
    Set stueli = New Collection
    Set teile_daten = New Teiledaten

    id_stu = record("id_stu")
    pos_nr = Trim(record("pos_nr"))
    unipps_typ = Trim(record("typ"))

    FA_Nr = record("id_fa")
    verurs_art = record("verurs_art")
    auftragsart = record("auftragsart")

End Sub

Public Sub init_serie(record As Fields)
    pos_typ = "FA_Serie"
    menge = 1 'bei FA Menge ignorieren
    
    Set stueli = New Collection
    Set teile_daten = New Teiledaten

    'id_stu = record("id_stu")
    id_stu = Trim(record("t_tg_nr"))
    pos_nr = Trim(record("pos_nr"))
    unipps_typ = Trim(record("typ"))

    FA_Nr = record("id_fa")
    verurs_art = record("verurs_art")
    auftragsart = record("auftragsart")

End Sub


'Analysiert die UNIPPS-Tabelle ASTUELIPOS
'Sucht die Positionen der obersten Ebene in dieser Tabelle und rekursiv deren Kinder
'Wenn in ASTUELIPOS keine Kinder mehr enthalten, wird "mit suche_Kinder_v_Serien_Teil" weiter gesucht
'ob es eine Teile-Stückliste zum letzten gefunden Kind gibt, was bei Serenteilen der Fall ist.
Public Sub hole_Kinder()
    Dim fa_rs As Recordset
    Dim gefunden As Boolean
    Dim FA_Pos As FA_Pos
    
    'Hole die Positionen des FA's aus der Unipps-Tabelle ASTUELIPOS
    gefunden = SQL_exec.hole_Pos_zu_FA(FA_Nr, fa_rs)
    
    'Daten ausgeben, zuerst nur Teile der obersten Ebene: ueb_s_nr=0
    Do While Not fa_rs.EOF
        'Debug.Print "                            rs.pos", fa_rs.AbsolutePosition
    
        'Erzeuge eine FA-position aus dem Datensatz
        Set FA_Pos = New FA_Pos
        FA_Pos.init fa_rs
               
        'Hier nur toplevel-KNoten berücksichtigen
        'd.h. alle die in ASTUELIPOS keine übergeordnete Stückliste haben: ueb_s_nr=0
        If FA_Pos.ist_toplevel Then
           
            'in Liste übernehmen
            stueli.Add FA_Pos
            
            'Rekursiv weiter in ASTUELIPOS suchen wenn Knoten Kinder hat (Feld ds=1)
            If FA_Pos.hat_Kinder Then
                'Bearbeite Kindknoten
                FA_Pos.hole_Kinder fa_rs, FA_Pos.id_pos
            Else
              'Pos hat keine weiteren Kinder im FA => merken fuer spaetere Suchläufe, wenn kein Kaufteil
               If Not FA_Pos.teile_daten.ist_Kaufteil Then
                    teile_ohne_stu.Add FA_Pos
               End If
            End If
        Else
            'Die Sortierung in ASTUELIPOS und der Programmablauf (Es werden zuerst alle Kinder gesucht)
            'sollten dazu führen, das wir hier nie hinkommen.
            'Der erste Eintrag in ASTUELIPOS sollte immer ein toplevel-KNoten sein.
            'Danach kommen dessen Kinder und Kindeskinder, die alle abgearbeitet werden
            'Danach sollte der Zeiger des Recordsets fa_rs auf dem nächsten toplevel-Knoten stehen.
            Logger.user_info "Unerwartete Datenstruktur in 'ASTUELIPOS'. Toplevelknoten mit Feld ueb_s_nr=0 erwartet.", level:=2
        End If
    
        'Hier erneut Endebedingung prüfen, da Recordzeiger verändert wurde
        If Not fa_rs.EOF Then
            fa_rs.MoveNext
        End If
    Loop
   
End Sub

