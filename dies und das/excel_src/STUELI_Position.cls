VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "STUELI_Position"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'Die Klasse enthält die Stücklistenelemente in verallgemeinerter Form
'Dies vereinfacht das Durchlaufen durch den Baum, das alle Elemente (fast) gleich behandelt werden können
'Sie enthalten alle zur Ausgabe bzw Berechnung nötigen Daten
'und zusätzlich als Pos_daten die spezifischen Original-Elemente aus Kundenauftrag,Teil_in_STU usw
'außerdem als "teile_daten" die Daten des Teils zur Position

Option Explicit

Public level% 'Ebene auf der das Teil im Gesamtbaum steht
Public menge_ueb As Double 'Aufmultiplizierte Menge aller übergeordneten Stücklisteneinträge

Public Pos_daten As Variant 'Objekt, welches die typ-spezifischen Daten hält
'Felder aus Pos_daten
Public pos_typ$
Public id_stu$
Public id_pos$
Public ueb_s_nr$
Public ds$
Public pos_nr$
Public verurs_art$
Public menge As Double
Public vk_preis As Double 'Verkaufspreis vor Rabatt für 1 Stück
Public vk_rabatt As Double 'Verkaufspreis nach Rabatt für 1 Stück
Public rabatt As Double 'Rabatt Achtung Vorzeichen ist negativ
Public FA_Nr$
Public komm_nr$

Public teile_daten As Teiledaten
Public stueli As Collection 'VBA-Stueckliste dieser Position

'Preise
'mit Stückzahlen und Mengenfaktoren auf die Position umgerechnet
Public preis_EU As Double
Public preis_Non_EU As Double
'Summen
Public Summe_EU As Double
Public Summe_Non_EU As Double

Public Sub init(meine_Pos, act_level%, act_menge_ueb As Double)
    Set stueli = New Collection
    Set Pos_daten = meine_Pos
    pos_typ = Pos_daten.pos_typ
    id_stu = Pos_daten.id_stu
    pos_nr = Pos_daten.pos_nr
    id_pos = ""
    vk_preis = 0
    vk_rabatt = 0
    rabatt = 0
    FA_Nr = ""
    komm_nr = ""
    verurs_art = ""
    menge = Pos_daten.menge
    If pos_typ = "KA_Pos" Then
        vk_preis = Pos_daten.vk_preis
        vk_rabatt = Pos_daten.vk_rabatt
        rabatt = Pos_daten.rabatt
        komm_nr = Pos_daten.komm_nr
        id_pos = Pos_daten.id_pos
    End If
    If pos_typ = "FA_Komm" Or pos_typ = "FA_Serie" Then
        FA_Nr = Pos_daten.FA_Nr
        verurs_art = CStr(Pos_daten.verurs_art)
    End If
    If pos_typ = "FA_Pos" Then
        ueb_s_nr = Pos_daten.ueb_s_nr
        ds = Pos_daten.ds
        id_pos = Pos_daten.id_pos
    End If
    Set teile_daten = Pos_daten.teile_daten
    level = act_level
    menge_ueb = act_menge_ueb * Pos_daten.menge
End Sub

'rechnet den Einzelpreis aus der Bestellung mit Gesamtmenge
'und dem  Faktor faktlme_sme (Stücklistenmengeneinheit zu Lagermengeneinheit)
'um auf den Preis der konkreten Stücklistenposition
Public Sub berechne_Preis_der_Position()
    Dim preis As Double
    Dim stupos As STUELI_Position
       
    If teile_daten.hat_Preis Then
        preis = teile_daten.Bestelldaten.STU_Pos_Preis(menge_ueb, teile_daten.faktlme_sme)
        If teile_daten.praeferenzkennung = 1 Then
            preis_EU = preis
        Else
            preis_Non_EU = preis
        End If
    Else
        preis_EU = 0
        preis_Non_EU = 0
    End If
    
    'Kinder bearbeiten
    For Each stupos In stueli
        stupos.berechne_Preis_der_Position
    Next
    
End Sub

'Summiere Preise für ein Teil
' aus der Summe der Kosten aller Teile in seiner Stueckliste
' und einem evtl zusätzlich vorhandenen eigenen Preis

'Beispiel Laufraeder: wir kaufen 233I26543PERF03 bei Ottenstein
'in der Stueckliste ist aber die Gewindebuchse 544D26265NKM019, die wir auch kaufen
'Der Gesatmpreis ist also Summe aller Teile in der Stueckliste + eigener Preis

