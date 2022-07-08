Attribute VB_Name = "Tests"
Dim fehler_sheet As Worksheet
Dim f_row As Long

Public Sub export()
'Export_Current_VB
Dim export_dir$

export_dir = ThisWorkbook.Path & "\excel_src\"

'ThisWorkbook.VBProject.VBComponents("main").export outdir
Export_all_VB export_dir
End Sub

'Hier nur Funktionen zum Testen
Public Sub test_KA_Analyse()
    Dim ka_id$
    set_logger True
    
    ka_id = 144211 'Pumpe
    'KA_id = 131645 'Pumpe
    'KA_id = 142302 'Ersatz
    ka_id = 142567 '2 Pumpen
    'hole_KA_Positionen_fuer_Preisblatt ka_id
    start_KA_Analyse ka_id
End Sub

Public Sub test_store_pdf()
    Dim ka_id$
    ka_id = 144211 'Pumpe
    store_pdf ka_id
End Sub

Public Sub test_hole_KA_Positionen_fuer_Preisblatt()
    Dim ka_id$
    ka_id = 142302 'Pumpe
    ka_id = 142567 '2 Pumpen

    hole_KA_Positionen_fuer_Preisblatt ka_id
End Sub
Public Sub test_hole_rabatt()
    Dim myrange As Range
    Dim kunde$
    Dim gefunden As Boolean
    Dim rs As Recordset
    set_globals
    kunde = "1120840"
    gefunden = SQL_exec.hole_Rabatt_zum_Kunden(kunde, rs)
    Set myrange = rs_debug_sheet.Range("A1")
    UNIPPS_dbr.recordset_2_sheet myrange, rs, True, True
End Sub
  
Public Sub test_Dauerlauf()
    Dim gefunden As Boolean
    Dim ka_rs As Recordset
    Dim ka_id$
    Dim rec_pos As Long, max_rec As Long
    Dim myKA As Kundenauftrag
    Dim my_dbr As DB_Reader

    set_logger True
    
    Set my_dbr = New_DB_Reader

    gefunden = hole_KA_aus_UNIPPS(my_dbr, ka_rs)
    
    rec_pos = 400
    max_rec = 450
    ka_rs.Move rec_pos
    
    Do While Not ka_rs.EOF And rec_pos < max_rec
        ka_id = ka_rs.Fields("KA_ID")
        Logger.log ka_id & " " & ka_rs.Fields("klassifiz")
        Debug.Print ka_id, rec_pos
        hole_KA_Positionen_fuer_Preisblatt ka_id
        start_KA_Analyse ka_id
        store_pdf ka_id, False
        ka_rs.MoveNext
        rec_pos = rec_pos + 1
    Loop
    
    Set Logger = Nothing
End Sub

Public Function hole_KA_aus_UNIPPS(my_dbr As DB_Reader, rs As Recordset)
    'Datenbankreader anlegen und Verbindung herstellen
    my_dbr.Open_Informix_Connection

    Dim sql$, sql_sub$
    Dim teile_kriterium$
    sql = "select first 500 ident_nr as ka_id, klassifiz  from auftragkopf order by erstanlage desc"
    sql = "select first 500 ident_nr as ka_id, klassifiz  from auftragkopf where klassifiz like '2_.%' order by erstanlage desc"
    
    'Oeffne recordset
    Set rs = my_dbr.hole_recordset(sql)
    
    'Fehlerhandling
    If my_dbr.Connection.Errors.Count <> 0 Then
        Debug.Print sql
        Debug.Print my_dbr.Connection.Errors(0).Description
        abbruchmeldung "UNIPPS-Daten konnten nicht gelesen werden."
    End If
    
    hole_KA_aus_UNIPPS = rs.RecordCount > 0
End Function


