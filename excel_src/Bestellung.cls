VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Bestellung"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public bestell_id
Public bestell_datum
Public pme_preis As Double
Public basis
Public pme
Public bme
Public faktlme_bme
Public faktbme_pme
Public netto_poswert
Public menge
Public we_menge
Public lieferant
Public kurzname

Public existiert As Boolean 'Gibt es Bestelldaten
Private Preis_je_LME As Double 'Preis je Lagermengeeinheit

Public last_col% 'letzte Spalte, in welche in Excel geschrieben wurde

Private rs As Recordset

Public Sub init(t_tg_nr$)
    Dim max_preis As Double
    Dim record_id_max_preis As Long

    existiert = SQL_exec.suche_letzte_3_Bestellungen(t_tg_nr, rs)
    
    'Suche max Preis aus 3 Bestellungen
    max_preis = 0
    Do While Not rs.EOF
        Preis_je_LME = Berechne_Preis_je_LME_rabattiert()
        If Preis_je_LME > max_preis Then
            'id merken
            max_preis = Preis_je_LME
            record_id_max_preis = rs.AbsolutePosition
        End If
        rs.MoveNext
    Loop
       
    If existiert Then
        'Positioniere auf Datensatz mit max Preis
        rs.MoveFirst
        rs.Move record_id_max_preis - 1
        
        'Weitere Bestelldaten in Eigenschaften wandeln
        bestell_id = rs.Fields("bestell_id")
        bestell_datum = rs.Fields("bestell_datum")
        pme_preis = rs.Fields("preis") 'Preis bezogen auf basis und preismengeneinheit
        basis = rs.Fields("basis")
        pme = rs.Fields("pme")
        bme = rs.Fields("bme")
        faktlme_bme = rs.Fields("faktlme_bme")
        faktbme_pme = rs.Fields("faktbme_pme")
        netto_poswert = rs.Fields("netto_poswert")
        menge = rs.Fields("menge")
        we_menge = rs.Fields("we_menge")
        lieferant = rs.Fields("lieferant")
        kurzname = Trim(rs.Fields("kurzname"))
    
        'Es gibt eine Bestellung zur t_tg_nr => Netto-Preis je Liefermengeneinheit berechnen und merken
        Preis_je_LME = Berechne_Preis_je_LME_rabattiert()
    
    Else
        'Es gibt keine Bestellung zu t_tg_nr$
        Preis_je_LME = 0
    End If

End Sub

Private Function Berechne_Preis_je_LME_rabattiert() As Double
    's. auch Erklärungen in Berechne_Preis_je_LME_unrabattiert
    Dim preis As Double
    'Wert der Bestellpos ohne Rabatte:
    'wert = Preis_je_BME * Bestellmenge
    '=> analog
    'Wert der Bestellpos mit Rabatt:
    'wert = rs.Fields("netto_poswert") = Preis_je_BME_netto = rs.Fields("netto_poswert") * Bestellmenge
    'also: Preis_je_BME_netto = rs.Fields("netto_poswert") / * Bestellmenge
    preis = rs.Fields("netto_poswert") / rs.Fields("menge")
   
    'Preis je Lagermengeneinheit
    Berechne_Preis_je_LME_rabattiert = preis * rs.Fields("faktlme_bme")
    
    'Probe
    If Abs(rs.Fields("netto_poswert") - rs.Fields("menge") * preis) > 0.01 Then
        Logger.user_info "Fehlerhafte Preisberechnung in Bestellung: " & CStr(rs.Fields("bestell_id"))
    End If

End Function


Private Function Berechne_Preis_je_LME_unrabattiert() As Double
    Dim preis As Double
    'Daten in UNIPPS aus Bestllung/Zusatz/Zusatzdaten zur Bestellposition (im Feld Preis) bzw Hauptformular zum Teil
    'Beispiel ERMPEØ40
    'Basis=1
    'PME=kg (Preismengeneinheit)
    'BME=Stück (Bestellmengeneinheit)
    'faktbme_pme= 2,48 Kg/St;   wieviele PME ergeben eine BME ? 2,48 Kg ergeben 1 Stück
    'Preis_je_PME=8,35€/Kg aus Bestellung
    'Preis_je_BME = Preis_je_PME *faktbme_pme=8,35€/Kg * 2,48Kg/St = 20,71€/St
    'LME=m (Lagermengeeinheit)
    'faktlme_bme=0,5St/m;  wieviele BME ergeben eine LME ? 0,5 ergeben 1 Stück
    'Preis_je_LME = Preis_je_BME * faktlme_bme = 20,71€/St * 0,5St/m = 10,35 €/m
    
    'UNIPPS-Feld Preis ist Preis je Basis (UNIPPS-Feld Basis) und Preismengeneinheit PME
    'unrabbatierter Preis je Preismengeneinheit
    preis = rs.Fields("preis") / rs.Fields("basis")
    
    'Preis je Bestellmengeneinheit
    preis = preis * rs.Fields("faktbme_pme")
      
    'Preis je Lagermengeneinheit
    Berechne_Preis_je_LME_unrabattiert = preis * rs.Fields("faktlme_bme")
    
End Function

'Gesamt-Preis einer Stücklistenposition aus Menge und Preis je Lagermengeeinheit berechnen
Public Function STU_Pos_Preis(menge As Double, faktlme_sme As Double) As Double
    'Beipiel
    'SME=mm
    'LME=m
    'Preis je Liefermengeneinheit=10,35 €/m
    'faktlme_sme=1000 [mm/m];   wieviele SME ergeben eine LME ? 1000 mm ergeben 1 m
    'Preis je Stücklistenmengeneinheit ist Preis je Lagermengeeinheit "Preis_je_LME" geteilt durch faktlme_sme
    'Preis_je_SME also 10,35 €/m (Preis_je_LME) / (1000 mm/m) = 0,01035 €/mm
    STU_Pos_Preis = Preis_je_LME / faktlme_sme
    'Preis der Stücklistenposition durch Mult. mit der übergeordneten gesamten Menge
    STU_Pos_Preis = STU_Pos_Preis * menge
End Function

Public Sub write2Excel_debug(myrow As Long, start_col%)
    'Einige Daten in Standard-Import-Blatt schreiben
    Dim col%
    col = start_col
    col = col + 1: imp_sheet.Cells(myrow, col) = bestell_id
    col = col + 1: imp_sheet.Cells(myrow, col) = bestell_datum
    col = col + 1: imp_sheet.Cells(myrow, col) = pme_preis
    col = col + 1: imp_sheet.Cells(myrow, col) = basis
    col = col + 1: imp_sheet.Cells(myrow, col) = pme
    col = col + 1: imp_sheet.Cells(myrow, col) = bme
    col = col + 1: imp_sheet.Cells(myrow, col) = faktlme_bme
    col = col + 1: imp_sheet.Cells(myrow, col) = faktbme_pme
    'col = col + 1: imp_sheet.Cells(myrow, col) = netto_poswert
    col = col + 1: imp_sheet.Cells(myrow, col) = lieferant
    col = col + 1: imp_sheet.Cells(myrow, col) = kurzname
    last_col = col
End Sub



