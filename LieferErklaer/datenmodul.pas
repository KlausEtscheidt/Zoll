unit datenmodul;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TDataModule1 = class(TDataModule)
    Erklaerung: TDataSource;
    ADOQuery1: TADOQuery;
    ADOQuery1TeileNr: TWideStringField;
    ADOQuery1TName1: TWideStringField;
    ADOQuery1TName2: TWideStringField;
    ADOQuery1PFK: TIntegerField;
    ADOConnection1: TADOConnection;
    ADOQuery2: TADOQuery;
    LieferantenDQuelle: TDataSource;
    ADOQuery2IdLieferant: TIntegerField;
    ADOQuery2eingelesen: TDateTimeField;
    ADOQuery3: TADOQuery;
    ADOQuery2LKurzname: TStringField;
    ADOQuery2LName1: TStringField;
    ADOQuery2LName2: TStringField;
    ADOQuery3Id: TIntegerField;
    ADOQuery3Status: TStringField;
    LStatusDQuelle: TDataSource;
    ADOQuery2lekl: TIntegerField;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses mainfrm;

{$R *.dfm}

end.
