object PreisFrm: TPreisFrm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Preiseingabe'
  ClientHeight = 472
  ClientWidth = 868
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 421
    Height = 23
    Caption = 'Preise einpflegen und evt Zugeh'#246'rigkeit angeben:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 45
    Width = 842
    Height = 384
    DataSource = DataSource1
    Options = [dgEditing, dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'id_pos'
        Title.Caption = 'Pos-Nr'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'menge'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'teile-Nr'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Bezeichnung'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VK Brutto'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'vk rabattiert'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'geh'#246'rt zu Pos'
        Visible = True
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 435
    Width = 868
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = -8
    ExplicitTop = 364
    DesignSize = (
      868
      37)
    object Button1: TButton
      Left = 700
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 787
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Abbrechen'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object DataSource1: TDataSource
    DataSet = PreisDS
    Left = 736
    Top = 288
  end
  object PreisDS: TWDataSet
    PersistDataPacket.Data = {
      1F0300009619E0BD01000000180000000700080000000300000019010669645F
      706F730400010010000000056D656E6765080004001000000007745F74675F6E
      7201004900100001000557494454480200020014000B42657A656963686E756E
      67010049001000010005574944544802000200140009766B5F62727574746F08
      0004001000000008766B5F6E6574746F0800040010000000075A754B41506F73
      040001001000000001000A4348414E47455F4C4F470400820018000000010000
      0000000000040000000200000000000000040000000300000000000000040000
      0004000000000000000400000005000000000000000400000006000000000000
      0004000000070000000000000004000000080000000000000004000000040000
      01000000000000000000F03F0F35303544323439363853584B3031390C536368
      756C74657272696E67D7A3703D0A57564021C8410933CD4D4000000000040000
      02000000000000000000F03F0F35303749323439363953584B3031390A537072
      69747A72696E67A4703D0AD7AB6840AF42CA4FAA746040000000000400000300
      0000000000000000F03F0F3231304132323333355343423031390557656C6C65
      D7A3703D0AD77F40B0FECF61BE3C754000000000040000040000000000000000
      00F03F0F3530314532323333395343413031391052696E672C207A7765697465
      696C69671F85EB51B89E324049BA66F2CDD62840000000000400000500000000
      000000000000400F3430304146303035314556573037340D466C616368646963
      6874756E6714AE47E17A1437407DB3CD8DE9C92E400000000004000006000000
      000000000000F03F0F34353541323732303650454B3232391153746F70666275
      63687365696E7361747A48E17A14AE238D40102384479B6F8340000000000400
      000700000000000000000000400F323333424F4E323030504552303030144C69
      6E6B736C6175667261642C2067657363686C3333333333A4904037AB3E571B33
      8640000000000400000800000000000000000000400F34373249333031343049
      534130313909476C65697472696E677B14AE47E1CA6D407EC6850321DF634000
      000000}
    Active = True
    Aggregates = <>
    FieldOptions.AutoCreateMode = acCombineAlways
    FileName = 
      'C:\Users\Etscheidt\Documents\Embarcadero\Studio\Projekte\Zoll\da' +
      'ta\output\Preis.xml'
    FetchOnDemand = False
    Params = <>
    Left = 584
    Top = 256
    object PreisDSid_pos: TIntegerField
      FieldName = 'id_pos'
    end
    object PreisDSmenge: TFloatField
      FieldName = 'menge'
    end
    object PreisDSt_tg_nr: TStringField
      FieldName = 't_tg_nr'
    end
    object PreisDSBezeichnung: TStringField
      FieldName = 'Bezeichnung'
    end
    object PreisDSvk_brutto: TFloatField
      FieldName = 'vk_brutto'
      currency = True
    end
    object PreisDSvk_netto: TFloatField
      FieldName = 'vk_netto'
      currency = True
    end
    object PreisDSZuKAPos: TIntegerField
      FieldName = 'ZuKAPos'
    end
  end
end
