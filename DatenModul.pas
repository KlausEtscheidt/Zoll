unit DatenModul;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient, PumpenDataSet,
  FireDAC.Comp.BatchMove.DataSet, FireDAC.Stan.Intf, FireDAC.Comp.BatchMove,
  FireDAC.Comp.BatchMove.Text;

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
    BestellungDSbest_t_tg_nr: TStringField;
    StueliPosDSPreisEU: TFloatField;
    StueliPosDSPreisNonEU: TFloatField;
    StueliPosDSSummeEU: TFloatField;
    StueliPosDSSummeNonEU: TFloatField;
    BestellungDSbasis: TFloatField;
    BestellungDSpme: TIntegerField;
    BestellungDSbme: TIntegerField;
    BestellungDSfaktlme_bme: TFloatField;
    BestellungDSfaktbme_pme: TFloatField;
    BestellungDSnetto_poswert: TFloatField;
    BestellungDSwe_menge: TFloatField;
    BestellungDSlieferant: TIntegerField;
    BestellungDSkurzname: TStringField;
    BestellungDSbest_menge: TFloatField;
    StueliPosDSvk_netto: TFloatField;
    StueliPosDSvk_brutto: TFloatField;
    StueliPosDSMengeTotal: TFloatField;
    StueliPosDSEbene: TIntegerField;
    StueliPosDSEbeneNice: TStringField;
    TeilDSid: TAutoIncField;
    BatchMoveTextWriter: TFDBatchMoveTextWriter;
    BatchMoveDSReader: TFDBatchMoveDataSetReader;
    BatchMove: TFDBatchMove;
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
