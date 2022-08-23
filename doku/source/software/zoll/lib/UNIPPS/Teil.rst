Teil
====

.. py:module:: Teil

.. py:exception:: EWTeil(Exception)


.. py:class:: TWTeil(TObject)


   .. py:attribute:: TeileNr

   .. py:attribute:: OA

   .. py:attribute:: UnippsTyp

   .. py:attribute:: Bezeichnung

   .. py:attribute:: BeschaffungsArt

   .. py:attribute:: Praeferenzkennung

   .. py:attribute:: Sme

   .. py:attribute:: FaktorLmeSme

   .. py:attribute:: Lme

   .. py:attribute:: PreisGesucht

   .. py:attribute:: PreisErmittelt

   .. py:attribute:: Bestellung

   .. py:attribute:: IstPraeferenzberechtigt

   .. py:attribute:: IstKaufteil

   .. py:attribute:: IstEigenfertigung

   .. py:attribute:: IstFremdfertigung

   .. py:attribute:: PreisJeLME

   .. py:method:: holeBenennung;


   .. py:method:: holeMaxPreisAus3Bestellungen;


   .. py:method:: DatenInAusgabe (ZielDS TWDataSet);

      :param TWDataSet ZielDS: 

   .. py:function:: StueliPosGesamtPreis (menge Double; faktlme_sme Double): Double;

      :param Double menge: 
      :param Double faktlme_sme: 

   .. py:function:: ToStr : string;

