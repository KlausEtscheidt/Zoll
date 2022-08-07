program NeueStueliTest;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Stueckliste in '..\lib\Stueli\Stueckliste.pas',
  Logger in '..\lib\Tools\Logger.pas';

var
  TopPos,SubPos,XPos:TWStueliPos;
  VaterPos,KindPos,EnkelPos,UrEnkelPos:TWStueliPos;
  txt:String;
  Key:Integer;
  Log:TLogFile;
  BaseDir:String;

begin
  try
      //Wo sind wir
    BaseDir:=ExtractFileDir(ParamStr(0));
    //von win32 2 x hoch gehen
    BaseDir:=ExtractFileDir(ExtractFileDir(BaseDir));

    Log:=TLogFile.Create();
    Log.OpenNew(BaseDir,'StrukTest.txt');

    TopPos:=TWStueliPos.Create(nil,'keineStu',1);
    SubPos:=TWStueliPos.Create(TopPos,'IDmeineStu_1',25);
    TopPos.StueliAdd(SubPos);
    SubPos:=TWStueliPos.Create(TopPos,'IDmeineStu_2',15);
    TopPos.StueliAdd(SubPos);
    SubPos:=TWStueliPos.Create(TopPos,'IDmeineStu_3',5);
    TopPos.StueliAdd(SubPos);
    XPos:=TopPos.Stueli[1];
    for Key in TopPos.StueliKeys do
    begin
       XPos:=TopPos.Stueli[Key];
    end;

    TopPos.SetzeEbenenUndMengen(1,1);
    txt:='Orig' + #10;
    txt:= TopPos.BaumAlsText(txt);
    Log.Log(txt);

    //Hänge 3. Eintrag (Key=3) der Liste von TopPos
    // unter den 1. Eintrag (Key=1) der Liste von TopPos
    VaterPos:=TopPos.Stueli[1];
    KindPos:=TopPos.Stueli[3];
    VaterPos.StueliTakePosFrom(KindPos);

    TopPos.SetzeEbenenUndMengen(1,1);
    txt:='verschoben' + #10;
    txt:= TopPos.BaumAlsText(txt);
    Log.Log(txt);

    //Und das Ganze zurück
    TopPos.StueliTakePosFrom(KindPos);

    TopPos.SetzeEbenenUndMengen(1,1);
    txt:='zurück verschoben' + #10;
    txt:= TopPos.BaumAlsText(txt);
    Log.Log(txt);

    //Enkel dazu
    XPos:=TopPos.Stueli[2];
    EnkelPos:=TWStueliPos.Create(XPos,'Enkel',10);
    XPos.StueliAdd(EnkelPos);

    UrEnkelPos:=TWStueliPos.Create(EnkelPos,'Ur Enkel 1',100);
    EnkelPos.StueliAdd(UrEnkelPos);
    UrEnkelPos:=TWStueliPos.Create(EnkelPos,'Ur Enkel 2',200);
    EnkelPos.StueliAdd(UrEnkelPos);
    UrEnkelPos:=TWStueliPos.Create(EnkelPos,'Ur Enkel 3',300);
    EnkelPos.StueliAdd(UrEnkelPos);

    TopPos.SetzeEbenenUndMengen(1,1);
    txt:='Jetzt mit Enkeln' + #10;
    txt:= TopPos.BaumAlsText(txt);
    Log.Log(txt);

    //Ur-Enkel verschieben
    VaterPos:=TopPos.Stueli[2];
    VaterPos.StueliTakeChildrenFrom(EnkelPos);
    EnkelPos.ReMove;

    TopPos.SetzeEbenenUndMengen(1,1);
    txt:='Jetzt mit verschobenen Ur-Enkeln' + #10;
    txt:= TopPos.BaumAlsText(txt);
    Log.Log(txt);

    Log.Close;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
