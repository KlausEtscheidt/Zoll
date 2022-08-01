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
    FetchOnDemand = False
    Params = <>
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
    object ErgebnisDSAnteilNonEU: TFloatField
      FieldName = 'AnteilNonEU'
    end
    object ErgebnisDSZuKAPos: TIntegerField
      FieldName = 'ZuKAPos'
    end
  end
  object AusgabeDS: TWDataSet
    Aggregates = <>
    Params = <>
    Left = 432
    Top = 64
  end
end
