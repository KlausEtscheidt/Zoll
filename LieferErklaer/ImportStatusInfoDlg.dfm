object ImportStatusDlg: TImportStatusDlg
  Left = 200
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Import'
  ClientHeight = 337
  ClientWidth = 430
  Color = clGradientActiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  DesignSize = (
    430
    337)
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 13
    Top = 19
    Width = 403
    Height = 202
    Alignment = taCenter
    Anchors = []
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clGradientActiveCaption
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      ' Der Import-Vorgang dauert ca 5 Minuten!'
      ''
      ' Er sollte und muss genau EINMAL im Jahr,'
      ' zu Beginn der Eingabe'
      'der Lieferantenerkl'#228'rungen ausgef'#252'hrt werden.'
      ''
      ' Wollen Sie jetzt Daten aus UNIPPS einlesen ?')
    ParentFont = False
    TabOrder = 0
    StyleElements = [seFont, seClient]
    ExplicitLeft = 42
  end
  object GridPanel1: TGridPanel
    AlignWithMargins = True
    Left = 0
    Top = 280
    Width = 430
    Height = 60
    Anchors = [akLeft]
    ColumnCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    Constraints.MaxHeight = 80
    Constraints.MinHeight = 60
    ControlCollection = <
      item
        Column = 0
        Control = ImportBtn
        Row = 0
      end
      item
        Column = 1
        Control = ESCButton
        Row = 0
      end>
    RowCollection = <
      item
        SizeStyle = ssAuto
        Value = 60.000000000000000000
      end>
    TabOrder = 1
    object ImportBtn: TButton
      AlignWithMargins = True
      Left = 130
      Top = 16
      Width = 75
      Height = 25
      Margins.Top = 15
      Margins.Right = 10
      Align = alRight
      Caption = 'Einlesen'
      Constraints.MaxHeight = 25
      Constraints.MaxWidth = 75
      TabOrder = 0
      OnClick = ImportBtnClick
      ExplicitLeft = 273
      ExplicitTop = 18
    end
    object ESCButton: TButton
      AlignWithMargins = True
      Left = 225
      Top = 16
      Width = 75
      Height = 25
      Margins.Left = 10
      Margins.Top = 15
      Align = alLeft
      Caption = 'Abbruch'
      Constraints.MaxHeight = 25
      Constraints.MaxWidth = 75
      TabOrder = 1
      OnClick = ESCButtonClick
      ExplicitLeft = 369
      ExplicitTop = 18
    end
  end
  object StatusPanel: TPanel
    Left = 0
    Top = 0
    Width = 430
    Height = 278
    BevelOuter = bvNone
    TabOrder = 2
    object Label1: TLabel
      Left = 24
      Top = 240
      Width = 32
      Height = 13
      Caption = 'Label1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object StringGrid1: TStringGrid
      Left = 24
      Top = 13
      Width = 363
      Height = 221
      ColCount = 3
      FixedCols = 0
      RowCount = 8
      FixedRows = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      GridLineWidth = 0
      Options = [goVertLine, goHorzLine]
      ParentFont = False
      ScrollBars = ssNone
      TabOrder = 0
    end
  end
end
