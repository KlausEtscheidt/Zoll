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
    Connection = ADOConnection1
    CursorType = ctStatic
    DataSource = LieferantenDQuelle
    Parameters = <>
    SQL.Strings = (
      'select *, TName1,TName2,Pumpenteil from LErklaerungen'
      'join Teile on LErklaerungen.TeileNr=Teile.TeileNr ;')
    Left = 176
    Top = 296
    object ADOQuery1IdLieferant: TIntegerField
      FieldName = 'IdLieferant'
    end
    object ADOQuery1TeileNr: TStringField
      FieldName = 'TeileNr'
      Size = 255
    end
    object ADOQuery1LTeileNr: TStringField
      FieldName = 'LTeileNr'
      Size = 255
    end
    object ADOQuery1LPfk: TIntegerField
      FieldName = 'LPfk'
    end
    object ADOQuery1Stand: TDateTimeField
      FieldName = 'Stand'
    end
    object ADOQuery1BestDatum: TDateTimeField
      FieldName = 'BestDatum'
    end
    object ADOQuery1TeileNr_1: TStringField
      FieldName = 'TeileNr_1'
      Size = 255
    end
    object ADOQuery1TName1: TStringField
      FieldName = 'TName1'
      Size = 255
    end
    object ADOQuery1TName2: TStringField
      FieldName = 'TName2'
      Size = 255
    end
    object ADOQuery1Pumpenteil: TIntegerField
      FieldName = 'Pumpenteil'
    end
    object ADOQuery1PFK: TIntegerField
      FieldName = 'PFK'
    end
    object ADOQuery1TName1_1: TStringField
      FieldName = 'TName1_1'
      Size = 255
    end
    object ADOQuery1TName2_1: TStringField
      FieldName = 'TName2_1'
      Size = 255
    end
    object ADOQuery1Pumpenteil_1: TIntegerField
      FieldName = 'Pumpenteil_1'
    end
  end
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 'Provider=MSDASQL.1;Persist Security Info=False;Data Source=lekl;'
    LoginPrompt = False
    Left = 40
    Top = 288
  end
  object ADOQuery2: TADOQuery
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from Lieferanten;')
    Left = 184
    Top = 224
  end
  object LieferantenDQuelle: TDataSource
    DataSet = ADOQuery2
    Left = 280
    Top = 224
  end
  object ADOTable1: TADOTable
    Connection = ADOConnection1
    CursorType = ctStatic
    TableDirect = True
    TableName = 'Bestellungen'
    Left = 296
    Top = 88
  end
end
