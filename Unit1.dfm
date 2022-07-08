object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 186
  ClientWidth = 418
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
    Left = 32
    Top = 56
    Width = 89
    Height = 13
    Caption = 'Id Kundenauftrag:'
  end
  object Run_Btn: TButton
    Left = 176
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Auswerten'
    TabOrder = 0
    OnClick = Run_BtnClick
  end
  object KA_id_ctrl: TEdit
    Left = 152
    Top = 56
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object Ende_Btn: TButton
    Left = 176
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Ende'
    TabOrder = 2
    OnClick = Ende_BtnClick
  end
end
