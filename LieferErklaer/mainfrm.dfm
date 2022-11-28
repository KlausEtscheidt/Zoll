object mainForm: TmainForm
  Left = 0
  Top = 0
  Caption = 'mainForm'
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
    TabOrder = 3
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
    TabOrder = 4
    Visible = False
    ExplicitLeft = 524
    ExplicitTop = 475
    ExplicitWidth = 403
    ExplicitHeight = 72
  end
  inline LieferantenErklaerungenFrm1: TLieferantenErklaerungenFrm
    Left = 0
    Top = 0
    Width = 1094
    Height = 593
    Align = alClient
    TabOrder = 2
    Visible = False
    ExplicitWidth = 1094
    ExplicitHeight = 593
    inherited Label1: TLabel
      Left = 10
      Top = 7
      ExplicitLeft = 10
      ExplicitTop = 7
    end
    inherited LKurznameLbl: TLabel
      Left = 90
      Top = 12
      ExplicitLeft = 90
      ExplicitTop = 12
    end
    inherited IdLieferantLbl: TLabel
      Left = 178
      Top = 12
      ExplicitLeft = 178
      ExplicitTop = 12
    end
    inherited LabelSort: TLabel
      Left = 14
      Top = 30
      ExplicitLeft = 14
      ExplicitTop = 30
    end
    inherited LabelFiltern: TLabel
      Left = 14
      Top = 83
      ExplicitLeft = 14
      ExplicitTop = 83
    end
    inherited DBCtrlGrid1: TDBCtrlGrid
      Left = 11
      Height = 350
      PanelHeight = 43
      ExplicitLeft = 11
      ExplicitHeight = 350
    end
    inherited BackBtn: TButton
      Left = 270
      Top = 535
      Height = 29
      OnClick = LieferantenErklaerungenFrm1Button1Click
      ExplicitLeft = 270
      ExplicitTop = 535
      ExplicitHeight = 29
    end
    inherited SortLTeileNrBtn: TButton
      Left = 372
      Top = 52
      ExplicitLeft = 372
      ExplicitTop = 52
    end
    inherited SortTeilenrBtn: TButton
      Left = 23
      Top = 52
      ExplicitLeft = 23
      ExplicitTop = 52
    end
    inherited SortLTNameBtn: TButton
      Left = 174
      Top = 52
      ExplicitLeft = 174
      ExplicitTop = 52
    end
    inherited FilterTeileNr: TEdit
      Left = 22
      Top = 104
      ExplicitLeft = 22
      ExplicitTop = 104
    end
    inherited FilterTName1: TEdit
      Left = 173
      Top = 104
      ExplicitLeft = 173
      ExplicitTop = 104
    end
    inherited FilterLTeileNr: TEdit
      Left = 372
      Top = 104
      Width = 106
      ExplicitLeft = 372
      ExplicitTop = 104
      ExplicitWidth = 106
    end
    inherited FilterTName2: TEdit
      Left = 173
      Top = 131
      ExplicitLeft = 173
      ExplicitTop = 131
    end
    inherited FilterOffBtn: TButton
      Left = 503
      Top = 100
      DisabledImages = LieferantenErklaerungenFrm1.ImageList1
      ExplicitLeft = 503
      ExplicitTop = 100
    end
  end
  inline LieferantenErklAnfordernFrm1: TLieferantenErklAnfordernFrm
    Left = -5
    Top = 0
    Width = 1099
    Height = 636
    ParentBackground = False
    TabOrder = 5
    ExplicitLeft = -5
    inherited GroupBox1: TGroupBox
      Left = 10
      ExplicitLeft = 10
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
      inherited Hauptdaten: TPanel
        Height = 120
        ExplicitHeight = 120
        inherited OrtDBText: TDBText
          Top = 72
          ExplicitTop = 77
        end
        inherited StrasseDBText: TDBText
          Top = 54
        end
      end
      inherited Panel1: TPanel
        Height = 120
        ExplicitHeight = 120
        inherited Label6: TLabel
          Margins.Left = 0
          Margins.Top = 3
          AutoSize = False
        end
        inherited Label4: TLabel
          Margins.Left = 0
          AutoSize = False
        end
        inherited ortlabel: TLabel
          Top = 72
          Margins.Left = 0
          AutoSize = False
          ExplicitTop = 60
        end
        inherited Label5: TLabel
          Top = 54
          Margins.Left = 0
          AutoSize = False
        end
        inherited dummy: TLabel
          Margins.Left = 0
          Margins.Top = 3
          AutoSize = False
          ExplicitWidth = 41
        end
        inherited staatlbl: TLabel
          ExplicitTop = 88
        end
      end
      inherited Panel2: TPanel
        inherited Label3: TLabel
          Top = 54
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
  inline LieferantenStatusFrm1: TLieferantenStatusFrm
    Left = 0
    Top = 0
    Width = 1094
    Height = 593
    Align = alClient
    ParentBackground = False
    TabOrder = 1
    ExplicitWidth = 1094
    ExplicitHeight = 593
    inherited Label11: TLabel
      Width = 341
      Caption = 'Teilespez. Lieferantenerkl'#228'rung eingeben'
      ExplicitWidth = 341
    end
    inherited GroupBox1: TGroupBox
      Width = 956
      ExplicitWidth = 956
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
      inherited OffeneChkBox: TCheckBox
        Left = 641
        Top = 19
        ExplicitLeft = 641
        ExplicitTop = 19
      end
    end
    inherited GroupBox2: TGroupBox
      Width = 956
      Height = 263
      ExplicitWidth = 956
      ExplicitHeight = 263
      inherited DBGrid1: TDBGrid
        Width = 691
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
            Expanded = False
            FieldName = 'gilt_bis'
            Title.Alignment = taCenter
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Stand'
            Title.Alignment = taCenter
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'StandTeile'
            Visible = True
          end>
      end
    end
    inherited GroupBox3: TGroupBox
      Width = 956
      ExplicitWidth = 956
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
      object UnippsMenAuswerten: TMenuItem
        Caption = 'Auswerten'
        OnClick = UnippsMenAuswertenClick
      end
      object UnippsMenLAdressen: TMenuItem
        Caption = 'LAdressen'
        OnClick = UnippsMenLAdressenClick
      end
    end
    object LieferantenMen: TMenuItem
      Caption = 'Lieferanten'
      object LMenStatus: TMenuItem
        Caption = 'Status'
        OnClick = LMenStatusClick
      end
      object Leklanfordern1: TMenuItem
        Caption = 'Lekl anfordern'
        OnClick = Leklanfordern1Click
      end
    end
    object TeileMen: TMenuItem
      Caption = 'Teile'
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
