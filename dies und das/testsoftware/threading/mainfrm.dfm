object mainForm: TmainForm
  Left = 0
  Top = 0
  Caption = 'Thread Test'
  ClientHeight = 336
  ClientWidth = 526
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 112
    Top = 48
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object StartBtn: TButton
    Left = 64
    Top = 160
    Width = 97
    Height = 41
    Caption = 'Start'
    TabOrder = 0
    OnClick = StartBtnClick
  end
  object EndeBtn: TButton
    Left = 288
    Top = 160
    Width = 97
    Height = 41
    Caption = 'Ende'
    TabOrder = 1
    OnClick = EndeBtnClick
  end
  object Edit1: TEdit
    Left = 248
    Top = 45
    Width = 65
    Height = 21
    TabOrder = 2
    Text = '10'
  end
  object StopBtn: TButton
    Left = 176
    Top = 160
    Width = 97
    Height = 41
    Caption = 'Stop'
    TabOrder = 3
    OnClick = StopBtnClick
  end
end
