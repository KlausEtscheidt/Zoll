program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  SQLite in 'SQLite.pas' {SQLiteDataModule: TDataModule},
  DBQryUNIPPS in 'DBQryUNIPPS.pas',
  DBZugriff in 'DBZugriff.pas',
  DBQrySQLite in 'DBQrySQLite.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TSQLiteDataModule, SQLiteDataModule);
  Application.Run;
end.
