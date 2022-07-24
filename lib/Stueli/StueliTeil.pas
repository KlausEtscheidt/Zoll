unit StueliTeil;

interface

uses System.Generics.Collections,Data.DB,
      StueliEigenschaften;

  type
//    TWTeileDaten = TDictionary<String, String>;

    TWStueliTeil = class
        Ausgabe:TWEigenschaften;

    private

    protected

    public
      //  constructor Create; override;
      //  destructor Destroy; override;
      function ToStr(KeyListe:TWFilter;var header:String):String;

    end;

implementation

function TWStueliTeil.ToStr(KeyListe:TWFilter;var header:String):String;
  var trenn :String;
begin
  Result:='####################';
end;


end.
