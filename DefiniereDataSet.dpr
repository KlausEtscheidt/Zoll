program DefiniereDataSet;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,   Data.DB,
  DatenModul in 'DatenModul.pas' {KaDataModule: TDataModule},
  Tools in 'lib\Tools\Tools.pas',
  Logger in 'lib\Tools\Logger.pas',
  ADOConnector in 'lib\Datenbank\ADOConnector.pas',
  ADOQuery in 'lib\Datenbank\ADOQuery.pas',
  BaumQrySQLite in 'lib\Datenbank\BaumQrySQLite.pas',
  BaumQryUNIPPS in 'lib\Datenbank\BaumQryUNIPPS.pas',
  PumpenDataSet in 'lib\Datenbank\PumpenDataSet.pas';


begin

  try
//    CoInitialize(nil);

    //Datenmodul initialiseren
    DatenModul.KaDataModule := TKaDataModule.Create(nil);
    //Die Datei enthält eine Beispielausgabe und definiert damit erst mal die Felder;
    KaDataModule.ErgebnisDS.FileName:= LogDir +'\Erg.xml';
    KaDataModule.ErgebnisDS.Active:=True;
    //Dynamisch neue Felder erzeugen
//    KaDataModule.ErgebnisDS.DefiniereTabelle(Felder);
    //FElder drucken
    KaDataModule.ErgebnisDS.TabelleDefInFile;


  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
