unit LeklStatusEingabeFrame;

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
  TLeklStatusFrm = class(TFrame)
    DataSource1: TDataSource;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    FilterKurzname: TEdit;
    GroupBox2: TGroupBox;
    DBGrid1: TDBGrid;
    FilterName: TEdit;
    Label1: TLabel;
    FilterAusBtn: TButton;
    ImageList1: TImageList;
    GroupBox3: TGroupBox;
    LKurznameTxt: TDBText;
    IDLieferantTxt: TDBText;
    StatusBtn: TButton;
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
    staatlbl: TLabel;
    StaatDBText: TDBText;
    Label16: TLabel;
    ActionList1: TActionList;
    StatusUpdateAction: TAction;
    PopupMenu1: TPopupMenu;
    TeileAnzeigeMen: TMenuItem;
    ExportExcelAction: TAction;
    ListenExcelMen: TMenuItem;
    Label13: TLabel;
    AnforderungResetMen: TMenuItem;
    FilterUpdateAction: TAction;
    GeantwortetChkBox: TCheckBox;
    NGeantwortetChkBox: TCheckBox;
    DBMemo2: TDBMemo;
    Label11: TLabel;
    Label8: TLabel;
    Panel4: TPanel;
    Label14: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Panel6: TPanel;
    mailDBText: TDBText;
    telefaxDBText: TDBText;
    NachnameDBText: TDBText;
    AnredeDBText: TDBText;
    VornameDBText: TDBText;
    Label20: TLabel;
    TeileAnzeigeAction: TAction;
    StandDatumResetAction: TAction;
    procedure ShowFrame();
    procedure HideFrame();
    procedure FilterAusBtnClick(Sender: TObject);
    procedure FilterUpdateActionExecute(Sender: TObject);
    procedure StatusUpdateActionExecute(Sender: TObject);
    procedure ExportExcelActionExecute(Sender: TObject);
    procedure FilterUpdateActionUpdate(Sender: TObject);
    procedure RefreshLocalQuery;
    procedure ZeigeAnzahlGefilterteLieferanten;
    procedure TeileAnzeigeActionExecute(Sender: TObject);
    procedure StandDatumResetActionExecute(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);

  private
    //Wieviele Tage muss die Lieferantenerklärung mindestens noch gelten
    minRestGueltigkeit:String;
    //wann wird eine Eingabe als veraltet betrachtet
    veraltet:String;
    //nach welcher Spalte wurde zuletzt sortiert
    lastSortCol: TColumn;
  public
    LocalQry: TWQry;
  end;


implementation

{$R *.dfm}

uses mainfrm, Excel, Mailing, Word;

procedure TLeklStatusFrm.ShowFrame();
var
  ColName,letztesZeichen:String;
