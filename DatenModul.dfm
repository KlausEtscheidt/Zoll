object KaDataModule: TKaDataModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 367
  Width = 587
  object BatchMoveTextWriter: TFDBatchMoveTextWriter
    DataDef.Fields = <>
    DataDef.Delimiter = '"'
    DataDef.Separator = ';'
    DataDef.EndOfLine = elWindows
    DataDef.RecordFormat = rfCustom
    DataDef.WithFieldNames = True
    Encoding = ecUTF8
    Left = 456
    Top = 248
  end
  object BatchMoveDSReader: TFDBatchMoveDataSetReader
    DataSet = ErgebnisDS
    Left = 312
    Top = 248
  end
  object BatchMove: TFDBatchMove
    Reader = BatchMoveDSReader
    Writer = BatchMoveTextWriter
    Options = [poUseTransactions]
    Mappings = <>
    LogFileAction = laCreate
    LogFileName = 
      'C:\Users\Klaus Etscheidt\Documents\Embarcadero\Studio\Projekte\z' +
      'oll\data\output\Data.log'
    LogFileEncoding = ecUTF8
    Left = 392
    Top = 200
  end
  object BatchMoveDSWriter: TFDBatchMoveDataSetWriter
    Left = 440
    Top = 304
  end
  object ErgebnisDS: TWDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'EbeneNice'
        Attributes = [faUnNamed]
        DataType = ftString
        Size = 20
      end
      item
        Name = 'MengeTotal'
        Attributes = [faUnNamed]
        DataType = ftFloat
      end
      item
        Name = 'bestell_datum'
        Attributes = [faUnNamed]
        DataType = ftDate
      end
      item
        Name = 't_tg_nr'
        Attributes = [faUnNamed]
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Bezeichnung'
        Attributes = [faUnNamed]
        DataType = ftString
        Size = 20
      end
      item
        Name = 'vk_netto'
        Attributes = [faUnNamed]
        DataType = ftCurrency
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 352
    Top = 64
  end
  object AusgabeDS: TWDataSet
    PersistDataPacket.Data = {
      AC0B00009619E0BD01000000180000000A001D00000003000000CE0209456265
      6E654E696365010049001000010005574944544802000200050007745F74675F
      6E7201004900100001000557494454480200020019000B42657A656963686E75
      6E6701004900100001000557494454480200020019000A4D656E6765546F7461
      6C0800040010000000086B75727A6E616D650100490010000100055749445448
      020002000A000750726569734555080004001000010007535542545950450200
      490006004D6F6E6579000A50726569734E6F6E45550800040010000100075355
      42545950450200490006004D6F6E6579000753756D6D65455508000400100001
      0007535542545950450200490006004D6F6E6579000A53756D6D654E6F6E4555
      080004001000010007535542545950450200490006004D6F6E65790008766B5F
      6E6574746F080004001000010007535542545950450200490006004D6F6E6579
      0001000A4348414E47455F4C4F47040082005700000001000000000000000400
      0000020000000000000004000000030000000000000004000000040000000000
      0000040000000500000000000000040000000600000000000000040000000700
      0000000000000400000008000000000000000400000009000000000000000400
      00000A00000000000000040000000B00000000000000040000000C0000000000
      0000040000000D00000000000000040000000E00000000000000040000000F00
      0000000000000400000010000000000000000400000011000000000000000400
      0000120000000000000004000000130000000000000004000000140000000000
      0000040000001500000000000000040000001600000000000000040000001700
      0000000000000400000018000000000000000400000019000000000000000400
      00001A00000000000000040000001B00000000000000040000001C0000000000
      0000040000001D00000000000000040000000400010001310F35303544323439
      363853584B3031390C536368756C74657272696E67000000000000F03F000000
      000000000000000000000000000000000000000000613583E5F5CDF43F21C841
      0933CD4D4004140100022E32000000000000F03F000000000000000000000000
      000000000000000000000000613583E5F5CDF43F000000000000000004000000
      032E2E3307455354D83535410952756E64737461686C00000000000024400754
      48595353454E0000000000000000613583E5F5CDF43F00000000000000006135
      83E5F5CDF43F00000000000000000400010001310F3530374932343936395358
      4B3031390A53707269747A72696E67000000000000F03F000000000000000000
      00000000000000000000000000000085EB51B81EC50440AF42CA4FAA74604004
      140100022E32000000000000F03F000000000000000000000000000000000000
      00000000000085EB51B81EC50440000000000000000004000000032E2E330645
      5354D836300952756E64737461686C0000000000002E400548414B454E000000
      000000000085EB51B81EC50440000000000000000085EB51B81EC50440000000
      00000000000400010001310F3231304132323333355343423031390557656C6C
      65000000000000F03F0000000000000000000000000000000000000000000000
      00A6F8F3FCD3E12C40B0FECF61BE3C754004140100022E32000000000000F03F
      000000000000000000000000000000000000000000000000A6F8F3FCD3E12C40
      000000000000000004000100032E2E330B455354D834354D303430351052756E
      64737461686C20676573E46774000000000000F03F0000000000000000000000
      00000000000000000000000000A6F8F3FCD3E12C400000000000000000041401
      00042E2E2E34000000000000F03F000000000000000000000000000000000000
      000000000000A6F8F3FCD3E12C40000000000000000004000000052E2E2E2E35
      07455354D83435440952756E64737461686CF38E537424C97A40054252DC434B
      0000000000000000A6F8F3FCD3E12C400000000000000000A6F8F3FCD3E12C40
      00000000000000000400010001310F3530314532323333395343413031391052
      696E672C207A7765697465696C6967000000000000F03F000000000000000000
      000000000000000000000000000000C9BDE642D294C13F49BA66F2CDD6284004
      140100022E32000000000000F03F000000000000000000000000000000000000
      000000000000C9BDE642D294C13F000000000000000004000000032E2E330745
      5354D83330420952756E64737461686C00000000000029400548414B454E0000
      000000000000C9BDE642D294C13F0000000000000000C9BDE642D294C13F0000
      0000000000000400000001310F3430304146303035314556573037340D466C61
      63686469636874756E6700000000000000400A574F4C544552484F464685EB51
      B81E851940000000000000000085EB51B81E85194000000000000000007DB3CD
      8DE9C92E400400010001310F34353541323732303650454B3232391153746F70
      66627563687365696E7361747A000000000000F03F0000000000000000000000
      00000000000000000000404040315F5E807D240540102384479B6F8340041401
      00022E32000000000000F03F0000000000000000000000000000000000000000
      00404040315F5E807D240540000000000000000004000000032E2E330A45524F
      D832393078373317526F6E64652C204469636874756E677365696E7361747A00
      0000000000F03F054F5454454E00000000004040400000000000000000000000
      00004040400000000000000000000000000000000004000100032E2E330F3530
      304233303135325352423035390452696E67000000000000F03F000000000000
      000000000000000000000000000000000000315F5E807D240540000000000000
      000004140100042E2E2E34000000000000F03F00000000000000000000000000
      0000000000000000000000315F5E807D24054000000000000000000400000005
      2E2E2E2E350B455252D832343435783633106E6168746C2E205369656465726F
      68721904560E2D923C40075448595353454E0000000000000000315F5E807D24
      05400000000000000000315F5E807D2405400000000000000000040001000131
      0F323333424F4E323030504552303030194C696E6B736C6175667261642C2067
      657363686C6F7373656E00000000000000400000000000000000000000000000
      00009CC420B072946440C3F5285C8FC2134037AB3E571B33864004140100022E
      320000000000000040000000000000000000000000000000009CC420B0729464
      40C3F5285C8FC21340000000000000000004000100032E2E330F323333413232
      333435504552303033194C696E6B736C6175667261642C2067657363686C6F73
      73656E0000000000000040000000000000000000000000000000009CC420B072
      946440C3F5285C8FC21340000000000000000004140100042E2E2E3400000000
      00000040000000000000000000000000000000009CC420B072946440C3F5285C
      8FC21340000000000000000004000000052E2E2E2E350F323333483232333435
      504552465433194C696E6B736C6175667261642C2067657363686C6F7373656E
      0000000000000040054F5454454E3333333333D3634000000000000000009CC4
      20B072946440C3F5285C8FC21340000000000000000004000000052E2E2E2E2E
      0F3534344931383433314E4B4D3031390D476577696E64656275636873650000
      0000000000400447454E440000000000000000C3F5285C8FC213400000000000
      000000C3F5285C8FC21340000000000000000004000000052E2E2E2E2E0D4552
      53504531303030475241551550452031303030207265696E2067726175203737
      38AE47E17A14AEFF3F054F5454454E0E2DB29DEF27184000000000000000000E
      2DB29DEF271840000000000000000000000000000000000400000001310F3437
      3249333031343049534130313909476C65697472696E67000000000000004008
      434552414D5445431F85EB51B81E3F4000000000000000001F85EB51B81E3F40
      00000000000000007EC6850321DF6340}
    Active = True
    Aggregates = <>
    FileName = 
      'C:\Users\Klaus Etscheidt\Documents\Embarcadero\Studio\Projekte\z' +
      'oll\data\output\AusgabeKurz.xml'
    Params = <>
    Left = 432
    Top = 64
  end
end
