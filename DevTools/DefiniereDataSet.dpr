program DefiniereDataSet;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Data.DB,
  Logger in '..\lib\Tools\Logger.pas',
  PumpenDataSet in '..\lib\Datenbank\PumpenDataSet.pas';

begin
var
  DS: TWDataSet;
  try
//    CoInitialize(nil);

    DS: TWDataSet.Create(nil);
    //Datenmodul initialiseren
    //Die Datei enthält eine Beispielausgabe und definiert damit erst mal die Felder;
    DS.FileName:= '\Erg.xml'; //LogDir +'\Erg.xml';
    DS.Active:=True;
    //Dynamisch neue Felder erzeugen
    DS.DefiniereTabelle(Felder);
    //FElder drucken
    DS.TabelleDefInFile;


  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
