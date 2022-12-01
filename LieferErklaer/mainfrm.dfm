object mainForm: TmainForm
  Left = 0
  Top = 0
  Caption = 'LEKL'
  ClientHeight = 612
  ClientWidth = 1094
  Color = clGradientActiveCaption
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
  DesignSize = (
    1094
    612)
  PixelsPerInch = 96
  TextHeight = 13
  inline LieferantenStatusFrm1: TLieferantenStatusFrm
    Left = 0
    Top = 0
    Width = 1094
    Height = 593
    Align = alClient
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 1094
    ExplicitHeight = 593
    inherited GroupBox1: TGroupBox
      Width = 828
      ExplicitWidth = 828
      inherited Label2: TLabel
        Left = 18
        Top = 23
        ExplicitLeft = 18
        ExplicitTop = 23
      end
      inherited Label1: TLabel
        Left = 215
        Top = 23
        ExplicitLeft = 215
        ExplicitTop = 23
      end
      inherited FilterKurzname: TEdit
        Left = 87
        Top = 19
        ExplicitLeft = 87
        ExplicitTop = 19
      end
      inherited FilterName: TEdit
        Left = 254
        Top = 19
        ExplicitLeft = 254
        ExplicitTop = 19
      end
      inherited FilterAusBtn: TButton
        Left = 438
        Top = 18
        ExplicitLeft = 438
        ExplicitTop = 18
      end
      inherited LeklUpdatedChkBox: TCheckBox
        Left = 514
        Top = 18
        ExplicitLeft = 514
        ExplicitTop = 18
      end
      inherited UnbearbeiteteCheckBox: TCheckBox
        Left = 653
        Top = 18
        Width = 140
        ExplicitLeft = 653
        ExplicitTop = 18
        ExplicitWidth = 140
      end
    end
    inherited GroupBox2: TGroupBox
      Width = 828
      Height = 263
      ExplicitWidth = 828
      ExplicitHeight = 263
      inherited DBGrid1: TDBGrid
        Left = 87
        Top = 22
        Width = 594
        Height = 220
        Columns = <
          item
            Expanded = False
            FieldName = 'LKurzname'
            Title.Caption = 'Kurzname'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LName1'
            Title.Caption = 'Name1'
            Width = 240
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'gilt_bis'
            Title.Alignment = taCenter
            Width = 70
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'Stand'
            Title.Alignment = taCenter
            Width = 70
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'StandTeile'
            Width = 70
            Visible = True
          end>
      end
    end
    inherited GroupBox3: TGroupBox
      Width = 828
      ExplicitWidth = 828
      inherited Panel3: TPanel
        inherited Label6: TLabel
          Width = 325
        end
        inherited DBText1: TDBText
          ExplicitTop = 21
        end
        inherited DBText2: TDBText
          ExplicitTop = 41
        end
      end
    end
  end
  inline LieferantenErklAnfordernFrm1: TLieferantenErklAnfordernFrm
    Left = -5
    Top = 0
    Width = 1099
    Height = 576
    ParentBackground = False
    PopupMenu = LieferantenErklAnfordernFrm1.PopupMenu1
    TabOrder = 4
    ExplicitLeft = -5
    inherited GroupBox1: TGroupBox
      Left = 3
      Top = 37
      ExplicitLeft = 3
      ExplicitTop = 37
    end
    inherited GroupBox2: TGroupBox
      Left = 10
      ExplicitLeft = 10
      inherited DBGrid1: TDBGrid
        Columns = <
          item
            Expanded = False
            FieldName = 'LKurzname'
            Title.Caption = 'Kurzname'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'name1'
            Title.Caption = 'Name'
            Width = 220
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'gilt_bis'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'letzteAnfrage'
            Title.Caption = 'angefragt'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'telefax'
            Width = 125
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'email'
            Width = 200
            Visible = True
          end>
      end
    end
    inherited GroupBox3: TGroupBox
      Left = 10
      ExplicitLeft = 10
      inherited Panel1b: TPanel
        Height = 120
        ExplicitHeight = 120
        inherited OrtDBText: TDBText
          Top = 72
          ExplicitTop = 77
        end
        inherited StrasseDBText: TDBText
          Top = 54
          ExplicitTop = 54
        end
      end
      inherited Panel1: TPanel
        Height = 120
        ExplicitHeight = 120
        inherited Label6: TLabel
          Margins.Left = 0
          Margins.Top = 3
        end
        inherited Label4: TLabel
          Margins.Left = 0
        end
        inherited ortlabel: TLabel
          Top = 72
          Margins.Left = 0
          ExplicitTop = 64
        end
        inherited Label5: TLabel
          Top = 54
          Margins.Left = 0
          ExplicitTop = 46
        end
        inherited dummy: TLabel
          Margins.Left = 0
          Margins.Top = 3
        end
        inherited staatlbl: TLabel
          ExplicitTop = 90
        end
      end
      inherited Panel2: TPanel
        inherited Label3: TLabel
          Top = 54
          ExplicitTop = 54
        end
        inherited Label7: TLabel
          Height = 18
          ExplicitLeft = 0
          ExplicitWidth = 112
          ExplicitHeight = 18
        end
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 593
    Width = 1094
    Height = 19
    Panels = <
      item
        Text = 'Hallo'
        Width = 270
      end
      item
        Width = 50
      end>
  end
  inline GesamtStatusFrm1: TGesamtStatusFrm
    Left = 26
    Top = 125
    Width = 260
    Height = 231
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = True
    TabOrder = 1
    Visible = False
    ExplicitLeft = 26
    ExplicitTop = 125
    ExplicitWidth = 260
    ExplicitHeight = 231
    inherited Label1: TLabel
      Left = 0
      Top = 0
      ExplicitLeft = 0
      ExplicitTop = 0
    end
  end
  inline TeileFrm1: TTeileFrm
    Left = 524
    Top = 475
    Width = 403
    Height = 72
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = True
    TabOrder = 2
    Visible = False
    ExplicitLeft = 524
    ExplicitTop = 475
    ExplicitWidth = 403
    ExplicitHeight = 72
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
      object UnippsMenAuswerten: TMenuItem
        Caption = 'Auswerten'
        OnClick = UnippsMenAuswertenClick
      end
    end
    object LieferantenMen: TMenuItem
      Caption = 'Lieferanten'
      object LieferMenErklaerAnfordern: TMenuItem
        Caption = 'Erkl'#228'rungen anfordern'
        OnClick = LieferMenErklaerAnfordernClick
      end
      object LieferMenAdressen: TMenuItem
        Caption = 'Adressen neu lesen'
        OnClick = LieferMenAdressenClick
      end
    end
    object TeileMen: TMenuItem
      Caption = 'Teile'
      object LTeileMenStatus: TMenuItem
        Caption = 'Status eingeben'
        OnClick = LTeileMenStatusClick
      end
      object TeileMenUebersicht: TMenuItem
        Caption = #220'bersicht'
        OnClick = TeileMenUebersichtClick
      end
    end
    object StatusMen: TMenuItem
      Caption = 'Status'
      object StatusMenAnzeigen: TMenuItem
        Caption = 'Anzeigen'
        OnClick = StatusMenAnzeigenClick
      end
    end
  end
end
