object mainFrm: TmainFrm
  Left = 0
  Top = 0
  Caption = 'Pr'#228'Fix'
  ClientHeight = 304
  ClientWidth = 612
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = RunIt
  DesignSize = (
    612
    304)
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
    Text = '142120'
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
    Left = 0
    Top = 64
    Width = 752
    Height = 241
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = DataSource1
    ReadOnly = True
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
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
  object DataSource1: TDataSource
    DataSet = AusgabeDS
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
