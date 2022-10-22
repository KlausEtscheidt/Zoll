object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 511
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
    Top = 492
    Width = 847
    Height = 19
    Panels = <>
    ExplicitLeft = 584
    ExplicitTop = 480
    ExplicitWidth = 0
  end
  object PageContol1: TPageControl
    Left = 0
    Top = 0
    Width = 847
    Height = 497
    ActivePage = LieferantenTab
    TabOrder = 1
    object StatusTab: TTabSheet
      Caption = 'Status'
      ImageIndex = 1
    end
    object LieferantenTab: TTabSheet
      Caption = 'Lieferanten'
      ImageIndex = 1
      inline LieferantenFrame: TLieferanten
        Left = 0
        Top = 0
        Width = 719
        Height = 383
        TabOrder = 0
        inherited DBNavigator1: TDBNavigator
          Hints.Strings = ()
        end
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 488
    object Datei1: TMenuItem
      Caption = 'Datei'
      object Ende1: TMenuItem
        Caption = 'Ende'
        OnClick = FormDestroy
      end
    end
    object Unipps1: TMenuItem
      Caption = 'Unipps'
      object UnippsEinlesen: TMenuItem
        Caption = 'Einlesen'
        OnClick = UnippsEinlesenClick
      end
    end
  end
end
