program DefiniereDataSet;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Data.DB, Datasnap.DBClient,
  Logger in '..\lib\Tools\Logger.pas',
  PumpenDataSet in '..\lib\Datenbank\PumpenDataSet.pas';

  const
    TestFelder: array [0..48] of TWFeldTypRecord =
     (
        (N: 'EbeneNice'; T:ftString; C:'Ebene'),
        (N: 'id_stu'; T:ftString; C:''),
        (N: 'PreisJeLME'; T:ftCurrency; C:''),
        (N: 'MengeTotal'; T:ftFloat; C:''),
        (N: 'faktlme_sme'; T:ftFloat; C:''),
        (N: 'faktlme_bme'; T:ftFloat; C:''),
        (N: 'faktbme_pme'; T:ftFloat; C:''),
        (N: 'netto_poswert'; T:ftCurrency; C:''),
        (N: 'pos_nr'; T:ftInteger; C:''),
        (N: 'stu_t_tg_nr'; T:ftString; C:''),
        (N: 'stu_oa'; T:ftInteger; C:''),
        (N: 'stu_unipps_typ'; T:ftString; C:''),
        (N: 'id_pos'; T:ftInteger; C:''),
        (N: 'besch_art'; T:ftInteger; C:''),
        (N: 'menge'; T:ftFloat; C:''),
        (N: 'FA_Nr'; T:ftString; C:''),
        (N: 'verurs_art'; T:ftInteger; C:''),
        (N: 'ueb_s_nr'; T:ftInteger; C:''),
        (N: 'ds'; T:ftInteger; C:''),
        (N: 'set_block'; T:ftInteger; C:''),
        (N: 'PosTyp'; T:ftString; C:''),
        (N: 'PreisEU'; T:ftCurrency; C:''),
        (N: 'PreisNonEU'; T:ftCurrency; C:''),
        (N: 'SummeEU'; T:ftCurrency; C:''),
        (N: 'SummeNonEU'; T:ftCurrency; C:''),
        (N: 'vk_netto'; T:ftCurrency; C:''),
        (N: 'vk_brutto'; T:ftCurrency; C:''),
        (N: 'Ebene'; T:ftInteger; C:''),
        (N: 't_tg_nr'; T:ftString; C:''),
        (N: 'oa'; T:ftInteger; C:''),
        (N: 'unipps_typ'; T:ftString; C:''),
        (N: 'Bezeichnung'; T:ftString; C:''),
        (N: 'v_besch_art'; T:ftInteger; C:''),
        (N: 'praeferenzkennung'; T:ftInteger; C:'PFK'),
        (N: 'sme'; T:ftInteger; C:''),
        (N: 'lme'; T:ftInteger; C:''),
        (N: 'preis'; T:ftCurrency; C:''),
        (N: 'bestell_id'; T:ftInteger; C:''),
        (N: 'bestell_datum'; T:ftString; C:''),
        (N: 'best_t_tg_nr'; T:ftString; C:''),
        (N: 'basis'; T:ftFloat; C:''),
        (N: 'pme'; T:ftInteger; C:''),
        (N: 'bme'; T:ftInteger; C:''),
        (N: 'we_menge'; T:ftFloat; C:''),
        (N: 'lieferant'; T:ftInteger; C:''),
        (N: 'kurzname'; T:ftString; C:''),
        (N: 'best_menge'; T:ftFloat; C:''),
        (N: 'AnteilNonEU'; T:ftFloat; C:''),
        (N: 'ZuKAPos'; T:ftInteger; C:'')
     );

var
  BaseDir:String;

function FieldtypeAsString(aType:TFieldType):String;
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


//Speichert Felddefinitionen als array of TWFeldTypRecord
//Dieses kann in den Sourcecode kopiert werden
procedure TabelleDefInFile(aDS: TWDataSet);
var
  TxtFile:TLogFile;
  aFieldDef:TFieldDef;
  aField:TField;
  aType:TFieldType;
  I,J: Integer;
  Precision:String;
  txt :String;
  capt:String;

begin

  TxtFile:=TLogFile.Create();
  TxtFile.OpenNew(BaseDir,'TableDef.txt');
  for I := 0 to aDS.FieldDefs.count-1 do
  begin
     aFieldDef:=aDS.FieldDefs.Items[I];
     aType:=aFieldDef.DataType;
     aField:=aDS.FieldByName(aFieldDef.Name);
     //#######hier noch Bedingung ändern, wo wird der schöne Name gespeichert ?
//     if aField.DisplayLabel<>aField.FieldName then
     if aField.DisplayName<>aField.FieldName then
       //capt:= aField.DisplayLabel
       capt:= aField.DisplayName
     else
        capt:='';  //Default

     //altes Format (N:'Testfeld1'; T:ftString; P:3; C:''),
     txt:= '(N: ''' + aFieldDef.Name + '''; T:' + FieldtypeAsString(aType) + '; P:' + Precision +'; C:''''),';
     //neues Format ohne Precision (N:'Testfeld1'; T:ftString; C:''),
     txt:= '(N: ''' + aFieldDef.Name + '''; T:' + FieldtypeAsString(aType) + '; C:'''+ capt + '''),';
     TxtFile.Log(txt);
  end;
  TxtFile.Close;
end;

procedure DefiniereStartTabelle(aDS: TWDataSet);
var
  myFieldDef:TFieldDef;
begin
    myFieldDef:=aDS.FieldDefs.AddFieldDef;
    myFieldDef.Name := 'irgend_n_Name';
    myFieldDef.DataType := ftString;
    aDS.CreateDataSet;
end;

var
  DS: TWDataSet;
  FelderDict: TWFeldTypenDict;
  FeldNamen:  TWFeldNamen;

begin

  try

    //Wo sind wir
    BaseDir:=ExtractFileDir(ParamStr(0));
    //von win32 2 x hoch gehen
    BaseDir:=ExtractFileDir(ExtractFileDir(BaseDir));

   //Lege Felddefintionen in Dict und alle Namen in FeldNamen ab
   FelderDict:=TWFeldTypenDict.Create;
   var I:Integer;
   setlength(FeldNamen,length(TestFelder));
   for I:=0 To length(TestFelder)-1 do
   begin
      //Lege kompletten Record in Dict ab, key ist der FeldName
      FelderDict.Add(TestFelder[I].N,TestFelder[I]);
      FeldNamen[I]:=TestFelder[I].N;
   end;

    DS:= TWDataSet.Create(nil);

    //Die Datei enthält eine Beispielausgabe und definiert damit erst mal die Felder;
    // DS.FileName:= '\Erg.xml'; //LogDir +'\Erg.xml';

//    DS.Active:=True;

    //Erst mal was zum Start erzeugen,
    // damit dann DefiniereTabelle aus Unit PumpenDataSet genutzt werden kann
    DefiniereStartTabelle(DS);

    //Dynamisch neue Felder erzeugen
    DS.DefiniereTabelle(FelderDict,FeldNamen);

    //FElder drucken
    TabelleDefInFile(DS);


  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
