object LieferantenErklaerungenFrm: TLieferantenErklaerungenFrm
  Left = 0
  Top = 0
  Width = 719
  Height = 423
  TabOrder = 0
  object Label1: TLabel
    Left = 25
    Top = 3
    Width = 80
    Height = 18
    Caption = 'Lieferant'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object LKurznameLbl: TLabel
    Left = 25
    Top = 27
    Width = 47
    Height = 13
    Caption = 'Kurzname'
  end
  object IdLieferantLbl: TLabel
    Left = 25
    Top = 46
    Width = 53
    Height = 13
    Caption = 'IdLieferant'
  end
  object DBCtrlGrid1: TDBCtrlGrid
    Left = 17
    Top = 72
    Width = 702
    Height = 275
    DataSource = DataSource1
    PanelHeight = 55
    PanelWidth = 685
    TabOrder = 0
    RowCount = 5
    object TeileNr: TDBText
      Left = 8
      Top = 8
      Width = 114
      Height = 17
      DataField = 'TeileNr'
      DataSource = DataSource1
    end
    object TName1: TDBText
      Left = 160
      Top = 8
      Width = 145
      Height = 17
      DataField = 'TName1'
      DataSource = DataSource1
    end
    object TName2: TDBText
      Left = 160
      Top = 31
      Width = 161
      Height = 17
      DataField = 'TName2'
      DataSource = DataSource1
    end
    object LTeileNr: TDBText
      Left = 368
      Top = 8
      Width = 65
      Height = 17
      DataField = 'LTeileNr'
      DataSource = DataSource1
    end
    object PFK: TDBCheckBox
      Left = 592
      Top = 7
      Width = 41
      Height = 17
      Caption = 'PFK'
      DataField = 'LPfk'
      DataSource = DataSource1
      TabOrder = 0
      ValueChecked = '-1'
      ValueUnchecked = '0'
    end
  end
  object Button1: TButton
    Left = 272
    Top = 376
    Width = 105
    Height = 25
    Caption = 'Zur'#252'ck'
    TabOrder = 1
    OnClick = Button1Click
  end
  object DataSource1: TDataSource
    Left = 560
    Top = 16
  end
end
