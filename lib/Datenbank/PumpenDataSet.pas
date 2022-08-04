unit PumpenDataSet;

interface

uses
  System.SysUtils, System.Classes, StrUtils,  System.Generics.Collections,
   Data.DB, Datasnap.DBClient,
  Tools,Logger;

type
  TWFeldTypRecord = record
    N:String;  //Feldname
    T:TFieldType; //Feldtyp
//    P:Integer;
    C:String;  //sch�ner Name Caption f�r HEader usw
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
    procedure DefiniereReadOnlyFalse(Felder: TWFeldNamen);
    function ToCSV:String;
    procedure FiltereSpalten(Felder: TWFeldNamen);
    procedure print;

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

///<summary>Setzt die ReadOnly-Eigenschaft der �bergebenen Felder auf False
///</summary>
///<param name="Felder"> Array mit den Namen der Felder,
///  die "schreibbar" werden sollen. </param>

procedure TWDataSet.DefiniereReadOnlyFalse(Felder: TWFeldNamen);
var
  I:Integer;
  myField:TField ;
begin
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
///Das Array definiert auch die Reihenfolge. Die Namen m�ssen in FeldTypen vorhanden sein.
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

    if Fields.Count>0 then
    begin
      Active:=True;

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
        if myRec.C<>'' then
        begin
          myFieldDef.DisplayName:=myRec.C;
        end;


    end;

    //Felder erzeugen
    CreateDataSet;

    //Dann weitere Eigenschaften fuer Felder setzen
    for I := 0 to Fields.Count-1 do
    begin
        myField:=Fields.Fields[I];
        myRec:=FeldTypen[myField.FieldName];

        if myRec.C<>'' then
        begin
//          myField.fieldd .DisplayName:=myRec.C;
          myField.DisplayLabel:=myRec.C;
        end;


        if myField.DataType=ftFloat then
        begin
          myFloatField:=TFloatField(myField) ;
          myFloatField.DisplayFormat:='0.##';
        end;
    end;

end;

procedure TWDataSet.DefiniereFeldEigenschaften(FeldTypen:TWFeldTypenDict);
var
  I:Integer;
  myFieldDef:TFieldDef;
  myField:TField ;
  myFloatField:TFloatField ;
  Name:String;
  myRec:TWFeldTypRecord;

  begin

    //Dann weitere Eigenschaften fuer Felder setzen
    for I := 0 to Fields.Count-1 do
    begin
        myField:=Fields.Fields[I];
        myRec:=FeldTypen[myField.FieldName];
        myField.ReadOnly:=True;

        if myRec.C<>'' then
        begin
//          myField.fieldd .DisplayName:=myRec.C;
          myField.DisplayLabel:=myRec.C;
        end;


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

procedure TWDataSet.print;
var
  I:Integer;
  myField:TField;
  myFloatField:TFloatField ;
  TxtFile:TLogFile;
  txt:String;
begin

  TxtFile:=TLogFile.Create();
  TxtFile.OpenNew(Tools.LogDir,'TableINfos.txt');

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
        TxtFile.Log(txt);
      end;

    end;

  TxtFile.Close;

end;


end.
