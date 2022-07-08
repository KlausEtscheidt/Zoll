Attribute VB_Name = "nach_Excel"
'In diesem Modul stehen Hilfsfunktionen zum Schreiben von Daten in Excel-Tabellen
Option Explicit

'Setze das Sheet für die Debug-Ausgabe in den Basiszustand
Public Sub import_sheet_reset()
    'Inhalte loeschen
    imp_sheet.Cells.ClearContents
    'Ueberschriften schreiben
    write_debug_header
End Sub

'Setze das Sheet für die Listenpreiseingabe in den Basiszustand
Public Sub Preis_sheet_reset()
    'Inhalte loeschen
    preis_sheet.Cells.ClearContents
    'Ueberschriften schreiben
    write_header preis_sheet, 1, Preis_header
End Sub

'Setze das Sheet für die KA-Doku in den Basiszustand
'die ersten 5 Zeilen bleiben unberührt
Public Sub KA_doku_sheet_reset()
    'Inhalte loeschen
    stu_sheet.Range("A6:BA1000").ClearContents
    'Schattierung raus
    DeColorCells stu_sheet
    'Ueberschriften schreiben
    write_KA_doku_header
End Sub

'Schreibt die Header Liste fuer die Tabelle mit den debug-Daten
Public Sub write_debug_header()
    write_header imp_sheet, 1, full_header
End Sub

'Schreibt die Header Liste fuer die Doku eines KA
Public Sub write_KA_doku_header()
    write_header stu_sheet, 6, KA_doku_header
    ColorCells stu_sheet, 6, KA_doku_header_min_col, KA_doku_header_max_col, "grau_1"
End Sub

'Schreibt Elemente einer Liste (z.B. Überschriften) in die Zeile row eines Blattes
Public Sub write_header(target_sheet As Worksheet, row As Long, header_liste)
    Dim col%
    Dim namen
    namen = Split(header_liste, ",")

    For col = 0 To UBound(namen)
        target_sheet.Cells(row, col + 1) = namen(col)
    Next
End Sub

'Entfernt Hintergrundfarbe aus allen Zellen eines Blattes
Public Sub DeColorCells(target_sheet As Worksheet)
    target_sheet.Cells.Interior.TintAndShade = 0
    target_sheet.Cells.Interior.Pattern = xlNone
End Sub

'Entfernt Hintergrundfarbe aus einer Spalte eines Blattes
Public Sub DeColorColumn(target_sheet As Worksheet, mycol%)
    target_sheet.Columns(mycol).Interior.TintAndShade = 0
    target_sheet.Columns(mycol).Interior.Pattern = xlNone
End Sub

'Setzt Hintergrundfarbe für eine Zeile  eines Blattes in den Spalten col_min% bis  col_max%
Public Sub ColorCells(target_sheet As Worksheet, row As Long, col_min%, col_max%, farbe$)
    'grau hinterlegen
    Dim my_int As Interior
    Dim old_sheet As Worksheet
    Set old_sheet = Excel.ActiveSheet
    target_sheet.Activate
    'Geht nur wenn sheet aktiv ?????
    Set my_int = target_sheet.Range(Cells(row, col_min), Cells(row, col_max)).Interior
    my_int.Pattern = xlSolid
    Select Case farbe
        Case "grau_1":
            my_int.TintAndShade = -0.3
        Case "grau_2":
            my_int.TintAndShade = -0.15
        Case "rot":
            my_int.TintAndShade = -0.15
            my_int.Color = 5263615
        Case "":
            my_int.TintAndShade = 0
            my_int.Pattern = xlNone
    End Select
    old_sheet.Activate
End Sub

'Ermittelt aus einem Hierarchie-level einen schön formatierten String mit Punkten am Anfang
Public Function level_formatiert(level)
    Dim i%
    For i = 1 To level
        level_formatiert = level_formatiert & "."
    Next i
    level_formatiert = level_formatiert + Str(level)
End Function


