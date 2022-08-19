UnippsStueliPos
===============
.. py:module:: UnippsStueliPos

.. py:exception:: EWUnippsStueliPos(Exception)

.. py:class:: TWUniStueliPos(TWStueliPos)

   .. py:method:: PosDatenSpeichern (Qry TWBaumQrySQLite);

   .. py:method:: SucheTeilzurStueliPos ;

   .. py:method:: holeKindervonEndKnoten ;

   .. py:method:: SummierePreise ;

   .. py:method:: BerechnePreisDerPosition ;

   .. py:method:: DatenInAusgabe (ZielDS TWDataSet);

   .. py:method:: StrukturInErgebnisTabelle (ZielDS TWDataSet; FirstRun Boolean);

   .. py:method:: EntferneFertigungsaufträge ;

      Entfernt Fertigungsaufträge aus der Struktur

   .. py:function:: holeKinderAusASTUELIPOS ;

      :rtype: Boolean

   .. py:function:: holeKinderAusTeileStu ;

      :rtype: Boolean

   .. py:function:: ToStr ;

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

   .. py:function:: ToStr ;

      :rtype: string
