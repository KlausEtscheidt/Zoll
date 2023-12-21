object ImportStatusDlg: TImportStatusDlg
  Left = 200
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Import'
  ClientHeight = 358
  ClientWidth = 433
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
    433
    358)
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    AlignWithMargins = True
    Left = 0
    Top = 50
    Width = 430
    Height = 202
    Alignment = taCenter
    Anchors = [akLeft, akRight]
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
    ReadOnly = True
    TabOrder = 0
    StyleElements = [seFont, seClient]
  end
  object StatusPanel: TPanel
    Left = 0
    Top = 0
    Width = 430
    Height = 297
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    DesignSize = (
      430
      297)
    object StringGrid1: TStringGrid
      Left = 24
      Top = 13
      Width = 363
      Height = 244
      ColCount = 3
      FixedCols = 0
      RowCount = 9
      FixedRows = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      GridLineWidth = 0
      Options = [goVertLine, goHorzLine]
      ParentColor = True
      ParentFont = False
      ScrollBars = ssNone
      TabOrder = 0
    end
    object Panel1: TPanel
      Left = 0
      Top = 263
      Width = 430
      Height = 33
      Anchors = [akLeft, akRight, akBottom]
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      ExplicitTop = 244
      object actRecordLbl: TLabel
        Left = 20
        Top = 17
        Width = 88
        Height = 13
        Caption = 'Fortschrittsanzeige'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
    end
  end
  object ImportBtn: TButton
    AlignWithMargins = True
    Left = 120
    Top = 316
    Width = 75
    Height = 25
    Margins.Top = 4
    Margins.Right = 10
    Margins.Bottom = 4
    Caption = 'Einlesen'
    Constraints.MaxHeight = 25
    Constraints.MaxWidth = 75
    Constraints.MinHeight = 25
    TabOrder = 2
    OnClick = ImportBtnClick
  end
  object ESCButton: TButton
    AlignWithMargins = True
    Left = 215
    Top = 316
    Width = 75
    Height = 25
    Margins.Left = 10
    Margins.Top = 4
    Margins.Bottom = 4
    Caption = 'Abbruch'
    Constraints.MaxHeight = 25
    Constraints.MaxWidth = 75
    Constraints.MinHeight = 25
    TabOrder = 3
    OnClick = ESCButtonClick
  end
end
