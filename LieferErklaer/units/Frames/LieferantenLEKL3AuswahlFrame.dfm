object LieferantenStatusFrm: TLieferantenStatusFrm
  Left = 0
  Top = 0
  Width = 1099
  Height = 569
  HelpType = htKeyword
  HelpKeyword = 'Lieferantenauswahl'
  ParentBackground = False
  ParentShowHint = False
  ShowHint = True
  TabOrder = 0
  object Label11: TLabel
    Left = 5
    Top = 12
    Width = 341
    Height = 19
    Caption = 'Teilespez. Lieferantenerkl'#228'rung eingeben'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object GroupBox1: TGroupBox
    Left = 5
    Top = 44
    Width = 1036
    Height = 72
    Caption = 'Filter'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label2: TLabel
      Left = 46
      Top = 18
      Width = 63
      Height = 16
      Caption = 'Kurz-Name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 254
      Top = 18
      Width = 33
      Height = 16
      Caption = 'Name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object FilterKurzname: TEdit
      Left = 115
      Top = 14
      Width = 121
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnChange = FilterUpdateActionExecute
    end
    object FilterName: TEdit
      Left = 293
      Top = 14
      Width = 172
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnChange = FilterUpdateActionExecute
    end
    object FilterAusBtn: TButton
      Left = 487
      Top = 16
      Width = 25
      Height = 25
      Hint = 'Filter Kurz-Name und Name leeren'
      DisabledImageIndex = 0
      HotImageIndex = 0
      ImageAlignment = iaCenter
      ImageIndex = 0
      Images = ImageList1
      PressedImageIndex = 0
      SelectedImageIndex = 0
      StylusHotImageIndex = 0
      TabOrder = 2
      OnClick = FilterAusBtnClick
    end
    object LeklUpdatedChkBox: TCheckBox
      Left = 671
      Top = 14
      Width = 114
      Height = 25
      Action = FilterUpdateAction
      Caption = 'nur aktuelle LEKL'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 3
    end
    object UnbearbeiteteCheckBox: TCheckBox
      Left = 808
      Top = 14
      Width = 130
      Height = 25
      TabStop = False
      Action = FilterUpdateAction
      Caption = 'nur unbearbeitete'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 4
    end
    object NLeklUpdatedChkBox: TCheckBox
      Left = 671
      Top = 38
      Width = 114
      Height = 25
      Action = FilterUpdateAction
      Caption = 'nur alte LEKL'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
    end
    object NUnbearbeiteteCheckBox: TCheckBox
      Left = 807
      Top = 38
      Width = 130
      Height = 25
      Action = FilterUpdateAction
      Caption = 'nur bearbeitete'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
    end
    object StandardFilterButton: TButton
      Left = 538
      Top = 18
      Width = 106
      Height = 25
      Hint = 'Mit diesem Filter sollten Teile gepflegt werden'
      Caption = 'Standard Filter'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClick = StandardFilterButtonClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 5
    Top = 122
    Width = 1036
    Height = 231
    Caption = 'gefiltert'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 62
      Top = 29
      Width = 760
      Height = 188
      DataSource = DataSource1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -15
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
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
          Title.Caption = 'Name'
          Width = 220
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'gilt_bis'
          Width = 70
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'Stand'
          Title.Caption = 'Stand Lekl'
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
  object GroupBox3: TGroupBox
    Left = 5
    Top = 398
    Width = 1036
    Height = 144
    Caption = 'gew'#228'hlt'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object Label8: TLabel
      Left = 392
      Top = 28
      Width = 132
      Height = 14
      Caption = 'Lieferantenerkl'#228'rung:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label10: TLabel
      Left = 655
      Top = 39
      Width = 127
      Height = 14
      Caption = 'Teile-Status pflegen:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LKurznameTxt: TDBText
      Left = 140
      Top = 3
      Width = 130
      Height = 17
      DataField = 'LKurzname'
      DataSource = DataSource1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object IDLieferantTxt: TDBText
      Left = 76
      Top = 3
      Width = 49
      Height = 17
      DataField = 'IdLieferant'
      DataSource = DataSource1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object TeileBtn: TButton
      Left = 688
      Top = 59
      Width = 73
      Height = 25
      Hint = 'Pr'#228'ferenz f'#252'r einzelne Teile eingeben'
      Caption = 'Teile'
      TabOrder = 0
      OnClick = TeileBtnClick
    end
    object Panel1: TPanel
      Left = 392
      Top = 48
      Width = 122
      Height = 89
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      object Label3: TLabel
        Left = 0
        Top = 0
        Width = 122
        Height = 18
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'gilt bis:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = 1
        ExplicitTop = 15
        ExplicitWidth = 119
      end
      object Label7: TLabel
        Left = 0
        Top = 18
        Width = 122
        Height = 18
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Stand Lekl:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = 1
        ExplicitTop = 29
        ExplicitWidth = 119
      end
      object Label4: TLabel
        Left = 0
        Top = 36
        Width = 122
        Height = 18
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Stand Teile:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = 1
        ExplicitTop = 43
        ExplicitWidth = 119
      end
    end
    object Panel2: TPanel
      Left = 520
      Top = 48
      Width = 89
      Height = 89
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 2
      object giltBisDBText: TDBText
        Left = 0
        Top = 0
        Width = 89
        Height = 18
        Align = alTop
        DataField = 'gilt_bis'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = 1
        ExplicitTop = 21
        ExplicitWidth = 183
      end
      object DatumStatusDBText: TDBText
        Left = 0
        Top = 18
        Width = 89
        Height = 18
        Align = alTop
        DataField = 'Stand'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = 1
        ExplicitTop = 41
        ExplicitWidth = 183
      end
      object DatumTeileDBText: TDBText
        Left = 0
        Top = 36
        Width = 89
        Height = 18
        Align = alTop
        DataField = 'StandTeile'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = 1
        ExplicitTop = 61
        ExplicitWidth = 183
      end
    end
    object Panel3: TPanel
      Left = 16
      Top = 26
      Width = 325
      Height = 81
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 3
      object Label6: TLabel
        AlignWithMargins = True
        Left = 0
        Top = 3
        Width = 325
        Height = 14
        Margins.Left = 0
        Margins.Right = 0
        Align = alTop
        Caption = 'Name:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 35
      end
      object DBText1: TDBText
        AlignWithMargins = True
        Left = 5
        Top = 21
        Width = 320
        Height = 18
        Margins.Left = 5
        Margins.Top = 1
        Margins.Right = 0
        Margins.Bottom = 1
        Align = alTop
        DataField = 'LName1'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = -5
        ExplicitTop = 13
        ExplicitWidth = 271
      end
      object DBText2: TDBText
        AlignWithMargins = True
        Left = 5
        Top = 41
        Width = 320
        Height = 18
        Margins.Left = 5
        Margins.Top = 1
        Margins.Right = 0
        Margins.Bottom = 1
        Align = alTop
        DataField = 'LName2'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = 0
        ExplicitTop = 36
        ExplicitWidth = 263
      end
    end
  end
  object DataSource1: TDataSource
    Left = 640
    Top = 200
  end
  object ImageList1: TImageList
    Left = 368
    Top = 272
    Bitmap = {
      494C010102000800040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      000000000000090909004B4B4B00484848000404040000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      000000000000090909004B4B4B00484848000404040000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      0000000000004F4F4F00E1E1E100ADADAD002020200000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000004F4F4F00E1E1E100ADADAD002020200000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00000000004B4B4B00FAFAFA008B8B8B001F1F1F00000000000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000004B4B4B00FAFAFA008B8B8B001F1F1F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF004B4B4B00EDEDED007C7C7C001F1F1F000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000004B4B4B00EDEDED007C7C7C001F1F1F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF00D9D9D900838383000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000047474700D9D9D900838383002525250000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000033333300AAAAAA00E7E7E700999999005C5C5C001C1C1C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF00202020000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000AFAFAF00FCFCFC00E5E5E500ACACAC008C8C8C0052525200202020000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000040404003636
      3600F3F3F3000000FF000000FF000000FF000000FF00808080005C5C5C002525
      2500000000000000000000000000000000000000000000000000040404003636
      3600F3F3F300EAEAEA00C0C0C0009D9D9D009D9D9D00808080005C5C5C002525
      2500000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000010101000A0A0A002D2D2D007777
      77000000FF000000FF000000FF000000FF000000FF000000FF007D7D7D005353
      530008080800010101000000000000000000010101000A0A0A002D2D2D007777
      77006E6E6E00666666006A6A6A0073737300828282008D8D8D007D7D7D005353
      5300080808000101010000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000151515003E3E3E006E6E6E008080
      80000000FF000000FF000000FF000000FF000000FF000000FF000000FF008888
      880036363600131313000000000000000000151515003E3E3E006E6E6E008080
      8000909090009C9C9C00AAAAAA00BEBEBE00D3D3D300DADADA00B5B5B5008888
      8800363636001313130000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000065656500A7A7A7000000FF000000
      FF000000FF00A8A8A800B8B8B800D1D1D100E8E8E8000000FF000000FF000000
      FF00A8A8A80058585800000000000000000065656500A7A7A700A6A6A6009797
      9700A3A3A300A8A8A800B8B8B800D1D1D100E8E8E800FAFAFA00EAEAEA00D4D4
      D400A8A8A8005858580000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000474747000000FF000000FF000000
      FF00A6A6A600A7A7A700B2B2B200CBCBCB00E2E2E200F7F7F7000000FF000000
      FF000000FF00424242000000000000000000474747007D7D7D00A0A0A0009999
      9900A6A6A600A7A7A700B2B2B200CBCBCB00E2E2E200F7F7F700F6F6F600DDDD
      DD007B7B7B004242420000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00A5A5A500ADADAD00B3B3B300CCCCCC00E2E2E200EFEFEF00D9D9D9000000
      FF000000FF000000FF0000000000000000000F0F0F0037373700666666007575
      7500A5A5A500ADADAD00B3B3B300CCCCCC00E2E2E200EFEFEF00D9D9D9009C9C
      9C00373737000E0E0E0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF002B2B
      2B00606060006666660068686800767676008282820087878700757575003B3B
      3B000000FF000000FF000000FF000000000001010100050505000F0F0F002B2B
      2B00606060006666660068686800767676008282820087878700757575003B3B
      3B00050505000101010000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF000000007FFFFFFF00000000
      3873F87F000000001871F87F000000008847F87F00000000C00FF87F00000000
      E00FF87F00000000F01FF03F00000000F01FF01F00000000C00FC00F00000000
      0003000300000000000300030000000000030003000000000003000300000000
      0003000300000000000100030000000000000000000000000000000000000000
      000000000000}
  end
  object ActionList1: TActionList
    Left = 688
    Top = 264
    object FilterUpdateAction: TAction
      Category = 'Filter'
      Caption = 'FilterUpdate'
      OnExecute = FilterUpdateActionExecute
      OnUpdate = FilterUpdateActionUpdate
    end
  end
end
