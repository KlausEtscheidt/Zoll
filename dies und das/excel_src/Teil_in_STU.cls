VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Teil_in_STU"
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

Public Sub init(record As Fields)
    Dim rs As Recordset
    Dim gefunden As Boolean
    
    pos_typ = "Teil"
    Set stueli = New Collection

    id_stu = Trim(record("id_stu"))
    t_tg_nr = Trim(record("t_tg_nr"))
    pos_nr = Trim(record("pos_nr"))
    menge = record("menge")
    
    'Suche Teil zu dieser Pos
    gefunden = SQL_exec.suche_Daten_zum_Teil(t_tg_nr, rs)
    If gefunden Then
        Set teile_daten = New Teiledaten
        teile_daten.init rs.Fields
    Else
        Logger.user_info "Konnte kein Teil >>" & t_tg_nr & "<< finden.", level:=2
    End If
End Sub

Public Sub xxxerzeuge_Baum(vater_stueli_pos As STUELI_Position)
    Dim pos As Variant
    Dim kind_stueli_pos As STUELI_Position

    For Each pos In stueli
        Set kind_stueli_pos = New STUELI_Position
        kind_stueli_pos.init pos, vater_stueli_pos.level + 1, vater_stueli_pos.menge_ueb
        'In Baum.stueli uebernehmen
        vater_stueli_pos.stueli.Add kind_stueli_pos
        pos.erzeuge_Baum kind_stueli_pos
    Next
    
End Sub