Public Sub STU_Vergleich()
    Dim gefunden As Boolean
    Dim hat_Stu As Boolean
    Dim hat_Fa As Boolean
    Dim t_tg_nr$
    Dim rs As Recordset
    Dim rs_teile As Recordset
    Dim rs_fa As Recordset
    Dim rs_stu As Recordset
    Dim besch_art%
    Dim teile_art$

    set_globals
    Set fehler_sheet = data_wb.Worksheets("Fehler")
    f_row = 2
    
    besch_art = 2
    teile_art = "egal"
    'teile_art = "teil"
    'teile_art = "tg"

    gefunden = hole_Teile_aus_UNIPPS(rs_teile, teile_art, besch_art)
    
    Do While Not rs_teile.EOF
        t_tg_nr = Trim(rs_teile.Fields("t_tg_nr"))
        If t_tg_nr <> "" Then
            'Suche Teil
            gefunden = SQL_exec.suche_Daten_zum_Teil(t_tg_nr, rs)
            If gefunden Then
                Set teile_daten = New Teiledaten
                teile_daten.init rs.Fields
                'Gibt es eine Stückliste zum Teil
                hat_Stu = SQL_exec.suche_Stueli_zu_Teil(t_tg_nr, rs_stu)
                'Gibt es einen Serien_FA zum Teil
                hat_Fa = SQL_exec.suche_FA_zu_Teil(t_tg_nr, rs_fa)
                Debug.Print teile_daten.oa, t_tg_nr, "Stu", hat_Stu, "FA", hat_Fa, teile_daten.besch_art, "Preis", teile_daten.hat_Preis
                fehler_sheet.Cells(f_row, 1) = t_tg_nr: fehler_sheet.Cells(f_row, 2) = teile_daten.besch_art: fehler_sheet.Cells(f_row, 3) = hat_Stu
                fehler_sheet.Cells(f_row, 4) = hat_Fa: fehler_sheet.Cells(f_row, 5) = teile_daten.hat_Preis
                If hat_Fa Then
                     fehler_sheet.Cells(f_row, 6) = rs_fa.Fields("id_fa")
                End If
                If hat_Stu And hat_Fa Then
                     Stueli_Vergleich t_tg_nr, rs_stu, rs_fa
                End If
                f_row = f_row + 1
            Else
                fehler_sheet.Cells(f_row, 1) = t_tg_nr: fehler_sheet.Cells(f_row, 2) = "Konnte keine Teil daten finden."
                f_row = f_row + 1
            End If
        End If
        rs_teile.MoveNext
    Loop
    
End Sub

Public Sub Stueli_Vergleich(t_tg_nr$, rs_stu As Recordset, rs_fa As Recordset)
    Dim stu_fa  As New Collection, stu_stu As New Collection
    Dim i%
    Dim FA_Nr$, msg$
    
    FA_Nr = rs_fa.Fields("id_fa")
    
    hole_FA_Stueli rs_fa, stu_fa
    hole_Stueli_zu_Teil rs_stu, stu_stu
    If stu_fa.Count <> stu_stu.Count Then
        msg = "Länge ungleich fuer Teil " & t_tg_nr & " FA " & FA_Nr
        Debug.Print msg
        fehler_sheet.Cells(f_row, 7) = "Länge der STU ungleich"
        f_row = f_row + 1
    Else
        For i = 1 To stu_fa.Count
            If stu_fa.Item(i).t_tg_nr <> stu_stu.Item(i).t_tg_nr Then
                msg = "Kinder t_tg_nr ungleich fuer Item " & i & " Vater-Teil " & t_tg_nr & " FA " & FA_Nr
                Debug.Print msg
                fehler_sheet.Cells(f_row, 7) = "Kinder t_tg_nr ungleich fuer Item " & i
                f_row = f_row + 1
            End If
            If stu_fa.Item(i).menge <> stu_stu.Item(i).menge Then
                msg = "menge ungleich fuer Item " & i & " Vater-Teil " & t_tg_nr & " FA " & FA_Nr
                Debug.Print msg
                fehler_sheet.Cells(f_row, 7) = "Menge ungleich fuer Item " & i
                f_row = f_row + 1
            End If
        Next
   End If
End Sub

