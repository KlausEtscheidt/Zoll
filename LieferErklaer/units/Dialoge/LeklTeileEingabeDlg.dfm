object LeklTeileEingabeDialog: TLeklTeileEingabeDialog
  Left = 0
  Top = 0
  Caption = 'teilebezogener Ursprungsnachweis'
  ClientHeight = 572
  ClientWidth = 744
  Color = clGradientActiveCaption
  Constraints.MinWidth = 760
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inline LieferantenErklaerungenFrm1: TLieferantenErklaerungenFrm
    Left = 0
    Top = 0
    Width = 744
    Height = 531
    Align = alClient
    Color = clGradientActiveCaption
    ParentBackground = False
    ParentColor = False
    TabOrder = 0
    Visible = False
    ExplicitWidth = 744
    ExplicitHeight = 531
    inherited DBCtrlGrid1: TDBCtrlGrid
      Left = 23
      Anchors = [akLeft, akTop, akBottom]
      ExplicitLeft = 23
    end
  end
  object GridPanel1: TGridPanel
    Left = 0
    Top = 531
    Width = 744
    Height = 41
    Align = alBottom
    Caption = 'GridPanel1'
    ColumnCollection = <
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = OKBtn
        Row = 0
      end>
    RowCollection = <
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 1
    DesignSize = (
      744
      41)
    object OKBtn: TButton
      AlignWithMargins = True
      Left = 334
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'OK'
      Constraints.MaxHeight = 25
      Constraints.MaxWidth = 75
      Constraints.MinHeight = 25
      ModalResult = 1
      TabOrder = 0
    end
  end
end
