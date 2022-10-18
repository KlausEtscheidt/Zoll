/// <summary>SQLite-Datenbank-Abfragen für das Programm PräFix</summary>
/// <remarks>
/// Die Unit ist identisch zu BaumQryUNIPPS arbeitet jedoch mit einer
/// SQLite-Datenbank in der geeignete Daten hinterlegt sein müssen.
///| Die Unit ermöglicht eine Entwicklung ohne UNIPPS-Zugang.
/// Sie wird durch Compiler-Flags anstatt BaumQryUNIPPS verwendet (s. Unit Tools)
/// und ist für den Produktivbetrieb überflüssig.
///| Die Daten werden im UNIPPS-Modus durch Kopieren gewonnen.
///| Die SQL-Strings sind nicht identisch zu BaumQryUNIPPS, da SQLite teilweise
/// eine andere Syntax hat, da die Daten aber auch in anderen Tabellen liegen.
/// </remarks>
unit QryAccess;

interface

  uses System.SysUtils, System.Classes, ADOQuery;

  type
    TWQryAccess = class(TWADOQuery)
      function SucheFAzuKAPos(KaId:String; id_pos:Integer): Boolean;
    end;

implementation

// Fertigungs-Aufrag (FA) zu Kunden-Auftrags-Positionen (Kommissions-FA)
//---------------------------------------------------------------------------
function TWQryAccess.SucheFAzuKAPos(KaId:String; id_pos:Integer): Boolean;
begin
  var sql: String;
  sql:= 'SELECT id_stu, pos_nr, auftragsart, verurs_art, '
      + 'stu_t_tg_nr, stu_oa, stu_unipps_typ, FA_Nr '
      + 'FROM f_auftragkopf where id_stu = ? and pos_nr= ? '
      + 'and stu_oa<9 ORDER BY FA_Nr';
  Result:= RunSelectQueryWithParam(sql,[KaId,IntToStr(id_pos)]);

end;


end.
