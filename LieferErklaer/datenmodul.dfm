object DataModule1: TDataModule1
  OldCreateOrder = False
  Height = 427
  Width = 492
  object Erklaerung: TDataSource
    DataSet = ADOQuery1
    Left = 272
    Top = 296
  end
  object ADOQuery1: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    DataSource = LieferantenDQuelle
    Parameters = <>
    SQL.Strings = (
      'select * from Teile;')
    Left = 176
    Top = 296
    object ADOQuery1TeileNr: TWideStringField
      DisplayWidth = 22
      FieldName = 'TeileNr'
      Size = 25
    end
    object ADOQuery1TName1: TWideStringField
      DisplayWidth = 27
      FieldName = 'TName1'
      Size = 255
    end
    object ADOQuery1TName2: TWideStringField
      DisplayWidth = 30
      FieldName = 'TName2'
      Size = 255
    end
    object ADOQuery1PFK: TIntegerField
      DisplayWidth = 10
      FieldName = 'PFK'
    end
  end
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 'Provider=MSDASQL.1;Persist Security Info=False;Data Source=lekl'
    LoginPrompt = False
    Left = 40
    Top = 288
  end
  object ADOQuery2: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from Lieferanten;')
    Left = 184
    Top = 224
    object ADOQuery2IdLieferant: TIntegerField
      FieldName = 'IdLieferant'
    end
    object ADOQuery2eingelesen: TDateTimeField
      FieldName = 'eingelesen'
    end
    object ADOQuery2LKurzname: TStringField
      FieldName = 'LKurzname'
      Size = 200
    end
    object ADOQuery2LName1: TStringField
      FieldName = 'LName1'
      Size = 200
    end
    object ADOQuery2LName2: TStringField
      FieldName = 'LName2'
      Size = 200
    end
    object ADOQuery2lekl: TIntegerField
      FieldName = 'lekl'
    end
  end
  object LieferantenDQuelle: TDataSource
    DataSet = ADOQuery2
    Left = 280
    Top = 224
  end
  object ADOQuery3: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from LieferantenStatus;')
    Left = 184
    Top = 160
    object ADOQuery3Id: TIntegerField
      FieldName = 'Id'
    end
    object ADOQuery3Status: TStringField
      FieldName = 'Status'
      Size = 50
    end
  end
  object LStatusDQuelle: TDataSource
    DataSet = ADOQuery3
    Left = 272
    Top = 160
  end
end
