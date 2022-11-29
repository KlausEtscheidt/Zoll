object TeileListeForm: TTeileListeForm
  Left = 0
  Top = 0
  Caption = 'Teile-Liste'
  ClientHeight = 333
  ClientWidth = 784
  Color = clSkyBlue
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    AlignWithMargins = True
    Left = 10
    Top = 10
    Width = 764
    Height = 282
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alClient
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleHotTrack]
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -15
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'TeileNr'
        Width = 120
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TName1'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TName2'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Pumpenteil'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -15
        Title.Font.Name = 'Tahoma'
        Title.Font.Style = []
        Visible = True
      end
      item
        DropDownRows = 10
        Expanded = False
        FieldName = 'Ersatzteil'
        Visible = True
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 292
    Width = 784
    Height = 41
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    Color = clGradientActiveCaption
    ParentBackground = False
    TabOrder = 1
    ExplicitLeft = 272
    ExplicitTop = 168
    ExplicitWidth = 185
    DesignSize = (
      784
      41)
    object OKBtn: TButton
      Left = 354
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'OK'
      Constraints.MaxHeight = 25
      Constraints.MaxWidth = 75
      TabOrder = 0
      OnClick = OKBtnClick
    end
  end
  object DataSource1: TDataSource
    Left = 288
    Top = 272
  end
end
