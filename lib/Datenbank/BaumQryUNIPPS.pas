//Abfragen fuer UNIPPS Datenbank über TADOQuery

{Anwendungsbeispiel:
  Abfrage zum Lesen des Kundenauftrags und seiner Positionen
  KAQry := DBConn.getQuery;
  gefunden := KAQry.SucheKundenAuftragspositionen(ka_id);

  mit DBConn.getQuery wird die Abfrage,
  d.h. eine Instanz dieser Klasse TWQryUNIPPS erzeugt.
  TWQryUNIPPS.SucheKundenAuftragspositionen füllt sie
  mit einem geeigneten SQL und führt sie aus.

}
unit BaumQryUNIPPS;

interface
  //ADOConnector nur fuer UNIPPS nach SQLite über SQLiteConnector
  uses System.SysUtils,System.Classes,ADOConnector, ADOQuery;

  type
    TWBaumQryUNIPPS = class(TWADOQuery)
      function SucheKundenRabatt(kunden_id:string):Boolean;
      function SucheKundenAuftragspositionen(ka_id:string):Boolean;
      function SucheDatenzumTeil(t_tg_nr:string):Boolean;
      function SucheLetzte3Bestellungen(t_tg_nr:string): Boolean;
      function SucheFAzuKAPos(KaId:String; id_pos:Integer): Boolean;
      function SucheFAzuTeil(t_tg_nr:String): Boolean;
      function SucheBenennungZuTeil(t_tg_nr:String): Boolean;
      function SucheStuelizuTeil(t_tg_nr:String): Boolean;
      function SuchePosZuFA(FA_Nr:String): Boolean;
      //NUr zum Testen
      procedure UNI2SQLite(tablename: String);
    private
      class var ExportQry: TWADOQuery;
    public
      class var Export2SQLite:Boolean;
      class var SQLiteConnector:TWADOConnector;

    end;


implementation

