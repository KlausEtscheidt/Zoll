object DataModule1: TDataModule1
  OldCreateOrder = False
  Height = 483
  Width = 490
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    DriverID = 'SQLite'
    Left = 104
    Top = 72
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=V:\E-MAIL\Dr Etscheidt\Datengrab\personal.sqlite'
      'LockingMode=Normal'
      'DriverID=SQLite')
    Connected = True
    LoginPrompt = False
    Left = 88
    Top = 144
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from stamm;')
    Left = 320
    Top = 264
  end
end
