object mainForm: TmainForm
  Left = 0
  Top = 0
  Caption = 'mainForm'
  ClientHeight = 612
  ClientWidth = 847
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
  DesignSize = (
    847
    612)
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 593
    Width = 847
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
  inline LieferantenStatusFrm1: TLieferantenStatusFrm
    Left = 0
    Top = 0
    Width = 769
    Height = 569
    ParentBackground = False
    TabOrder = 1
    inherited GroupBox2: TGroupBox
      Width = 758
      ExplicitWidth = 758
    end
  end
  inline LieferantenErklaerungenFrm1: TLieferantenErklaerungenFrm
    Left = 0
    Top = 0
    Width = 719
    Height = 587
    TabOrder = 2
    Visible = False
    ExplicitHeight = 587
    inherited Label1: TLabel
      Top = 20
      ExplicitTop = 20
    end
    inherited LKurznameLbl: TLabel
      Top = 25
      ExplicitTop = 25
    end
    inherited IdLieferantLbl: TLabel
      Top = 25
      ExplicitTop = 25
    end
    inherited LabelSort: TLabel
      Left = 17
      Top = 50
      ExplicitLeft = 17
      ExplicitTop = 50
    end
    inherited LabelFiltern: TLabel
      Left = 17
      Top = 103
      ExplicitLeft = 17
      ExplicitTop = 103
    end
    inherited DBCtrlGrid1: TDBCtrlGrid
      Top = 184
      Height = 350
      PanelHeight = 43
      ExplicitTop = 184
      ExplicitHeight = 350
    end
    inherited BackBtn: TButton
      Left = 273
      Top = 555
      Height = 29
      OnClick = LieferantenErklaerungenFrm1Button1Click
      ExplicitLeft = 273
      ExplicitTop = 555
      ExplicitHeight = 29
    end
    inherited SortLTeileNrBtn: TButton
      Top = 72
      ExplicitTop = 72
    end
    inherited SortTeilenrBtn: TButton
      Left = 26
      Top = 72
      ExplicitLeft = 26
      ExplicitTop = 72
    end
    inherited SortLTNameBtn: TButton
      Top = 72
      ExplicitTop = 72
    end
    inherited FilterTeileNr: TEdit
      Left = 25
      Top = 124
      ExplicitLeft = 25
      ExplicitTop = 124
    end
    inherited FilterTName1: TEdit
      Left = 176
      Top = 124
      ExplicitLeft = 176
      ExplicitTop = 124
    end
    inherited FilterLTeileNr: TEdit
      Left = 375
      Top = 124
      Width = 106
      ExplicitLeft = 375
      ExplicitTop = 124
      ExplicitWidth = 106
    end
    inherited FilterTName2: TEdit
      Left = 176
      Top = 151
      ExplicitLeft = 176
      ExplicitTop = 151
    end
    inherited FilterOffBtn: TButton
      Left = 506
      Top = 120
      ExplicitLeft = 506
      ExplicitTop = 120
    end
  end
  inline GesamtStatusFrm1: TGesamtStatusFrm
    Left = 8
    Top = 8
    Width = 265
    Height = 207
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = True
    TabOrder = 3
    Visible = False
    ExplicitLeft = 8
    ExplicitTop = 8
    inherited Label1: TLabel
      Left = 0
      Top = 0
      ExplicitLeft = 0
      ExplicitTop = 0
    end
    inherited nTeile: TLabel
      Width = 28
      ExplicitWidth = 28
    end
  end
  inline TeileFrm1: TTeileFrm
    Left = 56
    Top = 37
    Width = 320
    Height = 240
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = True
    TabOrder = 4
    Visible = False
    ExplicitLeft = 56
    ExplicitTop = 37
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
    object LieferantenMen: TMenuItem
      Caption = 'Lieferanten'
      object LMenStatus: TMenuItem
        Caption = 'Status'
        OnClick = LMenStatusClick
      end
    end
    object UnippsMen: TMenuItem
      Caption = 'Unipps'
      object UnippsMenEinlesen: TMenuItem
        Caption = 'Einlesen'
        OnClick = UnippsMenEinlesenClick
      end
      object UnippsMenAuswerten: TMenuItem
        Caption = 'Auswerten'
        OnClick = UnippsMenAuswertenClick
      end
    end
    object TeileMen: TMenuItem
      Caption = 'Teile'
      object TeileMenUebersicht: TMenuItem
        Caption = #220'bersicht'
        OnClick = TeileMenUebersichtClick
      end
    end
    object StatusMen: TMenuItem
      Caption = 'Status'
      object StatusMenAnzeigen: TMenuItem
        Caption = 'Anzeigen'
        OnClick = StatusMenAnzeigenClick
      end
    end
  end
end
