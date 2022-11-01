object GesamtStatusFrm: TGesamtStatusFrm
  Left = 0
  Top = 0
  Width = 727
  Height = 383
  TabOrder = 0
  object Label1: TLabel
    Left = 3
    Top = 3
    Width = 47
    Height = 19
    Caption = 'Teile:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 3
    Top = 107
    Width = 100
    Height = 19
    Caption = 'Lieferanten:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 48
    Top = 40
    Width = 47
    Height = 13
    Caption = 'ingesamt:'
  end
  object nTeile: TLabel
    Left = 192
    Top = 40
    Width = 65
    Height = 13
    Caption = 'nTeile'
  end
  object Label4: TLabel
    Left = 48
    Top = 59
    Width = 95
    Height = 13
    Caption = 'davon Pumpenteile:'
  end
  object nPumpenteile: TLabel
    Left = 192
    Top = 59
    Width = 49
    Height = 13
    Caption = 'xx'
  end
  object Label5: TLabel
    Left = 48
    Top = 78
    Width = 133
    Height = 13
    Caption = 'davon pr'#228'ferenzberechtigt:'
  end
  object nPfk: TLabel
    Left = 192
    Top = 78
    Width = 49
    Height = 13
    Caption = 'xx'
  end
  object Label6: TLabel
    Left = 48
    Top = 140
    Width = 47
    Height = 13
    Caption = 'ingesamt:'
  end
  object nLieferanten: TLabel
    Left = 216
    Top = 140
    Width = 49
    Height = 13
    Caption = 'xx'
  end
  object Label7: TLabel
    Left = 48
    Top = 159
    Width = 112
    Height = 13
    Caption = 'davon f'#252'r Pumpenteile:'
  end
  object nLieferPumpenteile: TLabel
    Left = 216
    Top = 159
    Width = 41
    Height = 13
    Caption = 'xx'
  end
  object Label8: TLabel
    Left = 48
    Top = 178
    Width = 149
    Height = 13
    Caption = 'davon mit unbekanntem Status'
  end
  object Label9: TLabel
    Left = 71
    Top = 194
    Width = 126
    Height = 13
    Caption = 'bzgl Lieferantenerkl'#228'rung:'
  end
  object nLieferStatusUnbekannt: TLabel
    Left = 216
    Top = 194
    Width = 33
    Height = 13
    Caption = 'xx'
  end
end
