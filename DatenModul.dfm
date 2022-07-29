object DataModule1: TDataModule1
  OldCreateOrder = False
  Height = 367
  Width = 587
  object CDSBestellung: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 136
    Top = 120
    object CDSBestellungbestell_id: TIntegerField
      FieldName = 'bestell_id'
    end
    object CDSBestellungbestell_datum: TDateField
      FieldName = 'bestell_datum'
    end
    object CDSBestellungpreis: TFloatField
      FieldName = 'preis'
    end
  end
  object CDSStueliPOs: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 256
    Top = 128
    object CDSStueliPOsPosTyp: TStringField
      FieldName = 'PosTyp'
    end
    object CDSStueliPOsid_stu: TStringField
      FieldName = 'id_stu'
    end
    object CDSStueliPOspos_nr: TIntegerField
      FieldName = 'pos_nr'
    end
    object CDSStueliPOst_tg_nr: TStringField
      FieldName = 't_tg_nr'
    end
    object CDSStueliPOsunipps_typ: TStringField
      FieldName = 'unipps_typ'
    end
  end
  object CDSTeil: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 368
    Top = 136
    object CDSTeilt_tg_nr: TStringField
      FieldName = 't_tg_nr'
    end
    object CDSTeiloa: TIntegerField
      FieldName = 'oa'
    end
    object CDSTeilbesch_art: TIntegerField
      FieldName = 'besch_art'
    end
    object CDSTeilunipps_typ: TStringField
      FieldName = 'unipps_typ'
    end
    object CDSTeilpraeferenzkennung: TIntegerField
      FieldName = 'praeferenzkennung'
    end
    object CDSTeilsme: TIntegerField
      FieldName = 'sme'
    end
    object CDSTeilfaktlme_sme: TFloatField
      FieldName = 'faktlme_sme'
    end
    object CDSTeillme: TIntegerField
      FieldName = 'lme'
    end
  end
end
