
class EStuBaumMainExc: public Exception{};

class TWPraeFixThread{
      public
          String ErrMsg;
          Boolean Success;
		  void Execute(); 
};

RunItGui ();
KaAuswerten (string KaId );
Boolean Preisabfrage (TWKundenauftrag KA ,TWZuordnungen &Zuordnungen );
ZuordnungAendern (TWKundenauftrag KA , TWZuordnungen Zuordnungen );
Boolean PraeferenzKalkBeginn (String KaId );
///<summary>Anfang der Berechnung einer Präferenzberechtigung  mit Preisabfrage</summary>
PraeferenzKalkAbschluss ();
///<summary>2. Teil der Berechnung einer Präferenzberechtigung</summary>
