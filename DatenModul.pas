unit DatenModul;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient, PumpenDataSet;

type
  TDataModule1 = class(TDataModule)
    StueliPosDS: TWDataSet;
    StueliPosDSid_stu: TStringField;
    StueliPosDSpos_nr: TIntegerField;
    StueliPosDSoa: TIntegerField;
    StueliPosDSbesch_art: TIntegerField;
    StueliPosDSmenge: TFloatField;
    StueliPosDSFA_Nr: TStringField;
    StueliPosDSid_pos: TIntegerField;
    StueliPosDSverurs_art: TIntegerField;
    StueliPosDSueb_s_nr: TIntegerField;
    StueliPosDSds: TIntegerField;
    StueliPosDSset_block: TIntegerField;
    StueliPosDSPosTyp: TStringField;
    TeilDS: TWDataSet;
    BestellungDS: TWDataSet;
    BestellungDSbestell_id: TIntegerField;
    BestellungDSbestell_datum: TDateTimeField;
    StueliPosDSstu_t_tg_nr: TStringField;
    StueliPosDSunipps_typ: TStringField;
    TeilDSBezeichnung: TStringField;
    TeilDSPreisJeLME: TFloatField;
    TeilDSPreisNonEU: TFloatField;
    TeilDSPreisEU: TFloatField;
    BestellungDSbest_t_tg_nr: TStringField;
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
