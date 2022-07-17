//Abfragen fuer SQLite Datenbank über TFDQuery
{Anwendungsbeispiel:
  Abfrage zum Lesen des Kundenauftrags und seiner Positionen
  KAQry := DBConn.getQuery;
  gefunden := KAQry.SucheKundenAuftragspositionen(ka_id);

  mit DBConn.getQuery wird die Abfrage,
  d.h. eine Instanz dieser Klasse TZQryUNIPPS erzeugt.
  TZQrySQLite.SucheKundenAuftragspositionen füllt sie
  mit einem geeigneten SQL und führt sie aus.

}

unit DBQrySQLite;

interface

  uses System.SysUtils, System.Classes, Data.Win.ADODB;

  type
    TZQrySQLite = class(TADOQuery)
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
      function query(sql:string):Boolean;
    private
      dbconn:TADOConnection;
    public
      { Public-Deklarationen }
      class var DbFilePath: String;
      n_records: Integer;
      gefunden: Boolean;
    end;


implementation


constructor TZQrySQLite.Create();
begin
  if dbconn=nil then
    OpenConnector();

  inherited Create(nil);
  Connection:=dbconn;
  n_records:=0;
  gefunden:=False;
end;

procedure TZQrySQLite.OpenConnector();

begin

  if (length(DbFilePath)=0) then
       raise Exception.Create('Vor Erstbenutzung Pfad zur Datenbank' +
                                  ' (DbFilePath) setzen.');
  dbconn:=TADOConnection.Create(nil);

//  dbconn.Close;
  dbconn.LoginPrompt := False;

  dbconn.ConnectionString :=
      'Provider=MSDASQL.1;Persist Security Info=False;' +
      'Extended Properties="DSN=zoll32;' +
      'Database=' + DbFilePath + ';'+
      'StepAPI=0;SyncPragma=NORMAL;NoTXN=0;Timeout=1000;ShortNames=0;' +
      'LongNames=0;NoCreat=0;NoWCHAR=0;FKSupport=0;' +
      'JournalMode=;OEMCP=0;LoadExt=;BigInt=0;JDConv=0;"';
  dbconn.ConnectOptions := coAsyncConnect;
  dbconn.Provider := 'MSDASQL.1';
  dbconn.Open;
end;


