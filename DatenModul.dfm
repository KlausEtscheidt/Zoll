object DataModule1: TDataModule1
  OldCreateOrder = False
  Height = 367
  Width = 587
  object StueliPosDS: TWDataSet
    Aggregates = <>
    Params = <>
    Left = 112
    Top = 200
    object StueliPosDSid_stu: TStringField
      FieldName = 'id_stu'
    end
    object StueliPosDSpos_nr: TIntegerField
      FieldName = 'pos_nr'
    end
    object StueliPosDSoa: TIntegerField
      FieldName = 'oa'
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
    object StueliPosDSid_pos: TIntegerField
      FieldName = 'id_pos'
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
    object StueliPosDSstu_t_tg_nr: TStringField
      FieldName = 'stu_t_tg_nr'
    end
    object StueliPosDSunipps_typ: TStringField
      FieldName = 'unipps_typ'
    end
  end
  object TeilDS: TWDataSet
    Aggregates = <>
    Params = <>
    Left = 248
    Top = 208
    object TeilDSt_tg_nr: TStringField
      FieldName = 't_tg_nr'
    end
    object TeilDSoa: TIntegerField
      FieldName = 'oa'
    end
    object TeilDSbesch_art: TIntegerField
      FieldName = 'besch_art'
    end
    object TeilDSunipps_typ: TStringField
      FieldName = 'unipps_typ'
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
    object TeilDSBezeichnung: TStringField
      FieldName = 'Bezeichnung'
    end
    object TeilDSPreisJeLME: TFloatField
      FieldName = 'PreisJeLME'
    end
    object TeilDSPreisNonEU: TFloatField
      FieldName = 'PreisNonEU'
    end
    object TeilDSPreisEU: TFloatField
      FieldName = 'PreisEU'
    end
  end
  object BestellungDS: TWDataSet
    Aggregates = <>
    Params = <>
    Left = 368
    Top = 96
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
  end
end
