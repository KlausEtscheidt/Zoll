object Lieferanten: TLieferanten
  Left = 0
  Top = 0
  Width = 719
  Height = 383
  TabOrder = 0
  object IdLieferant: TDBText
    Left = 32
    Top = 32
    Width = 65
    Height = 17
    DataField = 'IdLieferant'
    DataSource = DataModule1.LieferantenDQuelle
  end
  object LKurzname: TDBText
    Left = 123
    Top = 32
    Width = 65
    Height = 17
    DataField = 'LKurzname'
    DataSource = DataModule1.LieferantenDQuelle
  end
  object DBCtrlGrid1: TDBCtrlGrid
    Left = 14
    Top = 112
    Width = 702
    Height = 232
    DataSource = DataModule1.Erklaerung
    PanelHeight = 77
    PanelWidth = 685
    TabOrder = 0
    object TeileNr: TDBText
      Left = 8
      Top = 8
      Width = 114
      Height = 17
      DataField = 'TeileNr'
      DataSource = DataModule1.Erklaerung
    end
    object TeileName1: TDBText
      Left = 152
      Top = 8
      Width = 161
      Height = 17
      DataField = 'TName1'
      DataSource = DataModule1.Erklaerung
    end
    object PFK: TDBCheckBox
      Left = 592
      Top = 7
      Width = 41
      Height = 17
      Caption = 'PFK'
      DataField = 'PFK'
      DataSource = DataModule1.Erklaerung
      TabOrder = 0
      ValueChecked = '-1'
      ValueUnchecked = '0'
    end
  end
  object DBNavigator1: TDBNavigator
    Left = 280
    Top = 26
    Width = 210
    Height = 25
    DataSource = DataModule1.LieferantenDQuelle
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbPost]
    TabOrder = 1
  end
  object DBLookupListBox1: TDBLookupListBox
    Left = 232
    Top = 57
    Width = 121
    Height = 43
    DataField = 'lekl'
    DataSource = DataModule1.LieferantenDQuelle
    KeyField = 'Id'
    ListField = 'Status'
    ListFieldIndex = 1
    ListSource = DataModule1.LStatusDQuelle
    TabOrder = 2
  end
end