function TZQrySQLite.SucheKundenAuftragspositionen(ka_id:string):Boolean;
begin
  var sql: String;
  {siehe Access Abfrage "b_hole_KAPositionen"
   sql = "SELECT auftragpos.ident_nr1 as id_stu, auftragpos.ident_nr2 as id_pos, auftragkopf.kunde, auftragpos.besch_art, auftragkopf.klassifiz, auftragpos.pos as pos_nr, " _
    & "auftragpos.t_tg_nr, auftragpos.oa, auftragpos.typ, auftragpos.menge, auftragpos.preis " _
    & "FROM auftragkopf INNER JOIN auftragpos ON auftragkopf.ident_nr = auftragpos.ident_nr1 " _
    & "WHERE auftragpos.ident_nr1 = """ & ka_id & """ "
  }
  sql := 'select id_stu, id_pos, kunde, besch_art, klassifiz, pos_nr, t_tg_nr, '
      +  'oa, typ, menge, preis '
      +  'from auftragkopf where id_stu = "' + ka_id + '"order by id_pos;';
  Result:= query(sql);

end;

function TZQrySQLite.SucheKundenRabatt(ka_id:string):Boolean;
begin
  var sql: String;
  {siehe Access Abfrage "b_hole_Rabatt_zum_Kunden"
    sql = "SELECT ident_nr1 as kunden_id, zu_ab_proz, datum_von, datum_bis " _
        & "FROM kunde_zuab " _
        & "WHERE ident_nr1 = """ & kunden_id & """ AND datum_von<=" & heute_datum_str _
                 & " AND datum_bis>" & heute_datum_str & " ; "

  }
  sql := 'select kunden_id, zu_ab_proz, datum_von, datum_bis '
       + 'from kunde_zuab where kunden_id = "' + ka_id + '";';
  Result:= query(sql);

end;

function TZQrySQLite.SucheDatenzumTeil(t_tg_nr:string):Boolean;
{siehe Access Abfrage "b_hole_Daten_zu Teil"
sql = "SELECT teil_uw.t_tg_nr, teil_uw.oa, " _
    & "teil_uw.v_besch_art as besch_art, teil.typ, teil.urspr_land,
       teil.ausl_u_land,
       teil.praeferenzkennung, " _
    & "teil.sme, teil.faktlme_sme, teil.lme " _
    & "FROM teil INNER JOIN teil_uw ON teil.ident_nr = teil_uw.t_tg_nr AND teil.art = teil_uw.oa " _
    & "Where teil_uw.t_tg_nr=""" & t_tg_nr _
    & """ and teil_uw.oa<9 AND teil_uw.uw=1; "

}

begin
  var sql: String;
  sql:= 'SELECT t_tg_nr, oa, besch_art, typ, praeferenzkennung, '
      + 'sme, faktlme_sme, lme '
      + 'FROM teil where t_tg_nr = "' + t_tg_nr + '" and oa<9;';
  Result:= query(sql);
end;

function TZQrySQLite.SucheLetzte3Bestellungen(t_tg_nr:string): Boolean;
{siehe Access Abfrage "b_Bestelldaten"
    'Suche �ber unipps_bestellpos.t_tg_nr=t_tg_nr; bestellkopf.datum muss aus der Unterabfrage hervorgehen (neuestes Datum)
    sql = "SELECT first 3 bestellkopf.ident_nr as bestell_id, bestellkopf.datum as bestell_datum, bestellpos.preis, bestellpos.basis, bestellpos.pme, bestellpos.bme, " _
        & "bestellpos.faktlme_bme, bestellpos.faktbme_pme, bestellpos.netto_poswert, bestellpos.menge, bestellpos.we_menge, " _
        & "bestellkopf.lieferant, adresse.kurzname, bestellpos.t_tg_nr " _
        & "FROM bestellpos INNER JOIN bestellkopf ON bestellpos.ident_nr1 = bestellkopf.ident_nr " _
        & "JOIN adresse ON bestellkopf.lieferant = adresse.ident_nr " _
        & "WHERE bestellpos.t_tg_nr=""" & t_tg_nr$ & """ order by bestellkopf.datum desc ;"

          bestell_id, bestell_datum, preis, basis, pme, bme,
          faktlme_bme, faktbme_pme, netto_poswert, menge,
          we_menge, lieferant, kurzname, t_tg_nr

}

begin
  var sql: String;
  sql:= 'SELECT bestell_id, bestell_datum, preis, basis, pme, bme, '
      + 'faktlme_bme, faktbme_pme, netto_poswert, menge, '
      + 'we_menge, lieferant, kurzname, t_tg_nr '
      + 'FROM bestellungen where t_tg_nr = "' + t_tg_nr
      + '" order by bestell_datum desc limit 3;';
  Result:= query(sql);

end;

function TZQrySQLite.SucheBenennungZuTeil(t_tg_nr:String): Boolean;
{siehe Access Abfrage "b_hole_Teile_Bezeichnung"
    sql = "SELECT teil_bez.ident_nr1 AS teil_bez_id, teil_bez.Text AS Bezeichnung FROM teil_bez " _
         & "WHERE ident_nr1=""" & t_tg_nr$ & """ and teil_bez.sprache=""D"" AND teil_bez.art=1 ;"
create table teil_bez( teil_bez_id text, Bezeichnung text)
}

begin
  var sql: String;
  sql:= 'SELECT teil_bez_id, Bezeichnung '
      + 'FROM teil_bez where teil_bez_id="' + t_tg_nr + '" ;' ;
  Result:= query(sql);
end;


function TZQrySQLite.SucheStuelizuTeil(t_tg_nr:String): Boolean;
{siehe Access Abfrage "b_suche_Stueli_zu_Teil"
  Suche über teil_stuelipos.ident_nr1=t_tg_nr
  Es werden die Daten aus teil_stuelipos gelesen
  Es existieren z.T. unterschiedlich Stücklisten wegen mehrerer Arbeitspläne (Ausweichmaschine mit anderen Rohteilen)
  Es wird daher zu TEIL_APLNKOPF gejoined und dort teil_aplnkopf.art=1 gefordert (Standardarbeitsplan)
}

begin
  var sql: String;
  sql:= 'SELECT id_stu, pos_nr, t_tg_nr, oa, typ, menge '
      + 'FROM teil_stuelipos where id_stu="' + t_tg_nr
      + '" ORDER BY pos_nr ;';
  Result:= query(sql);
end;


function TZQrySQLite.SucheFAzuKAPos(id_stu:String; id_pos:String): Boolean;
{siehe Access Abfrage "a_FA_Kopf_zu_KAPos_mit_Teileinfo"
 Suche ueber f_auftragkopf.auftr_nr=KA_id (Id des Kundenauftrages) und f_auftragkopf.auftr_pos=pos_id
    sql = "SELECT f_auftragkopf.auftr_nr as id_stu, " _
        & "f_auftragkopf.auftr_pos as pos_nr, f_auftragkopf.auftragsart,
           f_auftragkopf.verurs_art, f_auftragkopf.t_tg_nr, f_auftragkopf.oa, " _
        & "f_auftragkopf.typ,  " _
        & "f_auftragkopf.ident_nr as id_FA " _
        & "FROM f_auftragkopf " _
        & "Where f_auftragkopf.auftr_nr=" & id_stu & " and f_auftragkopf.auftr_pos=" & id_pos _
        & " and f_auftragkopf.oa<9 " _
        & " ORDER BY id_FA;"
}
begin
  var sql: String;
  sql:= 'SELECT id_stu, pos_nr, auftragsart, verurs_art, '
      + 't_tg_nr, oa, typ, FA_Nr '
      + 'FROM f_auftragkopf where id_stu = "' + id_stu
      + '" and pos_nr="' + id_pos
      + '" and oa<9 ORDER BY FA_Nr';
  Result:= query(sql);

end;


function TZQrySQLite.SucheFAzuTeil(t_tg_nr:String): Boolean;
{siehe Access Abfrage "b_suche_FA_zu_Teil"
    sql = "SELECT first 1 f_auftragkopf.auftr_nr as id_stu,
          f_auftragkopf.auftr_pos as pos_nr, f_auftragkopf.auftragsart, f_auftragkopf.verurs_art,
          f_auftragkopf.t_tg_nr, f_auftragkopf.oa, f_auftragkopf.typ,
          f_auftragkopf.ident_nr as id_FA
          FROM f_auftragkopf " _
          Where f_auftragkopf.t_tg_nr=""" & t_tg_nr _
          """ and f_auftragkopf.oa<9 " _
           ORDER BY id_FA desc;"
        }
begin
  var sql: String;
  sql:= 'SELECT id_stu, pos_nr, auftragsart, verurs_art, '
      + 't_tg_nr, oa, typ, FA_Nr '
      + 'FROM f_auftragkopf '
      + 'Where t_tg_nr="' + t_tg_nr + '" and oa<9 ORDER BY FA_Nr desc limit 1';
  Result:= query(sql);

end;



//Suche alle Positionen zu einem FA (ASTUELIPOS)
function TZQrySQLite.SuchePosZuFA(FA_Nr:String): Boolean;
{siehe Access Abfrage "b_hole_Pos_zu_FA"
 Suche ueber astuelipos.ident_nr1=FA_Nr (Id des Fertigungsauftrages)
 sql = "SELECT astuelipos.ident_nr1 AS id_stu, astuelipos.ident_nr2 as id_pos, " _
          & "astuelipos.ueb_s_nr, astuelipos.ds, astuelipos.set_block, " _
          & "astuelipos.pos_nr, astuelipos.t_tg_nr, astuelipos.oa, " _
          & "astuelipos.typ, astuelipos.menge " _
          & "FROM astuelipos " _
          & "WHERE astuelipos.ident_nr1=" & FA_id _
          & " AND astuelipos.oa<9 " _
          & "ORDER BY astuelipos.pos_nr"
}
begin
  var sql: String;
  sql:= 'SELECT id_stu, id_pos, '
      + 'ueb_s_nr, ds, set_block, pos_nr, t_tg_nr, oa, typ, menge '
      + 'FROM astuelipos where id_stu = "' + FA_Nr
      + '" and oa<9 ORDER BY pos_nr';
  Result:= query(sql);
end;

function TZQrySQLite.query(sql:string):Boolean;
begin
  //sql ins Qry-Objekt
  self.SQL.Add(sql);
  //Qry ausführen
  self.Open;

//  SQL.Add(sqlqry);
  n_records:=self.GetRecordCount();
  gefunden:=n_records>0;
  Result:= gefunden;
end;


end.
