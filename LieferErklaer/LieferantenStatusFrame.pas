unit LieferantenStatusFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.DateUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.Win.ADODB, Data.DB,
  Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids,datenmodul,
  LieferantenStatusDlg, Tools, Vcl.Mask, System.ImageList, Vcl.ImgList,
  Vcl.Buttons, System.Actions, Vcl.ActnList;

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
    FilterAusBtn: TButton;
    ImageList1: TImageList;
    AbgelaufenChkBox: TCheckBox;
    EinigeTeileChkBox: TCheckBox;
    ActionList1: TActionList;
    FilterUpdateAction: TAction;
    procedure TeileBtnClick(Sender: TObject);
    procedure StatusBtnClick(Sender: TObject);
    procedure ShowFrame();
    procedure HideFrame();
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure FilterAusBtnClick(Sender: TObject);
    procedure AbgelaufenChkBoxClick(Sender: TObject);
    procedure FilterUpdateActionExecute(Sender: TObject);

  private
    //Wieviele Tage muss die Lieferantenerklärung mindestens noch gelten
    minRestGueltigkeit:String;
    LocalQry: TWQry;
  public
  end;


implementation

{$R *.dfm}

uses mainfrm;

procedure TLieferantenStatusFrm.ShowFrame();
begin
    LocalQry := Tools.GetQuery;
    //Wieviele Tage muss die Lieferantenerklärung mindestens noch gelten
    minRestGueltigkeit:=LocalQry.LiesProgrammDatenWert('Gueltigkeit_Lekl');
    LocalQry.HoleLieferantenMitStatusTxt;
    DataSource1.DataSet := LocalQry;
    FilterUpdateActionExecute(nil);
    Self.Visible := True;
end;

procedure TLieferantenStatusFrm.HideFrame();
begin
  if assigned(LocalQry) then
    LocalQry.Close;
  Self.Visible := False;
end;

procedure TLieferantenStatusFrm.StatusBtnClick(Sender: TObject);
var
  IdLieferant: Integer;
  Stand, GiltBis: String;
  lekl : String;
  UpdateQry:TWQry;
  BM:TBookmark;

begin

   // ------- Steuererlemente des Dialogs vorbesetzen
   // Anzeige des Ist-Status der Lieferantenerkl�rung
   LieferantenStatusDialog.alterStatus.Caption
            := LocalQry.FieldByName('StatusTxt').AsString;
   // Ist-Status der Lieferantenerkl�rung in List-Box vorausw�hlen
   LieferantenStatusDialog.StatusListBox.KeyValue
            := LocalQry.FieldByName('lekl').AsInteger;
   //Zeiteingabe nur bei Status 'alle Teile' oder 'einige Teile'
   LieferantenStatusDialog.ValidateDateTime;
   // Datumsw�hler auf bisheriges G�ltigkeitsdatum
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
      // Gew�hlten Status aus Dialog
      lekl := LieferantenStatusDialog.StatusListBox.KeyValue ;
      // Id des Lieferanen aus Basis-Abfrage
      IdLieferant := LocalQry.FieldByName('IdLieferant').AsInteger;

      // --- Update-Abfrage �bernimmt Daten in Lieferanten-Tabelle
      UpdateQry := Tools.GetQuery;
      UpdateQry.UpdateLieferant(IdLieferant, Stand, GiltBis, lekl);

      // Basis-Abfrage erneuern um aktuelle Daten anzuzeigen
      LocalQry.Requery();

      // Gehe auf ursp�nglichen Datensatz
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
    // Bei LEKL-Status "einige Teile" Dateneingabe f�r Teile erm�glichen
    if LocalQry.FieldByName('lekl').AsInteger =3 then
      TeileBtn.Visible:=True
    else
      TeileBtn.Visible:=False;

end;


procedure TLieferantenStatusFrm.FilterUpdateActionExecute(Sender: TObject);
var
  FilterStr : String;
  filtern : Boolean;
begin

    filtern := False;
    FilterStr := '';

    if PumpenTeileChkBox.State = cbChecked then
    begin
      filtern := True;
      FilterStr := 'Pumpenteile=-1';
    end;

    if EinigeTeileChkBox.State = cbChecked then
    begin
      if filtern then
        FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'lekl=3';
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

    GroupBox2.Caption:= 'gefiltert '
                   + IntToStr(LocalQry.RecordCount) + ' Lieferanten';
end;



procedure TLieferantenStatusFrm.AbgelaufenChkBoxClick(Sender: TObject);
begin
    if AbgelaufenChkBox.State = cbChecked then
      LocalQry.HoleLieferantenMitStatusTxtAbgelaufen(minRestGueltigkeit)
    else
      LocalQry.HoleLieferantenMitStatusTxt;
    DataSource1.DataSet := LocalQry;
    FilterUpdateActionExecute(Sender);
end;

procedure TLieferantenStatusFrm.FilterAusBtnClick(Sender: TObject);
begin
  FilterKurzname.Text := '';
  FilterName.Text := '';
  FilterUpdateActionExecute(Sender);
end;


end.
