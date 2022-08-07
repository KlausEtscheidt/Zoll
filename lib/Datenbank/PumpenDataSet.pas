unit PumpenDataSet;

interface

uses
  System.SysUtils, System.Classes, StrUtils,  System.Generics.Collections,
   Data.DB, Datasnap.DBClient,
//  Tools,
  Logger
  ;

type
  TWFeldAusrichtung = (l,c,r);
  TWFeldTypRecord = record
    N:String;  //Feldname
    T:TFieldType; //Feldtyp
    C:String;  //schöner Name Caption für HEader usw
    W:Integer; //Breite
    J:TWFeldAusrichtung; //Ausrichtung
  end;

  TWFeldTypenDict = TDictionary<String,TWFeldTypRecord>;
  TWFeldNamen = array of String;

  TWDataSet = class(TClientDataSet)
  private
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
  public
    procedure AddData(Felder:TFields);overload;
    procedure AddData(Key:String;Felder:TFields);overload;
    procedure AddData(Key:String;Val:Variant);overload;
    procedure DefiniereTabelle(FeldTypen:TWFeldTypenDict;
                                               Felder: TWFeldNamen);
    procedure DefiniereFeldEigenschaften(FeldTypen:TWFeldTypenDict);
    procedure DefiniereReadOnly(Felder: TWFeldNamen=[]);
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

//Feld mit Namen Key eines Records uebernehmen
procedure TWDataSet.AddData(Key:String;Felder:TFields);
begin
    FieldByName(Key).Value:=Felder.FieldByName(Key).Value;
end;


//Alle Felder eines Records uebernehmen
procedure TWDataSet.AddData(Felder:TFields);
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

//Einen Wert fuer Feld mit Namen Key uebernehmen
procedure TWDataSet.AddData(Key:String;Val:Variant);
begin
    FieldByName(Key).Value:=Val;
end;

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
///<param name="Felder"> Array mit den Namen der Felder,
///  die "schreibbar" werden sollen. </param>
procedure TWDataSet.DefiniereReadOnly(Felder: TWFeldNamen=[]);
var
  I:Integer;
  myField:TField ;
begin

    //Erste alle of Read only
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

///<summary>Definiert ein Dataset</summary>
///<param name="FeldTypen"> Dict mit Eigenschaften aller Felder.
///Als key dient ein Name aus "Felder".</param>
///<param name="Felder"> Array mit den Namen aller Felder, die angelegt werden sollen.
///Das Array definiert auch die Reihenfolge. Die Namen müssen in FeldTypen vorhanden sein.
/// </param>
procedure TWDataSet.DefiniereTabelle(FeldTypen:TWFeldTypenDict;
                                         Felder: TWFeldNamen);
var
  I:Integer;
  myFieldDef:TFieldDef;
  myField:TField ;
  myFloatField:TFloatField ;
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

//Eigenschaften fuer Felder setzen
procedure TWDataSet.DefiniereFeldEigenschaften(FeldTypen:TWFeldTypenDict);
var
  I:Integer;
  myFieldDef:TFieldDef;
  myField:TField ;
  myFloatField:TFloatField ;
  Name:String;
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
          myFloatField.DisplayFormat:='0.##';
        end;
    end;

end;


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

procedure TWDataSet.print(TxtFile:TStreamWriter);
var
  I:Integer;
  myField:TField;
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
