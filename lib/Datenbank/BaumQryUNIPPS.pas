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
    ///<summary>Abfragengenerator für alle nötigen UNIPPS-Abfragen.
    ///  s. auch <see cref='TWADOQuery'/>
    ///</summary>
    TWBaumQryUNIPPS = class(TWADOQuery)
      destructor Destroy; override;
      function SucheKundenAuftragspositionen(ka_id:string):Boolean;
      function SucheFAzuKAPos(KaId:String; id_pos:Integer): Boolean;
      function SucheFAzuTeil(t_tg_nr:String): Boolean;
      function SuchePosZuFA(FA_Nr:String): Boolean;
      function SucheStuelizuTeil(t_tg_nr:String): Boolean;

      function SucheDatenzumTeil(t_tg_nr:string):Boolean;
      function SucheBenennungZuTeil(t_tg_nr:String): Boolean;
      function SucheLetzte3Bestellungen(t_tg_nr:string): Boolean;
      function SucheKundenRabatt(kunden_id:string):Boolean;
      ///<summary>Kopiert Daten 1:1 nach SQLite</summary>
      procedure UNI2SQLite(tablename: String);
    private
      class var ExportQry: TWADOQuery;
    public
      class var Export2SQLite:Boolean;
      class var SQLiteConnector:TWADOConnector;

    end;


implementation

destructor TWBaumQryUNIPPS.Destroy;
begin
  inherited;
end;

//---------------------------------------------------------------------------
// Struktur-Aufbau: Suche Stueli-Positionen
//---------------------------------------------------------------------------

// Kunden-Auftrags-Positionen
//---------------------------------------------------------------------------
function TWBaumQryUNIPPS.SucheKundenAuftragspositionen(ka_id:string):Boolean;
var sql: String;
begin
  //siehe Access Abfrage "b_hole_KAPositionen"
  sql := 'select auftragpos.ident_nr1 as id_stu, auftragpos.ident_nr2 as id_pos, '
      +  ' auftragkopf.kunde, auftragpos.besch_art, '
      +  ' auftragkopf.klassifiz, auftragpos.pos as pos_nr, '
      +  ' trim(auftragpos.t_tg_nr) as stu_t_tg_nr, '
      +  'auftragpos.oa as stu_oa, trim(auftragpos.typ) as stu_unipps_typ, auftragpos.menge, auftragpos.preis '
      +  'from auftragkopf INNER JOIN auftragpos ON auftragkopf.ident_nr = auftragpos.ident_nr1 '
      +  'where auftragpos.ident_nr1 = ? order by id_pos;';
  Result:= RunSelectQueryWithParam(sql,[ka_id]);
  UNI2SQLite('auftragkopf');

end;

// Fertigungs-Aufrag (FA) zu Kunden-Auftrags-Positionen (Kommissions-FA)
//---------------------------------------------------------------------------
function TWBaumQryUNIPPS.SucheFAzuKAPos(KaId:String; id_pos:Integer): Boolean;
{siehe Access Abfrage "a_FA_Kopf_zu_KAPos_mit_Teileinfo"

 UNIPPS-Mapping für Kundenauftragspositionen (Tabelle auftragpos)
 KaId (Id des Kundenauftrages) ist in auftragpos.ident_nr1 as id_stu
 id_pos aus auftragpos.ident_nr2 as id_pos

 Suche in Fertigunsauftraegen (Tabelle f_auftragkopf)
 über f_auftragkopf.auftr_nr=KaId und f_auftragkopf.auftr_pos=id_pos
}
var sql: String;
begin
  sql:= 'SELECT f_auftragkopf.auftr_nr as id_stu, f_auftragkopf.auftr_pos as pos_nr, f_auftragkopf.auftragsart, '
      + 'f_auftragkopf.verurs_art, trim(f_auftragkopf.t_tg_nr) as stu_t_tg_nr, '
      + 'f_auftragkopf.oa as stu_oa, '
      + 'trim(f_auftragkopf.typ) as stu_unipps_typ, f_auftragkopf.ident_nr as FA_Nr '
      + 'FROM f_auftragkopf '
      + 'Where f_auftragkopf.auftr_nr= ? and f_auftragkopf.auftr_pos= ? '
      + 'and f_auftragkopf.oa<9 and status>3 ORDER BY FA_Nr';
//    Result:= RunSelectQuery(sql);
    Result:= RunSelectQueryWithParam(sql,[KaId,IntToStr(id_pos)]);

  UNI2SQLite('f_auftragkopf');

end;

