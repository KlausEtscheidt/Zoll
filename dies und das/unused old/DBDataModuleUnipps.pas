unit DBDataModuleUnipps;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TDataModuleUnipps = class(TDataModule)
    ADOConnectionUniPPS: TADOConnection;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  DataModuleUnipps: TDataModuleUnipps;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
