object LeklStatusFrm: TLeklStatusFrm
  Left = 0
  Top = 0
  Width = 1099
  Height = 593
  HelpType = htKeyword
  HelpKeyword = 'LieferantenStatus'
  ParentBackground = False
  PopupMenu = PopupMenu1
  TabOrder = 0
  object Label20: TLabel
    Left = 6
    Top = 12
    Width = 224
    Height = 19
    HelpType = htKeyword
    HelpKeyword = 'Lieferanten-Status'
    Caption = 'Lieferantenstatus eingeben'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object GroupBox1: TGroupBox
    Left = 5
    Top = 44
    Width = 1076
    Height = 72
    Caption = 'Filter'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label2: TLabel
      Left = 46
      Top = 18
      Width = 63
      Height = 16
      Caption = 'Kurz-Name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 254
      Top = 18
      Width = 33
      Height = 16
      Caption = 'Name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object FilterKurzname: TEdit
      Left = 115
      Top = 14
      Width = 121
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnChange = FilterUpdateActionExecute
    end
    object FilterName: TEdit
      Left = 293
      Top = 14
      Width = 172
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnChange = FilterUpdateActionExecute
    end
    object FilterAusBtn: TButton
      Left = 487
      Top = 14
      Width = 25
      Height = 25
      Hint = 'Filter Kurz-Name und Name leeren'
      DisabledImageIndex = 0
      HotImageIndex = 0
      ImageIndex = 0
      ImageMargins.Left = 2
      ImageMargins.Top = 2
      Images = ImageList1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = FilterAusBtnClick
    end
    object GeantwortetChkBox: TCheckBox
      Left = 536
      Top = 14
      Width = 112
      Height = 25
      Hint = 'Lieferanten, deren Antwort schon erfasst wurde'
      Action = FilterUpdateAction
      Caption = 'Antwort erfasst'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
    object NGeantwortetChkBox: TCheckBox
      Left = 664
      Top = 14
      Width = 105
      Height = 25
      Hint = 'Lieferanten, deren Antwort noch nicht erfasst wurde'
      Action = FilterUpdateAction
      Caption = 'keine Antwort'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 4
    end
  end
  object GroupBox2: TGroupBox
    Left = 5
    Top = 122
    Width = 1076
    Height = 231
    HelpType = htKeyword
    HelpKeyword = 'LieferantenStatus'
    Caption = 'gefiltert'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 62
      Top = 29
      Width = 939
      Height = 188
      DataSource = DataSource1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      PopupMenu = PopupMenu1
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -15
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
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
          FieldName = 'letzteAnfrage'
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Stand'
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'StatusTxt'
          Title.Caption = 'Status'
          Width = 160
          Visible = True
        end>
    end
  end
  object GroupBox3: TGroupBox
    Left = 23
    Top = 388
    Width = 1076
    Height = 202
    Caption = 'gew'#228'hlt'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object Label12: TLabel
      Left = 423
      Top = 28
      Width = 89
      Height = 14
      Caption = 'Lief.-Erkl'#228'rung'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object AdressUebLabel: TLabel
      Left = 10
      Top = 26
      Width = 48
      Height = 14
      Caption = 'Adresse'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label16: TLabel
      Left = 883
      Top = 46
      Width = 77
      Height = 14
      Caption = 'aktualisieren'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object IDLieferantTxt: TDBText
      Left = 64
      Top = 3
      Width = 49
      Height = 17
      DataField = 'IdLieferant'
      DataSource = DataSource1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object LKurznameTxt: TDBText
      Left = 130
      Top = 3
      Width = 130
      Height = 17
      DataField = 'LKurzname'
      DataSource = DataSource1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label13: TLabel
      Left = 883
      Top = 26
      Width = 41
      Height = 14
      Caption = 'Status'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label11: TLabel
      Left = 400
      Top = 144
      Width = 74
      Height = 18
      Margins.Left = 15
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Kommentar:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 652
      Top = 27
      Width = 50
      Height = 14
      Caption = 'Kontakt'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object StatusBtn: TButton
      Left = 883
      Top = 78
      Width = 64
      Height = 25
      Action = StatusUpdateAction
      TabOrder = 0
    end
    object Panel1b: TPanel
      Left = 70
      Top = 48
      Width = 275
      Height = 121
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      object DBText1: TDBText
        Left = 0
        Top = 0
        Width = 275
        Height = 18
        Align = alTop
        DataField = 'name1'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = 2
        ExplicitTop = 20
        ExplicitWidth = 181
      end
      object DBText2: TDBText
        Left = 0
        Top = 18
        Width = 275
        Height = 18
        Align = alTop
        DataField = 'name2'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = -17
        ExplicitTop = 24
        ExplicitWidth = 154
      end
      object PlzDBText: TDBText
        Left = 0
        Top = 36
        Width = 275
        Height = 18
        Align = alTop
        DataField = 'plz_haus'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = 2
        ExplicitTop = 57
        ExplicitWidth = 181
      end
      object OrtDBText: TDBText
        Left = 0
        Top = 54
        Width = 275
        Height = 18
        Align = alTop
        DataField = 'ort'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitTop = 40
        ExplicitWidth = 154
      end
      object StrasseDBText: TDBText
        Left = 0
        Top = 72
        Width = 275
        Height = 18
        Align = alTop
        DataField = 'strasse'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitTop = 66
        ExplicitWidth = 154
      end
      object StaatDBText: TDBText
        Left = 0
        Top = 90
        Width = 275
        Height = 18
        Align = alTop
        DataField = 'staat'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitTop = 80
        ExplicitWidth = 154
      end
    end
    object Panel1: TPanel
      Left = 17
      Top = 48
      Width = 48
      Height = 129
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 2
      object Label6: TLabel
        Left = 0
        Top = 0
        Width = 48
        Height = 18
        Margins.Left = 15
        Margins.Top = 5
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Name:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label4: TLabel
        Left = 0
        Top = 36
        Width = 48
        Height = 18
        Margins.Left = 15
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Plz:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitTop = 32
      end
      object ortlabel: TLabel
        Left = 0
        Top = 54
        Width = 48
        Height = 18
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Ort:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 0
        Top = 72
        Width = 48
        Height = 18
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Strasse:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitTop = 64
      end
      object dummy: TLabel
        Left = 0
        Top = 18
        Width = 48
        Height = 18
        Margins.Left = 15
        Margins.Top = 5
        Align = alTop
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitTop = 14
      end
      object staatlbl: TLabel
        Left = 0
        Top = 90
        Width = 48
        Height = 18
        Margins.Left = 15
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Staat:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitTop = 96
      end
    end
    object Panel2: TPanel
      Left = 376
      Top = 48
      Width = 73
      Height = 73
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 3
      object Label3: TLabel
        Left = 0
        Top = 50
        Width = 73
        Height = 18
        Margins.Left = 15
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'erfasst:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = 80
        ExplicitTop = 42
        ExplicitWidth = 112
      end
      object giltbislbl: TLabel
        Left = 0
        Top = 18
        Width = 73
        Height = 18
        Margins.Left = 15
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'gilt bis:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitTop = 14
        ExplicitWidth = 112
      end
      object Label9: TLabel
        Left = 0
        Top = 0
        Width = 73
        Height = 18
        Margins.Left = 15
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Status:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 112
      end
      object Label7: TLabel
        Left = 0
        Top = 36
        Width = 73
        Height = 14
        Margins.Left = 15
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'angefragt:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = 15
        ExplicitWidth = 97
      end
    end
    object Panel3: TPanel
      Left = 455
      Top = 48
      Width = 82
      Height = 89
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 4
      object Status: TDBText
        Left = 0
        Top = 0
        Width = 82
        Height = 18
        Align = alTop
        DataField = 'StatusTxt'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = 31
        ExplicitTop = 43
        ExplicitWidth = 81
      end
      object giltBisDBText: TDBText
        Left = 0
        Top = 18
        Width = 82
        Height = 18
        Align = alTop
        DataField = 'gilt_bis'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = 30
        ExplicitTop = 60
      end
      object letzteAbfrageDBText: TDBText
        Left = 0
        Top = 36
        Width = 82
        Height = 18
        Align = alTop
        DataField = 'letzteAnfrage'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitTop = 42
        ExplicitWidth = 66
      end
      object StandDBText: TDBText
        Left = 0
        Top = 54
        Width = 82
        Height = 18
        Align = alTop
        DataField = 'Stand'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = 30
        ExplicitTop = 71
      end
    end
    object DBMemo2: TDBMemo
      Left = 480
      Top = 143
      Width = 584
      Height = 51
      DataField = 'Kommentar'
      DataSource = DataSource1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object Panel4: TPanel
      Left = 560
      Top = 48
      Width = 65
      Height = 89
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 6
      object Label14: TLabel
        Left = 0
        Top = 18
        Width = 65
        Height = 18
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'mail:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitTop = 12
        ExplicitWidth = 41
      end
      object Label15: TLabel
        Left = 0
        Top = 0
        Width = 65
        Height = 18
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Fax:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitTop = 54
        ExplicitWidth = 41
      end
      object Label17: TLabel
        Left = 0
        Top = 72
        Width = 65
        Height = 18
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Nachname:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitTop = 26
        ExplicitWidth = 41
      end
      object Label18: TLabel
        Left = 0
        Top = 36
        Width = 65
        Height = 18
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Anrede:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitTop = 44
        ExplicitWidth = 41
      end
      object Label19: TLabel
        Left = 0
        Top = 54
        Width = 65
        Height = 18
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Vorname:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitTop = 62
        ExplicitWidth = 41
      end
    end
    object Panel6: TPanel
      Left = 631
      Top = 48
      Width = 258
      Height = 89
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 7
      object mailDBText: TDBText
        Left = 0
        Top = 18
        Width = 258
        Height = 18
        Align = alTop
        DataField = 'email'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = -29
        ExplicitTop = 43
        ExplicitWidth = 165
      end
      object telefaxDBText: TDBText
        Left = 0
        Top = 0
        Width = 258
        Height = 18
        Align = alTop
        DataField = 'telefax'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitTop = -1
      end
      object NachnameDBText: TDBText
        Left = 0
        Top = 72
        Width = 258
        Height = 18
        Align = alTop
        DataField = 'Nachname'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitTop = 26
      end
      object AnredeDBText: TDBText
        Left = 0
        Top = 36
        Width = 258
        Height = 18
        Align = alTop
        DataField = 'Anrede'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitTop = 44
      end
      object VornameDBText: TDBText
        Left = 0
        Top = 54
        Width = 258
        Height = 18
        Align = alTop
        DataField = 'Vorname'
        DataSource = DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitTop = 62
      end
    end
  end
  object DataSource1: TDataSource
    Left = 640
    Top = 200
  end
  object ImageList1: TImageList
    ShareImages = True
    Left = 368
    Top = 272
    Bitmap = {
      494C010102000800040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      000000000000090909004B4B4B00484848000404040000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      000000000000090909004B4B4B00484848000404040000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      0000000000004F4F4F00E1E1E100ADADAD002020200000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000004F4F4F00E1E1E100ADADAD002020200000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00000000004B4B4B00FAFAFA008B8B8B001F1F1F00000000000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000004B4B4B00FAFAFA008B8B8B001F1F1F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF004B4B4B00EDEDED007C7C7C001F1F1F000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000004B4B4B00EDEDED007C7C7C001F1F1F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF00D9D9D900838383000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000047474700D9D9D900838383002525250000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000033333300AAAAAA00E7E7E700999999005C5C5C001C1C1C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF00202020000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000AFAFAF00FCFCFC00E5E5E500ACACAC008C8C8C0052525200202020000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000040404003636
      3600F3F3F3000000FF000000FF000000FF000000FF00808080005C5C5C002525
      2500000000000000000000000000000000000000000000000000040404003636
      3600F3F3F300EAEAEA00C0C0C0009D9D9D009D9D9D00808080005C5C5C002525
      2500000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000010101000A0A0A002D2D2D007777
      77000000FF000000FF000000FF000000FF000000FF000000FF007D7D7D005353
      530008080800010101000000000000000000010101000A0A0A002D2D2D007777
      77006E6E6E00666666006A6A6A0073737300828282008D8D8D007D7D7D005353
      5300080808000101010000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000151515003E3E3E006E6E6E008080
      80000000FF000000FF000000FF000000FF000000FF000000FF000000FF008888
      880036363600131313000000000000000000151515003E3E3E006E6E6E008080
      8000909090009C9C9C00AAAAAA00BEBEBE00D3D3D300DADADA00B5B5B5008888
      8800363636001313130000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000065656500A7A7A7000000FF000000
      FF000000FF00A8A8A800B8B8B800D1D1D100E8E8E8000000FF000000FF000000
      FF00A8A8A80058585800000000000000000065656500A7A7A700A6A6A6009797
      9700A3A3A300A8A8A800B8B8B800D1D1D100E8E8E800FAFAFA00EAEAEA00D4D4
      D400A8A8A8005858580000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000474747000000FF000000FF000000
      FF00A6A6A600A7A7A700B2B2B200CBCBCB00E2E2E200F7F7F7000000FF000000
      FF000000FF00424242000000000000000000474747007D7D7D00A0A0A0009999
      9900A6A6A600A7A7A700B2B2B200CBCBCB00E2E2E200F7F7F700F6F6F600DDDD
      DD007B7B7B004242420000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00A5A5A500ADADAD00B3B3B300CCCCCC00E2E2E200EFEFEF00D9D9D9000000
      FF000000FF000000FF0000000000000000000F0F0F0037373700666666007575
      7500A5A5A500ADADAD00B3B3B300CCCCCC00E2E2E200EFEFEF00D9D9D9009C9C
      9C00373737000E0E0E0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF002B2B
      2B00606060006666660068686800767676008282820087878700757575003B3B
      3B000000FF000000FF000000FF000000000001010100050505000F0F0F002B2B
      2B00606060006666660068686800767676008282820087878700757575003B3B
      3B00050505000101010000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF000000007FFFFFFF00000000
      3873F87F000000001871F87F000000008847F87F00000000C00FF87F00000000
      E00FF87F00000000F01FF03F00000000F01FF01F00000000C00FC00F00000000
      0003000300000000000300030000000000030003000000000003000300000000
      0003000300000000000100030000000000000000000000000000000000000000
      000000000000}
  end
  object ActionList1: TActionList
    Left = 472
    Top = 240
    object StatusUpdateAction: TAction
      Category = 'Button'
      Caption = 'Status'
      OnExecute = StatusUpdateActionExecute
    end
    object ExportExcelAction: TAction
      Category = 'PopUpMen'
      Caption = 'ExportExcel'
      OnExecute = ExportExcelActionExecute
    end
    object FilterUpdateAction: TAction
      Caption = 'FilterUpdate'
      OnExecute = FilterUpdateActionExecute
      OnUpdate = FilterUpdateActionUpdate
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 432
    Top = 16
    object TeileAnzeigeMen: TMenuItem
      Caption = 'Teile Anzeige'
    end
    object ListenExcelMen: TMenuItem
      Action = ExportExcelAction
      Caption = 'Excel-Export'
    end
    object AnforderungResetMen: TMenuItem
      Caption = 'Anfrage-Datum zur'#252'ck setzen'
    end
    object AnforderungHeuteMen: TMenuItem
      Caption = 'Anfrage-Datum heute'
    end
  end
end
