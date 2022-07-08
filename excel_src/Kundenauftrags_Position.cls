VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Kundenauftrags_Position"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'Eigenschaften fuer alle Eintraege
Public pos_typ$
Public id_stu$ 'Id der Stückliste zu der die Position gehört
Public t_tg_nr$ 'Teilenummer des Teils auf der KA-Position
Public pos_nr$
Public menge As Double
Public teile_daten As Teiledaten 'Daten zum Teil auf der Position
Public stueli As Collection 'VBA-Stueckliste dieser Position

'Besondere Eigenschaften fuer diesen Typ
Public id_pos$  'Id der Stücklisten-Position
Public vk_preis As Double 'Verkaufspreis vor Rabatt für 1 Stück
Public vk_rabatt As Double 'Verkaufspreis nach Rabatt für 1 Stück
Public rabatt As Double 'Rabatt Achtung Vorzeichen ist negativ
Public unipps_typ$
Public komm_nr$

Public Sub init(record As Fields, my_rabatt As Double)
    Dim rs As Recordset
    Dim gefunden As Boolean
    
    pos_typ = "KA_Pos"
    Set stueli = New Collection

    id_pos = record("id_pos")
    id_stu = record("id_stu")
    t_tg_nr = Trim(record("t_tg_nr"))
    pos_nr = Trim(record("pos_nr"))
    unipps_typ = Trim(record("typ"))

    menge = Trim(record("menge"))
    'Ermittle den Listenpreis aus UNIPPS
    vk_preis = Trim(record("preis"))
    rabatt = my_rabatt
    vk_rabatt = vk_preis * (1 + rabatt) 'Rabbat hat -
    komm_nr = record("klassifiz")
       
    'Suche Teil zu dieser Pos
    gefunden = SQL_exec.suche_Daten_zum_Teil(t_tg_nr, rs)
    If gefunden Then
        Set teile_daten = New Teiledaten
        teile_daten.init rs.Fields
    Else
        Logger.user_info "Konnte kein Teil >>" & t_tg_nr & "<< finden.", level:=2
    End If
End Sub

'Sucht Kinder zu einer Position im Kundenauftrag
'Die Position kann a) komm-spezifisch sein oder b) ein Teil mit Serienfertigung oder c) ein Kaufteil
'Fuer a) wird ein FA-Objekt erzeugt und als Zwischenebene in die Stückliste eingetragen
Public Sub hole_Kinder_aus_Komm_FA()
         
    Dim myFA As FA
    Dim rs As Recordset
    Dim gefunden As Boolean
    
    'Gibt es auftragsbezogene FAs zur Pos im Kundenauftrag
    gefunden = SQL_exec.suche_FA_zu_KAPos(id_stu, id_pos, rs)
    
    Do While Not rs.EOF
        'Erzeuge Objekt fuer einen auftragsbezogenen FA
        Set myFA = New FA
        myFA.init rs.Fields
        
        'in Stueck-Liste übernehmen
        stueli.Add myFA
    
        'Kinder suchen
        myFA.hole_Kinder
        
        'Naechter Datensatz
        rs.MoveNext
    
    Loop
    
    'Keine Kinder im auftragsbezogenen FA
    '=> Teil fuer spaetere Suche merken
    If Not gefunden And Not teile_daten.ist_Kaufteil Then
        teile_ohne_stu.Add Me
    End If
    
    
End Sub

Public Sub write2Excel_Preisblatt(myrow As Long)
    Dim col%
    col = 0
    col = col + 1: preis_sheet.Cells(myrow, col) = Me.id_pos
    col = col + 1: preis_sheet.Cells(myrow, col) = Me.menge
    col = col + 1: preis_sheet.Cells(myrow, col) = Me.t_tg_nr
    col = col + 1: preis_sheet.Cells(myrow, col) = Me.teile_daten.bezeichnung
    col = col + 1: preis_sheet.Cells(myrow, col) = Me.vk_preis
    col = col + 1: preis_sheet.Cells(myrow, col) = Me.rabatt
    col = col + 1: preis_sheet.Cells(myrow, col) = Me.vk_rabatt

End Sub


