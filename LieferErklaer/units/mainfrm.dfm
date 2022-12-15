object mainForm: TmainForm
  Left = 0
  Top = 0
  HelpType = htKeyword
  HelpKeyword = 'Ablauf'
  Caption = 'DigiLek Digitale Lieferantenerkl'#228'rung'
  ClientHeight = 629
  ClientWidth = 1103
  Color = clGradientActiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  HelpFile = 'C:\tmp\digilekdoc.chm'
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesigned
  OnDestroy = FormDestroy
  OnHelp = FormHelp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inline Lekl3LieferantAuswahlFrm: TLieferantenStatusFrm
    Left = 0
    Top = 0
    Width = 1103
    Height = 610
    HelpType = htKeyword
    HelpKeyword = 'Lieferantenauswahl'
    Align = alClient
    ParentBackground = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    ExplicitWidth = 1094
    ExplicitHeight = 610
    inherited GroupBox1: TGroupBox
      Width = 889
      ExplicitWidth = 889
      inherited Label2: TLabel
        Left = 18
        Top = 23
        ExplicitLeft = 18
        ExplicitTop = 23
      end
      inherited Label1: TLabel
        Left = 215
        Top = 23
        ExplicitLeft = 215
        ExplicitTop = 23
      end
      inherited FilterKurzname: TEdit
        Left = 87
        Top = 19
        ExplicitLeft = 87
        ExplicitTop = 19
      end
      inherited FilterName: TEdit
        Left = 254
        Top = 19
        ExplicitLeft = 254
        ExplicitTop = 19
      end
      inherited FilterAusBtn: TButton
        Left = 438
        Top = 18
        ExplicitLeft = 438
        ExplicitTop = 18
      end
      inherited LeklUpdatedChkBox: TCheckBox
        Left = 605
        Top = 10
        Hint = 'Zeige nur Lekl, die in den letzten 200 Tagen abgegeben wurden'
        ExplicitLeft = 605
        ExplicitTop = 10
      end
      inherited UnbearbeiteteCheckBox: TCheckBox
        Left = 741
        Top = 10
        Width = 140
        Hint = 'zeige nur Lekl, f'#252'r die noch keine Teile erfasst wurden'
        ExplicitLeft = 741
        ExplicitTop = 10
        ExplicitWidth = 140
      end
      inherited NLeklUpdatedChkBox: TCheckBox
        Left = 605
        Top = 30
        Hint = 'Zeige nur Lekl, die vor mehr als 200 Tagen abgegeben wurden'
        ExplicitLeft = 605
        ExplicitTop = 30
      end
      inherited NUnbearbeiteteCheckBox: TCheckBox
        Left = 741
        Top = 30
        Hint = 'zeige nur Lekl, f'#252'r die aktuell schon Teile erfasst wurden'
        ExplicitLeft = 741
        ExplicitTop = 30
      end
      inherited StandardFilterButton: TButton
        Left = 480
        Top = 20
        ExplicitLeft = 480
        ExplicitTop = 20
      end
    end
    inherited GroupBox2: TGroupBox
      Width = 889
      Height = 263
      ExplicitWidth = 889
      ExplicitHeight = 263
      inherited DBGrid1: TDBGrid
        Left = 87
        Top = 22
        Width = 594
        Height = 220
        Columns = <
          item
            Expanded = False
            FieldName = 'LKurzname'
            Title.Caption = 'Kurzname'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LName1'
            Title.Caption = 'Name1'
            Width = 240
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'gilt_bis'
            Title.Alignment = taCenter
            Width = 70
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'Stand'
            Title.Alignment = taCenter
            Width = 70
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'StandTeile'
            Width = 70
            Visible = True
          end>
      end
    end
    inherited GroupBox3: TGroupBox
      Width = 890
      ExplicitWidth = 890
      inherited Panel3: TPanel
        inherited Label6: TLabel
          Width = 325
        end
        inherited DBText1: TDBText
          ExplicitTop = 21
        end
        inherited DBText2: TDBText
          ExplicitTop = 41
        end
      end
    end
  end
  inline ExportFrm1: TGesamtStatusFrm
    Left = 0
    Top = 0
    Width = 1103
    Height = 610
    Align = alClient
    AutoSize = True
    TabOrder = 1
    Visible = False
    ExplicitWidth = 1094
    ExplicitHeight = 610
    inherited Label1: TLabel
      Width = 1050
    end
    inherited Label2: TLabel
      Width = 1050
    end
    inherited TeilePanel: TPanel
      Width = 1020
      ExplicitWidth = 1011
      inherited Panel5: TPanel
        ExplicitHeight = 130
        inherited Label3: TLabel
          Left = 0
          Width = 237
        end
        inherited Label4: TLabel
          Left = 0
          Top = 25
          Width = 237
          ExplicitTop = 25
        end
        inherited Label5: TLabel
          Left = 0
          Top = 47
          Width = 237
          ExplicitTop = 47
        end
        inherited Label14: TLabel
          Left = 0
          Top = 69
          Width = 237
          ExplicitTop = 69
        end
      end
      inherited Panel4: TPanel
        ExplicitHeight = 130
        inherited nTeile: TLabel
          Left = 3
          Width = 56
        end
        inherited nPumpenteile: TLabel
          Left = 3
          Top = 25
          Width = 56
          ExplicitTop = 25
        end
        inherited nErsatzteile: TLabel
          Left = 3
          Top = 47
          Width = 56
          ExplicitTop = 47
        end
        inherited nPfk: TLabel
          Left = 3
          Top = 69
          Width = 56
          ExplicitTop = 69
        end
      end
    end
    inherited LieferantenPanel: TPanel
      Width = 1020
      ExplicitTop = 240
      ExplicitWidth = 1011
      inherited Panel1: TPanel
        ExplicitHeight = 157
        inherited Label6: TLabel
          Left = 0
          Width = 237
        end
        inherited Label7: TLabel
          Left = 0
          Top = 47
          Width = 237
          ExplicitTop = 47
        end
        inherited Label8: TLabel
          Top = 69
          Width = 237
          ExplicitTop = 69
        end
        inherited Label9: TLabel
          Left = 30
          Top = 91
          Width = 207
          ExplicitTop = 91
        end
        inherited Label10: TLabel
          Left = 0
          Top = 25
          Width = 237
          ExplicitTop = 25
        end
      end
      inherited Panel2: TPanel
        ExplicitHeight = 157
        inherited nLIeferanten: TLabel
          Left = 3
          Width = 56
        end
        inherited nLieferErsatzteile: TLabel
          Left = 3
          Top = 47
          Width = 56
          ExplicitTop = 47
        end
        inherited dummyLabel12: TLabel
          Left = 3
          Top = 69
          Width = 56
          ExplicitTop = 69
        end
        inherited nLieferStatusUnbekannt: TLabel
          Left = 3
          Top = 91
          Width = 56
          ExplicitTop = 91
        end
        inherited nLieferPumpenteile: TLabel
          Left = 3
          Top = 25
          Width = 56
          ExplicitTop = 25
        end
      end
    end
  end
  inline TeileStausKontrolleFrm: TTeileStatusKontrolleFrm
    Left = 0
    Top = 0
    Width = 1103
    Height = 610
    Align = alClient
    AutoSize = True
    TabOrder = 2
    Visible = False
    ExplicitWidth = 1094
    ExplicitHeight = 610
    inherited Panel1: TPanel
      Width = 1097
      ExplicitWidth = 1088
    end
    inherited Panel3: TPanel
      Width = 1097
      Height = 313
      ExplicitWidth = 1088
      ExplicitHeight = 313
      inherited TeileNrLabel: TLabel
        Left = 34
        Top = 6
        ExplicitLeft = 34
        ExplicitTop = 6
      end
      inherited BenennungLabel: TLabel
        Left = 181
        Top = 7
        ExplicitLeft = 181
        ExplicitTop = 7
      end
      inherited PfkLabel: TLabel
        Left = 461
        Top = 6
        ExplicitLeft = 461
        ExplicitTop = 6
      end
      inherited DBCtrlGrid1: TDBCtrlGrid
        Left = 22
        ExplicitLeft = 22
        inherited TeileNr: TDBText
          Left = 12
          Top = 7
          ExplicitLeft = 12
          ExplicitTop = 7
        end
        inherited TName1: TDBText
          Top = 7
          ExplicitTop = 7
        end
        inherited Pfk: TDBText
          Top = 7
          ExplicitLeft = 438
          ExplicitTop = 7
        end
      end
    end
    inherited Panel2: TPanel
      Top = 393
      Width = 1097
      Height = 200
      Align = alTop
      Anchors = [akLeft, akTop, akRight, akBottom]
      ExplicitTop = 393
      ExplicitWidth = 1088
      ExplicitHeight = 200
      inherited LKNameLabel: TLabel
        Left = 31
        Top = 1
        ExplicitLeft = 31
        ExplicitTop = 1
      end
      inherited LNameLabel: TLabel
        Left = 190
        Top = 1
        ExplicitLeft = 190
        ExplicitTop = 1
      end
      inherited StatusLabel: TLabel
        Left = 426
        Top = 1
        ExplicitLeft = 426
        ExplicitTop = 1
      end
      inherited LPfkLabel: TLabel
        Left = 518
        Top = 1
        ExplicitLeft = 518
        ExplicitTop = 1
      end
      inherited DBCtrlGrid2: TDBCtrlGrid
        Left = 23
        Top = 20
        Height = 132
        PanelHeight = 33
        RowCount = 4
        ExplicitLeft = 23
        ExplicitTop = 20
        ExplicitHeight = 132
      end
    end
  end
  inline LieferantenErklAnfordernFrm1: TLieferantenErklAnfordernFrm
    Left = -5
    Top = 0
    Width = 1099
    Height = 576
    HelpType = htKeyword
    HelpKeyword = 'Anforderung'
    ParentBackground = False
    ParentShowHint = False
    PopupMenu = LieferantenErklAnfordernFrm1.PopupMenu1
    ShowHint = True
    TabOrder = 3
    ExplicitLeft = -5
    ExplicitHeight = 576
    inherited Label20: TLabel
      Left = 15
      HelpType = htKeyword
      HelpKeyword = 'LieferantenStatus'
      ExplicitLeft = 15
    end
    inherited GroupBox1: TGroupBox
      Left = 10
      Top = 37
      ExplicitLeft = 10
      ExplicitTop = 37
      inherited AbgelaufenChkBox: TCheckBox
        Left = 748
        Top = 13
        ExplicitLeft = 748
        ExplicitTop = 13
      end
      inherited ohneAnfrageChkBox: TCheckBox
        Left = 838
        Top = 13
        ExplicitLeft = 838
        ExplicitTop = 13
      end
      inherited ErsatzTeileChkBox: TCheckBox
        Left = 641
        ExplicitLeft = 641
      end
      inherited RelevantChkBox: TCheckBox
        Left = 968
        Top = 13
        ExplicitLeft = 968
        ExplicitTop = 13
      end
      inherited NRelevantChkBox: TCheckBox
        Left = 968
        Top = 37
        ExplicitLeft = 968
        ExplicitTop = 37
      end
      inherited NohneAnfrageChkBox: TCheckBox
        Left = 838
        Top = 37
        ExplicitLeft = 838
        ExplicitTop = 37
      end
      inherited NAbgelaufenChkBox: TCheckBox
        Left = 748
        Top = 36
        ExplicitLeft = 748
        ExplicitTop = 36
      end
    end
    inherited GroupBox2: TGroupBox
      Left = 10
      ExplicitLeft = 10
      inherited DBGrid1: TDBGrid
        Columns = <
          item
            Expanded = False
            FieldName = 'LKurzname'
            Title.Caption = 'Kurzname'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'name1'
            Title.Caption = 'Name'
            Width = 220
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'gilt_bis'
            Width = 72
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'letzteAnfrage'
            Title.Caption = 'angefragt'
            Width = 72
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Stand'
            Width = 72
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'telefax'
            Width = 125
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'email'
            Width = 200
            Visible = True
          end>
      end
    end
    inherited GroupBox3: TGroupBox
      Left = 10
      ExplicitLeft = 10
      inherited Panel1b: TPanel
        Height = 120
        ExplicitHeight = 120
        inherited OrtDBText: TDBText
          Top = 72
          ExplicitTop = 77
        end
        inherited StrasseDBText: TDBText
          Top = 54
          ExplicitTop = 54
        end
      end
      inherited Panel1: TPanel
        Height = 120
        ExplicitHeight = 120
        inherited Label6: TLabel
          Margins.Left = 0
          Margins.Top = 3
        end
        inherited Label4: TLabel
          Margins.Left = 0
        end
        inherited ortlabel: TLabel
          Top = 72
          Margins.Left = 0
          ExplicitTop = 64
        end
        inherited Label5: TLabel
          Top = 54
          Margins.Left = 0
          ExplicitTop = 46
        end
        inherited dummy: TLabel
          Margins.Left = 0
          Margins.Top = 3
        end
        inherited staatlbl: TLabel
          ExplicitTop = 90
        end
      end
      inherited Panel2: TPanel
        inherited Label3: TLabel
          Top = 54
          ExplicitTop = 54
        end
        inherited Label7: TLabel
          Height = 18
          ExplicitLeft = 0
          ExplicitWidth = 112
          ExplicitHeight = 18
        end
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 610
    Width = 1103
    Height = 19
    Panels = <
      item
        Text = 'Hallo'
        Width = 270
      end
      item
        Width = 50
      end>
    ExplicitWidth = 1094
  end
  inline LeklStatusEingabeFrm: TLeklStatusFrm
    Left = -5
    Top = 8
    Width = 1099
    Height = 593
    HelpType = htKeyword
    HelpKeyword = 'LieferantenStatus'
    ParentBackground = False
    PopupMenu = LeklStatusEingabeFrm.PopupMenu1
    TabOrder = 5
    ExplicitLeft = -5
    ExplicitTop = 8
    inherited Label20: TLabel
      Left = 25
      Top = 11
      ExplicitLeft = 25
      ExplicitTop = 11
    end
    inherited GroupBox1: TGroupBox
      Left = 20
      ExplicitLeft = 20
      inherited NGeantwortetChkBox: TCheckBox
        Left = 661
        Width = 188
        Caption = 'noch keine Antwort erhalten'
        ExplicitLeft = 661
        ExplicitWidth = 188
      end
    end
    inherited GroupBox2: TGroupBox
      Left = 20
      ExplicitLeft = 20
      inherited DBGrid1: TDBGrid
        Columns = <
          item
            Expanded = False
            FieldName = 'LKurzname'
            Title.Caption = 'Kurzname'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'name1'
            Title.Caption = 'Name'
            Width = 220
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'letzteAnfrage'
            Title.Alignment = taCenter
            Title.Caption = 'angefragt'
            Width = 75
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Stand'
            Title.Alignment = taCenter
            Width = 75
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'StatusTxt'
            Title.Caption = 'Status'
            Width = 160
            Visible = True
          end>
      end
    end
    inherited GroupBox3: TGroupBox
      Left = 20
      Top = 385
      ExplicitLeft = 20
      ExplicitTop = 385
    end
  end
  object MainMenu1: TMainMenu
    Left = 488
    object DateiMen: TMenuItem
      Caption = 'Datei'
      object DateiMenEnde: TMenuItem
        Caption = 'Ende'
        OnClick = FormDestroy
      end
    end
    object UnippsMen: TMenuItem
      Caption = 'Import'
      object UnippsMenEinlesen: TMenuItem
        Caption = 'Einlesen'
        OnClick = UnippsMenEinlesenClick
      end
    end
    object LieferantenMen: TMenuItem
      Caption = 'Lieferanten'
      object LieferMenErklaerAnfordern: TMenuItem
        Caption = 'Erkl'#228'rungen anfordern/eingeben'
        OnClick = LieferMenErklaerAnfordernClick
      end
      object LieferMenStatuseingeben: TMenuItem
        Caption = 'Status pr'#252'fen/eingeben'
        OnClick = LieferMenStatuseingebenClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object LieferMenAdressen: TMenuItem
        Caption = 'Adressen aktualisieren'
        OnClick = LieferMenAdressenClick
      end
    end
    object TeileMen: TMenuItem
      Caption = 'Teile'
      object LTeileMenStatus: TMenuItem
        Caption = 'Status eingeben'
        OnClick = LTeileMenStatusClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object TeileMenUebersicht: TMenuItem
        Caption = 'Status pr'#252'fen'
        OnClick = TeileMenUebersichtClick
      end
    end
    object ExportMen: TMenuItem
      Caption = 'Export'
      object ExportMenErzeugen: TMenuItem
        Caption = 'Erzeugen'
        OnClick = ExportMenErzeugenClick
      end
    end
    object InfoMen: TMenuItem
      Caption = 'Info'
      object VersMen: TMenuItem
        Caption = 'Version'
        OnClick = VersMenClick
      end
      object Hilfe1: TMenuItem
        Caption = 'Hilfe'
        OnClick = Hilfe1Click
      end
    end
    object TestMen: TMenuItem
      Caption = 'Tests'
      object N300Tage1: TMenuItem
        Caption = '300 Tage'
        OnClick = N300Tage1Click
      end
      object N0Tage1: TMenuItem
        Caption = '0 Tage'
        OnClick = N0Tage1Click
      end
    end
  end
end
