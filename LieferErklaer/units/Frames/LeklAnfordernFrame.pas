unit LeklAnfordernFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.DateUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.Win.ADODB, Data.DB,
  Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids,
  LieferantenStatusDlg, Tools, Vcl.Mask, System.ImageList, Vcl.ImgList,
  Vcl.Buttons, System.Actions, Vcl.ActnList, Vcl.ExtCtrls, Vcl.Menus,
  TeileAnzeigenDlg;

type
  TLieferantenErklAnfordernFrm = class(TFrame)
    DataSource1: TDataSource;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    FilterKurzname: TEdit;
    GroupBox2: TGroupBox;
    DBGrid1: TDBGrid;
    FilterName: TEdit;
    Label1: TLabel;
    PumpenTeileChkBox: TCheckBox;
    FilterAusBtn: TButton;
    ImageList1: TImageList;
    AbgelaufenChkBox: TCheckBox;
    ohneAnfrageChkBox: TCheckBox;
    GroupBox3: TGroupBox;
    Label8: TLabel;
    LKurznameTxt: TDBText;
    IDLieferantTxt: TDBText;
    Label10: TLabel;
    StatusBtn: TButton;
    FaxBtn: TButton;
    Label12: TLabel;
    Panel1b: TPanel;
    DBText1: TDBText;
    DBText2: TDBText;
    PlzDBText: TDBText;
    OrtDBText: TDBText;
    StrasseDBText: TDBText;
    Panel1: TPanel;
    Label6: TLabel;
    Label4: TLabel;
    ortlabel: TLabel;
    Label5: TLabel;
    dummy: TLabel;
    Panel2: TPanel;
    Label3: TLabel;
    giltbislbl: TLabel;
    Label9: TLabel;
    Label7: TLabel;
    Panel3: TPanel;
    Status: TDBText;
    giltBisDBText: TDBText;
    letzteAbfrageDBText: TDBText;
    StandDBText: TDBText;
    AdressUebLabel: TLabel;
    Panel4: TPanel;
    Label14: TLabel;
    Label15: TLabel;
    Panel6: TPanel;
    mailDBText: TDBText;
    telefaxDBText: TDBText;
    staatlbl: TLabel;
    StaatDBText: TDBText;
    mailBtn: TButton;
    Label16: TLabel;
    ActionList1: TActionList;
    mailAction: TAction;
    FaxAction: TAction;
    StatusUpdateAction: TAction;
    Label11: TLabel;
    DBMemo2: TDBMemo;
    PopupMenu1: TPopupMenu;
    TeileAnzeigeMen: TMenuItem;
    TeileAnzeigeAction: TAction;
    ExportExcelAction: TAction;
    ListenExcelMen: TMenuItem;
    Label13: TLabel;
    AnforderungResetMen: TMenuItem;
    AnfordDatumResetAction: TAction;
    ErsatzTeileChkBox: TCheckBox;
    FilterUpdateAction: TAction;
    Label17: TLabel;
    NachnameDBText: TDBText;
    Label18: TLabel;
    AnredeDBText: TDBText;
    VornameDBText: TDBText;
    Label19: TLabel;
    RelevantChkBox: TCheckBox;
    NRelevantChkBox: TCheckBox;
    NohneAnfrageChkBox: TCheckBox;
    NAbgelaufenChkBox: TCheckBox;
    AnforderungHeuteMen: TMenuItem;
    AnfordDatumHeuteAction: TAction;
    procedure ShowFrame();
    procedure HideFrame();
    procedure FilterAusBtnClick(Sender: TObject);
