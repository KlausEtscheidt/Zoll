unit DatenModul;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient;

type
  TDataModule1 = class(TDataModule)
    CDSBestellung: TClientDataSet;
    CDSBestellungbestell_id: TIntegerField;
    CDSBestellungbestell_datum: TDateField;
    CDSBestellungpreis: TFloatField;
    CDSStueliPOs: TClientDataSet;
    CDSTeil: TClientDataSet;
    CDSStueliPOspos_nr: TIntegerField;
    CDSStueliPOsPosTyp: TStringField;
    CDSStueliPOsid_stu: TStringField;
    CDSStueliPOst_tg_nr: TStringField;
    CDSStueliPOsunipps_typ: TStringField;
    CDSTeilt_tg_nr: TStringField;
    CDSTeiloa: TIntegerField;
    CDSTeilbesch_art: TIntegerField;
    CDSTeilunipps_typ: TStringField;
    CDSTeilpraeferenzkennung: TIntegerField;
    CDSTeilsme: TIntegerField;
    CDSTeilfaktlme_sme: TFloatField;
    CDSTeillme: TIntegerField;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
