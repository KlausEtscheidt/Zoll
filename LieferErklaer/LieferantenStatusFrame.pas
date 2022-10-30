unit LieferantenStatusFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.DateUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.Win.ADODB, Data.DB,
  Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids,datenmodul,
  LieferantenStatusDlg, Init, Vcl.Mask, System.ImageList, Vcl.ImgList,
  Vcl.Buttons;

type
  TLieferantenStatusFrm = class(TFrame)
    DataSource1: TDataSource;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    FilterKurzname: TEdit;
    GroupBox2: TGroupBox;
    DBGrid1: TDBGrid;
    FilterName: TEdit;
    Label1: TLabel;
    GroupBox3: TGroupBox;
    DBText2: TDBText;
    Label8: TLabel;
    Label7: TLabel;
    Label6: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    DBText4: TDBText;
    Status: TDBText;
    DBText1: TDBText;
    LKurznameTxt: TDBText;
    IDLieferantTxt: TDBText;
    StatusBtn: TButton;
    TeileBtn: TButton;
    Label3: TLabel;
    DBText3: TDBText;
    Label9: TLabel;
    Label10: TLabel;
    PumpenTeileChkBox: TCheckBox;
    Label11: TLabel;
    Button1: TButton;
    ImageList1: TImageList;
    procedure FilterNameChange(Sender: TObject);
    procedure FilterKurznameChange(Sender: TObject);
    procedure TeileBtnClick(Sender: TObject);
    procedure StatusBtnClick(Sender: TObject);
    procedure ShowFrame();
    procedure HideFrame();
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure PumpenTeileChkBoxClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);

  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    LocalQry: TWQry;
    procedure FilterUpdate();
  end;


implementation

{$R *.dfm}

uses mainfrm;

procedure TLieferantenStatusFrm.ShowFrame();
var
  SQL : String;

begin
    LocalQry := Init.GetQuery;
    LocalQry.HoleLieferantenMitStatusTxt;
    DataSource1.DataSet := LocalQry;
    FilterUpdate;
    Self.Visible := True;
end;

procedure TLieferantenStatusFrm.HideFrame();
begin
  if assigned(LocalQry) then
    LocalQry.Close;
  Self.Visible := False;
end;

procedure TLieferantenStatusFrm.PumpenTeileChkBoxClick(Sender: TObject);
begin
    Self.FilterUpdate;
end;

procedure TLieferantenStatusFrm.StatusBtnClick(Sender: TObject);
var
  SQL: String;
  IdLieferant: Integer;
  Stand, GiltBis: String;
  lekl : String;
  UpdateQry:TWQry;
  BM:TBookmark;

begin

   // ------- Steuererlemente des Dialogs vorbesetzen
   // Anzeige des Ist-Status der Lieferantenerklärung
   LieferantenStatusDialog.alterStatus.Caption
            := LocalQry.FieldByName('StatusTxt').AsString;
   // Ist-Status der Lieferantenerklärung in List-Box vorauswählen
   LieferantenStatusDialog.StatusListBox.KeyValue
            := LocalQry.FieldByName('lekl').AsInteger;
   // Datumswähler auf bisheriges Gültigkeitsdatum
   GiltBis := Trim(LocalQry.FieldByName('gilt_bis').AsString);
   LieferantenStatusDialog.DateTimePicker1.DateTime := ISO8601ToDate(GiltBis);

   // Dialog anzeigen
   if (LieferantenStatusDialog.ShowModal=mrOK) then
    begin

      // akt. Datensatz merken
      BM := LocalQry.GetBookmark;

      // --- Daten fuer Update-Abfrage vorbereiten
      // Datenstand ist heute
      Stand := FormatDateTime('YYYY-MM-DD', Date);
      // Lekl gilt bis aus Dialog
      GiltBis := FormatDateTime('YYYY-MM-DD',
                        LieferantenStatusDialog.DateTimePicker1.DateTime);
      // Gewählten Status aus Dialog
      lekl := LieferantenStatusDialog.StatusListBox.KeyValue ;
      // Id des Lieferanen aus Basis-Abfrage
      IdLieferant := LocalQry.FieldByName('IdLieferant').AsInteger;

      // --- Update-Abfrage übernimmt Daten in Lieferanten-Tabelle
      UpdateQry := Init.GetQuery;
      UpdateQry.UpdateLieferant(IdLieferant, Stand, GiltBis, lekl);

      // Basis-Abfrage erneuern um aktuelle Daten anzuzeigen
      LocalQry.Requery();

      // Gehe auf urspünglichen Datensatz
      LocalQry.GotoBookmark(BM);

    end;


end;

procedure TLieferantenStatusFrm.TeileBtnClick(Sender: TObject);
begin
    mainForm.LieferantenErklaerungenFrm1.IdLieferant
      :=  LocalQry.FieldByName('IdLieferant').AsInteger;
    mainForm.LieferantenErklaerungenFrm1.IdLieferantLbl.Caption
      := IntToStr(mainForm.LieferantenErklaerungenFrm1.IdLieferant);
    mainForm.LieferantenErklaerungenFrm1.LKurznameLbl.Caption
      :=  LocalQry.FieldByName('LKurzname').AsString;

    mainForm.LieferantenStatusFrm1.Visible := False;
    mainForm.LieferantenErklaerungenFrm1.ShowFrame(
                                    mainForm.LieferantenStatusFrm1);
end;

procedure TLieferantenStatusFrm.DataSource1DataChange(Sender: TObject;
  Field: TField);
begin
    // Bei LEKL-Status "einige Teile" Dateneingabe für Teile ermöglichen
    if LocalQry.FieldByName('lekl').AsInteger =3 then
      TeileBtn.Visible:=True
    else
      TeileBtn.Visible:=False;

end;

procedure TLieferantenStatusFrm.FilterUpdate();
var
  FilterStr : String;
  filtern : Boolean;
begin

    filtern := False;
    FilterStr := '';

    if PumpenTeileChkBox.State = cbChecked then
    begin
      FilterStr := 'Pumpenteile=-1';
      filtern := True;
    end;

    if length(FilterName.Text)>0 then
    begin
      if filtern then
        FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'LName1 Like ''%' + FilterName.Text + '%''';
    end;

    if length(FilterKurzname.Text)>0 then
    begin
      if filtern then
        FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'LKurzname Like ''' + FilterKurzname.Text + '%''';
    end;

    LocalQry.Filter := FilterStr;
    LocalQry.Filtered := filtern;

end;

procedure TLieferantenStatusFrm.Button1Click(Sender: TObject);
begin
  FilterKurzname.Text := '';
  FilterName.Text := '';
  FilterUpdate;

end;


procedure TLieferantenStatusFrm.FilterNameChange(Sender: TObject);
begin
  FilterUpdate;

end;


procedure TLieferantenStatusFrm.FilterKurznameChange(Sender: TObject);
begin
  FilterUpdate;

end;


end.