function TWBaumQryUNIPPS.SucheKundenAuftragspositionen(ka_id:string):Boolean;
begin
  var sql: String;
  {siehe Access Abfrage "b_hole_KAPositionen"
   sql = "SELECT auftragpos.ident_nr1 as id_stu, auftragpos.ident_nr2 as id_pos, auftragkopf.kunde,
     auftragpos.besch_art, auftragkopf.klassifiz, auftragpos.pos as pos_nr, " _
    & "auftragpos.t_tg_nr, auftragpos.oa, auftragpos.typ, auftragpos.menge, auftragpos.preis " _
    & "FROM auftragkopf INNER JOIN auftragpos ON auftragkopf.ident_nr = auftragpos.ident_nr1 " _
    & "WHERE auftragpos.ident_nr1 = """ & ka_id & """ "
  }
  sql := 'select auftragpos.ident_nr1 as id_stu, auftragpos.ident_nr2 as id_pos, '
      +  ' auftragkopf.kunde, auftragpos.besch_art, '
      +  ' auftragkopf.klassifiz, auftragpos.pos as pos_nr, auftragpos.t_tg_nr, '
      +  'auftragpos.oa, auftragpos.typ, auftragpos.menge, auftragpos.preis '
      +  'from auftragkopf INNER JOIN auftragpos ON auftragkopf.ident_nr = auftragpos.ident_nr1 '
      +  'where auftragpos.ident_nr1 = "' + ka_id + '" order by id_pos;';
  Result:= RunSelectQuery(sql);
  UNI2SQLite('auftragkopf');

end;

function TWBaumQryUNIPPS.SucheKundenRabatt(kunden_id:string):Boolean;
begin
  var sql: String;
  {siehe Access Abfrage "b_hole_Rabatt_zum_Kunden"
    sql = "SELECT ident_nr1 as kunden_id, zu_ab_proz, datum_von, datum_bis " _
        & "FROM kunde_zuab " _
        & "WHERE ident_nr1 = """ & kunden_id & """ AND datum_von<=" & heute_datum_str _
                 & " AND datum_bis>" & heute_datum_str & " ; "
  }
  sql := 'select ident_nr1 as kunden_id, zu_ab_proz, datum_von, datum_bis '
       + 'from kunde_zuab where ident_nr1 = "' + kunden_id + '";';
  Result:= RunSelectQuery(sql);
  UNI2SQLite('kunde_zuab');

end;


function TWBaumQryUNIPPS.SucheDatenzumTeil(t_tg_nr:string):Boolean;
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
  sql:= 'SELECT teil_uw.t_tg_nr, teil_uw.oa, teil_uw.v_besch_art besch_art, '
      + 'teil.typ as unipps_typ, '
//      + 'teil.urspr_land, teil.ausl_u_land, '
      + 'teil.praeferenzkennung, teil.sme, teil.faktlme_sme, teil.lme '
      + 'FROM teil INNER JOIN teil_uw ON teil.ident_nr = teil_uw.t_tg_nr AND teil.art = teil_uw.oa '
      + 'where teil_uw.t_tg_nr = "' + t_tg_nr + '" and teil_uw.oa<9 and teil_uw.uw=1;';
  Result:= RunSelectQuery(sql);
  UNI2SQLite('teil');

end;

function TWBaumQryUNIPPS.SucheLetzte3Bestellungen(t_tg_nr:string): Boolean;
{siehe Access Abfrage "b_Bestelldaten"
    'Suche �ber unipps_bestellpos.t_tg_nr=t_tg_nr; bestellkopf.datum muss aus der Unterabfrage hervorgehen (neuestes Datum)
    sql = "SELECT first 3 bestellkopf.ident_nr as bestell_id, bestellkopf.datum as bestell_datum,
           bestellpos.preis, bestellpos.basis, bestellpos.pme, bestellpos.bme, _
           bestellpos.faktlme_bme, bestellpos.faktbme_pme, bestellpos.netto_poswert, bestellpos.menge,
           bestellpos.we_menge, bestellkopf.lieferant, adresse.kurzname, bestellpos.t_tg_nr " _
        & "FROM bestellpos INNER JOIN bestellkopf ON bestellpos.ident_nr1 = bestellkopf.ident_nr " _
        & "JOIN adresse ON bestellkopf.lieferant = adresse.ident_nr " _
        & "WHERE bestellpos.t_tg_nr=""" & t_tg_nr$ & """ order by bestellkopf.datum desc ;"

          bestell_id, bestell_datum, preis, basis, pme, bme,
          faktlme_bme, faktbme_pme, netto_poswert, menge,
          we_menge, lieferant, kurzname, t_tg_nr

}

begin
  var sql: String;
  sql:= 'SELECT first 3 bestellkopf.ident_nr as bestell_id, bestellkopf.datum as bestell_datum, '
      + 'bestellpos.preis, bestellpos.basis, bestellpos.pme, bestellpos.bme, '
      + 'bestellpos.faktlme_bme, bestellpos.faktbme_pme, bestellpos.netto_poswert, bestellpos.menge,  '
      + 'bestellpos.we_menge,bestellkopf.lieferant, adresse.kurzname, bestellpos.t_tg_nr '
      + 'FROM bestellpos INNER JOIN bestellkopf ON bestellpos.ident_nr1 = bestellkopf.ident_nr '
      + 'JOIN adresse ON bestellkopf.lieferant = adresse.ident_nr '
      + 'WHERE bestellpos.t_tg_nr="' + t_tg_nr + '" order by bestellkopf.datum desc ;';
  Result:= RunSelectQuery(sql);

  UNI2SQLite('bestellungen');

end;

function TWBaumQryUNIPPS.SucheBenennungZuTeil(t_tg_nr:String): Boolean;
{siehe Access Abfrage "b_hole_Teile_Bezeichnung"
    sql = "SELECT teil_bez.ident_nr1 AS teil_bez_id, teil_bez.Text AS Bezeichnung
     FROM teil_bez
     WHERE ident_nr1=""" & t_tg_nr$ & """ and teil_bez.sprache=""D""
     AND teil_bez.art=1 ;"
}

begin
  var sql: String;
  sql:= 'SELECT teil_bez.ident_nr1 AS teil_bez_id, teil_bez.Text AS Bezeichnung '
      + 'FROM teil_bez where ident_nr1="' + t_tg_nr
      + '" and teil_bez.sprache="D" AND teil_bez.art=1 ;' ;
  Result:= RunSelectQuery(sql);
  UNI2SQLite('teil_bez');
end;


function TWBaumQryUNIPPS.SucheStuelizuTeil(t_tg_nr:String): Boolean;
{siehe Access Abfrage "b_suche_Stueli_zu_Teil"
  Suche über teil_stuelipos.ident_nr1=t_tg_nr
  Es werden die Daten aus teil_stuelipos gelesen
  Es existieren z.T. unterschiedlich Stücklisten wegen mehrerer Arbeitspläne (Ausweichmaschine mit anderen Rohteilen)
  Es wird daher zu TEIL_APLNKOPF gejoined und dort teil_aplnkopf.art=1 gefordert (Standardarbeitsplan)
}
{
    sql = "SELECT teil_stuelipos.ident_nr1 As id_stu, teil_stuelipos.pos_nr,
           teil_stuelipos.t_tg_nr, teil_stuelipos.oa, teil_stuelipos.menge
           FROM teil_aplnkopf INNER JOIN teil_stuelipos ON teil_aplnkopf.ident_nr1 = teil_stuelipos.ident_nr1
          AND teil_aplnkopf.ident_nr2 = teil_stuelipos.ident_nr2 AND teil_aplnkopf.ident_nr3 = teil_stuelipos.ident_nr3
          WHERE teil_stuelipos.ident_nr1=""" & t_tg_nr & """ And teil_aplnkopf.art=""1""
          ORDER BY teil_stuelipos.pos_nr ;
       }

begin
  var sql: String;
  sql:= 'SELECT teil_stuelipos.ident_nr1 As id_stu, teil_stuelipos.pos_nr, '
      + 'teil_stuelipos.t_tg_nr, teil_stuelipos.oa, teil_stuelipos.typ, teil_stuelipos.menge '
      + 'FROM teil_aplnkopf INNER JOIN teil_stuelipos ON teil_aplnkopf.ident_nr1 = teil_stuelipos.ident_nr1 '
      + 'AND teil_aplnkopf.ident_nr2 = teil_stuelipos.ident_nr2 AND teil_aplnkopf.ident_nr3 = teil_stuelipos.ident_nr3 '
      + 'Where teil_stuelipos.ident_nr1="' + t_tg_nr + '" And teil_aplnkopf.art="1"'
      + 'ORDER BY teil_stuelipos.pos_nr ;';
  Result:= RunSelectQuery(sql);

  UNI2SQLite('teil_stuelipos');

end;


function TWBaumQryUNIPPS.SucheFAzuKAPos(KaId:String; id_pos:Integer): Boolean;
{siehe Access Abfrage "a_FA_Kopf_zu_KAPos_mit_Teileinfo"

 UNIPPS-Mapping für Kundenauftragspositionen (Tabelle auftragpos)
 KaId (Id des Kundenauftrages) ist in auftragpos.ident_nr1 as id_stu
 id_pos aus auftragpos.ident_nr2 as id_pos

 Suche in Fertigunsauftraegen (Tabelle f_auftragkopf)
 über f_auftragkopf.auftr_nr=KaId und f_auftragkopf.auftr_pos=id_pos
}
begin
  var sql: String;
  sql:= 'SELECT f_auftragkopf.auftr_nr as id_stu, f_auftragkopf.auftr_pos as pos_nr, f_auftragkopf.auftragsart, '
      + 'f_auftragkopf.verurs_art, f_auftragkopf.t_tg_nr, f_auftragkopf.oa, f_auftragkopf.typ, '
      + 'f_auftragkopf.ident_nr as FA_Nr '
      + 'FROM f_auftragkopf '
      + 'Where f_auftragkopf.auftr_nr="' + KaId + '" and f_auftragkopf.auftr_pos="' + IntToStr(id_pos)
      + '" and f_auftragkopf.oa<9 ORDER BY FA_Nr';
  Result:= RunSelectQuery(sql);

  UNI2SQLite('f_auftragkopf');

end;

function TWBaumQryUNIPPS.SucheFAzuTeil(t_tg_nr:String): Boolean;
{siehe Access Abfrage "b_suche_FA_zu_Teil"
 Suche über f_auftragkopf.t_tg_nr}
begin
  var sql: String;
  { TODO 1 : nur freigegebene nehmen }
  sql:= 'SELECT first 1 f_auftragkopf.auftr_nr as id_stu, '
      + 'f_auftragkopf.auftr_pos as pos_nr, f_auftragkopf.auftragsart, f_auftragkopf.verurs_art, '
      + 'f_auftragkopf.t_tg_nr, f_auftragkopf.oa, f_auftragkopf.typ, '
      + 'f_auftragkopf.ident_nr as FA_Nr '
      + 'FROM f_auftragkopf '
      + 'Where f_auftragkopf.t_tg_nr="' + t_tg_nr
      + '" and f_auftragkopf.oa<9 ORDER BY FA_Nr desc';
  Result:= RunSelectQuery(sql);

  UNI2SQLite('f_auftragkopf');

end;


//Suche alle Positionen zu einem FA (ASTUELIPOS)
function TWBaumQryUNIPPS.SuchePosZuFA(FA_Nr:String): Boolean;
//siehe Access Abfrage "b_hole_Pos_zu_FA"
begin
  var sql: String;
  sql:= 'SELECT astuelipos.ident_nr1 AS id_stu, astuelipos.ident_nr2 as id_pos, '
      + 'astuelipos.ueb_s_nr, astuelipos.ds, astuelipos.set_block, '
      + 'astuelipos.pos_nr, astuelipos.t_tg_nr, astuelipos.oa, '
      + 'astuelipos.typ, astuelipos.menge '
      + 'FROM astuelipos where astuelipos.ident_nr1 = "' + FA_Nr
      + '" and astuelipos.oa<9 ORDER BY astuelipos.pos_nr';
  Result:= RunSelectQuery(sql);

  UNI2SQLite('astuelipos');

end;


/////////////nicht fuer produktiv-version
procedure TWBaumQryUNIPPS.UNI2SQLite(tablename: String);
begin
  if not Export2SQLite then
    exit;
  //Qry anlegen und mit Connector versorgen
  ExportQry:= TWADOQuery.Create(nil);
  ExportQry.Connector:=SQLiteConnector;
  while not self.Eof do
  begin
      ExportQry.InsertFields(tablename, Fields);
      Self.next;
  end;
  //WICHTIGGGGGGGGG
  self.First;

end;

end.
