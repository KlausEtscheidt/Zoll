Attribute VB_Name = "Globals"
'Hier stehen Daten von globaler Bedeutung:
     'Namen und Objekte von Excel-Mappen und Blättern
     'Überschriften für die Ausgabe
     'Objekte zum Zugriff auf die Datenbank
'Sie müssen vor jedem Funktionsaufruf mit der Funktion set_globals gesetzt werden
Option Explicit

'Mappen und Blattnamen
Public Const xls_codemappe = "Präferenzkalkulation Makros.xlsm"
Public xls_hauptmappe$
Public Const import_sheet_name = "import"   'sheet fuer UNIPPS Import
Public Const preis_sheet_name = "Listenpr"  'sheet Eingabe  der Listenpreis der Kundenauftragspostionen
Public Const stu_sheet_name = "Kalkulation"   'sheet fuer Kurzfassung der Stückliste
Public Const rs_debug_sheet_name = "rs_debug"   'sheet fuer testausgaben von abfragen

Public data_wb As Workbook  'Arbeitsmappe mit Daten
Public code_wb As Workbook  'Mappe mit Software
Public imp_sheet As Worksheet  'sheet fuer UNIPPS Import
Public stu_sheet As Worksheet  'sheet fuer Kurzfassung der Stückliste
Public preis_sheet As Worksheet  'sheet Eingabe  der Listenpreis der Kundenauftragspostionen
Public rs_debug_sheet As Worksheet  'sheet fuer testausgaben von abfragen

'Überschriften und Konstanten f Ausgabe
Public Const full_header = "Ebene,Typ,zu Teil,FA,id_pos,ueb_s_nr,ds,pos_nr,verurs_art,t_tg_nr,oa,Bezchng,typ,v_besch_art,urspr_land,ausl_u_land,praeferenzkennung," _
                         & "menge,sme,faktlme_sme,lme," _
                         & "bestell_id,bestell_datum,preis,basis,pme,bme,faktlme_bme,faktbme_pme,id_lief," _
                         & "lieferant,pos_menge,preis_eu,preis_n_eu,Summe_Eu,Summe_n_EU,LP je Stück,KT_zu_LP"

Public Const KA_doku_header = "Ebene,t_tg_nr,Bezeichnung," _
                         & "Menge,Lieferant,Preis_eu,Preis_n_eu,Summe_Eu,Summe_n_EU,LP(Stück),KT_zu_LP"
Public Const KA_doku_header_min_col = 1
'Public Const KA_doku_header_med_col = 9    'Mittelspalte ohne Hinterlegung
Public Const KA_doku_header_max_col = 11

Public Const Preis_header = "id_pos,Menge,t_tg_nr,Bezeichnung,Verkaufspreis je Stück,Rabatt,VK rabattiert,Subpos zu"

'Sonstige Globals
'###########################################

'Datenbank-Reader
Public UNIPPS_dbr As DB_Reader

'Klasse zum Ausführen von SQL-Abfragen
Public SQL_exec As SQL_Executor

'Liste von Endknoten (Blätter des Baumes, noch ohne Kinder und auch nicht Kaufteil)
'wird fuer stufenweise Suche verwendet
Public teile_ohne_stu As Collection

'Modul zur Ausgabe von Meldungen
Public Logger As Logger_cls

'Vorbelegung von globalen Variablen
Public Sub set_globals()
    
    'Mappe und Blatt fuer Import
    Set data_wb = Workbooks(xls_hauptmappe)
    Set code_wb = Workbooks(xls_codemappe)
    Set imp_sheet = data_wb.Worksheets(import_sheet_name)
    Set preis_sheet = data_wb.Worksheets(preis_sheet_name)
    Set rs_debug_sheet = code_wb.Worksheets(rs_debug_sheet_name)
    Set stu_sheet = data_wb.Worksheets(stu_sheet_name)
    
    'Globalen Datenbankreader anlegen und Verbindung herstellen
    Set UNIPPS_dbr = New_DB_Reader
    UNIPPS_dbr.Open_Informix_Connection
    'Globales Objekt zur SQL-Ausführung anlegen
    Set SQL_exec = New SQL_Executor
End Sub
    
'Legt einen Logger an und setzt dessen Batch-Modus
'Bei True erfolgen die Ausgaben nur in eine Datei und nicht per Msxbox
Public Sub set_logger(Optional batchmode As Boolean = False)
    Set Logger = New Logger_cls
    Logger.init batchmode
End Sub


