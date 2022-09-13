///<summary>Datenspeicher des Programms auf Basis einer Erweiterung
///von TClientDataSet.</summary>
///<remarks>Die Unit ermöglicht die dynamische Definition verschiedener
/// Datasets zur Laufzeit. Diese dienen zum Speichern der vom Programm
/// ermittelten Daten in Tabellenform.
/// |Die Eigenschaften der Felder werden über Records vom
///  Typ TWFeldTypRecord definiert. Die Records aller Felder werden in
/// einem Dictionary TWFeldTypenDict abgelegt, bei dem der Feldname
/// als key für den Zugriff dient.
/// |Weiterhin sind Prozeduren zum komfortablen Speichern von Daten
/// in einem DataSet enthalten.
///</remarks>
unit PumpenDataSet;

interface

uses
  System.SysUtils, System.Classes, StrUtils,  System.Generics.Collections,
   Data.DB, Datasnap.DBClient, Logger ;

type
  ///<summary>Ausrichtung l wird zu left c zu center r zu right</summary>
  TWFeldAusrichtung = (l,c,r);

  ///<summary>Definition eines Dataset-Feldes</summary>
  TWFeldTypRecord = record
    ///<summary>Feldname</summary>
    N:String;
    ///<summary>Feldtyp</summary>
    T:TFieldType;
    ///<summary>Name zum Anzeigen (Überschriften)</summary>
    C:String;
    ///<summary>Anzeige-Breite bei String-Feldern</summary>
    W:Integer; //Breite
    ///<summary>Ausrichtung (links,zentriert,rechts)</summary>
    J:TWFeldAusrichtung; //Ausrichtung
  end;

  TWFeldTypenDict = TDictionary<String,TWFeldTypRecord>;

  ///<summary>Array mit Feldnamen</summary>
  TWFeldNamen = array of String;

  TWDataSet = class(TClientDataSet)
  private
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
  public
    procedure AddFields(Felder:TFields);
    procedure AddFieldByName(FeldName:String;Felder:TFields);
    procedure AddValue(FeldName:String;Val:Variant);
    procedure DefiniereTabelle(FeldTypen:TWFeldTypenDict;
                                               Felder: TWFeldNamen);
    procedure DefiniereFeldEigenschaften(FeldTypen:TWFeldTypenDict);
    procedure SetzeSchreibmodus(Felder: TWFeldNamen=[]);
    function ToCSV:String;
    procedure FiltereSpalten(Felder: TWFeldNamen);
    procedure print(TxtFile:TStreamWriter);

  published
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TWDataSet]);
end;

///<summary>Alle Felder aus einer TFields-Liste speichern.</summary>
/// <remarks>
/// Hiermit können komplette Datensätze aus Datenbank-Querys im
/// DataSet gespeichert werden.
/// </remarks>
///<param name="Felder">Liste von Feldern</param>
procedure TWDataSet.AddFields(Felder:TFields);
var
  Feld:TField;
  Key:String;
begin
    for Feld in Felder do
    begin
      Key:=Feld.FieldName;
      FieldByName(Key).Value:=Feld.Value;
    end;
end;

///<summary>Einzelnes Feld aus einer TFields-Liste speichern.</summary>
/// <remarks>
/// Hiermit können einzelne Felder aus Datenbank-Query im
/// DataSet gespeichert werden.
/// </remarks>
///<param name="Felder">Liste von Feldern</param>
// <param name="FeldName">Name des zu speichernden Feldes </param>
procedure TWDataSet.AddFieldByName(FeldName:String;Felder:TFields);
begin
    FieldByName(FeldName).Value:=Felder.FieldByName(FeldName).Value;
end;

//<param name="FeldName">Name des Feldes, in das gespeichert wird.</param>

///<summary>Einen Wert in das Dataset-Feld mit Namen Key speichern.</summary>
///<param name="Val">Wert, der gespeichert wird.</param>
procedure TWDataSet.AddValue(FeldName:String;Val:Variant);
begin
    FieldByName(FeldName).Value:=Val;
end;

///<summary> Erzeugt einen String mit allen Feldnamen (; getrennt)</summary>
function TWDataSet.ToCSV: string;
const
  Trenner=';';
var
  Feld:TField;
  txt:String;
begin
    txt:='';
    for Feld in Self.Fields do
    begin
      txt:=txt + Feld.Asstring + Trenner;
    end;
end;

///<summary>Setzt die ReadOnly-Eigenschaft der übergebenen Felder auf False
///</summary>
/// <remarks>Für alle Felder des DataSet, die nicht in der Liste übergeben
///wurden, wird ReadOnly auf True gesetzt.</remarks>
///<param name="Felder"> Array mit den Namen der Felder,
///  die "schreibbar" werden sollen. </param>
procedure TWDataSet.SetzeSchreibmodus(Felder: TWFeldNamen=[]);
var
  I:Integer;
  myField:TField ;
begin

    //Erste alle auf Read only
    for I := 0 to Fields.Count-1 do
    begin
        myField:=Fields.Fields[I];
        myField.ReadOnly:=True;
    end;

    //Dann Ausnahmen zurück setzen
    for I := 0 to length(Felder)-1 do
    begin

        try
          myField:=Fields.FieldByName(Felder[I]);
        except
          raise Exception.Create('TWDataSet.DefiniereReadOnlyFalse Name '+
                         Felder[I] + ' ist nicht in Feldern des Datasets.');
        end;
        myField.ReadOnly:=False;
    end;


end;

