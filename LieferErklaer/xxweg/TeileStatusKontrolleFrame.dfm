object TeileStatusKontrolleFrm: TTeileStatusKontrolleFrm
  Left = 0
  Top = 0
  Width = 774
  Height = 537
  TabOrder = 0
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 768
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object LabelFiltern: TLabel
      Left = 18
      Top = 16
      Width = 41
      Height = 16
      Caption = 'Filtern:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object FilterTName1: TEdit
      Left = 173
      Top = 38
      Width = 113
      Height = 21
      TabOrder = 0
      OnChange = FilterTName1Change
    end
    object FilterTeileNr: TEdit
      Left = 22
      Top = 38
      Width = 121
      Height = 21
      TabOrder = 1
      OnChange = FilterTeileNrChange
    end
    object FilterOffBtn: TButton
      Left = 311
      Top = 36
      Width = 25
      Height = 25
      DisabledImageIndex = 0
      HotImageIndex = 0
      ImageIndex = 0
      ImageMargins.Left = 2
      ImageMargins.Top = 2
      Images = ImageList1
      TabOrder = 2
      OnClick = FilterOffBtnClick
    end
    object PfkOnCheckBox: TCheckBox
      Left = 352
      Top = 40
      Width = 49
      Height = 17
      Caption = 'Pfk 1'
      TabOrder = 3
      OnClick = PfkOnCheckBoxClick
    end
    object PfkOffCheckBox: TCheckBox
      Left = 407
      Top = 40
      Width = 97
      Height = 17
      Caption = 'Pfk 0'
      TabOrder = 4
      OnClick = PfkOffCheckBox2Click
    end
  end
  object Panel3: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 74
    Width = 768
    Height = 277
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object DBCtrlGrid1: TDBCtrlGrid
      AlignWithMargins = True
      Left = 59
      Top = 16
      Width = 518
      Height = 250
      AllowDelete = False
      AllowInsert = False
      DataSource = TeileDataSource
      PanelHeight = 25
      PanelWidth = 501
      TabOrder = 0
      RowCount = 10
      object TeileNr: TDBText
        Left = 20
        Top = 8
        Width = 114
        Height = 17
        Anchors = [akTop]
        DataField = 'TeileNr'
        DataSource = TeileDataSource
        ExplicitLeft = 0
      end
      object TName1: TDBText
        Left = 159
        Top = 8
        Width = 199
        Height = 17
        DataField = 'TName1'
        DataSource = TeileDataSource
      end
      object Pfk: TDBText
        Left = 438
        Top = 8
        Width = 22
        Height = 17
        Anchors = [akTop]
        DataField = 'Pfk'
        DataSource = TeileDataSource
        ExplicitLeft = 388
      end
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 357
    Width = 768
    Height = 177
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object DBCtrlGrid2: TDBCtrlGrid
      AlignWithMargins = True
      Left = 35
      Top = 24
      Width = 582
      Height = 90
      AllowDelete = False
      AllowInsert = False
      DataSource = LieferantenDataSource
      PanelHeight = 30
      PanelWidth = 565
      TabOrder = 0
      object LKurznameDBText: TDBText
        Left = 8
        Top = 7
        Width = 114
        Height = 17
        DataField = 'LKurzname'
        DataSource = LieferantenDataSource
      end
      object LName1DBText: TDBText
        Left = 167
        Top = 7
        Width = 145
        Height = 17
        DataField = 'LName1'
        DataSource = LieferantenDataSource
      end
      object LPfkDBText: TDBText
        Left = 496
        Top = 7
        Width = 49
        Height = 17
        DataField = 'LPfk'
        DataSource = LieferantenDataSource
      end
      object Lekl: TDBText
        Left = 406
        Top = 8
        Width = 84
        Height = 17
        Anchors = [akTop]
        DataField = 'StatusTxt'
        DataSource = LieferantenDataSource
      end
    end
  end
  object TeileDataSource: TDataSource
    AutoEdit = False
    OnDataChange = TeileDataSourceDataChange
    Left = 616
    Top = 152
  end
  object ImageList1: TImageList
    ImageType = itMask
    Left = 608
    Top = 208
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
  object LieferantenDataSource: TDataSource
    Left = 616
    Top = 88
  end
end
