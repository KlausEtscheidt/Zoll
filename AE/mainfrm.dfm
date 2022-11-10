object mainform: Tmainform
  Left = 0
  Top = 0
  Caption = 'Auftragseingang'
  ClientHeight = 415
  ClientWidth = 590
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 138
    Height = 18
    Caption = 'Auswertungsumfang:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 24
    Top = 120
    Width = 144
    Height = 18
    Caption = 'Auswertungszeitraum:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object MonatLabel: TLabel
    Left = 40
    Top = 155
    Width = 34
    Height = 13
    Caption = 'Monat:'
  end
  object Label4: TLabel
    Left = 128
    Top = 155
    Width = 25
    Height = 13
    Caption = 'Jahr:'
  end
  object Label5: TLabel
    Left = 24
    Top = 264
    Width = 118
    Height = 18
    Caption = 'Auftragseing'#228'nge:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 39
    Top = 298
    Width = 35
    Height = 16
    Caption = 'Ersatz'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 64
    Top = 320
    Width = 35
    Height = 16
    Caption = 'Inland'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label8: TLabel
    Left = 64
    Top = 342
    Width = 65
    Height = 16
    Caption = 'EU-Ausland'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label9: TLabel
    Left = 64
    Top = 364
    Width = 79
    Height = 16
    Caption = 'Ausland sonst'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object InlandLabel: TLabel
    Left = 184
    Top = 320
    Width = 71
    Height = 16
    Alignment = taRightJustify
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object EUAuslandLabel: TLabel
    Left = 184
    Top = 342
    Width = 71
    Height = 16
    Alignment = taRightJustify
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object NEUAuslandLabel: TLabel
    Left = 184
    Top = 364
    Width = 71
    Height = 16
    Alignment = taRightJustify
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object JahrRBtn: TRadioButton
    Left = 64
    Top = 80
    Width = 113
    Height = 17
    Caption = 'Jahr'
    TabOrder = 0
    OnClick = JahrRBtnClick
  end
  object MonatRBtn: TRadioButton
    Left = 64
    Top = 48
    Width = 113
    Height = 17
    Caption = 'Monat'
    Checked = True
    TabOrder = 1
    TabStop = True
    OnClick = MonatRBtnClick
  end
  object MonatEdit: TEdit
    Left = 88
    Top = 152
    Width = 25
    Height = 21
    Alignment = taCenter
    TabOrder = 2
    Text = '10'
    OnChange = MonatEditChange
    OnExit = MonatEditExit
    OnMouseLeave = MonatEditMouseLeave
  end
  object JahrEdit: TEdit
    Left = 176
    Top = 152
    Width = 49
    Height = 21
    Alignment = taCenter
    TabOrder = 3
    Text = '2000'
    OnChange = JahrEditChange
    OnExit = JahrEditExit
    OnMouseLeave = JahrEditMouseLeave
  end
  object AuswertenBtn: TButton
    Left = 184
    Top = 224
    Width = 75
    Height = 25
    Caption = 'Auswerten'
    TabOrder = 4
    OnClick = AuswertenBtnClick
  end
  object EndeBtn: TButton
    Left = 336
    Top = 224
    Width = 75
    Height = 25
    Caption = 'Ende'
    TabOrder = 5
    OnClick = EndeBtnClick
  end
  object MainMenu1: TMainMenu
    Left = 352
    Top = 24
    object DateiMen: TMenuItem
      Caption = 'Datei'
      object EndeMen: TMenuItem
        Caption = 'Ende'
        OnClick = EndeMenClick
      end
    end
  end
end
