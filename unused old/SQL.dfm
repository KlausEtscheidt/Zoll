object SQLite_Reader: TSQLite_Reader
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
      
        'Database=C:\Users\Klaus Etscheidt\Documents\Embarcadero\Studio\P' +
        'rojekte\zoll\zoll.sqlite'
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 88
    Top = 144
  end
  object Query: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from stamm;')
    Left = 320
    Top = 264
  end
end