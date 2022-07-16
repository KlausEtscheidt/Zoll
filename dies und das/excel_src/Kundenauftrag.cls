VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Kundenauftrag"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public ka_id$
Public kunden_id$
Public komm_nr$
Public stueli As Collection 'Stueckliste

'Liste aller Zuordnungen von Positionen zu übergeordnetetn Positionen mit id_pos als Index
'zu_pos(3)=1 bedeutet also: Die Pos mit der id_pos=3 ist Unterposition der Pos mit id_pos=1
Public zu_Pos As Dictionary


Public Sub init(id$)

    Dim rs As Recordset, rs_rabatt As Recordset
    Dim gefunden As Boolean
    Dim ka_pos As Kundenauftrags_Position
    Dim stu_pos As STUELI_Position
    Dim rabatt As Double
    
    Set stueli = New Collection
    Set zu_Pos = New Dictionary
    
    'id als Eigenschaft merken
    ka_id = id
   
    'Suche Positionen im Kundenauftrag der id KA_id
    'Abfrage mit globalem Objekt ausführen und  recordset merken
    gefunden = SQL_exec.suche_Kundenauftragspositionen(ka_id, rs)
    
    'Wenn Daten gefunden
    If gefunden Then
        komm_nr = rs.Fields("klassifiz")
        kunden_id = rs.Fields("kunde")
    Else
        Logger.user_info "Konnte keine Daten zu " & ka_id & " finden.", level:=1
    End If
       
    'Suche Positionen im Kundenauftrag der id KA_id
    'Abfrage mit globalem Objekt ausführen und  recordset merken
    SQL_exec.hole_Rabatt_zum_Kunden kunden_id, rs_rabatt
    If rs_rabatt.RecordCount <> 1 Then
        Logger.user_info "Es wurden " & rs_rabatt.RecordCount & " Rabatte zum Kunden " & kunden_id & " des Auftrages gefunden."
    Else
        rabatt = rs_rabatt.Fields("zu_ab_proz") / 100
    End If
       
    'Daten analysieren
    Do While Not rs.EOF
        'Erzeuge eine KA-Position aus dem Datensatz
        Set ka_pos = New Kundenauftrags_Position
        ka_pos.init rs.Fields, rabatt
        
        'in Stueck-Liste übernehmen
        stueli.Add ka_pos, CStr(ka_pos.id_pos)
        
        rs.MoveNext
    Loop
    
End Sub

Public Sub sortiere_neu()
    Dim super_pos$, sub_pos$
    Dim super_part, sub_part
    Dim i%
    For i = 0 To zu_Pos.Count - 1
        super_pos = zu_Pos.Items(i)
        sub_pos = zu_Pos.Keys(i)
        Debug.Print sub_pos & " gehört zu " & super_pos
        Set super_part = stueli.Item(CStr(super_pos))
        Set sub_part = stueli.Item(CStr(sub_pos))
        'Untergeordnete Pos an Stueckliste der uebergeordneten anhaengen
        super_part.stueli.Add sub_part
        'VK des untergeordneten Teils zum uebergeordneten addieren
        super_part.vk_rabatt = super_part.vk_rabatt + sub_part.vk_rabatt
        sub_part.vk_rabatt = 0
        'Untergeordnete Pos aus aktuelles Stueckliste loeschen
        stueli.Remove CStr(sub_pos)
    Next i
    
End Sub

Public Sub hole_Listenpreise()
    Dim ka_pos As Kundenauftrags_Position
    Dim Preise As Dictionary 'Liste aller Preis mit id_pos als Index
    Dim row%
    Dim id_pos%
    Dim super_pos%
    Dim preis As Double
    
    'Zuerst Preise aus Excel lesen
    Set Preise = New Dictionary
    row = 2
    Do While preis_sheet.Cells(row, 1) <> ""
        id_pos = preis_sheet.Cells(row, 1)
        preis = preis_sheet.Cells(row, 7)
        super_pos = preis_sheet.Cells(row, 8)
        Preise.Add Key:=CStr(id_pos), Item:=preis
        If super_pos <> 0 Then
            zu_Pos.Add Key:=CStr(id_pos), Item:=super_pos
        End If
        row = row + 1
    Loop
    
    For Each ka_pos In stueli
        'If ka_pos.vk_preis = 0 Then
            If Preise.Exists(ka_pos.id_pos) Then
                ka_pos.vk_rabatt = Preise(CStr(ka_pos.id_pos))
            Else
                Logger.user_info "Konnte keinen Preis zu Pos-Nr " & ka_pos.id_pos & " in Excel Tabelle " & preis_sheet_name & " finden.", level:=2
                If Not Logger.batch_modus Then
                    MsgBox "Programmabbruch", vbCritical
                    End
                End If
            End If
        'End If
    Next
End Sub


Public Sub hole_Kinder()
    Dim ka_pos As Kundenauftrags_Position
    Dim pos As Variant
    Dim teile_ohne_stu_aktuell As Collection
   
    Set teile_ohne_stu = New Collection
    Set teile_ohne_stu_aktuell = New Collection

    'Schritt 1 nur über Kommissions-FA suchen. Diese haben Prio 1.
    'Fuer alle Pos, die kein Kaufteil sind, rekursiv in der UNIPPS-Tabelle ASTUELIPOS nach Kindern suchen
    'Alle Kinder, die in ASTUELIPOS selbst keine Kinder mehr haben werden in der Liste teile_ohne_stu vermerkt
    For Each ka_pos In stueli
        Application.StatusBar = "erzeuge Strukturbaum für KA-Pos " & ka_pos.id_pos
        If Not ka_pos.teile_daten.ist_Kaufteil Then
            ka_pos.hole_Kinder_aus_Komm_FA
        End If
    Next
    
    'Suche Kinder für die Knoten der Liste teile_ohne_stu bis diese leer ist.
    Do
        'Original-Liste leeren (vorher kopieren)
        Set teile_ohne_stu_aktuell = teile_ohne_stu
        Set teile_ohne_stu = New Collection
        'Fuer alle Teile der Liste
        For Each pos In teile_ohne_stu_aktuell
            'Suche Kinder, Knoten die nicht Kaufteil sind in teile_ohne_stu merken
             suche_Kinder_v_Serien_Teil pos
        Next
    Loop Until teile_ohne_stu.Count = 0
    
End Sub

'Umwandeln der typspezifischen Objekte in Baumstruktur mit typunabhängigen (allgemeinen) Knoten
Public Sub erzeuge_Baum(Baum As STU_Baum, mit_FA As Boolean)
    Dim level%
    Dim menge_ueb As Double 'multiplizierte Menge aller übergeordneten Positionen (im KA immer 1)
    Dim ka_pos As Kundenauftrags_Position
    Dim stueli_pos As STUELI_Position

    'level immer 0 da Kundenauftrag
    level = 0
    'menge übergeordent immer 1 da Kundenauftrag
    menge_ueb = 1

    Baum.init

    For Each ka_pos In stueli
        'Erzeuge neuen, typunabhängigen Stueli-Eintrag
        Set stueli_pos = New STUELI_Position
        stueli_pos.init ka_pos, level, menge_ueb
        'In Baum.stueli uebernehmen
        Baum.stueli.Add stueli_pos
        'Suche alle Unterpositionen von ka_pos und trage sie in die stueli von stueli_pos ein
        Baum.erzeuge_Baum ka_pos, stueli_pos, mit_FA
    Next

    'Fuer jede Pos im Baum Preise aller Unterpos aufsummieren
    Baum.summiere_Preise

End Sub

