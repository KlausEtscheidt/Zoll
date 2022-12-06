object mainForm: TmainForm
  Left = 0
  Top = 0
  Caption = 'DigiLek Digitale Lieferantenerkl'#228'rung'
  ClientHeight = 612
  ClientWidth = 1094
  Color = clGradientActiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesigned
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inline LieferantenErklAnfordernFrm1: TLieferantenErklAnfordernFrm
    Left = -5
    Top = 0
    Width = 1099
    Height = 576
    ParentBackground = False
    PopupMenu = LieferantenErklAnfordernFrm1.PopupMenu1
    TabOrder = 4
    ExplicitLeft = -5
    inherited GroupBox1: TGroupBox
      Left = 3
      Top = 37
      ExplicitLeft = 3
      ExplicitTop = 37
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
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'letzteAnfrage'
            Title.Caption = 'angefragt'
            Width = 70
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
  inline TeileStausKontrolleFrm: TTeileStatusKontrolleFrm
    Left = 0
    Top = 0
    Width = 1094
    Height = 593
    Align = alClient
    AutoSize = True
    TabOrder = 2
    Visible = False
    ExplicitWidth = 1094
    ExplicitHeight = 593
    inherited Panel1: TPanel
      Width = 1088
      ExplicitWidth = 1088
    end
    inherited Panel3: TPanel
      Width = 1088
      ExplicitWidth = 1088
      inherited DBCtrlGrid1: TDBCtrlGrid
        Left = 22
        Top = 7
        ExplicitLeft = 22
        ExplicitTop = 7
        inherited TeileNr: TDBText
          Left = 12
          Top = 7
          ExplicitLeft = 12
          ExplicitTop = 7
        end
      end
    end
    inherited Panel2: TPanel
      Top = 391
      Width = 1088
      Height = 199
      ExplicitTop = 391
      ExplicitWidth = 1088
      ExplicitHeight = 199
      inherited DBCtrlGrid2: TDBCtrlGrid
        Left = 23
        Top = 33
        Height = 91
        ExplicitLeft = 23
        ExplicitTop = 33
        ExplicitHeight = 91
      end
    end
  end
  inline LieferantenStatusFrm1: TLieferantenStatusFrm
    Left = 0
    Top = 0
    Width = 1094
    Height = 593
    Align = alClient
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 1094
    ExplicitHeight = 593
    inherited GroupBox1: TGroupBox
      Width = 828
      ExplicitWidth = 828
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
        Left = 514
        Top = 18
        ExplicitLeft = 514
        ExplicitTop = 18
      end
      inherited UnbearbeiteteCheckBox: TCheckBox
        Left = 653
        Top = 18
        Width = 140
        ExplicitLeft = 653
        ExplicitTop = 18
        ExplicitWidth = 140
      end
    end
    inherited GroupBox2: TGroupBox
      Width = 828
      Height = 263
      ExplicitWidth = 828
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
      Width = 828
      ExplicitWidth = 828
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
  object StatusBar1: TStatusBar
    Left = 0
    Top = 593
    Width = 1094
    Height = 19
    Panels = <
      item
        Text = 'Hallo'
        Width = 270
      end
      item
        Width = 50
      end>
  end
  inline ExportFrm1: TGesamtStatusFrm
    Left = 0
    Top = 0
    Width = 1094
    Height = 593
    Align = alClient
    AutoSize = True
    TabOrder = 1
    Visible = False
    ExplicitWidth = 1094
    ExplicitHeight = 593
    inherited Label1: TLabel
      Width = 1041
    end
    inherited Label2: TLabel
      Width = 1041
    end
    inherited TeilePanel: TPanel
      Width = 1011
      ExplicitWidth = 1011
      inherited Panel5: TPanel
        inherited Label3: TLabel
          Left = 0
          Width = 237
        end
        inherited Label4: TLabel
          Left = 0
          Width = 237
        end
        inherited Label5: TLabel
          Left = 0
          Width = 237
        end
        inherited Label14: TLabel
          Left = 0
          Width = 237
        end
      end
      inherited Panel4: TPanel
        inherited nTeile: TLabel
          Left = 3
          Width = 56
        end
        inherited nPumpenteile: TLabel
          Left = 3
          Width = 56
        end
        inherited nErsatzteile: TLabel
          Left = 3
          Width = 56
        end
        inherited nPfk: TLabel
          Left = 3
          Width = 56
        end
      end
    end
    inherited LieferantenPanel: TPanel
      Width = 1011
      ExplicitWidth = 1011
      inherited Panel1: TPanel
        inherited Label6: TLabel
          Left = 0
          Width = 237
        end
        inherited Label7: TLabel
          Left = 0
          Width = 237
        end
        inherited Label8: TLabel
          Width = 237
        end
        inherited Label9: TLabel
          Left = 30
          Width = 207
        end
        inherited Label10: TLabel
          Left = 0
          Width = 237
        end
      end
      inherited Panel2: TPanel
        inherited nLIeferanten: TLabel
          Left = 3
          Width = 56
        end
        inherited nLieferErsatzteile: TLabel
          Left = 3
          Width = 56
        end
        inherited dummyLabel12: TLabel
          Left = 3
          Width = 56
        end
        inherited nLieferStatusUnbekannt: TLabel
          Left = 3
          Width = 56
        end
        inherited nLieferPumpenteile: TLabel
          Left = 3
          Width = 56
        end
      end
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
  end
end