Public Sub summiere_Preise()
    Dim stupos As STUELI_Position
    Dim preis As Double
    Summe_EU = 0
    Summe_Non_EU = 0
    
    'Fa's mit verursacher_art <> 1 sind untergeordnete FA z.B zu einer Pumpenmontage
    'Deren Teile sind schon im Haupt-FA enthalten und dürfen daher hier nicht nochmals in die Preissumme einfließen
    'Sie sollen zum debuggen aber in der Struktur enthalten sein
    If pos_typ = "FA_komm" Then
        If verurs_art <> 1 Then
            Exit Sub
        End If
    End If
    
    For Each stupos In stueli
        'Debug.Print stupos.level, stupos.pos_typ, stupos.pos_nr, stupos.teile_daten.t_tg_nr
        'erst Preise der Stuecklisten-Kinder summieren
        stupos.summiere_Preise
        
        'Gesamtsumme ist Summe der Summen aller Kinder
        Summe_EU = Summe_EU + stupos.Summe_EU
        Summe_Non_EU = Summe_Non_EU + stupos.Summe_Non_EU
               
    Next
    
    'Eigenen Preis dazu
    Summe_EU = Summe_EU + preis_EU
    Summe_Non_EU = Summe_Non_EU + preis_Non_EU
    
End Sub


'Schreibt eine Stückliste und rekursiv deren Kinder
'in die Tabelle zur Dokumentation eines Kundenauftrages (reduzierter Datenumfang)
Public Sub writeSTU2Excel_KA_doku(row As Long)
    Dim stupos As STUELI_Position
    
    'Fa's mit verursacher_art <> 1 sind untergeordnete FA z.B zu einer Pumpenmontage
    'Deren Teile sind schon im Haupt-FA enthalten und sollen nicht in der Doku erscheinen
    If pos_typ = "FA_Komm" Then
        If verurs_art <> 1 Then
            Exit Sub
        End If
    End If
    
    'Pos ausgeben
    writePos2Excel_KA_doku row
    row = row + 1
    'Kinder ausgeben
    For Each stupos In stueli
        'row = row + 1
        'Kinder ausgeben
        stupos.writeSTU2Excel_KA_doku row
    Next
End Sub

'Schreibt eine Stückliste und rekursiv deren Kinder
'in die Tabelle zum Debuggen (voller Daten-Umfang)
Public Sub writeSTU2Excel_debug(row As Long)
    Dim stupos As STUELI_Position
    'Pos ausgeben
    writePos2Excel_debug row
    row = row + 1

    'Kinder ausgeben
    For Each stupos In stueli
        'row = row + 1
        'Kinder ausgeben
        stupos.writeSTU2Excel_debug row
    Next
End Sub

'Schreibt eine Stücklistenposition
'in die Tabelle zur Dokumentation eines Kundenauftrages (reduzierter Datenumfang)
Public Sub writePos2Excel_KA_doku(myrow As Long)
    Dim col%
    Dim ratio As Double
    Dim praeferenzteil As Boolean
    Dim msg$
    
    col = 0
    'col = col + 1: stu_sheet.Cells(myrow, col) = myrow - 6 'Laufende Nummer
    col = col + 1: stu_sheet.Cells(myrow, col) = level_formatiert(level)
    'col = col + 1: stu_sheet.Cells(myrow, col) = pos_typ
    'col = col + 1: stu_sheet.Cells(myrow, col) = id_stu
    'col = col + 1: stu_sheet.Cells(myrow, col) = pos_nr
    col = col + 1: stu_sheet.Cells(myrow, col) = teile_daten.t_tg_nr
    col = col + 1: stu_sheet.Cells(myrow, col) = teile_daten.bezeichnung
    col = col + 1: stu_sheet.Cells(myrow, col) = menge_ueb
    
    'col = col + 1
    'col = col + 1: stu_sheet.Cells(myrow, col) = myrow - 6 'Laufende Nummer
    If teile_daten.hat_Preis Then
        stu_sheet.Cells(myrow, col + 1) = teile_daten.Bestelldaten.kurzname
        If teile_daten.praeferenzkennung Then
            stu_sheet.Cells(myrow, col + 2) = preis_EU
        Else
            stu_sheet.Cells(myrow, col + 3) = preis_Non_EU
        End If
    End If
    col = col + 3
    If level = 0 Then
        msg = pos_nr & " " & teile_daten.t_tg_nr & " " & teile_daten.bezeichnung
        ColorCells stu_sheet, myrow, KA_doku_header_min_col, KA_doku_header_max_col, "grau_2"
        col = col + 1: stu_sheet.Cells(myrow, col) = Summe_EU
        col = col + 1: stu_sheet.Cells(myrow, col) = Summe_Non_EU
        
        If vk_rabatt <> 0 Then
            col = col + 1: stu_sheet.Cells(myrow, col) = vk_rabatt
            ratio = Summe_Non_EU / vk_rabatt / menge
            col = col + 1: stu_sheet.Cells(myrow, col) = ratio
            praeferenzteil = True
            If Me.teile_daten.ist_Kaufteil Then
                praeferenzteil = Not (Summe_Non_EU > 0)
            Else
                praeferenzteil = ratio < 0.4
            End If
            If Not praeferenzteil Then
                ColorCells stu_sheet, myrow, KA_doku_header_min_col, KA_doku_header_max_col, "rot"
                msg = msg & "  --- kein PT"
            End If
        End If
        
        Logger.log msg, level:=1
    
    End If
    
