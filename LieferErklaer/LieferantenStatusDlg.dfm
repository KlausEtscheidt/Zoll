object LieferantenStatusDialog: TLieferantenStatusDialog
  Left = 0
  Top = 0
  Caption = 'Lieferanten-Status'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 144
    Width = 60
    Height = 18
    Caption = 'g'#252'ltig bis:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 24
    Top = 16
    Width = 208
    Height = 18
    Caption = 'Status der Lieferantenerkl'#228'rung:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object alterStatus: TLabel
    Left = 64
    Top = 48
    Width = 31
    Height = 13
    Caption = 'Label3'
  end
  object OKBtn: TButton
    Left = 128
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Speichern'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object ESCBtn: TButton
    Left = 288
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Abbruch'
    ModalResult = 2
    TabOrder = 1
  end
  object DateTimePicker1: TDateTimePicker
    Left = 104
    Top = 176
    Width = 186
    Height = 21
    Date = 44858.000000000000000000
    Time = 0.733019178238464500
    ShowCheckbox = True
    TabOrder = 2
  end
  object StatusListBox: TDBLookupListBox
    Left = 224
    Top = 40
    Width = 273
    Height = 56
    KeyField = 'Id'
    ListField = 'StatusTxt'
    ListFieldIndex = 2
    ListSource = DataSource1
    TabOrder = 3
    OnClick = StatusListBoxClick
  end
  object DataSource1: TDataSource
    Left = 536
    Top = 56
  end
end
