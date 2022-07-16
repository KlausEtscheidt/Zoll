Attribute VB_Name = "main"
'In diesem Modul stehen die Funktionen, die direkt aufgerufen werden.
'Sie bilden die oberste Programmebene

Option Explicit

'Die folgenden Funktionen sind Buttons in der Hauptmappe zugeordnet
'Sie dienen hauptsächlich zum Einlesen der ID des Kundeauftrages
'Die Arbeit wird von den weiter unten stehenden Funktionen erledigt, die schon eine ID als Parameter erwarten
Public Sub Btn_hole_Preise_fuer_KA_Positionen()
    Dim ka$
    xls_hauptmappe = Application.ActiveWorkbook.Name
    set_logger
    ka = Application.ActiveSheet.Range("D5")
    hole_KA_Positionen_fuer_Preisblatt (ka)
End Sub


Public Sub Btn_KA_Analyse()
    Dim ka$
    xls_hauptmappe = Application.ActiveWorkbook.Name
    set_logger
    ka = Application.ActiveSheet.Range("D5")
    start_KA_Analyse (ka)
End Sub

'Druckt das Dokumentationsblatt aus
Public Sub Btn_print_doku()
    xls_hauptmappe = Application.ActiveWorkbook.Name
    set_globals
    stu_sheet.PrintPreview
End Sub

'Speichert das Dokumentationsblatt als PDF
Public Sub Btn_speichere_pdf()
    Dim ka$
    xls_hauptmappe = Application.ActiveWorkbook.Name
    set_logger
    ka = Application.ActiveSheet.Range("D5")
    store_pdf (ka)
End Sub

'Schreibt wichtige Daten des Kundenauftrages auf das Blatt zur Eingabe der Listenpreise
Public Sub hole_KA_Positionen_fuer_Preisblatt(ka_id$)
    Dim myKA As Kundenauftrag
    Dim ka_pos As Kundenauftrags_Position
    Dim myrow As Long
       
    set_globals
       
    'Blatt leeren
    Preis_sheet_reset
    
    'Daten lesen
    Set myKA = New Kundenauftrag
    myKA.init ka_id
    
    'Daten ausgeben
    myrow = 2
    For Each ka_pos In myKA.stueli
        ka_pos.write2Excel_Preisblatt myrow
        myrow = myrow + 1
    Next
    
    'Blatt aktivieren (anzeigen)
    preis_sheet.Activate
    
End Sub

'Liest alle Daten des Kundeauftrages rekursiv bis zur untersten Ebene
'Gibt die Daten in Excel aus
Public Sub start_KA_Analyse(ka_id$)
    Dim myKA As Kundenauftrag
    Dim Baum_komplett As STU_Baum
    Dim Baum_doku As STU_Baum
    Dim Start As Double
    Start = Timer
    
    Application.ScreenUpdating = False
    Logger.log CStr(Application.ScreenUpdating)
    Application.StatusBar = "lese Daten"
    
    set_globals
    
    'Ausgabe-Blätter leeren
    import_sheet_reset
    KA_doku_sheet_reset

    'Objekt anlegen und Positionen des KA einlesen
    Set myKA = New Kundenauftrag
    myKA.init ka_id
    
    'Lese Verkaufpreise aus Excel
    'Dies ist nötig, wenn in UNIPPS keine Preise waren und diese manuell ergänzt wurden
    myKA.hole_Listenpreise
    
    'Kinder der Positionen des KA einlesen
    'Aufbau der kompletten Struktur
    myKA.hole_Kinder
       
    'Falls es Positionen des KA gibt, die eigentlich Unterpositionen anderer Pos. sind:
    'Beispiel Motor gehört zu Pumpenaggregat
    myKA.sortiere_neu
    
    'Umwandeln in Baumstruktur mit typunabhängigen (allgemeinen) Knoten
    'Berechnen der Preissummen
    Set Baum_komplett = New STU_Baum
    myKA.erzeuge_Baum Baum_komplett, mit_FA:=True
       
    'volle Ausgabe zum debuggen
    Baum_komplett.write2Excel_debug
    
    'Ausgabe zum Drucken (auch pdf) und aufheben
    Set Baum_doku = New STU_Baum
    myKA.erzeuge_Baum Baum_doku, mit_FA:=False
    Baum_doku.write2Excel_KA_doku
    
    Application.StatusBar = "fertig"
    Logger.user_info "Fertig analysiert nach " & Format(Timer - Start, "#0.00") & " Sekunden.", level:=1
End Sub

'Erzeugt PDF aus Dokumentationsblatt
Public Sub store_pdf(ka_id$, Optional zeigen As Boolean = True)
    Dim pfad$, pdf_name$
    set_globals
    pfad = data_wb.Path 'PDF ins Verzeichnis der Excel-Mappe
    pdf_name = pfad & "\pdf\" & ka_id$
    stu_sheet.ExportAsFixedFormat Type:=xlTypePDF, filename:=pdf_name, _
        Quality:=xlQualityStandard, IncludeDocProperties:=True, IgnorePrintAreas _
        :=False, OpenAfterPublish:=zeigen
        
End Sub
   
