program DruckTest;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Printers,
  PumpenDataSet in '..\lib\Datenbank\PumpenDataSet.pas',
  DatenModul in '..\DatenModul.pas' {KaDataModule: TDataModule},
  Logger in '..\lib\Tools\Logger.pas',
  Preiseingabe in '..\Preiseingabe.pas' {PreisFrm},
  Settings in '..\lib\Tools\Settings.pas',
  DruckeTabelle in '..\lib\Tools\DruckeTabelle.pas',
  DruckBlatt in '..\lib\Tools\DruckBlatt.pas';

procedure DruckMal;
var
  Ausgabe:TWDataSetPrinter;
  txt,x:String;

begin
  for x in Printer.Printers do
  begin
      writeln(x);
  end;

  Ausgabe:=TWDataSetPrinter.Create(nil,'Microsoft Print to PDF',
                                              KaDataModule.AusgabeDS);
//  Ausgabe:=TWDataSetPrinter.Create(nil,'\\wernert-print\HP3015n-115');

  Ausgabe.Tabelle.Ausrichtung[2]:=c;
  Ausgabe.Tabelle.Ausrichtung[3]:=d;
  Ausgabe.Tabelle.NachkommaStellen[3]:=2;

  txt:='lalalal';
  Ausgabe.Kopfzeile.TextLinks:=txt;
  Ausgabe.Dokumentenkopf.TextMitte:=txt;
  DateTimeToString(txt, 'dd.mm.yy hh:mm', System.SysUtils.Now);
  Ausgabe.Kopfzeile.TextRechts:=txt;
  Ausgabe.Fusszeile.TextLinks:='Klaus Etscheidt';

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
