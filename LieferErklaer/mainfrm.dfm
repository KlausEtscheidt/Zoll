object mainForm: TmainForm
  Left = 0
  Top = 0
  Caption = 'mainForm'
  ClientHeight = 562
  ClientWidth = 847
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesigned
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 543
    Width = 847
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  inline LieferantenStatusFrm1: TLieferantenStatusFrm
    Left = 0
    Top = 0
    Width = 803
    Height = 445
    TabOrder = 1
    Visible = False
  end
  inline LieferantenErklaerungenFrm1: TLieferantenErklaerungenFrm
    Left = 8
    Top = 8
    Width = 719
    Height = 466
    TabOrder = 2
    ExplicitLeft = 8
    ExplicitTop = 8
    inherited Button1: TButton
      OnClick = LieferantenErklaerungenFrm1Button1Click
    end
  end
  object MainMenu1: TMainMenu
    Left = 488
    object DateiMen: TMenuItem
      Caption = 'Datei'
      object DateiMenEnde: TMenuItem
        Caption = 'Ende'
        OnClick = FormDestroy
      end
    end
    object UnippsMen: TMenuItem
      Caption = 'Unipps'
      object UnippsMenEinlesen: TMenuItem
        Caption = 'Einlesen'
        OnClick = UnippsMenEinlesenClick
      end
    end
    object LieferantenMen: TMenuItem
      Caption = 'Lieferanten'
      object LMenStatus: TMenuItem
        Caption = 'Status'
        OnClick = LMenStatusClick
      end
      object LMenErklaer: TMenuItem
        Caption = 'Erkl'#228'rungen'
        OnClick = LMenErklaerClick
      end
    end
  end
end
