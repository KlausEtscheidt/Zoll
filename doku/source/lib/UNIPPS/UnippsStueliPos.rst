UnippsStueliPos
===============
.. py:module:: UnippsStueliPos

.. py:class:: EWUnippsStueliPos

.. py:class:: TWUniStueliPos

   .. py:method:: PosDatenSpeichern (Qry TWBaumQryUNIPPS);

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

.. py:class:: TWEndKnotenListe

   .. py:function:: ToStr ;

      :rtype: string
