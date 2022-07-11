object KombiDataModule: TKombiDataModule
  OldCreateOrder = False
  Height = 483
  Width = 490
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    DriverID = 'SQLite'
    Left = 80
    Top = 40
  end
  object FDConnectionSQLite: TFDConnection
    Params.Strings = (
      'ConnectionDef=Zoll')
    LoginPrompt = False
    Left = 88
    Top = 144
  end
  object Query: TFDQuery
    Connection = FDConnectionSQLite
    SQL.Strings = (
      'select * from stamm;')
    Left = 88
    Top = 216
  end
  object ADOQuery1: TADOQuery
    Connection = ADOConnectionUnipps
    Parameters = <>
    SQL.Strings = (
      'SElect * from kunde_zuab;')
    Left = 304
    Top = 232
    object ADOQuery1Kunden_id: TIntegerField
      FieldName = 'Kunden_id'
    end
  end
  object ADOConnectionUnipps: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Persist Security Info=False;Data Source=unipp' +
      's;'
    ConnectOptions = coAsyncConnect
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 312
    Top = 152
  end
end
