///<summary>Komfort-Funktionen zum Verbinden mit einer Datenbank
///</summary>
///<remarks>
/// Funktionalitäten aus der Delphi-Klasse TADOConnection werden ergänzt,
/// um komfortabel eine Verbindung zur WERNERT-Unipps-Datenbank oder
/// zur einer beliebigen SQLite-Datenbank aufzubauen.
/// |
/// Die Eigenschaft Connection enthält eine TADOConnection,
/// die an Instanzen von TWADOQuery übergeben werden kann.
///</remarks>
unit FDConnector;

interface

uses  System.SysUtils,  System.Classes,
//  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
//  FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client, FireDAC.Phys.MSAccDef, FireDAC.Phys.ODBCBase,
  FireDAC.Phys.MSAcc,
Data.Win.ADODB  ;

type
    ///<summary>Wenn die Verbindung zur Datenbank fehlschlägt,
    ///wird der Fehler: &quot;Konnte Datenbank nicht öffen.&quot; erzeugt.</summary>
    EFDConnectErr = class(Exception);

    ///<summary>Klasse zur einfachen Verbindung mit UNIPPS oder SQLite</summary>
    TWFDConnector = class(TComponent)
      constructor Create(AOwner: TComponent);
      function ConnectToSQLite(PathTODBFile: String): TFDConnection;
      function ConnectToAccess(PathTODBFile: String): TFDConnection;
//      function ConnectToDB(AConnectStr : String; AProvider: String):TFDConnection;
    private
      FConnection:TFDConnection;
      FTabellen: TStringList;
      FSynchronous:String;
      FLockingMode:String;

      function GetTabellen(): System.TArray<String>;
      function GetConnection(): TFDConnection;
    public
      ///<summary>True, wenn Verbindung hergestellt.</summary>
      verbunden: Boolean;
      ///<summary>Name der Datenbank (z Debuggen)</summary>
      Datenbank: String;   //nur Info
      ///<summary>Pfad zur Datenbank (bei SQLite-DB)</summary>
      Datenbankpfad: String; //nur Info
      ///<summary>Verbindung zur Datenbank</summary>
      property Connection: TFDConnection read GetConnection;
      ///<summary>Off->max performance</summary>
      property Synchronous: String write FSynchronous;
      ///<summary>Default=Exclusive->max. perform. Normal->multi-user</summary>
      property LockingMode: String write FLockingMode;
      ///<summary>Liste aller Tabellen der Datenbank</summary>
      property Tabellen: System.TArray<String> read GetTabellen;
   end;

implementation

constructor TWFDConnector.Create(AOwner: TComponent);
begin
  //Connection anlegen
  FConnection:=TFDConnection.Create(AOwner);
  //Ohne Login-Aufforderung (Kann vor Connect geändert werden)
  FConnection.LoginPrompt := False;
  FLockingMode:='Exclusive';
  FSynchronous:='Off';
end;

///<summary>Mit SQLite-Datenbank verbinden.</summary>
/// <remarks>
/// Die Verbindung erfolgt über die allgemeine Funktion ConnectToDB.
/// </remarks>
/// <param name="PathTODBFile">Pfad zur SQLite-Datenbank-Datei.</param>
/// <returns>Geöffnete TADOConnection </returns>
function TWFDConnector.ConnectToSQLite(PathTODBFile: String): TFDConnection;
var
  ConnString, Provider :String;
  begin
    with FConnection do begin
      Close;
      // create temporary connection definition
      with Params do begin
        Clear;
        Add('DriverID=SQLite');
        Add('Database=' + PathTODBFile);
        Add('LockingMode=' + FLockingMode);
        Add('Synchronous=' + FSynchronous);
      end;
      Open;
    end;
//  FConnection.DriverName:='SQLite';
//  FConnection.Params .Database:=PathTODBFile;
    //verbinden
//  try
//    ConnectToDB(ConnString, Provider);
//  except
//    raise EDBConnecErr.Create(
//      'Konnte Datenbank >>' + PathTODBFile + '<< nicht öffnen.' );
//  end;

  Datenbank:='SQLite per FDac';   //nur Info
  Datenbankpfad:=PathTODBFile; //nur Info

  Result:=FConnection;
