VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "STU_Baum"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'Die Klasse enthält die Stücklistenstruktur in verallgemeinerter Form
'Dies vereinfacht das Durchlaufen durch den Baum, das alle Elemente (fast) gleich behandelt werden können
'Die Elemente gehören zur Klasse STUELI_Position und enthalten alle zur Ausgabe bzw Berechnung nötigen Daten
'und zusätzlich die spezifischen Original-Elemente aus Kundenauftrag,Teil_in_STU usw

Option Explicit

Public stueli As Collection 'VBA-Stueckliste dieser Position

Public Sub init()
    Set stueli = New Collection
End Sub

'Summiere Preise für ein Teil
' aus der Summe der Kosten aller Teile in seiner Stueckliste
' und einem evtl zusätzlich vorhandenen eigenen Preis
Public Sub summiere_Preise()
    Dim stupos As STUELI_Position
    Application.StatusBar = "Berechne Preissummen"
    
   
    'Preis der Position ermitteln
    'Umrechnung mit Gesamtmenge und Einheiten
    For Each stupos In stueli
        stupos.berechne_Preis_der_Position
    Next
    
    'Preise summieren
    For Each stupos In stueli
        stupos.summiere_Preise
    Next

End Sub

'Schreibt den kompletten Baum
'in die Tabelle zum Debuggen (voller Daten-Umfang)
Public Sub write2Excel_KA_doku()
    
    Dim stupos As STUELI_Position
    Dim row As Long
    Application.StatusBar = "Ausgabe nach Kalkulation"
    
    stu_sheet.PageSetup.LeftHeader = "Kundenauftrag: " & stueli(1).id_stu
    stu_sheet.PageSetup.RightHeader = "&D"

    'Hauptüberschriften schreiben
    stu_sheet.Range("e2") = stueli(1).id_stu
    stu_sheet.Range("E3") = stueli(1).komm_nr
    
    row = 7
    For Each stupos In stueli
        stupos.writeSTU2Excel_KA_doku row
        'row = row + 1
    Next
    
    'Mittel-Spalte ohne Schattierung
    'DeColorColumn stu_sheet, KA_doku_header_med_col
    
End Sub

'Schreibt den kompletten Baum
'in die Tabelle zur Dokumentation eines Kundenauftrages (reduzierter Datenumfang)
Public Sub write2Excel_debug()
    Dim stupos As STUELI_Position
    Dim row As Long
    Application.StatusBar = "Ausgabe nach Import"
    row = 2
    For Each stupos In stueli
        'Pos ausgeben
        stupos.writeSTU2Excel_debug row
        'row = row + 1
    Next
End Sub

'Suche alle Kinder von typ_spez_pos (Knoten im typspezifischen Format)
'Wandelt die Kinder in typunabhängige Form unter Berücksichtigung der Ebene und der Gesamtmenge
'legt typunabhängige Form in non_type_pos.stueli ab
'non_type_pos ist Knoten im typunabhängigen Format (Klasse STUELI_Position)
Public Sub erzeuge_Baum(typ_spez_pos As Variant, non_type_pos As STUELI_Position, mit_FA As Boolean)
    Dim pos As Variant
    Dim kind_stueli_pos As STUELI_Position
    Dim Ignore, Skip_complete  As Boolean
    
    For Each pos In typ_spez_pos.stueli
        'Debug.Print non_type_pos.level, pos.pos_nr, pos.t_tg_nr
        Skip_complete = False
        Ignore = False
        
        If Not mit_FA Then
            If pos.pos_typ = "FA_Komm" Or pos.pos_typ = "FA_Serie" Then
                'Fa-Eintraege sollen ignoriert, also nicht in die Doku übernommen werden
                'Es werden jedoch die Kinder eine Ebene höher eingehängt
                Ignore = True
            
                If pos.pos_typ = "FA_Komm" And pos.verurs_art <> 1 Then
                    'Auftragsbezogene Fa's mit verursacher_art <> 1 sind untergeordnete FA z.B zu einer Pumpenmontage
                    'Deren Teile sind schon im Haupt-FA enthalten und sollen nicht in der Doku erscheinen
                    'Knoten und alle Kinder werden ignoriert => Weiter im For-Loop mit naechster Pos
                    Skip_complete = True
                End If
            
            End If
        
        End If
        
        If Not Skip_complete Then
            If Ignore Then
                'Rekursion: Kinder fuer neu gefundene pos bearbeiten
                'Der Eintrag erfolgt aber in die stueli von non_type_pos, der bereits übergeben wurde
                'Im Gegensatz dazu wird im ELSE-Zweig die Stueli des neu gewandelten Kind-Knotens kind_stueli_pos verwendet
                '=> der aktuelle Eintrag pos wird im Baum übergangen
                erzeuge_Baum pos, non_type_pos, mit_FA
            Else
                'typunabhängige Pos erzeugen
                Set kind_stueli_pos = New STUELI_Position
                kind_stueli_pos.init pos, non_type_pos.level + 1, non_type_pos.menge_ueb
                'In stueli von non_type_pos uebernehmen
                non_type_pos.stueli.Add kind_stueli_pos
                'Rekursion: Kinder fuer neu gefundene pos bearbeiten
                'Der Eintrag der Kinder erfolgt in die Stueli des neu gewandelten Kind-Knotens kind_stueli_pos
                erzeuge_Baum pos, kind_stueli_pos, mit_FA
            End If
        End If
        
    Next
    
End Sub

