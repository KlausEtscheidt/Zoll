program DefiniereDataSet;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,System.Classes,
  Data.DB, Datasnap.DBClient,
  Logger in '..\lib\Tools\Logger.pas',
  PumpenDataSet in '..\lib\Datenbank\PumpenDataSet.pas';

  const
    TestFelder: array [0..48] of TWFeldTypRecord =
     (
      (N: 'EbeneNice'; T:ftString; C:'Ebene'; W:10; J:l),
      (N: 'id_stu'; T:ftString; C:'zu Stu'; W:10; J:l),
      (N: 'PreisJeLME'; T:ftCurrency; C:''; W:10; J:l),
      (N: 'MengeTotal'; T:ftFloat; C:''; W:10; J:l),
      (N: 'faktlme_sme'; T:ftFloat; C:''; W:10; J:l),
      (N: 'faktlme_bme'; T:ftFloat; C:''; W:10; J:l),
      (N: 'faktbme_pme'; T:ftFloat; C:''; W:10; J:l),
      (N: 'netto_poswert'; T:ftCurrency; C:''; W:10; J:l),
      (N: 'pos_nr'; T:ftString; C:'Pos-Nr'; W:10; J:l),
      (N: 'stu_t_tg_nr'; T:ftString; C:'Teile-Nr'; W:10; J:l),
      (N: 'stu_oa'; T:ftInteger; C:''; W:10; J:l),
      (N: 'stu_unipps_typ'; T:ftString; C:''; W:10; J:l),
      (N: 'id_pos'; T:ftInteger; C:'Id Pos'; W:10; J:l),
      (N: 'besch_art'; T:ftInteger; C:''; W:10; J:l),
      (N: 'menge'; T:ftFloat; C:'Menge'; W:10; J:l),
      (N: 'FA_Nr'; T:ftString; C:''; W:10; J:l),
      (N: 'verurs_art'; T:ftInteger; C:''; W:10; J:l),
      (N: 'ueb_s_nr'; T:ftInteger; C:''; W:10; J:l),
      (N: 'ds'; T:ftInteger; C:''; W:10; J:l),
      (N: 'set_block'; T:ftInteger; C:''; W:10; J:l),
      (N: 'PosTyp'; T:ftString; C:''; W:10; J:l),
      (N: 'PreisEU'; T:ftCurrency; C:''; W:10; J:l),
      (N: 'PreisNonEU'; T:ftCurrency; C:''; W:10; J:l),
      (N: 'SummeEU'; T:ftCurrency; C:''; W:10; J:l),
      (N: 'SummeNonEU'; T:ftCurrency; C:''; W:10; J:l),
      (N: 'vk_netto'; T:ftCurrency; C:'VK rabattiert'; W:10; J:l),
      (N: 'vk_brutto'; T:ftCurrency; C:'VK Liste'; W:10; J:l),
      (N: 'Ebene'; T:ftInteger; C:''; W:10; J:l),
      (N: 't_tg_nr'; T:ftString; C:'Teile-Nr'; W:10; J:l),
      (N: 'oa'; T:ftInteger; C:''; W:10; J:l),
      (N: 'unipps_typ'; T:ftString; C:''; W:10; J:l),
      (N: 'Bezeichnung'; T:ftString; C:''; W:10; J:l),
      (N: 'v_besch_art'; T:ftInteger; C:''; W:10; J:l),
      (N: 'praeferenzkennung'; T:ftInteger; C:''; W:10; J:l),
      (N: 'sme'; T:ftInteger; C:''; W:10; J:l),
      (N: 'lme'; T:ftInteger; C:''; W:10; J:l),
      (N: 'preis'; T:ftCurrency; C:''; W:10; J:l),
      (N: 'bestell_id'; T:ftInteger; C:''; W:10; J:l),
      (N: 'bestell_datum'; T:ftDate; C:''; W:10; J:l),
      (N: 'best_t_tg_nr'; T:ftString; C:''; W:10; J:l),
      (N: 'basis'; T:ftFloat; C:''; W:10; J:l),
      (N: 'pme'; T:ftInteger; C:''; W:10; J:l),
      (N: 'bme'; T:ftInteger; C:''; W:10; J:l),
      (N: 'we_menge'; T:ftFloat; C:''; W:10; J:l),
      (N: 'lieferant'; T:ftInteger; C:''; W:10; J:l),
      (N: 'kurzname'; T:ftString; C:''; W:10; J:l),
      (N: 'best_menge'; T:ftFloat; C:''; W:10; J:l),
      (N: 'AnteilNonEU'; T:ftFloat; C:''; W:10; J:l),
      (N: 'ZuKAPos'; T:ftInteger; C:'gehört zu'; W:10; J:l)

     );

var
  BaseDir:String;

function JustificationAsString(aJust:TWFeldAusrichtung):String;
begin
  case aJust of
    l     :Result:='l';
    c     :Result:='c';
    r     :Result:='r';
  else
    raise Exception.Create('Unbekannter Datentyp');
  end; // case

end;

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
  width:Integer;
  justif:TWFeldAusrichtung;

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

    case aField.Alignment of
      taLeftJustify :justif:=l;
      taCenter :justif:=C;
      taRightJustify :justif:=r;
    else
      raise Exception.Create('Unbekannte Ausrichtung');
    end; // case

    width:=aField.Size;
    if width=0 then width:=10;

     //neues Format ohne Precision (N:'Testfeld1'; T:ftString; C:''),
     txt:= '(N: ''' + aFieldDef.Name + '''; T:' + FieldtypeAsString(aType)
     + '; C:'''+ capt + '''; W:' + IntToStr(width) + '; J:'
     + JustificationAsString(justif) + '),';
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
