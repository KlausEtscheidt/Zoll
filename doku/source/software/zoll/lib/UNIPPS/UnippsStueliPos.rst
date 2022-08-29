UnippsStueliPos
===============

.. py:module:: UnippsStueliPos

.. py:exception:: EWUnippsStueliPos(Exception)

.. py:class:: TWUniStueliPos(TWStueliPos)

      .. py:attribute:: PosTyp

         :type: string

      .. py:attribute:: TeileNr

         :type: string

      .. py:attribute:: IdPos

         :type: Integer

      .. py:attribute:: PosNr

         :type: string

      .. py:attribute:: OA

         :type: Integer

      .. py:attribute:: UnippsTyp

         :type: string

      .. py:attribute:: BeschaffungsArt

         :type: Integer

      .. py:attribute:: FANr

         :type: Integer

      .. py:attribute:: VerursacherArt

         :type: Integer

      .. py:attribute:: UebergeordneteStueNr

         :type: Integer

      .. py:attribute:: Ds

         :type: Integer

      .. py:attribute:: SetBlock

         :type: Integer

      .. py:attribute:: SummeEU

         :type: Double

      .. py:attribute:: SummeNonEU

         :type: Double

      .. py:attribute:: PreisEU

         :type: Double

      .. py:attribute:: PreisNonEU

         :type: Double

      .. py:attribute:: VerkaufsPreisRabattiert

         :type: Double

      .. py:attribute:: VerkaufsPreisUnRabattiert

         :type: Double

      .. py:attribute:: AnteilNonEU

         :type: Double

      .. py:attribute:: PräfBerechtigt

         :type: string

      .. py:attribute:: Teil

         :type: TWTeil

      .. py:method:: PosDatenSpeichern (Qry TWBaumQrySQLite);

         :param TWBaumQrySQLite Qry: 

      .. py:method:: SucheTeilzurStueliPos;


      .. py:method:: holeKindervonEndKnoten;


      .. py:function:: holeKinderAusASTUELIPOS : Boolean;


      .. py:function:: holeKinderAusTeileStu : Boolean;


      .. py:method:: SummierePreise;


      .. py:method:: BerechnePreisDerPosition;


      .. py:function:: ToStr : string;


      .. py:method:: DatenInAusgabe (ZielDS TWDataSet);

         :param TWDataSet ZielDS: 

      .. py:method:: StrukturInErgebnisTabelle (ZielDS TWDataSet; FirstRun Boolean);

         :param TWDataSet ZielDS: 
         :param Boolean FirstRun: 

      .. py:method:: EntferneFertigungsaufträge;
         Entfernt Fertigungsaufträge aus der Struktur


.. py:class:: TWEndKnotenListe({System.Generics.Collections}TList<UnippsStueliPos.TWUniStueliPos>)

         .. py:function:: ToStr : string;


         .. py:property:: EndKnotenListe

            :type: TWEndKnotenListe
