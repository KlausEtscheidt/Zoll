unit Stueckliste;

interface
  uses System.RTTI, System.SysUtils, System.Generics.Collections,
       Exceptions,Data.DB,Tools,Logger;

 type
    TWValue = TValue; //alias
    TwDictKeys = TArray<String>;
    TWPosdata = TDictionary<String, String>;
    TWTeileEigenschaften = TFields;
    TWStueli = TDictionary<String, TValue>;

    TWStueliPos = class
      private
//        FStueliTeil: TValue; //bel. Objekt

      protected

      public
        Stueli: TWStueli;
        PosData:TWPosdata;   //Positions-Daten fuer Ausgaben
        StueliTeil: TValue;
        FTeileEigenschaften:TWTeileEigenschaften; //Teile-Daten fuer Ausgaben
        hatTeil:Boolean;
        constructor Create();
        function ToStr():String;overload;
        function ToStr(KeyListe:TwDictKeys):String;overload;
        procedure AddPosData(PosDataKey:String;PosDataVal:String);overload;
        procedure AddPosData(PosDataKey:String;Felder:TFields);overload;
        function GetTeileEigenschaften():String;
        procedure SetTeileEigenschaften(Felder:TFields);
//        procedure SetStueliTeil(Teil: TValue);
//        property StueliTeil:TValue read FStueliTeil write SetStueliTeil;

        property TeileEigenschaften:TWTeileEigenschaften
                      read FTeileEigenschaften write SetTeileEigenschaften;
    end;

    TWEndKnotenListe = class(TList<TValue>)
        private
        public
          Liste: TList<TValue>;
          constructor Create;
          function ToStr():String;
          procedure WriteToLog;
    end;

implementation

uses UnippsStueliPos;

constructor TWStueliPos.Create();
begin
  //untergeordenete Stueli anlegen
  Stueli:= TWStueli.Create;
  Posdata:=TWPosdata.Create;
//  TeileEigenschaften:=TWTeileEigenschaften.Create;

  //noch kein Teil zugeordnet (Teil wird auch nicht fuer alle PosTyp gesucht)
  hatTeil:=False;

  inherited;
end;

//procedure TWStueliPos.SetStueliTeil(Teil: TValue);
//begin
//  FStueliTeil:=Teil;
//end;
procedure TWStueliPos.SetTeileEigenschaften(Felder:TFields);
var myfield: TField;
begin
  FTeileEigenschaften:=Felder;
end;

function TWStueliPos.GetTeileEigenschaften():String;
var
myfield: TField;
txt:String;
begin
    txt:='';
    if not assigned(FTeileEigenschaften ) then
      exit;
    for myfield in  FTeileEigenschaften do
    begin
        txt:=txt + Trim(myField.AsString) + ', ';
    end;
    System.delete(txt,length(txt)-1,1);
    Result:=txt;


end;


procedure TWStueliPos.AddPosData(PosDataKey:String;PosDataVal:String);
begin
    PosData.Add(PosDataKey, PosDataVal);
end;

procedure TWStueliPos.AddPosData(PosDataKey:String;Felder:TFields);
begin
    PosData.Add( PosDataKey, trim(Felder.FieldByName(PosDataKey).AsString));
end;


function TWStueliPos.ToStr(KeyListe:TwDictKeys):String;
const trenn = ' ; ' ;
var
  txt,key:string;

  begin
  txt:='';
  for key in  KeyListe do
  begin
    txt:= txt + PosData[key] + trenn;
  end;
  Result:=txt;
end;

function TWStueliPos.ToStr():String;
const trenn = ' ; ' ;
var
  val,txt:string;
  myfield:TField;
begin
  txt:='';
  for val in  PosData.Values do
  begin
    txt:= txt + val + trenn;
  end;
  txt:=txt+GetTeileEigenschaften;
  Result:=txt;


end;


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

constructor TWEndKnotenListe.Create;
begin
  inherited;
end;

function TWEndKnotenListe.ToStr():String;
var
  txt:String;
  Member:TWValue;
  StueliPos: TWStueliPos;

begin
  txt:= 'EndknotenListe: ';
  for Member in Self do
  begin
    StueliPos:= Member.AsType<TWStueliPos>;
    txt:= txt + '<' + StueliPos.ToStr() +  '>'  ;
  end;
  Result := txt;
end;

procedure TWEndKnotenListe.WriteToLog;
var
  Member:TWValue;
  StueliPos: TWStueliPos;

begin
  Tools.Log.Log('EndknotenListe: ');
  for Member in Self do
  begin
    StueliPos:= Member.AsType<TWStueliPos>;
    Tools.Log.Log(StueliPos.ToStr );
  end;
end;

end.
