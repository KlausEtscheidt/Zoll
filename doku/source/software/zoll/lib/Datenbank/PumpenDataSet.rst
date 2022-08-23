PumpenDataSet
=============

.. py:module:: PumpenDataSet

.. py:class:: TWDataSet(TClientDataSet)


   .. py:method:: AddData (Felder TFields);

      :param TFields Felder: 

   .. py:method:: AddData (Key string; Felder TFields);

      :param string Key: 
      :param TFields Felder: 

   .. py:method:: AddData (Key string; Val Variant);

      :param string Key: 
      :param Variant Val: 

   .. py:method:: DefiniereTabelle (FeldTypen TWFeldTypenDict; Felder TWFeldNamen);
      Definiert ein Dataset


      :param TWFeldTypenDict FeldTypen: Dict mit Eigenschaften aller Felder. Als key dient ein Name aus "Felder".
      :param TWFeldNamen Felder: Array mit den Namen aller Felder, die angelegt werden sollen. Das Array definiert auch die Reihenfolge. Die Namen müssen in FeldTypen vorhanden sein.

   .. py:method:: DefiniereFeldEigenschaften (FeldTypen TWFeldTypenDict);

      :param TWFeldTypenDict FeldTypen: 

   .. py:method:: DefiniereReadOnly (Felder TWFeldNamen);
      Setzt die ReadOnly-Eigenschaft der übergebenen Felder auf False


      :param TWFeldNamen Felder: Array mit den Namen der Felder, die "schreibbar" werden sollen.

   .. py:method:: FiltereSpalten (Felder TWFeldNamen);

      :param TWFeldNamen Felder: 

   .. py:method:: print (TxtFile TStreamWriter);

      :param TStreamWriter TxtFile: 

   .. py:function:: ToCSV : string;


.. py:method:: Register;

