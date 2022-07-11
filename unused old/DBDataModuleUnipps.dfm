object DataModuleUnipps: TDataModuleUnipps
  OldCreateOrder = False
  Height = 375
  Width = 357
  object ADOConnectionUniPPS: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Persist Security Info=False;Data Source=unipp' +
      's;'
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 144
    Top = 72
  end
end
