object ImportFrm: TImportFrm
  Left = 0
  Top = 0
  Width = 621
  Height = 355
  TabOrder = 0
  object GridPanel1: TGridPanel
    Left = 0
    Top = 0
    Width = 621
    Height = 355
    Align = alClient
    ColumnCollection = <
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = ImportBtn
        Row = 1
      end
      item
        Column = 0
        Control = Memo1
        Row = 0
      end>
    RowCollection = <
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 60.000000000000000000
      end
      item
        SizeStyle = ssAuto
      end>
    TabOrder = 0
    ExplicitLeft = 114
    ExplicitTop = 136
    ExplicitWidth = 185
    ExplicitHeight = 105
    DesignSize = (
      621
      355)
    object ImportBtn: TButton
      Left = 273
      Top = 311
      Width = 75
      Height = 25
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'Einlesen'
      Constraints.MaxHeight = 25
      Constraints.MaxWidth = 75
      TabOrder = 0
      OnClick = ImportBtnClick
    end
    object Memo1: TMemo
      Left = 109
      Top = 46
      Width = 403
      Height = 202
      Anchors = []
      Lines.Strings = (
        ' Der Import-Vorgang dauert ca 5 Minuten!'
        ''
        ' Er sollte und muss genau EINMAL im Jahr,'
        
          ' zu Beginn der Eingabe der Lieferantenerkl'#228'rungen ausgef'#252'hrt wer' +
          'den.'
        ''
        ' Wollen Sie jetzt Daten aus UNIPPS einlesen ?')
      TabOrder = 1
      ExplicitLeft = 0
      ExplicitTop = 103
    end
  end
end
