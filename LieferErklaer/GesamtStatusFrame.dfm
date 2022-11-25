object GesamtStatusFrm: TGesamtStatusFrm
  Left = 0
  Top = 0
  Width = 781
  Height = 535
  TabOrder = 0
  object Label1: TLabel
    Left = 35
    Top = 27
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
    Left = 35
    Top = 131
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
    Left = 80
    Top = 64
    Width = 47
    Height = 13
    Caption = 'ingesamt:'
  end
  object nTeile: TLabel
    Left = 224
    Top = 64
    Width = 28
    Height = 13
    Caption = 'nTeile'
  end
  object Label4: TLabel
    Left = 80
    Top = 83
    Width = 95
    Height = 13
    Caption = 'davon Pumpenteile:'
  end
  object nPumpenteile: TLabel
    Left = 224
    Top = 83
    Width = 12
    Height = 13
    Caption = 'xx'
  end
  object Label5: TLabel
    Left = 80
    Top = 102
    Width = 133
    Height = 13
    Caption = 'davon pr'#228'ferenzberechtigt:'
  end
  object nPfk: TLabel
    Left = 224
    Top = 102
    Width = 12
    Height = 13
    Caption = 'xx'
  end
  object Label6: TLabel
    Left = 80
    Top = 164
    Width = 47
    Height = 13
    Caption = 'ingesamt:'
  end
  object nLieferanten: TLabel
    Left = 248
    Top = 164
    Width = 12
    Height = 13
    Caption = 'xx'
  end
  object Label7: TLabel
    Left = 80
    Top = 183
    Width = 112
    Height = 13
    Caption = 'davon f'#252'r Pumpenteile:'
  end
  object nLieferPumpenteile: TLabel
    Left = 248
    Top = 183
    Width = 12
    Height = 13
    Caption = 'xx'
  end
  object Label8: TLabel
    Left = 80
    Top = 202
    Width = 149
    Height = 13
    Caption = 'davon mit unbekanntem Status'
  end
  object Label9: TLabel
    Left = 103
    Top = 218
    Width = 126
    Height = 13
    Caption = 'bzgl Lieferantenerkl'#228'rung:'
  end
  object nLieferStatusUnbekannt: TLabel
    Left = 248
    Top = 218
    Width = 12
    Height = 13
    Caption = 'xx'
  end
end
