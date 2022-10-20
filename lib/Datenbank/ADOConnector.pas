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
unit ADOConnector;

interface

uses  System.SysUtils,  System.Classes, Data.Win.ADODB  ;

type
    ///<summary>Wenn die Verbindung zur Datenbank fehlschlägt,
    ///wird der Fehler: &quot;Konnte Datenbank nicht öffen.&quot; erzeugt.</summary>
    EADOConnector = class(Exception);

    ///<summary>Klasse zur einfachen Verbindung mit UNIPPS oder SQLite</summary>
    TWADOConnector = class(TComponent)
      constructor Create(AOwner: TComponent);
      function ConnectToUNIPPS(): TADOConnection;
      function ConnectToSQLite(PathTODBFile: String): TADOConnection;
      function ConnectToDB(AConnectStr : String; AProvider: String):TADOConnection;
    private
      FConnection:TADOConnection;
      FTabellen: TStringList;
      function GetTabellen(): System.TArray<String>;
      function GetConnection(): TADOConnection;
    public
      ///<summary>True, wenn Verbindung hergestellt.</summary>
      verbunden: Boolean;
      ///<summary>Name der Datenbank (z Debuggen)</summary>
      Datenbank: String;   //nur Info
      ///<summary>Pfad zur Datenbank (bei SQLite-DB)</summary>
      Datenbankpfad: String; //nur Info
      ///<summary>Verbindung zur Datenbank</summary>
      property Connection: TADOConnection read GetConnection;
      ///<summary>Liste aller Tabellen der Datenbank</summary>
      property Tabellen: System.TArray<String> read GetTabellen;
    end;

implementation

constructor TWADOConnector.Create(AOwner: TComponent);
begin
  //Connection anlegen
  FConnection:=TADOConnection.Create(AOwner);
  //Ohne Login-Aufforderung (Kann vor Connect geändert werden)
  FConnection.LoginPrompt := False;

end;

///<summary>Mit SQLite-Datenbank verbinden.</summary>
/// <remarks>
/// Die Verbindung erfolgt über die allgemeine Funktion ConnectToDB.
/// </remarks>
/// <param name="PathTODBFile">Pfad zur SQLite-Datenbank-Datei.</param>
/// <returns>Geöffnete TADOConnection </returns>
function TWADOConnector.ConnectToSQLite(PathTODBFile: String): TADOConnection;
var
  ConnString, Provider :String;

  begin
  ConnString :=
        'Provider=MSDASQL.1;Persist Security Info=False;' +
//        'Data Source=SQLite UTF-8 Datasource;' +
//        'Data Source=SQLite3 Datasource;' +
        'Data Source=LEKL;' +
        'Database=' + PathTODBFile + ';';
  Provider := 'MSDASQL.1';

    //verbinden
  try
    ConnectToDB(ConnString, Provider);
  except
    raise EADOConnector.Create(
      'Konnte Datenbank >>' + PathTODBFile + '<< nicht öffnen.' );
  end;

  Datenbank:='SQLite';   //nur Info
  Datenbankpfad:=PathTODBFile; //nur Info

  Result:=FConnection;
end;

///<summary>Mit UNIPPS-Datenbank verbinden.</summary>
/// <remarks>
/// Die Verbindung erfolgt über die allgemeine Funktion ConnectToDB.
/// </remarks>
/// <returns>Geöffnete TADOConnection </returns>
function TWADOConnector.ConnectToUNIPPS(): TADOConnection;
var
  ConnString, Provider :String;

  begin
  ConnString :=
        'Provider=MSDASQL.1;Persist Security Info=False;' +
        'Data Source=unipps;';
  Provider := 'MSDASQL.1';

  //verbinden
  try
    ConnectToDB(ConnString, Provider);
  except
    raise Exception.Create('Konnte UNIPPS nicht �ffen.' );
  end;

  Datenbank:='UNIPPS';   //nur Info
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
function TWADOConnector.ConnectToDB(AConnectStr: String; AProvider: String): TADOConnection;
var
  Tabellen: TStringList ;
  ErrMsg:String;
begin

  verbunden:=False;

  FConnection.ConnectionString := AConnectStr;
  FConnection.Provider := AProvider;

  FConnection.Open;

  ErrMsg:='Konnte Datenbank nicht öffen.';
  if not (FConnection.State=[stOpen]) then
       raise EADOConnector.Create(ErrMsg);

  Tabellen:= TStringList.Create();
  FConnection.GetTableNames(Tabellen,False);

  if (Tabellen.Count=0) then
     raise EADOConnector.Create(ErrMsg)
  else
    FTabellen:=Tabellen;

  verbunden:=True;

  Result:=FConnection;

end;

function TWADOConnector.GetConnection(): TADOConnection;
begin
  Result:=FConnection
end;

function TWADOConnector.GetTabellen(): System.TArray<String>;
begin
  Result:=FTabellen.ToStringArray;
end;

end.
