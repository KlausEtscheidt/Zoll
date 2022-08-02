object mainFrm: TmainFrm
  Left = 0
  Top = 0
  Caption = 'Pr'#228'Fix'
  ClientHeight = 560
  ClientWidth = 1062
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = RunIt
  OnDestroy = FormDestroy
  DesignSize = (
    1062
    560)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 89
    Height = 13
    Caption = 'Id Kundenauftrag:'
  end
  object Run_Btn: TButton
    Left = 144
    Top = 25
    Width = 75
    Height = 25
    Caption = 'Auswerten'
    TabOrder = 0
    OnClick = Run_BtnClick
  end
  object KA_id_ctrl: TEdit
    Left = 8
    Top = 27
    Width = 121
    Height = 21
    TabOrder = 1
    Text = '142567'
  end
  object Ende_Btn: TButton
    Left = 225
    Top = 25
    Width = 75
    Height = 25
    Caption = 'Ende'
    TabOrder = 2
    OnClick = Ende_BtnClick
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 56
    Width = 1049
    Height = 496
    Margins.Left = 20
    Margins.Right = 20
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = DataSource1
    ReadOnly = True
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'id_stu'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PreisJeLME'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MengeTotal'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'faktlme_sme'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'faktlme_bme'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'faktbme_pme'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'netto_poswert'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'pos_nr'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'stu_t_tg_nr'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'stu_oa'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'stu_unipps_typ'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'id_pos'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'besch_art'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'menge'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FA_Nr'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'verurs_art'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ueb_s_nr'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ds'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'set_block'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PosTyp'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PreisEU'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PreisNonEU'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SummeEU'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SummeNonEU'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'vk_netto'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'vk_brutto'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Ebene'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'EbeneNice'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 't_tg_nr'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'oa'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'unipps_typ'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Bezeichnung'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'v_besch_art'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'praeferenzkennung'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'sme'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'lme'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'preis'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'bestell_id'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'bestell_datum'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'best_t_tg_nr'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'basis'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'pme'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'bme'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'we_menge'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'lieferant'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'kurzname'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'best_menge'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'AnteilNonEU'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ZuKAPos'
        Visible = True
      end>
  end
  object langBtn: TButton
    Left = 306
    Top = 25
    Width = 75
    Height = 25
    Caption = 'Lang'
    Enabled = False
    TabOrder = 4
    OnClick = langBtnClick
  end
  object kurzBtn: TButton
    Left = 387
    Top = 25
    Width = 75
    Height = 25
    Caption = 'Kurz'
    Enabled = False
    TabOrder = 5
    OnClick = kurzBtnClick
  end
  object TestBtn: TButton
    Left = 468
    Top = 25
    Width = 75
    Height = 25
    Caption = 'Test'
    Enabled = False
    TabOrder = 6
    OnClick = TestBtnClick
  end
  object PreisBtn: TButton
    Left = 560
    Top = 25
    Width = 75
    Height = 25
    Caption = 'Preise'
    TabOrder = 7
    OnClick = PreisBtnClick
  end
  object DataSource1: TDataSource
    AutoEdit = False
    DataSet = KaDataModule.ErgebnisDS
    Left = 184
    Top = 216
  end
  object AusgabeDS: TWDataSet
    Aggregates = <>
    Params = <>
    Left = 280
    Top = 248
  end
end
