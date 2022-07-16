Attribute VB_Name = "Suche_Kinder"
'Hier stehen Funktionen zum Suchen von Kindern (Elementen einer St�ckliste)
'Die Funktionen werden von mehreren Klassen verwendet und wurden deshalb nicht als Klassenfunktionen realisiert.

Option Explicit

'Verwendet von Kundenauftrags_Position.hole_kinder, FA.hole_kinder, FA_Pos.hole_kinder
'Teil ist Kaufteil => Suche beendet
'Fremdfertigung => suche �ber STU
'Eigenfertigung => suche �ber Fa oder STU

Public Function suche_Kinder_v_Serien_Teil(teil As Variant) As Boolean
    Dim gefunden As Boolean
    Dim Variante%
    Variante = 1
    
    'Debug.Print teil.t_tg_nr
    
    'Kaufteil
    If teil.teile_daten.ist_Kaufteil Then
        If Not teil.teile_daten.hat_Preis Then
            Logger.user_info "Kaufteil ohne Preis gefunden " & teil.t_tg_nr, level:=2
        End If
        'keine weitere Suche
        gefunden = True
    
    'Fremdfertigung
    ElseIf teil.teile_daten.ist_Fremdfertigung Then
        
        'Suche nur �ber Teilestueckliste
        gefunden = suche_Kinder_in_Teile_Stu(teil)
    
    'Eigenfertigung
    ElseIf teil.teile_daten.ist_Eigenfertigung Then
    
        'Weitere Suche auf 2 Arten
        If Variante = 1 Then
            'Suche erst �ber FA, dann �ber Teilestueckliste
            gefunden = suche_Serien_FA(teil)
            If Not gefunden Then
                gefunden = suche_Kinder_in_Teile_Stu(teil)
            End If
        Else
            'Suche nur �ber Teilestueckliste
            gefunden = suche_Kinder_in_Teile_Stu(teil)
        End If
    
    'Unerwartete Beschaffungsart => Daten oder Programmfehler
    Else
        Logger.user_info "Unerwartete Daten bei Teil >>" & teil.t_tg_nr & "<< gefunden" _
                         & "Beschaffungsart ist " & teil.teile_daten.besch_art, level:=2
        gefunden = False
    End If
    
    suche_Kinder_v_Serien_Teil = gefunden
End Function

'Holt rekursiv untergeordnete St�cklistenelemente aus der Tabelle teil_stuelipos
Public Function suche_Kinder_in_Teile_Stu(teil As Variant) As Boolean
    Dim kinder_teil As Teil_in_STU
    Dim rs As Recordset
    Dim gefunden As Boolean
    
    'Gibt es eine St�ckliste zum Teil
    gefunden = SQL_exec.suche_Stueli_zu_Teil(teil.t_tg_nr, rs)
    
    'Wenn Kinder gefunden
    Do While Not rs.EOF
        
        'aktuellen Datensatz in Objekt wandeln
        Set kinder_teil = New Teil_in_STU
        kinder_teil.init rs.Fields
        
        'in Stueck-Liste �bernehmen
        teil.stueli.Add kinder_teil
        
        'merken als Teil noch ohne Kinder fuer weitere Suchl�ufe
        teile_ohne_stu.Add kinder_teil
        
        'Naechter Datensatz
        rs.MoveNext
        
    Loop
    
    suche_Kinder_in_Teile_Stu = gefunden
   
End Function

'Public Function suche_Serien_FA(t_tg_nr$, stueli As Collection) As Boolean
Public Function suche_Serien_FA(teil As Variant) As Boolean

    Dim myFA As FA
    Dim rs As Recordset
    Dim gefunden As Boolean
    
    'Gibt es einen Serien_FA zum Teil
    gefunden = SQL_exec.suche_FA_zu_Teil(teil.t_tg_nr, rs)

    If Not gefunden Then
        suche_Serien_FA = False
        Exit Function
    End If
        
    'Erzeuge Objekt fuer einen Serien FA
    Set myFA = New FA
    myFA.init_serie rs.Fields
    
    'in Stueck-Liste �bernehmen
    teil.stueli.Add myFA

    'Kinder suchen
    myFA.hole_Kinder
    
    suche_Serien_FA = gefunden
        
End Function
    