end;

///<summary>Mit MS-Access-Datenbank verbinden.</summary>
/// <remarks>
/// Die Verbindung erfolgt über die allgemeine Funktion ConnectToDB.
/// </remarks>
/// <param name="PathTODBFile">Pfad zur Access-Datenbank-Datei.</param>
/// <returns>Geöffnete TADOConnection </returns>
function TWFDConnector.ConnectToAccess(PathTODBFile: String): TFDConnection;
var
  ConnString, Provider :String;

  begin

  //Variante mit Datei-DSN C:\Users\Etscheidt\Documents\access.dsn
  //access.dsn müsste in Programmverzeichnis
//  ConnString :=
//    'DBQ=' + PathTODBFile + ';' +
//    'Driver={Microsoft Access Driver (*.mdb, *.accdb)};'+
//    'FILEDSN=C:\Users\Etscheidt\Documents\access.dsn;' ;

  //Variante mit 'Microsoft.ACE.OLEDB.16.0'
  //dieser Name wird nur in der Delphi-Entwicklungsumgebung beim AUfbau eines
  // Connection string angezeigt
  //Wie kann man prüfen ob der Treiber auf dem lokalen Rechner vorliegt ?
  Provider := 'Microsoft.ACE.OLEDB.16.0';
  Provider := 'Microsoft.ACE.OLEDB.12.0';
  ConnString :=
        'Provider=' + Provider + ';Persist Security Info=False;' +
        'Data Source=' + PathTODBFile + ';';

    //verbinden
//  try
//    ConnectToDB(ConnString, Provider);
//  except
//    raise EDBConnecErr.Create(
//      'Konnte Datenbank >>' + PathTODBFile + '<< nicht öffnen.' );
//  end;

  Datenbank:='Access per FDac';   //nur Info
  Datenbankpfad:=PathTODBFile; //nur Info

  Result:=FConnection;
end;



///<summary>Mit beliebiger Datenbank verbinden.</summary>
/// <remarks>
/// Per Connection-String und Provider wird eine Verbindung (TADOConnection)
/// zu einer beliebigen Datenbank hergestellt.
/// |
/// Die Werte für Connection-String und Provider müssen an die spezielle
/// Datenbank angepasst werden und müssen in deren Doku recherchiert werden.
/// |
/// Es wird ein Fehler erzeugt, wenn der Connection.State ungleich stOpen
/// oder wenn die verbundene DB keine Tabellen enthält.
/// |
/// Im Erfolgsfall enthält die Eigenschaft Tabellen, die in der DB gefundenen
/// Tabellen, die Eigenschaft Connection die geöffnete TADOConnection
/// und die Eigenschaft verbunden, wird auf True gesetzt.
/// </remarks>
/// <param name="AConnectStr">Zum Öffnen der DB geeigneter Connection-String. </param>
/// <param name="AProvider">Zum Öffnen der DB geeigneter Provider.</param>
/// <returns>Geöffnete TADOConnection </returns>
//function TWFDConnector.ConnectToDB(AConnectStr: String; AProvider: String): TADOConnection;
//var
//  Tabellen: TStringList ;
//  ErrMsg:String;
//begin
//
//  verbunden:=False;
//
//  FConnection.ConnectionString := AConnectStr;
//  FConnection.Provider := AProvider;
//
//  FConnection.Open;
//
//  ErrMsg:='Konnte Datenbank nicht öffen.';
//  if not (FConnection.State=[stOpen]) then
//       raise EADOConnector.Create(ErrMsg);
//
//  Tabellen:= TStringList.Create();
//  FConnection.GetTableNames(Tabellen,False);
//
//  if (Tabellen.Count=0) then
//     raise EADOConnector.Create(ErrMsg)
//  else
//    FTabellen:=Tabellen;
//
//  verbunden:=True;
//
//  Result:=FConnection;
//
//end;

function TWFDConnector.GetConnection(): TFDConnection;
begin
  Result:=FConnection
end;

function TWFDConnector.GetTabellen(): System.TArray<String>;
begin
  Result:=FTabellen.ToStringArray;
end;

end.
