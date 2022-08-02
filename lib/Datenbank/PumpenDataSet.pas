unit PumpenDataSet;

interface

uses
  System.SysUtils, System.Classes,  Data.DB, Datasnap.DBClient,
  Tools, Logger;

type
  TWFeldTypRecord = record
    N:String;
    T:TFieldType;
    P:Integer;
    C:String;
  end;
  TWFeldNamen = array of String;
  TWDataSet = class(TClientDataSet)
  private
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
  public
    procedure SetEditMode(Datensatz:TBookmark);
    procedure AddData(Felder:TFields);overload;
    procedure AddData(Key:String;Felder:TFields);overload;
    procedure AddData(Key:String;Val:Variant);overload;
    procedure EditData(Datensatz:TBookmark;Key:String;Val:Variant);overload;
    procedure EditData(Datensatz:TBookmark;Key:String;Felder:TFields);overload;
    procedure DefiniereSubTabelle(DS2Copy:TWDataSet;Filter:TWFeldNamen);
    procedure TabelleDefInFile();

    procedure DefiniereTabelle(Feldliste: array of TWFeldTypRecord);overload;
    procedure DefiniereTabelle(DS2Copy:TWDataSet;
                 Clear:Boolean;Create:Boolean;Filter:TWFeldNamen=nil);overload;
    function ToCSV:String;
    function FieldtypeAsString(aType:TFieldType):String;
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

procedure TWDataSet.SetEditMode(Datensatz:TBookmark);
begin
    Self.GotoBookmark(Datensatz);
    Edit;
end;

procedure TWDataSet.EditData(Datensatz:TBookmark;Key:String;Felder:TFields);
begin
    Self.GotoBookmark(Datensatz);
    Edit;
    FieldByName(Key).Value:=Felder.FieldByName(Key).Value;
    Post;
end;

procedure TWDataSet.EditData(Datensatz:TBookmark;Key:String;Val:Variant);
begin
    Self.GotoBookmark(Datensatz);
    Edit;
    FieldByName(Key).Value:=Val;
    Post;
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

procedure TWDataSet.DefiniereSubTabelle(DS2Copy:TWDataSet;Filter:TWFeldNamen);
var
  OrigFieldDef:TFieldDef;
  I:Integer;
  OrigName:String;
//  WasActive:Boolean;

begin

//  WasActive:=Active;
  Active:=False;

  FieldDefs.Clear;
  for I:=0 to length(Filter)-1 do
  begin

    OrigFieldDef:=DS2Copy.FieldDefs.Find(Filter[i]);
    with FieldDefs.AddFieldDef do
    begin
      DataType := OrigFieldDef.DataType;
      if DataType= ftFloat then
        Precision:=2;
      Size := OrigFieldDef.Size;
      Name := OrigFieldDef.Name;
    end;

  end;

  CreateDataSet;

end;

procedure TWDataSet.DefiniereTabelle(DS2Copy:TWDataSet;
                    Clear:Boolean;Create:Boolean;Filter:TWFeldNamen=nil);
var
  OrigFieldDef:TFieldDef;
  I:Integer;

begin

  Active:=False;
  if Clear then FieldDefs.Clear;

  if not DS2Copy.Active then
    DS2Copy.CreateDataSet;

  for I:=0 to DS2Copy.FieldDefs.Count-1 do
  begin
    OrigFieldDef := DS2Copy.FieldDefs.Items[I];

    with FieldDefs.AddFieldDef do
    begin
      DataType := OrigFieldDef.DataType;
      if DataType= ftFloat then
      begin
        Precision:=3;
//        Size:=10;
      end;

      Size := OrigFieldDef.Size;
      Name := OrigFieldDef.Name;
    end;
  end;

  if Create then CreateDataSet;

end;

function TWDataSet.FieldtypeAsString(aType:TFieldType):String;
begin
  case aType of
    ftString     :Result:='ftString';
    ftSmallint   :Result:='ftSmallint';
    ftInteger    :Result:='ftInteger';
    ftWord       :Result:='ftWord';
    ftBoolean    :Result:='ftBoolean';
    ftFloat      :Result:='ftFloat';
    ftCurrency   :Result:='ftCurrency';
    ftDate       :Result:='ftDate';
    ftTime       :Result:='ftTime';
    ftDateTime   :Result:='ftDateTime';
  else
    raise Exception.Create('Unbekannter Datentyp');
  end; // case

end;

procedure TWDataSet.DefiniereTabelle(Feldliste: array of TWFeldTypRecord);
var
  I:Integer;
  FieldNo:Integer;
  myFieldDef:TFieldDef;
  myField:TField ;
  myFloatField:TFloatField ;
begin

    Active:=False;

    FieldDefs.Clear;
    Fields.Clear;

    //Erst Felder anlegen
    for I := 0 to length(Feldliste)-1 do
    begin

        myFieldDef:=FieldDefs.AddFieldDef;

        myFieldDef.Name := Feldliste[I].N;

        myFieldDef.DataType := Feldliste[I].T;
        if myFieldDef.DataType= ftFloat then
        begin
          myFieldDef.Precision:=Feldliste[I].P;
        end;

    end;

    myFieldDef:=FieldDefs.Find('PreisJeLME');
    CreateDataSet;


    //Dann Precision setzen
    for I := 0 to length(Feldliste)-1 do
    begin

        myFieldDef:=FieldDefs.Find(Feldliste[I].N);

        if myFieldDef.DataType= ftFloat then
        begin
          myFieldDef.Precision:=Feldliste[I].P;
          myField:=Fields.FieldByName(Feldliste[I].N);
    active:=False;
          myFloatField:=TFloatField.Create(self) ;
          Fields.Remove(myField);
          myFloatField.Name:=Feldliste[I].N;
          myFloatField.FieldName:=Feldliste[I].N;
          myFloatField.DisplayFormat:='##.#';
          myFloatField.DataSet:=Self;
//          myFloatField.FieldNo:=FieldNo;
          Fields.Add(myFloatField);
    active:=True;
        end;


    end;



    myFieldDef:=FieldDefs.Find('PreisJeLME');

end;

//Speichert Felddefinitionen als array of TWFeldTypRecord
//Dieses kann in den Sourcecode kopiert werden
procedure TWDataSet.TabelleDefInFile();
var
  TxtFile:TLogFile;
  aFieldDef:TFieldDef;
  aType:TFieldType;
  I,J: Integer;
  Precision:String;
  txt :String;
begin


  TxtFile:=TLogFile.Create();
  TxtFile.OpenNew(Tools.LogDir,'TableDef.txt');
  for I := 0 to FieldDefs.count-1 do
  begin
     aFieldDef:=FieldDefs.Items[I];
     aType:=aFieldDef.DataType;
     if aFieldDef.Precision<>0 then
       Precision:= IntToStr(aFieldDef.Precision)
     else
        Precision:='5';  //Default

     //Format (N:'Testfeld1'; T:ftString; P:3; C:''),
     txt:= '(N: ''' + aFieldDef.Name + '''; T:' + FieldtypeAsString(aType) + '; P:' + Precision +'; C:''''),';
     TxtFile.Log(txt);
  end;
  TxtFile.Close;
end;

end.
