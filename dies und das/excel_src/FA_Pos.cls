VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "FA_Pos"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'Eigenschaften fuer alle Eintraege
Public pos_typ$
Public t_tg_nr$ 'Teilenummer des Teils auf der KA-Position
Public pos_nr$
Public menge As Double
Public teile_daten As Teiledaten 'Daten zum Teil auf der Position
Public stueli As Collection 'VBA-Stueckliste dieser Position

'Besondere Eigenschaften fuer diesen Typ
Public id_stu$
Public id_pos$
Public ueb_s_nr$
Public ds$
Public set_block$
Public unipps_typ$

Public ist_toplevel As Boolean
Public hat_Kinder As Boolean


Public Sub init(rs As Recordset)
    Dim teil_rs As Recordset
    Dim gefunden As Boolean

    pos_typ = "FA_Pos"

    Set stueli = New Collection

    id_stu = rs.Fields("id_stu")
    id_pos = rs.Fields("id_pos") 'in ASTUELIPOS zeigt ueb_s_nr auf die ident_nr2
    t_tg_nr = Trim(rs.Fields("t_tg_nr"))
    pos_nr = rs.Fields("pos_nr")
    unipps_typ = Trim(rs.Fields("typ"))

    ueb_s_nr = rs.Fields("ueb_s_nr")
    ds = rs.Fields("ds")
    set_block = rs.Fields("set_block")
    
    menge = rs.Fields("menge")

    'Suche Teil zu dieser Pos
    gefunden = SQL_exec.suche_Daten_zum_Teil(t_tg_nr, teil_rs)
    If gefunden Then
        Set teile_daten = New Teiledaten
        teile_daten.init teil_rs.Fields
    Else
        Logger.user_info "Konnte kein Teil >>" & t_tg_nr & "<< finden.", level:=2
    End If
       
    'Ist der Eintrag auf der höchsten Ebene des FA
    If ueb_s_nr = 0 Then
        ist_toplevel = True
    Else
        ist_toplevel = False
    End If
    
    'Hat der Eintrag Kinder in ASTUELIPOS
    'Einträge mit ds=1 sind in der Unipps-Tabelle ASTUELIPOS eines FA schon aufgelöst,
    'If ds = 1 Then
    If set_block = 1 Then
        'Oder besser auf set_block=1 prüfen?
        hat_Kinder = True
    Else
        hat_Kinder = False
    End If

End Sub

'Holt rekursiv untergeordnete Stücklistenelemente aus dem FA (Tabelle astuelipos)
'Es wird vorrausgesetzt das die Datensätze in astuelipos in der korrekten Reihenfolge stehen,
'd.h. auf jeden Vaterknoten folgen zunaechst die Kinder und bei denen evtl die Kindeskinder bevor
'der nächste Vater der gleichen Ebene folgt
'Wenn in ASTUELIPOS keine Kinder mehr enthalten, wird "mit suche_Kinder_v_Serien_Teil" weiter gesucht
'ob es eine Teile-Stückliste zum letzten gefunden Kind gibt, was bei Serenteilen der Fall ist.
Public Sub hole_Kinder(fa_rs As Recordset, vater_stuli_id%)
    Dim FA_Pos As FA_Pos
    Dim gefunden As Boolean
    
    '!!!! Beachte: Hier wird der selbe Recordset verwendet, wie in der aufrufenden Funktion mit der selben Positionierung
    '##########
    fa_rs.MoveNext 'gehe auf naechsten Datensatz
    
    Do While Not fa_rs.EOF
    
        'aktuellen Datensatz aus fa_rs in Objekt wandeln
        Set FA_Pos = New FA_Pos
        FA_Pos.init fa_rs
        
        'Debug.Print FA_Pos.pos_nr, FA_Pos.t_tg_nr

        'Gehört der Eintrag zur übergeordneten Stückliste => ausgeben; sonst rücksprung
        'Achtung auch hier verlassen wir uns auf die korrekte Reihenfolge in ASTUELIPOS
        If FA_Pos.ueb_s_nr = vater_stuli_id Then

            'in Liste übernehmen
            stueli.Add FA_Pos
    
            '------------------ Suche Kinder
            If FA_Pos.hat_Kinder Then
               'Teile mit ds=1 sind schon von UNIPPS aufgelöst => Kinder direkt in Tabelle ASTUELIPOS des FA suchen
                '!!! -----------   Rekursion: Bearbeite Kindknoten
                FA_Pos.hole_Kinder fa_rs, FA_Pos.id_pos
            Else
               'Für Teile mit ds<>1
               'Pos hat keine weiteren Kinder im FA => merken fuer spaetere Suchläufe, wenn kein Kaufteil
               If Not FA_Pos.teile_daten.ist_Kaufteil Then
                    teile_ohne_stu.Add FA_Pos
               End If
            End If
           
        Else
            'Der aktuelle Eintrag ist kein Kind des in der Tabelle ASTUELIPOS darüber stehenden Eintrags
            '=> Rücksprung in der Rekursion, also eine Ebene höher und dort recordzeiger um 1 zurücksetzen
            '######
            fa_rs.MovePrevious
            Exit Do
        End If
        
        'Hier erneut Endebedingung prüfen, da Recordzeiger verändert wurde
        If Not fa_rs.EOF Then
            fa_rs.MoveNext
        End If

    Loop


End Sub