Public Sub hole_FA_Stueli(rs As Recordset, stueli As Collection)
    Dim FA_Nr$
    Dim gefunden As Boolean
    'Hole die Positionen des FA's aus der Unipps-Tabelle ASTUELIPOS
    FA_Nr = rs.Fields("id_fa")
    gefunden = SQL_exec.hole_Pos_zu_FA(FA_Nr, rs)
        
    If Not gefunden Then
        fehler_sheet.Cells(f_row, 7) = "keine FA Daten gefunden"
        f_row = f_row + 1
        Exit Sub
    End If
          
    Do While Not rs.EOF
    
        'Erzeuge eine FA-position aus dem Datensatz
        Set FA_Pos = New FA_Pos
        FA_Pos.init rs
               
        'Hier nur toplevel-KNoten berücksichtigen
        'd.h. alle die in ASTUELIPOS keine übergeordnete Stückliste haben: ueb_s_nr=0
        If FA_Pos.ist_toplevel Then
           
            'in Liste übernehmen
            stueli.Add FA_Pos
            
        Else
            'In Serien FA sollten nur toplevel-KNoten sein.
            msg = "Unerwartete Datenstruktur in 'ASTUELIPOS'. Toplevelknoten mit Feld ueb_s_nr=0 erwartet."
            fehler_sheet.Cells(f_row, 6) = msg

        End If
        
        rs.MoveNext
    
    Loop
    

End Sub

Public Sub hole_Stueli_zu_Teil(rs As Recordset, stueli As Collection)
    Dim kinder_teil As Teil_in_STU
    Do While Not rs.EOF
        'aktuellen Datensatz in Objekt wandeln
        Set kinder_teil = New Teil_in_STU
        kinder_teil.init rs.Fields
        
        'in Stueck-Liste übernehmen
        stueli.Add kinder_teil

        rs.MoveNext
    Loop
End Sub

Public Function hole_Teile_aus_UNIPPS(rs As Recordset, teile_art$, besch_art%)
    Dim sql$, sql_sub$
    Dim teile_kriterium$
    Dim sql_exe As New SQL_Executor
    
    If teile_art = "egal" Then
        teile_kriterium = "<9"
    ElseIf teile_art = "teil" Then
        teile_kriterium = "=1"
    ElseIf teile_art = "tg" Then
        teile_kriterium = "=0"
    Else
        MsgBox "Ungültige Teileart " & teile_art
        End
    End If
    
    sql_where = "Where teil_uw.t_tg_nr not like ""E%"" " _
                & "and teil_uw.t_tg_nr not like ""B%"" " _
                & "and teil_uw.t_tg_nr not like ""T%"" " _
                & "and teil_uw.v_besch_art=" & besch_art & " and teil_uw.oa" & teile_kriterium & " AND teil_uw.uw=1"
    
    sql = "SELECT count(teil_uw.t_tg_nr) as n "
    sql_from = "FROM teil_uw  "
    sql = sql + sql_from + sql_where
    Set rs = sql_exe.hole_recordset(sql)
    MsgBox rs.Fields("n") & " Teile gefunden"
    hole_Teile_aus_UNIPPS = rs.Fields("n") > 0
       
    sql = "SELECT teil_uw.t_tg_nr, teil_uw.oa, " _
        & "teil_uw.v_besch_art as besch_art, teil.typ, teil.urspr_land, teil.ausl_u_land, teil.praeferenzkennung, " _
        & "teil.sme, teil.faktlme_sme, teil.lme "
    sql_from = "FROM teil INNER JOIN teil_uw ON teil.ident_nr = teil_uw.t_tg_nr AND teil.art = teil_uw.oa "
    'sql_where = "Where teil.ident_nr in (" & sql_sub & "); "
    sql = sql + sql_from + sql_where
    
    'Abfrage ausführen und recordset zurück liefern
    Set rs = sql_exe.hole_recordset(sql)
    'MsgBox rs.RecordCount & " Teile gefunden"
    'hole_Teile_aus_UNIPPS = rs.RecordCount > 0

End Function
