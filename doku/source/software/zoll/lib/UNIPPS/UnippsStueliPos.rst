UnippsStueliPos
===============

.. py:module:: UnippsStueliPos

.. py:exception:: EWUnippsStueliPos(Exception)


.. py:class:: TWUniStueliPos(TWStueliPos)


   .. py:method:: PosDatenSpeichern (Qry TWBaumQrySQLite);

      :param TWBaumQrySQLite Qry: 

   .. py:method:: SucheTeilzurStueliPos;


   .. py:method:: holeKindervonEndKnoten;


   .. py:method:: SummierePreise;


   .. py:method:: BerechnePreisDerPosition;


   .. py:method:: DatenInAusgabe (ZielDS TWDataSet);

      :param TWDataSet ZielDS: 

   .. py:method:: StrukturInErgebnisTabelle (ZielDS TWDataSet; FirstRun Boolean);

      :param TWDataSet ZielDS: 
      :param Boolean FirstRun: 

   .. py:method:: EntferneFertigungsaufträge;
      Entfernt Fertigungsaufträge aus der Struktur



   .. py:function:: holeKinderAusASTUELIPOS : Boolean;

      :rtype: Boolean

   .. py:function:: holeKinderAusTeileStu : Boolean;

      :rtype: Boolean

   .. py:function:: ToStr : string;

      :rtype: string

   .. py:attribute:: PosTyp

   .. py:attribute:: TeileNr

   .. py:attribute:: IdPos

   .. py:attribute:: PosNr

   .. py:attribute:: OA

   .. py:attribute:: UnippsTyp

   .. py:attribute:: BeschaffungsArt

   .. py:attribute:: FANr

   .. py:attribute:: VerursacherArt

   .. py:attribute:: UebergeordneteStueNr

   .. py:attribute:: Ds

   .. py:attribute:: SetBlock

   .. py:attribute:: SummeEU

   .. py:attribute:: SummeNonEU

   .. py:attribute:: PreisEU

   .. py:attribute:: PreisNonEU

   .. py:attribute:: VerkaufsPreisRabattiert

   .. py:attribute:: VerkaufsPreisUnRabattiert

   .. py:attribute:: AnteilNonEU

   .. py:attribute:: PräfBerechtigt

   .. py:attribute:: Teil

.. py:class:: TWEndKnotenListe({System.Generics.Collections}TList<UnippsStueliPos.TWUniStueliPos>)


   .. py:function:: ToStr : string;

      :rtype: string
