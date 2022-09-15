FertigungsauftragsPos
=====================


.. py:module:: FertigungsauftragsPos

.. py:class:: TWFAPos(TWUniStueliPos)
   
   .. py:data:: var ueb_s_nr
      
      :type:: Integer
   
   .. py:data:: var pos_nr
      
      :type:: Integer
   
   .. py:data:: var set_block
      
      :type:: Integer
   
   .. py:data:: var istToplevel
      
      :type:: Boolean
   
   .. py:data:: var KinderInASTUELIPOSerwartet
      
      :type:: Boolean
   
   .. py:data:: var FaPosIdStuVater
      
      :type:: String
   
   .. py:data:: var FaPosIdPos
      
      :type:: Integer
   
   .. py:data:: var FaPosPosNr
      
      :type:: String
    
   .. py:method:: Create(einVater:TWUniStueliPos;AQry:TWUNIPPSQry)
      
      :param TWUniStueliPos einVater: 
      :param TWUNIPPSQry AQry: 
    
   .. py:method:: holeKinderAusASTUELIPOS(id_pos_vater:Integer)
      
      :param Integer id_pos_vater: 
