unit StueliTeil;

interface

uses System.SysUtils, System.Generics.Collections,Data.DB;

  type
    TWTeileDaten = TDictionary<String, String>;

    TStueliTeil = class
      TeileDaten: TWTeileDaten;
    private

    protected

    public
      //  constructor Create; override;
      //  destructor Destroy; override;
      procedure AddData(Key:String;Val:String);overload;
      procedure AddData(Key:String;Felder:TFields);overload;
    end;

    implementation

procedure TStueliTeil.AddData(Key:String;Val:String);
begin
    TeileDaten.Add(Key, Val);
end;

procedure TStueliTeil.AddData(Key:String;Felder:TFields);
begin
    TeileDaten.Add( Key, trim(Felder.FieldByName(Key).AsString));
end;


end.
