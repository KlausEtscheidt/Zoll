program DruckTest;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,Printers,
  DruckBlatt in '..\lib\Tools\DruckBlatt.pas',
  PumpenDataSet in '..\lib\Datenbank\PumpenDataSet.pas',
  DatenModul in '..\DatenModul.pas' {KaDataModule: TDataModule},
  Logger in '..\lib\Tools\Logger.pas',
  Preiseingabe in '..\Preiseingabe.pas' {PreisFrm},
  Settings in '..\lib\Tools\Settings.pas',
  DruckeTabelle in '..\lib\Tools\DruckeTabelle.pas';

procedure DruckMal;
const
  Ausrichtungen:array [0..1] of TWColumnAlignment=
                                     ((C:1;J:d;P:3),(C:2;J:c));
var
  Ausgabe:TWDataSetPrinter;
  x:String;

begin
  for x in Printer.Printers do
  begin
      writeln(x);
  end;

  Ausgabe:=TWDataSetPrinter.Create(nil,'Microsoft Print to PDF',
                                              KaDataModule.AusgabeDS);
//  Ausgabe:=TWDataSetPrinter.Create(nil,'\\wernert-print\HP3015n-115');

  Ausgabe.Tabelle.SetAusrichtungen(Ausrichtungen);

  try
//  Ausgabe.Drucker:= Printer;
  Ausgabe.Drucken();
  finally
    if Ausgabe.Drucker.Printing then
      Ausgabe.Drucker.EndDoc;
  end;

end;

begin
  try
//      CoInitialize(nil);

    //Datenmodul initialiseren
    DatenModul.KaDataModule := TKaDataModule.Create(nil);
    DruckMal;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