//    procedure AbgelaufenChkBoxClick(Sender: TObject);
    procedure FilterUpdateActionExecute(Sender: TObject);
    procedure StatusUpdateActionExecute(Sender: TObject);
    procedure mailActionExecute(Sender: TObject);
    procedure FaxActionExecute(Sender: TObject);
    procedure UpdateAnfrageDatum(Reset:Boolean=False);
    procedure TeileAnzeigeActionExecute(Sender: TObject);
    procedure ExportExcelActionExecute(Sender: TObject);
    procedure AnfordDatumResetActionExecute(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure FilterUpdateActionUpdate(Sender: TObject);
    procedure AnfordDatumHeuteActionExecute(Sender: TObject);
    procedure RefreshLocalQuery;

  private
    //Wieviele Tage muss die Lieferantenerklärung mindestens noch gelten
    minRestGueltigkeit:String;
    //wann wird eine Eingabe als veraltet betrachtet
    veraltet:String;
  public
    LocalQry: TWQry;
  end;


implementation

{$R *.dfm}

uses mainfrm, Excel, Mailing, Word;

procedure TLieferantenErklAnfordernFrm.ShowFrame();
begin
    LocalQry := Tools.GetQuery;
    //Wieviele Tage muss die Lieferantenerklärung mindestens noch gelten
    minRestGueltigkeit:=LocalQry.LiesProgrammDatenWert('Gueltigkeit_Lekl');
    veraltet:=LocalQry.LiesProgrammDatenWert('veraltet');
    LocalQry.HoleLieferantenMitAdressen;
    DataSource1.DataSet := LocalQry;
    FilterUpdateActionExecute(Self);
    mainForm.HelpKeyword:='Anforderung';
    Self.Visible := True;
end;

procedure TLieferantenErklAnfordernFrm.HideFrame();
begin
  if assigned(LocalQry) then
    LocalQry.Close;
  Self.Visible := False;
end;

procedure TLieferantenErklAnfordernFrm.UpdateAnfrageDatum(Reset:Boolean=False);
var
  letzteAnfrage:string;
  IdLieferant: Integer;
  UpdateQry:TWQry;
  var Datum: TDateTime;
begin
    //heute
    Datum:=Date;
    //Datum ein Jahr zurücksetzen
    if Reset then
      Datum:=IncYear(Datum,-1);
    // Datenstand ist heute
    letzteAnfrage := FormatDateTime('YYYY-MM-DD', Datum);
    // Id des Lieferanen aus Basis-Abfrage
    IdLieferant := LocalQry.FieldByName('IdLieferant').AsInteger;
    // --- Update-Abfrage �bernimmt Daten in Lieferanten-Tabelle
    UpdateQry := Tools.GetQuery;
    UpdateQry.UpdateLieferantAnfrageDatum(IdLieferant,letzteAnfrage);

    RefreshLocalQuery;

end;

procedure TLieferantenErklAnfordernFrm.RefreshLocalQuery;
var
  BM:TBookmark;
begin
    // akt. Datensatz merken
    BM := LocalQry.GetBookmark;
    // Basis-Abfrage erneuern um aktuelle Daten anzuzeigen
{$IFDEF FIREDAC}
    LocalQry.Refresh();
{$ELSE}
    LocalQry.Requery();
{$ENDIF}

    // Gehe auf ursp�nglichen Datensatz
    LocalQry.GotoBookmark(BM);

end;

procedure TLieferantenErklAnfordernFrm.StatusUpdateActionExecute(
  Sender: TObject);
var
  IdLieferant: Integer;
  Stand, GiltBis: String;
  lekl,Kommentar : String;
  UpdateQry:TWQry;
  BM:TBookmark;
//  Jahr:Integer;
begin

   // ------- Steuerelemente des Dialogs vorbesetzen
   // Anzeige des Ist-Status der Lieferantenerkl�rung
   LieferantenStatusDialog.alterStatus.Caption
            := LocalQry.FieldByName('StatusTxt').AsString;
   // Ist-Status der Lieferantenerkl�rung in List-Box vorausw�hlen
   LieferantenStatusDialog.StatusListBox.KeyValue
            := LocalQry.FieldByName('lekl').AsInteger;
   //Kommentar
   LieferantenStatusDialog.KommentarEdit.Text
            := LocalQry.FieldByName('Kommentar').AsString;

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
      Kommentar := LieferantenStatusDialog.KommentarEdit.Text ;

      // Id des Lieferanen aus Basis-Abfrage
      IdLieferant := LocalQry.FieldByName('IdLieferant').AsInteger;

      // --- Update-Abfrage �bernimmt Daten in Lieferanten-Tabelle
      UpdateQry := Tools.GetQuery;
      UpdateQry.UpdateLieferant(IdLieferant, Stand, GiltBis, lekl,
                                                            Kommentar);

      // Basis-Abfrage erneuern um aktuelle Daten anzuzeigen
{$IFDEF FIREDAC}
    LocalQry.Refresh();
{$ELSE}
    LocalQry.Requery();
{$ENDIF}
      // Gehe auf ursp�nglichen Datensatz
      if not LocalQry.Eof then
          LocalQry.GotoBookmark(BM);

    end;

end;


procedure TLieferantenErklAnfordernFrm.TeileAnzeigeActionExecute(
  Sender: TObject);
begin
  TeileListeForm.IdLieferant:= LocalQry.FieldByName('IdLieferant').AsString;
  TeileListeForm.Show;
end;

procedure TLieferantenErklAnfordernFrm.FilterUpdateActionExecute(Sender: TObject);
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

    if ErsatzTeileChkBox.State = cbChecked then
    begin
      if filtern then
        FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'Ersatzteile=-1' ;
    end;

    if AbgelaufenChkBox.State = cbChecked then
    begin
      if filtern then
        FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'gilt_noch <' + minRestGueltigkeit;
    end;

    if NAbgelaufenChkBox.State = cbChecked then
    begin
      if filtern then
        FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'gilt_noch >=' + minRestGueltigkeit;
    end;

    if ohneAnfrageChkBox.State = cbChecked then
    begin
      if filtern then
        FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'angefragt_vor_Tagen >' + veraltet;
    end;

    if NohneAnfrageChkBox.State = cbChecked then
    begin
      if filtern then
        FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'angefragt_vor_Tagen <=' + veraltet;
    end;

    if RelevantChkBox.State = cbChecked then
    begin
      if filtern then
         FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'lekl<4';
    end;

    if NRelevantChkBox.State = cbChecked then
    begin
      if filtern then
         FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'lekl=4';
    end;

    if length(FilterName.Text)>0 then
    begin
      if filtern then
        FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'name1 Like ''%' + FilterName.Text + '%''';
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

procedure TLieferantenErklAnfordernFrm.FilterUpdateActionUpdate(
  Sender: TObject);
var
  SenderComp:TComponent;
begin
//    if assigned(Sender) then
    SenderComp:= (Sender as TAction).ActionComponent;
    if not assigned(SenderComp) then
      exit;

    if SenderComp.Equals(AbgelaufenChkBox) then
      if AbgelaufenChkBox.State = cbChecked then
        NAbgelaufenChkBox.State := cbUnchecked;

    if SenderComp.Equals(NAbgelaufenChkBox) then
      if NAbgelaufenChkBox.State = cbChecked then
        AbgelaufenChkBox.State := cbUnchecked;

    if SenderComp.Equals(ohneAnfrageChkBox) then
      if ohneAnfrageChkBox.State = cbChecked then
        NohneAnfrageChkBox.State := cbUnchecked;

    if SenderComp.Equals(NohneAnfrageChkBox) then
      if NohneAnfrageChkBox.State = cbChecked then
        ohneAnfrageChkBox.State := cbUnchecked;

    if SenderComp.Equals(RelevantChkBox) then
      if RelevantChkBox.State = cbChecked then
          NRelevantChkBox.State := cbUnchecked;

    if SenderComp.Equals(NRelevantChkBox) then
      if NRelevantChkBox.State = cbChecked then
          RelevantChkBox.State := cbUnchecked;

end;

//procedure TLieferantenErklAnfordernFrm.AbgelaufenChkBoxClick(Sender: TObject);
//begin
//    FilterUpdateActionExecute(Sender);
//end;

procedure TLieferantenErklAnfordernFrm.FilterAusBtnClick(Sender: TObject);
begin
  FilterKurzname.Text := '';
  FilterName.Text := '';
  FilterUpdateActionExecute(Sender);
end;

procedure TLieferantenErklAnfordernFrm.AnfordDatumHeuteActionExecute(
  Sender: TObject);
begin
  UpdateAnfrageDatum();
end;

procedure TLieferantenErklAnfordernFrm.AnfordDatumResetActionExecute(
  Sender: TObject);
begin
  UpdateAnfrageDatum(True);
end;

procedure TLieferantenErklAnfordernFrm.DataSource1DataChange(Sender: TObject;
  Field: TField);
begin
    mailBtn.Enabled := (mailDBText.Caption<>'');
    FaxBtn.Enabled := (telefaxDBText.Caption<>'');
end;

procedure TLieferantenErklAnfordernFrm.ExportExcelActionExecute(
  Sender: TObject);
var
  BM:TBookmark;

begin
  // akt. Datensatz merken
  BM := LocalQry.GetBookmark;

  LieferantenNachExcel(LocalQry);

  // Gehe auf ursp�nglichen Datensatz
  LocalQry.GotoBookmark(BM);
end;

procedure TLieferantenErklAnfordernFrm.FaxActionExecute(Sender: TObject);
begin
  //Erstelle und Drucke Fax, vermerke in DB wenn OK
  if SendeFax(LocalQry.Fields) then
    UpdateAnfrageDatum;
end;

procedure TLieferantenErklAnfordernFrm.mailActionExecute(Sender: TObject);
begin
  //Erstelle und versende mail, vermerke in DB wenn OK
  if SendeMailAn(LocalQry.Fields) then
    UpdateAnfrageDatum;
end;


end.
