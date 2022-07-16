object Wkz: TWkz
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 292
  Width = 376
  object Log: TLogFile
    FileDir = 
      'C:\Users\Etscheidt\Documents\Embarcadero\Studio\Projekte\Zoll\ou' +
      'tput'
    FileName = 'Protokoll'
    FileExt = 'txt'
    Left = 136
    Top = 64
  end
  object ErrLog: TLogFile
    FileDir = 
      'C:\Users\Etscheidt\Documents\Embarcadero\Studio\Projekte\Zoll\ou' +
      'tput'
    FileName = 'Errlog'
    FileExt = 'txt'
    Left = 136
    Top = 128
  end
  object CSVKurz: TLogFile
    FileDir = 
      'C:\Users\Etscheidt\Documents\Embarcadero\Studio\Projekte\Zoll\ou' +
      'tput'
    FileName = 'Baum'
    FileExt = 'txt'
    Left = 216
    Top = 72
  end
  object CSVLang: TLogFile
    FileDir = 
      'C:\Users\Etscheidt\Documents\Embarcadero\Studio\Projekte\Zoll\ou' +
      'tput'
    FileName = 'Kalkulation'
    FileExt = 'txt'
    Left = 224
    Top = 160
  end
end
