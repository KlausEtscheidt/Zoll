object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 329
  ClientWidth = 566
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 128
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Run Query'
    TabOrder = 0
    OnClick = Button1Click
  end
  object RunTest: TButton
    Left = 256
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Run Test'
    TabOrder = 1
    OnClick = RunTestClick
  end
  object Ende: TButton
    Left = 384
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Ende'
    TabOrder = 2
    OnClick = EndeClick
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 8
    Width = 1000
    Height = 282
    DataSource = DataSource1
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Persist Security Info=False;Data Source=zoll3' +
      '2'
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 512
    Top = 16
  end
  object DataSource1: TDataSource
    Left = 520
    Top = 128
  end
  object ADOQuery1: TADOQuery
    Parameters = <>
    Left = 496
    Top = 200
  end
end