// Fertigungs-Aufrag (FA) zu einer Teile-Nummer (Serien-FA)
//---------------------------------------------------------------------------
function TWBaumQryUNIPPS.SucheFAzuTeil(t_tg_nr:String): Boolean;
{siehe Access Abfrage "b_suche_FA_zu_Teil"
 Suche über f_auftragkopf.t_tg_nr}
var sql: String;
begin
  { TODO 1 : nur freigegebene nehmen }
  sql:= 'SELECT first 1 f_auftragkopf.t_tg_nr as id_stu, '
      + '1 as pos_nr, f_auftragkopf.auftragsart, f_auftragkopf.verurs_art, '
      + 'trim(f_auftragkopf.t_tg_nr) as stu_t_tg_nr, f_auftragkopf.oa as stu_oa, '
      + 'trim(f_auftragkopf.typ) as stu_unipps_typ, '
      + 'f_auftragkopf.ident_nr as FA_Nr '
      + 'FROM f_auftragkopf '
      + 'Where f_auftragkopf.t_tg_nr= ? '
      + 'and f_auftragkopf.oa<9 and status>4 ORDER BY FA_Nr desc';
  Result:= RunSelectQueryWithParam(sql,[t_tg_nr]);

  UNI2SQLite('f_auftragkopf');

end;

// Suche alle Positionen zu einem FA (ASTUELIPOS)
//---------------------------------------------------------------------------
function TWBaumQryUNIPPS.SuchePosZuFA(FA_Nr:String): Boolean;
//siehe Access Abfrage "b_hole_Pos_zu_FA"
var sql: String;
begin
  sql:= 'SELECT astuelipos.ident_nr1 AS id_stu, astuelipos.ident_nr2 as id_pos, '
      + 'astuelipos.ueb_s_nr, astuelipos.ds, astuelipos.set_block, '
      + 'astuelipos.pos_nr, trim(astuelipos.t_tg_nr) as stu_t_tg_nr, '
      + 'astuelipos.oa as stu_oa, '
      + 'trim(astuelipos.typ) as stu_unipps_typ, astuelipos.menge '
      + 'FROM astuelipos where astuelipos.ident_nr1 = ? '
      + 'and astuelipos.oa<9 ORDER BY astuelipos.pos_nr';
  Result:= RunSelectQueryWithParam(sql,[FA_Nr]);

  UNI2SQLite('astuelipos');

end;

// Suche Stueckliste zu einem Teil (Objekt TeilAlsStuPos wird hieraus erzeugt)
//---------------------------------------------------------------------------
function TWBaumQryUNIPPS.SucheStuelizuTeil(t_tg_nr:String): Boolean;
{siehe Access Abfrage "b_suche_Stueli_zu_Teil"
  Suche über teil_stuelipos.ident_nr1=t_tg_nr
  Es werden die Daten aus teil_stuelipos gelesen
  Es existieren z.T. unterschiedlich Stücklisten wegen mehrerer Arbeitspläne (Ausweichmaschine mit anderen Rohteilen)
  Es wird daher zu TEIL_APLNKOPF gejoined und dort teil_aplnkopf.art=1 gefordert (Standardarbeitsplan)
}
var sql: String;
begin
  sql:= 'SELECT trim(teil_stuelipos.ident_nr1) As id_stu, teil_stuelipos.pos_nr, '
      + 'trim(teil_stuelipos.t_tg_nr) as stu_t_tg_nr, '
      + 'teil_stuelipos.oa as stu_oa, trim(teil_stuelipos.typ) as stu_unipps_typ, teil_stuelipos.menge '
      + 'FROM teil_aplnkopf INNER JOIN teil_stuelipos ON teil_aplnkopf.ident_nr1 = teil_stuelipos.ident_nr1 '
      + 'AND teil_aplnkopf.ident_nr2 = teil_stuelipos.ident_nr2 AND teil_aplnkopf.ident_nr3 = teil_stuelipos.ident_nr3 '
      + 'Where teil_stuelipos.ident_nr1= ? And teil_aplnkopf.art="1"'
      + 'ORDER BY teil_stuelipos.pos_nr ;';
  Result:= RunSelectQueryWithParam(sql,[t_tg_nr]);
  UNI2SQLite('teil_stuelipos');

end;

//---------------------------------------------------------------------------
// Suche Zusatz-Infos
//---------------------------------------------------------------------------

