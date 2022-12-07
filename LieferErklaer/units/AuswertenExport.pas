unit AuswertenExport;

interface

uses System.SysUtils,Tools;

procedure Init();
procedure SetzePfkInTeileTabelle();

var
  Initialized:Boolean;
  LocalQry: TWQry;

implementation

/// <summary> Finale Auswertung und Erzeugen der UNIPPS-Export-Tabelle</summary>

procedure Init();
begin
    Initialized:=False;
  // Qry fuer lokale DB anlegen
    LocalQry := Tools.GetQuery;
    if not LocalQry.Connected then
      raise Exception.Create('Keine Verbindung zur Datenbank!');
    Initialized:=True;
end;

procedure SetzePfkInTeileTabelle();

var
  minRestGueltigkeit:String;

begin
  //Verbinde zu DB, falls noch nie erfolgt
  if not Initialized then
    Init;
  //Falls ohne Erfolg
  if not Initialized then
    exit;
  //Lies die Tage, die eine Lief.-Erklär. mindestens noch gelten muss
  minRestGueltigkeit:=LocalQry.LiesProgrammDatenWert('Gueltigkeit_Lekl');

  //Leere Zwischentabelle
  LocalQry.RunExecSQLQuery('delete from tmpLieferantTeilPfk;');

  //Fuege Teile von Lieferanten mit gültiger Erklärung "alle Teile" ein
  LocalQry.LeklAlleTeileInTmpTabelle(minRestGueltigkeit);

  //Fuege Teile von Lieferanten mit gültiger Erklärung "einige Teile" ein
  LocalQry.LeklEinigeTeileInTmpTabelle(minRestGueltigkeit);

  //Leere Zwischentabelle
  LocalQry.RunExecSQLQuery('delete from tmp_anz_xxx_je_teil;');

  //Anzahl der Lieferanten mit gültiger Erklaerung je Teil in tmp Tabelle
  LocalQry.UpdateTmpAnzErklaerungenJeTeil;

  //Anzahl der Lieferanten mit gültiger Erklaerung je Teil
  //in Tabelle Teile auf 0 setzen
  LocalQry.RunExecSQLQuery('UPDATE Teile SET n_LPfk= 0');

  //Anzahl der Lieferanten mit gültiger Erklaerung je Teil in Tabelle Teile
  LocalQry.UpdateTeileZaehleGueltigeLErklaerungen;

  // Flag PFK in Teile setzen
  LocalQry.UpdateTeileResetPFK;
  LocalQry.UpdateTeileSetPFK;

//  StatusBarLeft('Auswertung fertig');



end;

end.
