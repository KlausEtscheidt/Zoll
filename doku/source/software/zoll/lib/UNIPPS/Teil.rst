Teil
====

.. py:module:: Teil

.. py:exception:: EWTeil(Exception)

.. py:class:: TWTeil(TObject)

      .. py:attribute:: TeileNr

         :type: string

      .. py:attribute:: OA

         :type: Integer

      .. py:attribute:: UnippsTyp

         :type: string

      .. py:attribute:: Bezeichnung

         :type: string

      .. py:attribute:: BeschaffungsArt

         :type: Integer

      .. py:attribute:: Praeferenzkennung

         :type: Integer

      .. py:attribute:: Sme

         :type: Integer

      .. py:attribute:: FaktorLmeSme

         :type: Double

      .. py:attribute:: Lme

         :type: Integer

      .. py:attribute:: PreisGesucht

         :type: Boolean

      .. py:attribute:: PreisErmittelt

         :type: Boolean

      .. py:attribute:: Bestellung

         :type: TWBestellung

      .. py:attribute:: IstPraeferenzberechtigt

         :type: Boolean

      .. py:attribute:: IstKaufteil

         :type: Boolean

      .. py:attribute:: IstEigenfertigung

         :type: Boolean

      .. py:attribute:: IstFremdfertigung

         :type: Boolean

      .. py:attribute:: PreisJeLME

         :type: Double

      .. py:method:: holeBenennung;


      .. py:method:: holeMaxPreisAus3Bestellungen;


      .. py:function:: StueliPosGesamtPreis (menge Double; faktlme_sme Double): Double;

         :param Double menge: 
         :param Double faktlme_sme: 

      .. py:function:: ToStr : string;


      .. py:method:: DatenInAusgabe (ZielDS TWDataSet);

         :param TWDataSet ZielDS: 
