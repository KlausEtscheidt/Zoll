object LieferantenErklaerungenFrm: TLieferantenErklaerungenFrm
  Left = 0
  Top = 0
  Width = 719
  Height = 466
  TabOrder = 0
  object Label1: TLabel
    Left = 25
    Top = 3
    Width = 56
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
    Left = 105
    Top = 7
    Width = 47
    Height = 13
    Caption = 'Kurzname'
  end
  object IdLieferantLbl: TLabel
    Left = 193
    Top = 7
    Width = 53
    Height = 13
    Caption = 'IdLieferant'
  end
  object DBCtrlGrid1: TDBCtrlGrid
    Left = 17
    Top = 72
    Width = 702
    Height = 352
    DataSource = DataSource1
    PanelHeight = 44
    PanelWidth = 685
    TabOrder = 0
    RowCount = 8
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
      Top = 23
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
  object BackBtn: TButton
    Left = 264
    Top = 430
    Width = 105
    Height = 25
    Caption = 'Zur'#252'ck'
    TabOrder = 1
    OnClick = BackBtnClick
  end
  object SortLTeileNrBtn: TButton
    Left = 385
    Top = 41
    Width = 65
    Height = 25
    Caption = 'LTeilenr'
    TabOrder = 2
    OnClick = SortLTeileNrBtnClick
  end
  object SortTeilenrBtn: TButton
    Left = 25
    Top = 41
    Width = 65
    Height = 25
    Caption = 'Teilenr'
    TabOrder = 3
    OnClick = SortTeilenrBtnClick
  end
  object SortLTNameBtn: TButton
    Left = 177
    Top = 41
    Width = 65
    Height = 25
    Caption = 'Teil-Name'
    TabOrder = 4
    OnClick = SortLTNameBtnClick
  end
  object DataSource1: TDataSource
    Left = 560
    Top = 16
  end
end
