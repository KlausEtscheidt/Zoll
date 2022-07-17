unit DBQryInterface;

interface

  uses System.SysUtils, System.Classes, Data.Win.ADODB;

  type
    IDBQry = class(TComponent)
      constructor Create();
      procedure OpenConnector();
      function SucheKundenRabatt(ka_id:string):Boolean;
      function SucheKundenAuftragspositionen(ka_id:string):Boolean;
      function SucheDatenzumTeil(t_tg_nr:string):Boolean;
      function SucheLetzte3Bestellungen(t_tg_nr:string): Boolean;
      function SucheFAzuKAPos(id_stu:String; id_pos:String): Boolean;
      function SucheFAzuTeil(t_tg_nr:String): Boolean;
      function SucheBenennungZuTeil(t_tg_nr:String): Boolean;
      function SucheStuelizuTeil(t_tg_nr:String): Boolean;
      function SuchePosZuFA(FA_Nr:String): Boolean;
      function RunQuery(sql:string):Boolean;
      property DBConn:TADOConnection read GetDBConn write SetDBConn;
      property RecCount: Integer read GetRecCount;
      property DbFilePath: String read GetDbFilePath write SetDbFilePath;
    end;


//implementation

end.
