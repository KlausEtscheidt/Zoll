object LieferantenStatusFrm: TLieferantenStatusFrm
  Left = 0
  Top = 0
  Width = 803
  Height = 445
  TabOrder = 0
  object GroupBox1: TGroupBox
    Left = 16
    Top = 12
    Width = 729
    Height = 53
    Caption = 'Filter'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label2: TLabel
      Left = 24
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
      Left = 232
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
      Left = 93
      Top = 18
      Width = 121
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnChange = FilterKurznameChange
    end
    object FilterName: TEdit
      Left = 271
      Top = 18
      Width = 172
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnChange = FilterNameChange
    end
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 96
    Width = 729
    Height = 193
    Caption = 'gefiltert'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 24
      Top = 24
      Width = 664
      Height = 161
      DataSource = DataSource1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
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
          ReadOnly = True
          Title.Caption = 'Kurzname'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'LName1'
          ReadOnly = True
          Title.Caption = 'Name1'
          Width = 220
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'LName2'
          ReadOnly = True
          Title.Caption = 'Name2'
          Width = 150
          Visible = True
        end>
    end
  end
  object GroupBox3: TGroupBox
    Left = 16
    Top = 312
    Width = 721
    Height = 113
    Caption = 'gew'#228'hlt'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object DBText2: TDBText
      Left = 321
      Top = 56
      Width = 217
      Height = 17
      DataField = 'LName2'
      DataSource = DataSource1
    end
    object Label8: TLabel
      Left = 201
      Top = 79
      Width = 116
      Height = 14
      Caption = 'Lieferantenerkl'#228'rung:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 21
      Top = 79
      Width = 94
      Height = 14
      Caption = 'zuletzt ge'#228'ndert:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 21
      Top = 56
      Width = 35
      Height = 14
      Caption = 'Name:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 129
      Top = 33
      Width = 57
      Height = 14
      Caption = 'Kurzname:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 21
      Top = 33
      Width = 15
      Height = 14
      Caption = 'Id:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object DBText4: TDBText
      Left = 121
      Top = 80
      Width = 82
      Height = 13
      DataField = 'Stand'
      DataSource = DataSource1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object DBText3: TDBText
      Left = 337
      Top = 80
      Width = 81
      Height = 13
      DataField = 'Status'
      DataSource = DataSource1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object DBText1: TDBText
      Left = 65
      Top = 56
      Width = 233
      Height = 13
      DataField = 'LName1'
      DataSource = DataSource1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object LKurznameTxt: TDBText
      Left = 209
      Top = 33
      Width = 130
      Height = 17
      DataField = 'LKurzname'
      DataSource = DataSource1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object IDLieferantTxt: TDBText
      Left = 57
      Top = 33
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
    object StatusBtn: TButton
      Left = 544
      Top = 25
      Width = 73
      Height = 25
      Caption = 'Status'
      TabOrder = 0
    end
    object TeileBtn: TButton
      Left = 544
      Top = 72
      Width = 73
      Height = 25
      Hint = 'Pr'#228'ferenz f'#252'r einzelne Teile eingeben'
      Caption = 'Teile'
      TabOrder = 1
      OnClick = TeileBtnClick
    end
  end
  object ADOQuery1: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select *,Status from lieferanten join LieferantenStatus'
      'on LieferantenStatus.id=lieferanten .lekl'
      'order by LKurzname;')
    Left = 496
    Top = 16
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 560
    Top = 16
  end
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 'Provider=MSDASQL.1;Persist Security Info=False;Data Source=lekl'
    LoginPrompt = False
    Left = 384
    Top = 8
  end
end
