unit datenmodul;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TDataModule1 = class(TDataModule)
    Erklaerung: TDataSource;
    ADOQuery1: TADOQuery;
    ADOConnection1: TADOConnection;
    ADOQuery2: TADOQuery;
    LieferantenDQuelle: TDataSource;
    ADOQuery1IdLieferant: TIntegerField;
    ADOQuery1TeileNr: TStringField;
    ADOQuery1LTeileNr: TStringField;
    ADOQuery1LPfk: TIntegerField;
    ADOQuery1Stand: TDateTimeField;
    ADOQuery1BestDatum: TDateTimeField;
    ADOQuery1TeileNr_1: TStringField;
    ADOQuery1TName1: TStringField;
    ADOQuery1TName2: TStringField;
    ADOQuery1Pumpenteil: TIntegerField;
    ADOQuery1PFK: TIntegerField;
    ADOQuery1TName1_1: TStringField;
    ADOQuery1TName2_1: TStringField;
    ADOQuery1Pumpenteil_1: TIntegerField;
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
