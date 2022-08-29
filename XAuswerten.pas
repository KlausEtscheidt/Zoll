///<summary>Komplettanalyse eines Kundenauftrages mit Berechnung der Präferenzberechtigung.</summary>
///<remarks>
///Die Unit enthält die übergeordneten Funktionen zur Analyse eines
/// Kundenauftrages inkl. der Ermittlung der Präferenzberechtigung.
/// Hierzu dient die Prozedur Auswerten.KaAuswerten .
///</remarks>
unit Auswerten ;

interface

uses  System.SysUtils, System.Dateutils, Vcl.Controls, Vcl.Dialogs, Windows,
      classes, Tools, Settings,
      Kundenauftrag,KundenauftragsPos, ADOQuery , ADOConnector,
      BaumQrySQLite, BaumQryUNIPPS, DatenModul, Preiseingabe;

type
/// <summary> Ausnahmen während der Ausführung des Threads</summary>
    EAuswerten = class(Exception);

type
/// <summary>Ausführung der UNIPPS-Analyse im thread</summary>
    TWPraeFixThread=class(TThread)
          ///<summary>Speichert Meldungen zu Fehlern, die während der Thread-Ausführung entstehen.</summary>
          ErrMsg:String;
          ///<summary>True, wenn Thread-Ausführung fehlerfrei.</summary>
          Success:Boolean;
          procedure Execute; override;
    end;

end.
