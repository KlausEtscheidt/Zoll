program NeueStueliTest;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Stueckliste in 'Stueckliste.pas',
  Logger in '..\Tools\Logger.pas';

var
  TopPos,SubPos,XPos:TWStueliPos;
  VaterPos,KindPos:TWStueliPos;
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
    SubPos:=TWStueliPos.Create(TopPos,'IDmeineStu',25);
    TopPos.StueliAdd(SubPos);
    SubPos:=TWStueliPos.Create(TopPos,'IDmeineStu',15);
    TopPos.StueliAdd(SubPos);
    SubPos:=TWStueliPos.Create(TopPos,'IDmeineStu',5);
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
    VaterPos.StueliMove(KindPos);

    TopPos.SetzeEbenenUndMengen(1,1);
    txt:='verschoben' + #10;
    txt:= TopPos.BaumAlsText(txt);
    Log.Log(txt);

    //Und das Ganze zurück
    TopPos.StueliMove(KindPos);

    TopPos.SetzeEbenenUndMengen(1,1);
    txt:='zurück verschoben' + #10;
    txt:= TopPos.BaumAlsText(txt);
    Log.Log(txt);

    Log.Close;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
