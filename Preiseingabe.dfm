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
        FieldName = 'stu_t_tg_nr'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Bezeichnung'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'vk_brutto'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'vk_netto'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ZuKAPos'
        Title.Caption = 'geh'#246'rt zu'
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
