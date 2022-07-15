unit Stueckliste;

interface
  uses System.RTTI, System.SysUtils, System.Generics.Collections,
       Exceptions,Data.DB,Logger;

 type
    TSValue = TValue; //alias
    TSDictKeys = TArray<String>;
    TSPosdata = TDictionary<String, String>;
    TSStueli = TDictionary<String, TValue>;

    TSStueliPos = class
      private
      protected

      public
        Stueli: TSStueli;
        PosData:TSPosdata;
        hatTeil:Boolean;
        constructor Create();
        function ToStr():String;overload;
        function ToStr(KeyListe:TSDictKeys):String;overload;
        procedure AddPosData(PosDataKey:String;PosDataVal:String);overload;
        procedure AddPosData(PosDataKey:String;Felder:TFields);overload;
    end;

    TZEndKnotenListe = class(TList<TValue>)
        private
        public
          Liste: TList<TValue>;
          constructor Create;
          function ToStr():String;
          procedure WriteToLog;
    end;

implementation

uses StuecklistenPosition;

constructor TSStueliPos.Create();
begin
  //untergeordenete Stueli anlegen
  Stueli:= TSStueli.Create;
  Posdata:=TSPosdata.Create;

  //noch kein Teil zugeordnet (Teil wird auch nicht fuer alle PosTyp gesucht)
  hatTeil:=False;

  inherited;
end;

procedure TSStueliPos.AddPosData(PosDataKey:String;PosDataVal:String);
begin
    PosData.Add(PosDataKey, PosDataVal);
end;

procedure TSStueliPos.AddPosData(PosDataKey:String;Felder:TFields);
begin
    PosData.Add( PosDataKey, trim(Felder.FieldByName(PosDataKey).AsString));
end;


function TSStueliPos.ToStr(KeyListe:TSDictKeys):String;
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

function TSStueliPos.ToStr():String;
const trenn = ' ; ' ;
var
  val,txt:string;
begin
  txt:='';
  for val in  PosData.Values do
  begin
    txt:= txt + val + trenn;
  end;
  Result:=txt;
end;


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

constructor TZEndKnotenListe.Create;
begin
  inherited;
end;

function TZEndKnotenListe.ToStr():String;
var
  txt:String;
  Member:TZValue;
  StueliPos: TSStueliPos;

begin
  txt:= 'EndknotenListe: ';
  for Member in Self do
  begin
    StueliPos:= Member.AsType<TSStueliPos>;
    txt:= txt + '<' + StueliPos.ToStr() +  '>'  ;
  end;
  Result := txt;
end;

procedure TZEndKnotenListe.WriteToLog;
var
  Member:TZValue;
  StueliPos: TZStueliPos;

begin
  Log.Log('EndknotenListe: ');
  for Member in Self do
  begin
    StueliPos:= Member.AsType<TZStueliPos>;
    Log.Log(StueliPos.ToStr );
  end;
end;

end.
