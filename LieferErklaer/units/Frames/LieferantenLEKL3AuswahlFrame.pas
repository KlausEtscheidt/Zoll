unit LieferantenLEKL3AuswahlFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.DateUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.Win.ADODB, Data.DB,
  Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids,
  LieferantenStatusDlg, Tools, Vcl.Mask, System.ImageList, Vcl.ImgList,
  Vcl.Buttons, System.Actions, Vcl.ActnList, Vcl.ExtCtrls, Vcl.StdActns;

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
    Label8: TLabel;
    LKurznameTxt: TDBText;
    IDLieferantTxt: TDBText;
    TeileBtn: TButton;
    Label10: TLabel;
    Label11: TLabel;
    FilterAusBtn: TButton;
    ImageList1: TImageList;
    LeklUpdatedChkBox: TCheckBox;
    ActionList1: TActionList;
    FilterUpdateAction: TAction;
    Panel1: TPanel;
    Label3: TLabel;
    Label7: TLabel;
    Label4: TLabel;
    Panel2: TPanel;
    giltBisDBText: TDBText;
    DatumStatusDBText: TDBText;
    DatumTeileDBText: TDBText;
    UnbearbeiteteCheckBox: TCheckBox;
    Panel3: TPanel;
    Label6: TLabel;
    DBText1: TDBText;
    DBText2: TDBText;
    NLeklUpdatedChkBox: TCheckBox;
    NUnbearbeiteteCheckBox: TCheckBox;
    procedure TeileBtnClick(Sender: TObject);
    procedure ShowFrame();
    procedure HideFrame();
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure FilterAusBtnClick(Sender: TObject);
    procedure FilterUpdateActionExecute(Sender: TObject);
    procedure FilterUpdateActionUpdate(Sender: TObject);

  private
    //Wieviele Tage muss die Lieferantenerklärung mindestens noch gelten
    minRestGueltigkeit:String;
    //Ab wievielen Tagen gilt ein Status als veraltet (Eingabe vom Vorjahr)
    veraltet:String;
    LocalQry: TWQry;
    procedure FormRequery;
  public
  end;

implementation

{$R *.dfm}

uses mainfrm, LeklTeileEingabeDlg;

procedure TLieferantenStatusFrm.ShowFrame();
begin
    LocalQry := Tools.GetQuery;
    //Wieviele Tage muss die Lieferantenerklärung mindestens noch gelten
    minRestGueltigkeit:=LocalQry.LiesProgrammDatenWert('Gueltigkeit_Lekl');
    //Ab wievielen Tagen gilt ein Status als veraltet (Eingabe vom Vorjahr)
    veraltet:=LocalQry.LiesProgrammDatenWert('veraltet');
    //Lies alle Lieferanten mit Erklärungs "einige Teile"
    LocalQry.HoleLieferantenFuerTeileEingabe(minRestGueltigkeit);
    DataSource1.DataSet := LocalQry;
    FilterUpdateActionExecute(nil);
    Self.Visible := True;
    mainForm.HelpKeyword:='Lieferantenauswahl';
end;

procedure TLieferantenStatusFrm.HideFrame();
begin
  if assigned(LocalQry) then
    LocalQry.Close;
  Self.Visible := False;
end;

procedure TLieferantenStatusFrm.TeileBtnClick(Sender: TObject);
const
  msg='Ist die Bearbeitung dieses Lieferanten abgeschlossen ?'+ #13+ #13 +
      'Nein, wenn später weiter gearbeitet werden soll.';
var
  IdL:Integer   ;
  KName :String;
begin
    IdL :=  LocalQry.FieldByName('IdLieferant').AsInteger;
    KName :=  LocalQry.FieldByName('LKurzname').AsString;

    with LeklTeileEingabeDialog.LeklTeileEingabeFrm do
    begin
      var bla:string;
      IdLieferant :=  IdL;
      IdLieferantLbl.Caption
        := IntToStr(IdL);
      LKurznameLbl.Caption :=  KName;
     end;

    //User fragen, ob Lieferant fertig bearbeitet
    LeklTeileEingabeDialog.ShowModal;

    //Stand aktualisieren, wenn Flags geändert wurden
//    if LeklTeileEingabeDialog.LeklTeileEingabeFrm.DatenGeaendert then
        if MessageDlg(msg,mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
          begin
            // Datum 'StandTeile' erneuern
            LocalQry.Edit;
            LocalQry.FieldByName('StandTeile').AsString:=
                           FormatDateTime('YYYY-MM-DD', Date);
            LocalQry.Post;
            //Abfrage erneuern, damit Filter wirken
            FormRequery;
          end;
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

    //Der Teile-Stand wurde vor mehr als "veraltet" Tagen eingegeben,
    //aktuell also noch gar nicht
    if UnbearbeiteteCheckBox.State = cbChecked then
    begin
      filtern := True;
      FilterStr := FilterStr + 'AlterStandTeile >'+ veraltet ;
    end;

    //Der Teile-Stand wurde vor weniger als "veraltet" Tagen eingegeben,
    //ist also aktuell
    if NUnbearbeiteteCheckBox.State = cbChecked then
    begin
      if filtern then
        FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'AlterStandTeile <=' + veraltet ;
    end;

    //Die LEKL wurde aktuell (vor weniger als veraltet Tagen )eingelesen
    if LeklUpdatedChkBox.State = cbChecked then
    begin
      if filtern then
        FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'AlterStand <' + veraltet ;
    end;

    //Die LEKL ist nicht aktuell
    //Sie wurde vor mehr als "veraltet" Tagen eingelesen
    if NLeklUpdatedChkBox.State = cbChecked then
    begin
      if filtern then
        FilterStr := FilterStr + ' AND ' ;
      filtern := True;
      FilterStr := FilterStr + 'AlterStand >=' + veraltet ;
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

procedure TLieferantenStatusFrm.FilterUpdateActionUpdate(Sender: TObject);
var
  SenderComp:TComponent;
begin
//    if assigned(Sender) then
    SenderComp:= (Sender as TAction).ActionComponent;
    if not assigned(SenderComp) then
      exit;

    if SenderComp.Equals(LeklUpdatedChkBox) then
      if LeklUpdatedChkBox.State = cbChecked then
        NLeklUpdatedChkBox.State := cbUnchecked;

    if SenderComp.Equals(NLeklUpdatedChkBox) then
      if NLeklUpdatedChkBox.State = cbChecked then
        LeklUpdatedChkBox.State := cbUnchecked;

    if SenderComp.Equals(UnbearbeiteteCheckBox) then
      if UnbearbeiteteCheckBox.State = cbChecked then
        NUnbearbeiteteCheckBox.State := cbUnchecked;

    if SenderComp.Equals(NUnbearbeiteteCheckBox) then
      if NUnbearbeiteteCheckBox.State = cbChecked then
        UnbearbeiteteCheckBox.State := cbUnchecked;

end;

procedure TLieferantenStatusFrm.FormRequery;
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

  // Gehe auf ursp�nglichen Datensatz, wenn nicht alle weggefiltert
  if not LocalQry.Eof then
    LocalQry.GotoBookmark(BM);
end;

procedure TLieferantenStatusFrm.FilterAusBtnClick(Sender: TObject);
begin
  FilterKurzname.Text := '';
  FilterName.Text := '';
  FilterUpdateActionExecute(Sender);
end;


end.
