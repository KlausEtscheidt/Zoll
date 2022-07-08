VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Teiledaten"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'Public exists As Boolean 'Die Objekte werden angelegt bevor in UNIPPS nach Ihnen gesucht wird: Wenn gefunden => exist = True
Public hat_stueli As Boolean
'Public teil_zu_pos As Teil 'Daten zum Teil auf der Position

Public t_tg_nr$
Public oa%
Public bezeichnung$
Public unipps_typ$
Public besch_art%
Public urspr_land%
Public ausl_u_land%
Public praeferenzkennung%
Public sme%
Public faktlme_sme As Double
Public lme%

Public ist_Kaufteil As Boolean
Public ist_Fremdfertigung As Boolean
Public ist_Eigenfertigung As Boolean

Public hat_Preis As Boolean
Public preis As Double
Public preis_EU As Double
Public preis_Non_EU As Double

Public Bestelldaten As Bestellung

Public Sub init(record As Fields)
    t_tg_nr = Trim(record("t_tg_nr"))
    'Debug.Print t_tg_nr
    oa = record("oa")
    besch_art = record("besch_art")
    unipps_typ = record("typ")
    urspr_land = record("urspr_land")
    ausl_u_land = record("ausl_u_land")
    praeferenzkennung = record("praeferenzkennung")
    sme = record("sme")
    faktlme_sme = record("faktlme_sme")
    lme = record("lme")
    
    Set Bestelldaten = New Bestellung
    'Weitere Eigenschaften berechnen
    ist_Kaufteil = besch_art = 1
    ist_Eigenfertigung = besch_art = 2
    ist_Fremdfertigung = besch_art = 4
    'ist_Beschaffungsteil = ist_Kaufteil Or ist_Fremdfertigung
    If ist_Kaufteil Or ist_Fremdfertigung Then
        Bestelldaten.init t_tg_nr
        hat_Preis = Bestelldaten.existiert
    End If
    
    Dim gefunden As Boolean
    Dim rs As Recordset
    gefunden = SQL_exec.hole_Teile_Bezeichnung(t_tg_nr, rs)
    If gefunden Then
        bezeichnung = rs.Fields("bezeichnung")
    End If
End Sub



