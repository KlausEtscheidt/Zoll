object PreisFrm: TPreisFrm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Preiseingabe'
  ClientHeight = 472
  ClientWidth = 690
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  GlassFrame.Enabled = True
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
  object Panel1: TPanel
    Left = 8
    Top = 424
    Width = 673
    Height = 40
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      673
      40)
    object Button2: TButton
      AlignWithMargins = True
      Left = 359
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop]
      Cancel = True
      Caption = 'Abbrechen'
      ModalResult = 2
      TabOrder = 0
    end
    object Button1: TButton
      Left = 239
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 56
    Width = 673
    Height = 345
    DataSource = DataSource1
    Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object DataSource1: TDataSource
    DataSet = PreisDS
    Left = 496
    Top = 384
  end
  object PreisDS: TWDataSet
    Aggregates = <>
    FieldOptions.AutoCreateMode = acCombineAlways
    FieldDefs = <
      item
        Name = 'id_pos'
        Attributes = [faUnNamed]
        DataType = ftInteger
      end
      item
        Name = 'menge'
        Attributes = [faUnNamed]
        DataType = ftFloat
      end
      item
        Name = 'stu_t_tg_nr'
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
        Name = 'vk_brutto'
        Attributes = [faUnNamed]
        DataType = ftFloat
        Precision = 3
      end
      item
        Name = 'vk_netto'
        Attributes = [faUnNamed]
        DataType = ftCurrency
      end
      item
        Name = 'ZuKAPos'
        Attributes = [faUnNamed]
        DataType = ftInteger
      end>
    IndexDefs = <>
    FetchOnDemand = False
    Params = <>
    StoreDefs = True
    Left = 584
    Top = 256
  end
end