End Sub


'Schreibt eine Stücklistenposition
'in die Tabelle zum Debuggen (voller Daten-Umfang)
Public Sub writePos2Excel_debug(myrow As Long)
    Dim col%
    col = 0
    col = col + 1: imp_sheet.Cells(myrow, col) = level_formatiert(level)
    col = col + 1: imp_sheet.Cells(myrow, col) = pos_typ
    col = col + 1: imp_sheet.Cells(myrow, col) = id_stu
    col = col + 1
    If pos_typ = "FA_Komm" Or pos_typ = "FA_Serie" Then
        imp_sheet.Cells(myrow, col) = FA_Nr
    End If
    
    col = col + 1: imp_sheet.Cells(myrow, col) = id_pos
    col = col + 1: imp_sheet.Cells(myrow, col) = ueb_s_nr
    col = col + 1: imp_sheet.Cells(myrow, col) = ds
    col = col + 1: imp_sheet.Cells(myrow, col) = pos_nr
    col = col + 1: imp_sheet.Cells(myrow, col) = verurs_art
    col = col + 1: imp_sheet.Cells(myrow, col) = teile_daten.t_tg_nr
    col = col + 1: imp_sheet.Cells(myrow, col) = teile_daten.oa
    col = col + 1: imp_sheet.Cells(myrow, col) = teile_daten.bezeichnung
    col = col + 1: imp_sheet.Cells(myrow, col) = teile_daten.unipps_typ
    col = col + 1: imp_sheet.Cells(myrow, col) = teile_daten.besch_art
    col = col + 1: imp_sheet.Cells(myrow, col) = teile_daten.urspr_land
    col = col + 1: imp_sheet.Cells(myrow, col) = teile_daten.ausl_u_land
    col = col + 1: imp_sheet.Cells(myrow, col) = teile_daten.praeferenzkennung
    col = col + 1: imp_sheet.Cells(myrow, col) = menge
    col = col + 1: imp_sheet.Cells(myrow, col) = teile_daten.sme
    col = col + 1: imp_sheet.Cells(myrow, col) = teile_daten.faktlme_sme
    col = col + 1: imp_sheet.Cells(myrow, col) = teile_daten.lme
    
    If teile_daten.hat_Preis Then
        teile_daten.Bestelldaten.write2Excel_debug myrow, col
        col = teile_daten.Bestelldaten.last_col + 1
        imp_sheet.Cells(myrow, col) = menge_ueb
        col = col + 1: imp_sheet.Cells(myrow, col) = preis_EU
        col = col + 1: imp_sheet.Cells(myrow, col) = preis_Non_EU
    End If
    col = 33
    If level < 2 Then
        col = col + 1: imp_sheet.Cells(myrow, col) = Summe_EU
        col = col + 1: imp_sheet.Cells(myrow, col) = Summe_Non_EU
        If vk_preis <> 0 Then
            col = col + 1: imp_sheet.Cells(myrow, col) = vk_preis
            col = col + 1: imp_sheet.Cells(myrow, col) = Summe_Non_EU / vk_preis / menge
        End If
    End If
    
End Sub