begin
    LocalQry := Tools.GetQuery;
    //Wieviele Tage muss die Lieferantenerklärung mindestens noch gelten
    minRestGueltigkeit:=LocalQry.LiesProgrammDatenWert('Gueltigkeit_Lekl');
    veraltet:=LocalQry.LiesProgrammDatenWert('veraltet');
    LocalQry.HoleLieferantenMitAdressen;
    DataSource1.DataSet := LocalQry;
    FilterUpdateActionExecute(Self);
    mainForm.HelpKeyword:='LieferantenStatus';
    //Falls schon mal sortiert wurde, Titel der alten Spalte zurück setzen
    if assigned(lastSortCol) then
      begin
        ColName:= lastSortCol.Title.Caption;
        letztesZeichen:=ColName[length(ColName)];
        if (letztesZeichen = #8593) or (letztesZeichen = #8595) then
          lastSortCol.Title.Caption := Copy(ColName, 1, length(ColName)-2)
      end;

    Self.Visible := True;
end;

procedure TLeklStatusFrm.HideFrame();
begin
  if assigned(LocalQry) then
    LocalQry.Close;
  Self.Visible := False;
end;


procedure TLeklStatusFrm.RefreshLocalQuery;
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

procedure TLeklStatusFrm.ZeigeAnzahlGefilterteLieferanten;
begin
  GroupBox2.Caption:= 'gefiltert '
                + IntToStr(LocalQry.RecordCount) + ' Lieferanten';
end;

procedure TLeklStatusFrm.StandDatumResetActionExecute(Sender: TObject);
var
  Stand:string;
  IdLieferant: Integer;
  UpdateQry:TWQry;
  var Datum: TDateTime;
begin
    //heute
    Datum:=Date;
    //Datum ein Jahr zurücksetzen
    Datum:=IncYear(Datum,-1);
    // Datenstand ist heute
    Stand := FormatDateTime('YYYY-MM-DD', Datum);
    // Id des Lieferanen aus Basis-Abfrage
    IdLieferant := LocalQry.FieldByName('IdLieferant').AsInteger;
    // --- Update-Abfrage �bernimmt Daten in Lieferanten-Tabelle
    UpdateQry := Tools.GetQuery;
    UpdateQry.UpdateLieferantStand(IdLieferant,Stand);

    RefreshLocalQuery;

end;

procedure TLeklStatusFrm.StatusUpdateActionExecute(
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

      ZeigeAnzahlGefilterteLieferanten;

      // Gehe auf ursp�nglichen Datensatz
      if not LocalQry.Eof then
          LocalQry.GotoBookmark(BM);

    end;

end;

procedure TLeklStatusFrm.TeileAnzeigeActionExecute(Sender: TObject);
begin
  TeileListeForm.IdLieferant:= LocalQry.FieldByName('IdLieferant').AsString;
  TeileListeForm.Show;
end;

procedure TLeklStatusFrm.FilterUpdateActionExecute(Sender: TObject);
var
  FilterStr : String;
  filtern : Boolean;
begin

    filtern := True;
    FilterStr := FilterStr + 'angefragt_vor_Tagen <=' + veraltet;

    if GeantwortetChkBox.State = cbChecked then
    begin
      if filtern then
         FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'Stand_minus_Anfrage>=0';
    end;

    if NGeantwortetChkBox.State = cbChecked then
    begin
      if filtern then
         FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'Stand_minus_Anfrage<0';
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

    //Diese Filter-Update Aktion wird evtl beim Erzeugen der Frames
    //durch Delphi aufgerufen, bevor die Qry erzeugt wurde
    if assigned (LocalQry) then
    begin
      LocalQry.Filter := FilterStr;
      LocalQry.Filtered := filtern;
      ZeigeAnzahlGefilterteLieferanten;
    end;

end;


procedure TLeklStatusFrm.FilterUpdateActionUpdate(
  Sender: TObject);
var
  SenderComp:TComponent;
begin
//    if assigned(Sender) then
    SenderComp:= (Sender as TAction).ActionComponent;
    if not assigned(SenderComp) then
      exit;

    if SenderComp.Equals(GeantwortetChkBox) then
      if GeantwortetChkBox.State = cbChecked then
          NGeantwortetChkBox.State := cbUnchecked;

    if SenderComp.Equals(NGeantwortetChkBox) then
      if NGeantwortetChkBox.State = cbChecked then
          GeantwortetChkBox.State := cbUnchecked;


end;

//procedure TLieferantenErklAnfordernFrm.AbgelaufenChkBoxClick(Sender: TObject);
//begin
//    FilterUpdateActionExecute(Sender);
//end;

procedure TLeklStatusFrm.FilterAusBtnClick(Sender: TObject);
begin
  FilterKurzname.Text := '';
  FilterName.Text := '';
  FilterUpdateActionExecute(Sender);
end;

//Sortiert Liste bei Click in Header
procedure TLeklStatusFrm.DBGrid1TitleClick(Column: TColumn);
var
  ColName,FeldName:String;
  letztesZeichen:String;

begin
  //Spaltentitel aendern und sortieren, jeweils abhängig von einer alten Sortierung
  FeldName:= Column.Fieldname;
  ColName:= Column.Title.Caption;
  letztesZeichen:=ColName[length(ColName)];
  if letztesZeichen = #8595 then
    begin
      //War ASC wird DESC
      FeldName:= FeldName + ' DESC';
      Column.Title.Caption:= Copy(ColName, 1, length(ColName)-2) + ' ' + #8593
    end
  else if letztesZeichen = #8593 then
    begin
      //War DESC wird unsortiert
      FeldName:='';
      Column.Title.Caption:= Copy(ColName, 1, length(ColName)-2);
    end
  else
    begin
      //War unsortiert wird ASC
      FeldName:= FeldName + ' ASC';
      Column.Title.Caption:= ColName + ' ' + #8595
    end;

{$IFDEF FIREDAC}
   LocalQry.IndexFieldNames  := FeldName;
{$ELSE}
   LocalQry.Sort := FeldName;
{$ENDIF}

  //Falls schon mal sortiert wurde, Titel der alten Spalte zurück setzen
  if assigned(lastSortCol) then
    if not lastSortCol.Equals(Column) then
      begin
        ColName:= lastSortCol.Title.Caption;
        letztesZeichen:=ColName[length(ColName)];
        if (letztesZeichen = #8593) or (letztesZeichen = #8595) then
          lastSortCol.Title.Caption := Copy(ColName, 1, length(ColName)-2)
      end;

  //neue Spalte merken
  lastSortCol:= Column;


end;

procedure TLeklStatusFrm.ExportExcelActionExecute(
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


end.
