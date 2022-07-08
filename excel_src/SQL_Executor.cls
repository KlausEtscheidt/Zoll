VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "SQL_Executor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'SQL-Abfrage sucht Fertigungsauftrag zu einer Position im Kundenauftrag
Public Function suche_FA_zu_KAPos(id_stu$, id_pos$, rs As Recordset) As Boolean

    Dim sql$
    
    'siehe Access Abfrage "a_FA_Kopf_zu_KAPos_mit_Teileinfo"
    'Suche über f_auftragkopf.auftr_nr=KA_id (Id des Kundenauftrages) und f_auftragkopf.auftr_pos=pos_id
    sql = "SELECT f_auftragkopf.auftr_nr as id_stu, " _
        & "f_auftragkopf.auftr_pos as pos_nr, f_auftragkopf.auftragsart, f_auftragkopf.verurs_art, f_auftragkopf.t_tg_nr, f_auftragkopf.oa, " _
        & "f_auftragkopf.typ,  " _
        & "f_auftragkopf.ident_nr as id_FA " _
        & "FROM f_auftragkopf " _
        & "Where f_auftragkopf.auftr_nr=" & id_stu & " and f_auftragkopf.auftr_pos=" & id_pos _
        & " and f_auftragkopf.oa<9 " _
        & " ORDER BY id_FA;"
   
    'Abfrage ausführen und recordset zurück liefern
    Set rs = hole_recordset(sql)
    suche_FA_zu_KAPos = rs.RecordCount > 0
    
    csv_out rs, "FA_zu_KAPos"

End Function


