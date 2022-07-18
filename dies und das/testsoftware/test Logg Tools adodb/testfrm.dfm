object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 329
  ClientWidth = 567
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 40
    Top = 8
    Width = 425
    Height = 167
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'KUNDEN_ID'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ZU_AB_PROZ'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DATUM_VON'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DATUM_BIS'
        Visible = True
      end>
  end
  object Button1: TButton
    Left = 208
    Top = 181
    Width = 75
    Height = 25
    Caption = 'Run Query'
    TabOrder = 1
    OnClick = Button1Click
  end
  object RunTest: TButton
    Left = 208
    Top = 224
    Width = 75
    Height = 25
    Caption = 'Run Test'
    TabOrder = 2
    OnClick = RunTestClick
  end
  object Ende: TButton
    Left = 208
    Top = 264
    Width = 75
    Height = 25
    Caption = 'Ende'
    TabOrder = 3
    OnClick = EndeClick
  end
  object ADOQuery1: TADOQuery
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from kunde_zuab; ')
    Left = 512
    Top = 72
    object ADOQuery1KUNDEN_ID: TLargeintField
      FieldName = 'KUNDEN_ID'
    end
    object ADOQuery1ZU_AB_PROZ: TFloatField
      FieldName = 'ZU_AB_PROZ'
    end
    object ADOQuery1DATUM_VON: TFloatField
      FieldName = 'DATUM_VON'
    end
    object ADOQuery1DATUM_BIS: TFloatField
      FieldName = 'DATUM_BIS'
    end
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Persist Security Info=False;Data Source=SQLit' +
      'e3 Datasource'
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 512
    Top = 16
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 520
    Top = 128
  end
end