///<summary>Definiert dynamisch ein Dataset</summary>
/// <remarks>
/// Es werden Felder eines Dataset angelegt und konfiguriert.
/// Die Namen der anzulegenden Felder werden im Array Felder übergeben.
/// | Zuerst werden alle evtl vorhandenen Felder bzw FieldDefs gelöscht.
/// | Dann werden anhand des Arrays neue FieldDefs erzeugt.
/// | Für diese wird anhand der Informationen, die in FeldTypen übergeben wurden,
/// der Datentyp, ein Anzeige-Name und bei String-Feldern
/// eine Feldbreite definiert.
/// | Mittels CreateDataSet werden die Felder angelegt und anschließend
/// über DefiniereFeldEigenschaften weitere FeldEigenschaften definiert.
/// </remarks>
///<param name="FeldTypen"> Dictionary mit Eigenschaften aller Felder.
///Als key dient ein Name aus "Felder".</param>
///<param name="Felder"> Array mit den Namen aller Felder, die angelegt werden sollen.
///Das Array definiert auch die Reihenfolge der Spalten. Die Namen müssen in FeldTypen vorhanden sein.
/// </param>
procedure TWDataSet.DefiniereTabelle(FeldTypen:TWFeldTypenDict;
                                         Felder: TWFeldNamen);
var
  I:Integer;
  myFieldDef:TFieldDef;
//  myField:TField ;
//  myFloatField:TFloatField ;
  Name:String;
  myRec:TWFeldTypRecord;

  begin
    { TODO : Sicherstellen das immer erst alles gelöscht wird }
    if (FieldDefs.Count>0) or (Fields.Count>0) then
    begin
//      Active:=True;
      FieldDefs.Clear;
      Fields.Clear;
      Active:=False;
    end;

    //Erst Feld-Def anlegen
    for I := 0 to length(Felder)-1 do
    begin

        Name := Felder[I];
        try
          myRec:=FeldTypen[Name];
        except
          raise Exception.Create('TWDataSet.DefiniereTabelle Feld '+
                         Name + ' nicht in FeldTypen gefunden.');
        end;

        myFieldDef:=FieldDefs.AddFieldDef;
        myFieldDef.Name := Name;
        myFieldDef.DataType := myRec.T;
        if myFieldDef.DataType = ftString then
        begin
          if myRec.W=0 then myRec.W:=10;
          myFieldDef.Size:=myRec.W;
        end;

        if myRec.C<>'' then
        begin
          myFieldDef.DisplayName:=myRec.C;
        end;


    end;

    //Felder erzeugen
    CreateDataSet;

    //Dann weitere Eigenschaften fuer Felder setzen
    Self.DefiniereFeldEigenschaften(FeldTypen);
end;

///<summary>Es werden Eigenschaften der Felder eines DataSet definiert.</summary>
/// <remarks>Für alle Felder werden der Anzeigename, die Ausrichtung und für
/// Float-Felder ein Standard-Display-Format "0.00" gesetzt.
/// | Die Ausrichtung(TWFeldAusrichtung) kann l,c oder r
/// für left,center oder right sein
/// </remarks>
///<param name="FeldTypen"> Dictionary mit Eigenschaften aller Felder.</param>
procedure TWDataSet.DefiniereFeldEigenschaften(FeldTypen:TWFeldTypenDict);
var
  I:Integer;
//  myFieldDef:TFieldDef;
  myField:TField ;
  myFloatField:TFloatField ;
//  Name:String;
  myRec:TWFeldTypRecord;

  begin

    for I := 0 to Fields.Count-1 do
    begin
        myField:=Fields.Fields[I];
        myRec:=FeldTypen[myField.FieldName];

        if myRec.C<>'' then
        begin
          myField.DisplayLabel:=myRec.C;
        end;

        case myRec.J of
          l: myField.Alignment :=taLeftJustify;
          c: myField.Alignment :=taCenter;
          r: myField.Alignment :=taRightJustify;
        else
          raise Exception.Create('Unbekannte Ausrichtung');
        end; // case

        if myField.DataType=ftFloat then
        begin
          myFloatField:=TFloatField(myField) ;
          myFloatField.DisplayFormat:='0.00';
        end;
    end;

end;

///<summary>Setzt alle Felder, die nicht in Felder übergeben wurden,
/// auf unsichtbar.</summary>
procedure TWDataSet.FiltereSpalten(Felder: TWFeldNamen);
var
  I:Integer;
  myField:TField;
begin

    for I := 0 to Fields.Count-1 do
    begin

          myField:=Fields.Fields[I];
        if AnsiIndexText(myField.FieldName,Felder) < 0   then
          myField.Visible:=False;

    end;

end;

///<summary>Gibt die Feldeigenschaften in eine Datei aus.</summary>
/// <remarks>
/// Das Format ist geeignet, als Source-Code zur Definition einer Feldliste
/// vom Typ array of TWFeldTypRecord (s. Unit Datenmodul) verwendet zu werden.
/// </remarks>
procedure TWDataSet.print(TxtFile:TStreamWriter);
var
  I:Integer;
//  myField:TField;
  myFloatField:TFloatField ;
  txt:String;
begin

//  TxtFile:=TLogFile.Create();
//  TxtFile.OpenNew(Tools.LogDir,'TableINfos.txt');

    for I := 0 to Fields.Count-1 do
    begin
      with Fields.Fields[I] do
      begin
        if DataType=ftFloat then
        begin
          myFloatField:=TFloatField(Fields.Fields[I]);
          txt:=Format('Name: %s Label %S Format %s',[FieldName,DisplayLabel,myFloatField.DisplayFormat] )
        end else
        txt:=Format('Name: %s Label %S',[FieldName,DisplayLabel]);
        TxtFile.WriteLine(txt);
      end;

    end;

//  TxtFile.Close;

end;


end.