'SQL-Abfrage Suche einen Serien-FA zu einem Teil
'Es wird der neueste FA verwendet (höchste ID)
Public Function suche_FA_zu_Teil(t_tg_nr$, rs As Recordset) As Boolean

    Dim sql$
    
    'siehe Access Abfrage "b_suche_FA_zu_Teil"
    sql = "SELECT first 1 f_auftragkopf.auftr_nr as id_stu,  " _
        & "f_auftragkopf.auftr_pos as pos_nr, f_auftragkopf.auftragsart, f_auftragkopf.verurs_art, f_auftragkopf.t_tg_nr, f_auftragkopf.oa, " _
        & "f_auftragkopf.typ, f_auftragkopf.ident_nr as id_FA " _
        & "FROM f_auftragkopf " _
        & "Where f_auftragkopf.t_tg_nr=""" & t_tg_nr _
        & """ and f_auftragkopf.oa<9 " _
        & " ORDER BY id_FA desc;"
  
    'Abfrage ausführen und recordset zurück liefern
    Set rs = hole_recordset(sql)
    suche_FA_zu_Teil = rs.RecordCount > 0

    csv_out rs, "FA_zu_Teil"

End Function


'SQL-Abfrage Suche eine Stückliste zum Teil
Public Function suche_Stueli_zu_Teil(t_tg_nr$, rs As Recordset) As Boolean

    Dim sql$
    
    'siehe Access Abfrage "b_suche_Stueli_zu_Teil"
    'Suche über teil_stuelipos.ident_nr1=t_tg_nr
    'Es werden die Daten aus teil_stuelipos gelesen
    'Es existieren z.T. unterschiedlich Stücklisten wegen mehrerer Arbeitspläne (Ausweichmaschine mit anderen Rohteilen)
    'Es wird daher zu TEIL_APLNKOPF gejoined und dort teil_aplnkopf.art=1 gefordert (Standardarbeitsplan)
    sql = "SELECT teil_stuelipos.ident_nr1 As id_stu, teil_stuelipos.pos_nr, teil_stuelipos.t_tg_nr, teil_stuelipos.oa, teil_stuelipos.menge " _
        & "FROM teil_aplnkopf INNER JOIN teil_stuelipos ON teil_aplnkopf.ident_nr1 = teil_stuelipos.ident_nr1 " _
        & "AND teil_aplnkopf.ident_nr2 = teil_stuelipos.ident_nr2 AND teil_aplnkopf.ident_nr3 = teil_stuelipos.ident_nr3 " _
        & "WHERE teil_stuelipos.ident_nr1=""" & t_tg_nr & """ And teil_aplnkopf.art=""1"" " _
        & "ORDER BY teil_stuelipos.pos_nr ;"
  
    'Abfrage ausführen und recordset zurück liefern
    Set rs = hole_recordset(sql)
    suche_Stueli_zu_Teil = rs.RecordCount > 0

    csv_out rs, "Stueli_zu_Teil"

End Function

'SQL-Abfrage holt Kundenauftrag und seine Positionen
Public Function suche_Kundenauftragspositionen(ka_id$, rs As Recordset) As Boolean

    Dim sql$
    
    '(siehe Access Abfrage "b_hole_KAPositionen")
    sql = "SELECT auftragpos.ident_nr1 as id_stu, auftragpos.ident_nr2 as id_pos, auftragkopf.kunde, auftragpos.besch_art, auftragkopf.klassifiz, auftragpos.pos as pos_nr, " _
        & "auftragpos.t_tg_nr, auftragpos.oa, auftragpos.typ, auftragpos.menge, auftragpos.preis " _
        & "FROM auftragkopf INNER JOIN auftragpos ON auftragkopf.ident_nr = auftragpos.ident_nr1 " _
        & "WHERE auftragpos.ident_nr1 = """ & ka_id & """ "
   
    'Abfrage ausführen und recordset zurück liefern
    Set rs = hole_recordset(sql)
    suche_Kundenauftragspositionen = rs.RecordCount > 0
    
    csv_out rs, "Kundenauftragspositionen"
End Function

'SQL-Abfrage holt Rabatt zu einem Kunden
Public Function hole_Rabatt_zum_Kunden(kunden_id$, rs As Recordset) As Boolean

    Dim sql$, heute_datum_str$
    
    'datumsformat yyyy-mm-dd
    heute_datum_str = odbc_xl_date(Now())
    
    '(siehe Access Abfrage "b_hole_Rabatt_zum_Kunden")
    sql = "SELECT ident_nr1 as kunden_id, zu_ab_proz, datum_von, datum_bis " _
        & "FROM kunde_zuab " _
        & "WHERE ident_nr1 = """ & kunden_id & """ AND datum_von<=" & heute_datum_str _
                 & " AND datum_bis>" & heute_datum_str & " ; "

    'Abfrage ausführen und recordset zurück liefern
    Set rs = hole_recordset(sql)
    hole_Rabatt_zum_Kunden = rs.RecordCount > 0

    csv_out rs, "Rabatt"

End Function



'Suche alle Positionen zu einem FA (ASTUELIPOS)
Public Function hole_Pos_zu_FA(FA_id$, rs As Recordset) As Boolean
    Dim sql$
    
    'siehe Access Abfrage "b_hole_Pos_zu_FA"
    'Suche über astuelipos.ident_nr1=FA_id (Id des Fertigungsauftrages)
    sql = "SELECT astuelipos.ident_nr1 AS id_stu, astuelipos.ident_nr2 as id_pos, " _
          & "astuelipos.ueb_s_nr, astuelipos.ds, astuelipos.set_block, " _
          & "astuelipos.pos_nr, astuelipos.t_tg_nr, astuelipos.oa, " _
          & "astuelipos.typ, astuelipos.menge " _
          & "FROM astuelipos " _
          & "WHERE astuelipos.ident_nr1=" & FA_id _
          & " AND astuelipos.oa<9 " _
          & "ORDER BY astuelipos.pos_nr"

    'Abfrage ausführen und recordset zurück liefern
    Set rs = hole_recordset(sql)
    hole_Pos_zu_FA = rs.RecordCount > 0

    csv_out rs, "Pos_zu_FA"

End Function


'SQL-Abfrage holt Zusatzinformationen zu einem Teil aus den Tabellen "TEIL" und "TEIL_UW"
Public Function suche_Daten_zum_Teil(t_tg_nr$, rs As Recordset) As Boolean

    Dim sql$
    
    '(siehe Access Abfrage "b_hole_Daten_zu Teil")
    sql = "SELECT teil_uw.t_tg_nr, teil_uw.oa, " _
        & "teil_uw.v_besch_art as besch_art, teil.typ, teil.urspr_land, teil.ausl_u_land, teil.praeferenzkennung, " _
        & "teil.sme, teil.faktlme_sme, teil.lme " _
        & "FROM teil INNER JOIN teil_uw ON teil.ident_nr = teil_uw.t_tg_nr AND teil.art = teil_uw.oa " _
        & "Where teil_uw.t_tg_nr=""" & t_tg_nr _
        & """ and teil_uw.oa<9 AND teil_uw.uw=1; "
        
    'Abfrage ausführen und recordset zurück liefern
    Set rs = hole_recordset(sql)
    suche_Daten_zum_Teil = rs.RecordCount > 0

    csv_out rs, "Daten_zum_Teil"

End Function

'SQL-Abfrage sucht letzte 3 Bestellungen zu einem Teil
Public Function suche_letzte_3_Bestellungen(t_tg_nr$, rs As Recordset) As Boolean
    Dim sql$, sql_sub$

    'siehe Access Abfrage "b_Bestelldaten"
    'Suche über unipps_bestellpos.t_tg_nr=t_tg_nr; bestellkopf.datum muss aus der Unterabfrage hervorgehen (neuestes Datum)
    sql = "SELECT first 3 bestellkopf.ident_nr as bestell_id, bestellkopf.datum as bestell_datum, bestellpos.preis, bestellpos.basis, bestellpos.pme, bestellpos.bme, " _
        & "bestellpos.faktlme_bme, bestellpos.faktbme_pme, bestellpos.netto_poswert, bestellpos.menge, bestellpos.we_menge, " _
        & "bestellkopf.lieferant, adresse.kurzname, bestellpos.t_tg_nr " _
        & "FROM bestellpos INNER JOIN bestellkopf ON bestellpos.ident_nr1 = bestellkopf.ident_nr " _
        & "JOIN adresse ON bestellkopf.lieferant = adresse.ident_nr " _
        & "WHERE bestellpos.t_tg_nr=""" & t_tg_nr$ & """ order by bestellkopf.datum desc ;"
        
    'Abfrage ausführen und recordset zurück liefern
    Set rs = hole_recordset(sql)
    suche_letzte_3_Bestellungen = rs.RecordCount > 0
    
    csv_out rs, "letzte_3_Bestellungen"

End Function

'Sucht Bezeichnung zu einem Teil
Public Function hole_Teile_Bezeichnung(t_tg_nr$, rs As Recordset) As Boolean
    'siehe Access Abfrage "b_hole_Teile_Bezeichnung"
    Dim sql$
    sql = "SELECT teil_bez.ident_nr1 AS teil_bez_id, teil_bez.Text AS Bezeichnung FROM teil_bez " _
                              & "WHERE ident_nr1=""" & t_tg_nr$ & """ and teil_bez.sprache=""D"" AND teil_bez.art=1 ;"
    
    'Abfrage ausführen und recordset zurück liefern
    Set rs = hole_recordset(sql)
    hole_Teile_Bezeichnung = rs.RecordCount > 0

    csv_out rs, "Teile_Bezeichnung"

End Function

'########################### helper #############################
'Allgemeingueltige Funktion fuer SQL-Abfragen
Public Function hole_recordset(sql$) As Recordset
    'UNIPPS_dbr ist global und verbunden
    
    'Oeffne recordset
    Set hole_recordset = UNIPPS_dbr.hole_recordset(sql)
    
    'Fehlerhandling
    If UNIPPS_dbr.Connection.Errors.Count <> 0 Then
        Debug.Print sql
        Debug.Print UNIPPS_dbr.Connection.Errors(0).Description
        abbruchmeldung "UNIPPS-Daten konnten nicht gelesen werden."
    End If
    'Set hole_recordset = UNIPPS_dbr.rs
End Function


