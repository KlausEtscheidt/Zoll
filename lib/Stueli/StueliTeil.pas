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
      function ToStr():String;

    end;

implementation

function TWStueliTeil.ToStr():String;
  var trenn :String;
begin
  Result:=Ausgabe.ToStr();
end;


end.