// Suche Daten zu einem Teil (Objekt Teil wird hieraus erzeugt)
//---------------------------------------------------------------------------
function TWBaumQryUNIPPS.SucheDatenzumTeil(t_tg_nr:string):Boolean;
//siehe Access Abfrage "b_hole_Daten_zu Teil"
var sql: String;
begin
  sql:= 'SELECT trim(teil_uw.t_tg_nr) as t_tg_nr , teil_uw.oa, '
      + 'teil_uw.v_besch_art, trim(teil.typ) as unipps_typ, '
//      + 'teil.urspr_land, teil.ausl_u_land, '
      + 'teil.praeferenzkennung, teil.sme, teil.faktlme_sme, teil.lme '
      + 'FROM teil INNER JOIN teil_uw ON teil.ident_nr = teil_uw.t_tg_nr AND teil.art = teil_uw.oa '
      + 'where teil_uw.t_tg_nr = ? and teil_uw.oa<9 and teil_uw.uw=1;';
  Result:= RunSelectQueryWithParam(sql,[t_tg_nr]);
  UNI2SQLite('teil');

end;

// Suche Benennung zu einem Teil (wird Objekt Teil zugefuegt)
//---------------------------------------------------------------------------
function TWBaumQryUNIPPS.SucheBenennungZuTeil(t_tg_nr:String): Boolean;
{siehe Access Abfrage "b_hole_Teile_Bezeichnung"
    sql = "SELECT teil_bez.ident_nr1 AS teil_bez_id, teil_bez.Text AS Bezeichnung
     FROM teil_bez
     WHERE ident_nr1=""" & t_tg_nr$ & """ and teil_bez.sprache=""D""
     AND teil_bez.art=1 ;"
}
var sql: String;
begin
  sql:= 'SELECT trim(teil_bez.ident_nr1) AS teil_bez_id, trim(teil_bez.Text) AS Bezeichnung '
      + 'FROM teil_bez where ident_nr1= ? '
      + 'and teil_bez.sprache="D" AND teil_bez.art=1 ;' ;
  Result:= RunSelectQueryWithParam(sql,[t_tg_nr]);
  UNI2SQLite('teil_bez');
end;


// Suche letzte 3 Bestellungen zu einem Teil um Preis zu bestimmen
//(Objekt Bestellung wird hieraus erzeugt)
//---------------------------------------------------------------------------
function TWBaumQryUNIPPS.SucheLetzte3Bestellungen(t_tg_nr:string): Boolean;
{siehe Access Abfrage "b_Bestelldaten"
    'Suche �ber unipps_bestellpos.t_tg_nr=t_tg_nr; bestellkopf.datum muss aus der Unterabfrage hervorgehen (neuestes Datum)
}
var sql: String;
begin
  sql:= 'SELECT first 3 bestellkopf.ident_nr as bestell_id, bestellkopf.datum as bestell_datum, '
      + 'bestellpos.preis, bestellpos.basis, bestellpos.pme, bestellpos.bme, '
      + 'bestellpos.faktlme_bme, bestellpos.faktbme_pme, bestellpos.netto_poswert, '
      + 'bestellpos.menge as best_menge,  '
      + 'bestellpos.we_menge,bestellkopf.lieferant, trim(adresse.kurzname) as kurzname, '
      + 'trim(bestellpos.t_tg_nr) as best_t_tg_nr '
      + 'FROM bestellpos INNER JOIN bestellkopf ON bestellpos.ident_nr1 = bestellkopf.ident_nr '
      + 'JOIN adresse ON bestellkopf.lieferant = adresse.ident_nr '
      + 'WHERE bestellpos.t_tg_nr=? order by bestellkopf.datum desc ;';
  Result:= RunSelectQueryWithParam(sql,[t_tg_nr]);
  UNI2SQLite('bestellungen');

end;

// Suche Rabatt zu einem Kunden (wird an Kundenauftrags-Pos angefuegt)
//---------------------------------------------------------------------------
function TWBaumQryUNIPPS.SucheKundenRabatt(kunden_id:string):Boolean;
var sql: String;
begin
  //siehe Access Abfrage "b_hole_Rabatt_zum_Kunden"
  //TODAY = Informix heutiges Datum
  sql := 'select ident_nr1 as kunden_id, zu_ab_proz, datum_von, datum_bis '
       + 'from kunde_zuab where ident_nr1 = ? '
       + 'and DATUM_VON <TODAY and TODAY <DATUM_BIS;';

  Result:= RunSelectQueryWithParam(sql,[kunden_id]);
  UNI2SQLite('kunde_zuab');

end;

//Kopiert Daten 1:1 in SQLite-Datebank
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
