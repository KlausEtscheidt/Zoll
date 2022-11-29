object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 32
    Top = 120
    Width = 537
    Height = 144
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object LiefererklConnection: TFDConnection
    Params.Strings = (
      'ConnectionDef=LieferErkl')
    Connected = True
    LoginPrompt = False
    Left = 109
    Top = 47
  end
  object FDQuery1: TFDQuery
    Active = True
    Connection = LiefererklConnection
    SQL.Strings = (
      'select * from lieferanten')
    Left = 280
    Top = 64
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 392
    Top = 24
  end
end
