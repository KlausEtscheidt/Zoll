unit ImportFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Import;

type
  TImportFrm = class(TFrame)
    GridPanel1: TGridPanel;
    ImportBtn: TButton;
    Memo1: TMemo;
    procedure ImportBtnClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure ShowWarning;
  end;

implementation

{$R *.dfm}
procedure TImportFrm.ImportBtnClick(Sender: TObject);
begin
  TBasisImport.Create(False);
end;

procedure TImportFrm.ShowWarning();
const
  msg = 'Achtung: ' + #13 + #13
       + 'Dieser Vorgang dauert ca 5 Minuten!'
       + #13 + #13
       + 'Er sollte und muss genau EINMAL im Jahr,' + #13
       + 'zu Beginn der Eingabe der Lieferantenerklärungen ausgeführt werden.'
       + #13 + #13 + 'Wollen Sie jetzt Daten aus UNIPPS einlesen ?';
begin

end;

end.
