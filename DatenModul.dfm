object KaDataModule: TKaDataModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 367
  Width = 587
  object StueliPosDS: TWDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 96
    Top = 56
    object StueliPosDSid_stu: TStringField
      FieldName = 'id_stu'
    end
    object StueliPosDSpos_nr: TIntegerField
      FieldName = 'pos_nr'
    end
    object StueliPosDSstu_t_tg_nr: TStringField
      FieldName = 'stu_t_tg_nr'
      OnChange = StueliPosDSstu_t_tg_nrChange
    end
    object StueliPosDSoa: TIntegerField
      FieldName = 'stu_oa'
    end
    object StueliPosDSunipps_typ: TStringField
      FieldName = 'stu_unipps_typ'
    end
    object StueliPosDSid_pos: TIntegerField
      FieldName = 'id_pos'
    end
    object StueliPosDSbesch_art: TIntegerField
      FieldName = 'besch_art'
    end
    object StueliPosDSmenge: TFloatField
      FieldName = 'menge'
    end
    object StueliPosDSFA_Nr: TStringField
      FieldName = 'FA_Nr'
    end
    object StueliPosDSverurs_art: TIntegerField
      FieldName = 'verurs_art'
    end
    object StueliPosDSueb_s_nr: TIntegerField
      FieldName = 'ueb_s_nr'
    end
    object StueliPosDSds: TIntegerField
      FieldName = 'ds'
    end
    object StueliPosDSset_block: TIntegerField
      FieldName = 'set_block'
    end
    object StueliPosDSPosTyp: TStringField
      FieldName = 'PosTyp'
    end
    object StueliPosDSPreisEU: TFloatField
      FieldName = 'PreisEU'
    end
    object StueliPosDSPreisNonEU: TFloatField
      FieldName = 'PreisNonEU'
    end
    object StueliPosDSSummeEU: TFloatField
      FieldName = 'SummeEU'
      currency = True
      Precision = 6
    end
    object StueliPosDSSummeNonEU: TFloatField
      FieldName = 'SummeNonEU'
    end
    object StueliPosDSvk_netto: TFloatField
      FieldName = 'vk_netto'
    end
    object StueliPosDSvk_brutto: TFloatField
      FieldName = 'vk_brutto'
    end
    object StueliPosDSMengeTotal: TFloatField
      FieldName = 'MengeTotal'
    end
    object StueliPosDSEbene: TIntegerField
      FieldName = 'Ebene'
    end
    object StueliPosDSEbeneNice: TStringField
      FieldName = 'EbeneNice'
    end
  end
  object TeilDS: TWDataSet
    Aggregates = <>
    Params = <>
    Left = 200
    Top = 64
    object TeilDSt_tg_nr: TStringField
      FieldName = 't_tg_nr'
    end
    object TeilDSoa: TIntegerField
      FieldName = 'oa'
    end
    object TeilDSunipps_typ: TStringField
      FieldName = 'unipps_typ'
    end
    object TeilDSBezeichnung: TStringField
      FieldName = 'Bezeichnung'
    end
    object TeilDSbesch_art: TIntegerField
      FieldName = 'v_besch_art'
    end
    object TeilDSpraeferenzkennung: TIntegerField
      FieldName = 'praeferenzkennung'
    end
    object TeilDSsme: TIntegerField
      FieldName = 'sme'
    end
    object TeilDSfaktlme_sme: TFloatField
      FieldName = 'faktlme_sme'
    end
    object TeilDSlme: TIntegerField
      FieldName = 'lme'
    end
    object TeilDSPreisJeLME: TFloatField
      FieldName = 'PreisJeLME'
    end
  end
  object BestellungDS: TWDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 280
    Top = 64
    object BestellungDSpreis: TFloatField
      FieldName = 'preis'
    end
    object BestellungDSbestell_id: TIntegerField
      FieldName = 'bestell_id'
    end
    object BestellungDSbestell_datum: TDateTimeField
      FieldName = 'bestell_datum'
    end
    object BestellungDSbest_t_tg_nr: TStringField
      FieldName = 'best_t_tg_nr'
    end
    object BestellungDSbasis: TFloatField
      FieldName = 'basis'
    end
    object BestellungDSpme: TIntegerField
      FieldName = 'pme'
    end
    object BestellungDSbme: TIntegerField
      FieldName = 'bme'
    end
    object BestellungDSfaktlme_bme: TFloatField
      FieldName = 'faktlme_bme'
    end
    object BestellungDSfaktbme_pme: TFloatField
      FieldName = 'faktbme_pme'
    end
    object BestellungDSnetto_poswert: TFloatField
      FieldName = 'netto_poswert'
    end
    object BestellungDSwe_menge: TFloatField
      FieldName = 'we_menge'
    end
    object BestellungDSlieferant: TIntegerField
      FieldName = 'lieferant'
    end
    object BestellungDSkurzname: TStringField
      FieldName = 'kurzname'
    end
    object BestellungDSbest_menge: TFloatField
      FieldName = 'best_menge'
    end
  end
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
    Options = [poClearDest, poIdentityInsert, poCreateDest, poUseTransactions]
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
    FileName = 
      'C:\Users\Klaus Etscheidt\Documents\Embarcadero\Studio\Projekte\z' +
      'oll\data\output\erg.xml'
    FieldDefs = <
      item
        Name = 'id_stu'
        Attributes = [faUnNamed]
        DataType = ftString
        Size = 20
      end
      item
        Name = 'pos_nr'
        Attributes = [faUnNamed]
        DataType = ftInteger
      end
      item
        Name = 'stu_t_tg_nr'
        Attributes = [faUnNamed]
        DataType = ftString
        Size = 20
      end
      item
        Name = 'stu_oa'
        Attributes = [faUnNamed]
        DataType = ftInteger
      end
      item
        Name = 'stu_unipps_typ'
        Attributes = [faUnNamed]
        DataType = ftString
        Size = 20
      end
      item
        Name = 'id_pos'
        Attributes = [faUnNamed]
        DataType = ftInteger
      end
      item
        Name = 'besch_art'
        Attributes = [faUnNamed]
        DataType = ftInteger
      end
      item
        Name = 'menge'
        Attributes = [faUnNamed]
        DataType = ftFloat
      end
      item
        Name = 'FA_Nr'
        Attributes = [faUnNamed]
        DataType = ftString
        Size = 20
      end
      item
        Name = 'verurs_art'
        Attributes = [faUnNamed]
        DataType = ftInteger
      end
      item
        Name = 'ueb_s_nr'
        Attributes = [faUnNamed]
        DataType = ftInteger
      end
      item
        Name = 'ds'
        Attributes = [faUnNamed]
        DataType = ftInteger
      end
      item
        Name = 'set_block'
        Attributes = [faUnNamed]
        DataType = ftInteger
      end
      item
        Name = 'PosTyp'
        Attributes = [faUnNamed]
        DataType = ftString
        Size = 20
      end
      item
        Name = 'PreisEU'
        Attributes = [faUnNamed]
        DataType = ftCurrency
      end
      item
        Name = 'PreisNonEU'
        Attributes = [faUnNamed]
        DataType = ftCurrency
      end
      item
        Name = 'SummeEU'
        Attributes = [faUnNamed]
        DataType = ftCurrency
      end
      item
        Name = 'SummeNonEU'
        Attributes = [faUnNamed]
        DataType = ftCurrency
      end
      item
        Name = 'vk_netto'
        Attributes = [faUnNamed]
        DataType = ftCurrency
      end
      item
        Name = 'vk_brutto'
        Attributes = [faUnNamed]
        DataType = ftCurrency
      end
      item
        Name = 'MengeTotal'
        Attributes = [faUnNamed]
        DataType = ftFloat
      end
      item
        Name = 'Ebene'
        Attributes = [faUnNamed]
        DataType = ftInteger
      end
      item
        Name = 'EbeneNice'
        Attributes = [faUnNamed]
        DataType = ftString
        Size = 20
      end
      item
        Name = 't_tg_nr'
        Attributes = [faUnNamed]
        DataType = ftString
        Size = 20
      end
      item
        Name = 'oa'
        Attributes = [faUnNamed]
        DataType = ftInteger
      end
      item
        Name = 'unipps_typ'
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
        Name = 'v_besch_art'
        Attributes = [faUnNamed]
        DataType = ftInteger
      end
      item
        Name = 'praeferenzkennung'
        Attributes = [faUnNamed]
        DataType = ftInteger
      end
      item
        Name = 'sme'
        Attributes = [faUnNamed]
        DataType = ftInteger
      end
      item
        Name = 'faktlme_sme'
        Attributes = [faUnNamed]
        DataType = ftFloat
      end
      item
        Name = 'lme'
        Attributes = [faUnNamed]
        DataType = ftInteger
      end
      item
        Name = 'PreisJeLME'
        Attributes = [faUnNamed]
        DataType = ftCurrency
      end
      item
        Name = 'preis'
        Attributes = [faUnNamed]
        DataType = ftCurrency
      end
      item
        Name = 'bestell_id'
        Attributes = [faUnNamed]
        DataType = ftInteger
      end
      item
        Name = 'bestell_datum'
        Attributes = [faUnNamed]
        DataType = ftDateTime
      end
      item
        Name = 'best_t_tg_nr'
        Attributes = [faUnNamed]
        DataType = ftString
        Size = 20
      end
      item
        Name = 'basis'
        Attributes = [faUnNamed]
        DataType = ftFloat
      end
      item
        Name = 'pme'
        Attributes = [faUnNamed]
        DataType = ftInteger
      end
      item
        Name = 'bme'
        Attributes = [faUnNamed]
        DataType = ftInteger
      end
      item
        Name = 'faktlme_bme'
        Attributes = [faUnNamed]
        DataType = ftFloat
      end
      item
        Name = 'faktbme_pme'
        Attributes = [faUnNamed]
        DataType = ftFloat
      end
      item
        Name = 'netto_poswert'
        Attributes = [faUnNamed]
        DataType = ftCurrency
      end
      item
        Name = 'we_menge'
        Attributes = [faUnNamed]
        DataType = ftFloat
      end
      item
        Name = 'lieferant'
        Attributes = [faUnNamed]
        DataType = ftInteger
      end
      item
        Name = 'kurzname'
        Attributes = [faUnNamed]
        DataType = ftString
        Size = 20
      end
      item
        Name = 'best_menge'
        Attributes = [faUnNamed]
        DataType = ftFloat
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 352
    Top = 64
    object ErgebnisDSid_stu: TStringField
      FieldName = 'id_stu'
    end
    object ErgebnisDSpos_nr: TIntegerField
      FieldName = 'pos_nr'
    end
    object ErgebnisDSstu_t_tg_nr: TStringField
      FieldName = 'stu_t_tg_nr'
    end
    object ErgebnisDSstu_oa: TIntegerField
      FieldName = 'stu_oa'
    end
    object ErgebnisDSstu_unipps_typ: TStringField
      FieldName = 'stu_unipps_typ'
    end
    object ErgebnisDSid_pos: TIntegerField
      FieldName = 'id_pos'
    end
    object ErgebnisDSbesch_art: TIntegerField
      FieldName = 'besch_art'
    end
    object ErgebnisDSmenge: TFloatField
      FieldName = 'menge'
    end
    object ErgebnisDSFA_Nr: TStringField
      FieldName = 'FA_Nr'
    end
    object ErgebnisDSverurs_art: TIntegerField
      FieldName = 'verurs_art'
    end
    object ErgebnisDSueb_s_nr: TIntegerField
      FieldName = 'ueb_s_nr'
    end
    object ErgebnisDSds: TIntegerField
      FieldName = 'ds'
    end
    object ErgebnisDSset_block: TIntegerField
      FieldName = 'set_block'
    end
    object ErgebnisDSPosTyp: TStringField
      FieldName = 'PosTyp'
    end
    object ErgebnisDSPreisEU: TFloatField
      FieldName = 'PreisEU'
    end
    object ErgebnisDSPreisNonEU: TFloatField
      FieldName = 'PreisNonEU'
    end
    object ErgebnisDSSummeEU: TFloatField
      FieldName = 'SummeEU'
      currency = True
      Precision = 8
    end
    object ErgebnisDSSummeNonEU: TFloatField
      FieldName = 'SummeNonEU'
    end
    object ErgebnisDSvk_netto: TFloatField
      FieldName = 'vk_netto'
    end
    object ErgebnisDSvk_brutto: TFloatField
      FieldName = 'vk_brutto'
    end
    object ErgebnisDSMengeTotal: TFloatField
      FieldName = 'MengeTotal'
    end
    object ErgebnisDSEbene: TIntegerField
      FieldName = 'Ebene'
    end
    object ErgebnisDSEbeneNice: TStringField
      FieldName = 'EbeneNice'
    end
    object ErgebnisDSt_tg_nr: TStringField
      FieldName = 't_tg_nr'
    end
    object ErgebnisDSoa: TIntegerField
      FieldName = 'oa'
    end
    object ErgebnisDSunipps_typ: TStringField
      FieldName = 'unipps_typ'
    end
    object ErgebnisDSBezeichnung: TStringField
      FieldName = 'Bezeichnung'
    end
    object ErgebnisDSv_besch_art: TIntegerField
      FieldName = 'v_besch_art'
    end
    object ErgebnisDSpraeferenzkennung: TIntegerField
      FieldName = 'praeferenzkennung'
    end
    object ErgebnisDSsme: TIntegerField
      FieldName = 'sme'
    end
    object ErgebnisDSfaktlme_sme: TFloatField
      FieldName = 'faktlme_sme'
    end
    object ErgebnisDSlme: TIntegerField
      FieldName = 'lme'
    end
    object ErgebnisDSPreisJeLME: TFloatField
      FieldName = 'PreisJeLME'
    end
    object ErgebnisDSpreis: TFloatField
      FieldName = 'preis'
    end
    object ErgebnisDSbestell_id: TIntegerField
      FieldName = 'bestell_id'
    end
    object ErgebnisDSbestell_datum: TDateTimeField
      FieldName = 'bestell_datum'
    end
    object ErgebnisDSbest_t_tg_nr: TStringField
      FieldName = 'best_t_tg_nr'
    end
    object ErgebnisDSbasis: TFloatField
      FieldName = 'basis'
    end
    object ErgebnisDSpme: TIntegerField
      FieldName = 'pme'
    end
    object ErgebnisDSbme: TIntegerField
      FieldName = 'bme'
    end
    object ErgebnisDSfaktlme_bme: TFloatField
      FieldName = 'faktlme_bme'
    end
    object ErgebnisDSfaktbme_pme: TFloatField
      FieldName = 'faktbme_pme'
    end
    object ErgebnisDSnetto_poswert: TFloatField
      FieldName = 'netto_poswert'
    end
    object ErgebnisDSwe_menge: TFloatField
      FieldName = 'we_menge'
    end
    object ErgebnisDSlieferant: TIntegerField
      FieldName = 'lieferant'
    end
    object ErgebnisDSkurzname: TStringField
      FieldName = 'kurzname'
    end
    object ErgebnisDSbest_menge: TFloatField
      FieldName = 'best_menge'
    end
  end
  object AusgabeDS: TWDataSet
    Aggregates = <>
    Params = <>
    Left = 416
    Top = 72
  end
end
