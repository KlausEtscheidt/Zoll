LeklTeileEingabeFrame
=====================


.. py:module:: LeklTeileEingabeFrame

.. py:class:: TLieferantenErklaerungenFrm(TFrame)
   
   .. py:data:: var DBCtrlGrid1
      
      :type:: TDBCtrlGrid
   
   .. py:data:: var PFKChkBox
      
      :type:: TDBCheckBox
   
   .. py:data:: var TeileNr
      
      :type:: TDBText
   
   .. py:data:: var TName1
      
      :type:: TDBText
   
   .. py:data:: var TName2
      
      :type:: TDBText
   
   .. py:data:: var LTeileNr
      
      :type:: TDBText
   
   .. py:data:: var DataSource1
      
      :type:: TDataSource
   
   .. py:data:: var Label1
      
      :type:: TLabel
   
   .. py:data:: var LKurznameLbl
      
      :type:: TLabel
   
   .. py:data:: var IdLieferantLbl
      
      :type:: TLabel
   
   .. py:data:: var SortLTeileNrBtn
      
      :type:: TButton
   
   .. py:data:: var SortTeilenrBtn
      
      :type:: TButton
   
   .. py:data:: var SortLTNameBtn
      
      :type:: TButton
   
   .. py:data:: var LabelSort
      
      :type:: TLabel
   
   .. py:data:: var LabelFiltern
      
      :type:: TLabel
   
   .. py:data:: var FilterTeileNr
      
      :type:: TEdit
   
   .. py:data:: var FilterTName1
      
      :type:: TEdit
   
   .. py:data:: var FilterLTeileNr
      
      :type:: TEdit
   
   .. py:data:: var FilterTName2
      
      :type:: TEdit
   
   .. py:data:: var FilterOffBtn
      
      :type:: TButton
   
   .. py:data:: var ImageList1
      
      :type:: TImageList
   
   .. py:data:: var PfkResetBtn
      
      :type:: TButton
   
   .. py:data:: var PfkSetBtn
      
      :type:: TButton
   
   .. py:data:: var Label2
      
      :type:: TLabel
   
   .. py:data:: var PfkOnCheckBox
      
      :type:: TCheckBox
   
   .. py:data:: var PfkOffCheckBox
      
      :type:: TCheckBox
   
   .. py:data:: var n_gefiltert
      
      :type:: TLabel
   
   .. py:data:: var LocalQry
      
      :type:: TWQry
   
   .. py:data:: var LErklaerungenTab
      
      :type:: TADOTable
   
   .. py:data:: var IdLieferant
      
      :type:: Integer
   
   .. py:data:: var DatenGeaendert
      
      :type:: Boolean
    
   .. py:method:: SortLTeileNrBtnClick(Sender:TObject)
      
      :param TObject Sender: 
    
   .. py:method:: SortLTNameBtnClick(Sender:TObject)
      
      :param TObject Sender: 
    
   .. py:method:: SortTeilenrBtnClick(Sender:TObject)
      
      :param TObject Sender: 
    
   .. py:method:: PFKChkBoxClick(Sender:TObject)
      
       Uebertragen des PFK-Flags in die Datenbank 
      
      Durch den left-Join geht dies nicht direkt in der LocalQry  Die Daten werden in die Tabelle LErklaerungen eingetragen  Das Formular merkt sich aber, das Daten ge�ndert wurden,  was wiederum zu Problemen f�hrt.  Nach dem Auslesen der Daten aus dem Formular,  wird dieses daher von der Datenquelle getrennt.  Nach dem Abspeichern der Daten in der Tabelle,  erhaelt LocalQry durch ein Requery die aktuellen Daten  und wird wieder mit dem Formular verbunden.  LocalQry und Formular werden wieder auf den ge�nderten Record positionert. 

      
      :param TObject Sender: 
    
   .. py:method:: FilterTeileNrChange(Sender:TObject)
      
      :param TObject Sender: 
    
   .. py:method:: FilterTName1Change(Sender:TObject)
      
      :param TObject Sender: 
    
   .. py:method:: FilterLTeileNrChange(Sender:TObject)
      
      :param TObject Sender: 
    
   .. py:method:: FilterTName2Change(Sender:TObject)
      
      :param TObject Sender: 
    
   .. py:method:: FilterOffBtnClick(Sender:TObject)
      
      :param TObject Sender: 
    
   .. py:method:: PfkResetBtnClick(Sender:TObject)
      
      :param TObject Sender: 
    
   .. py:method:: PfkSetBtnClick(Sender:TObject)
      
      :param TObject Sender: 
    
   .. py:method:: PfkSet(NeuerWert:Integer)
      
      :param Integer NeuerWert: 
    
   .. py:method:: PfkOnCheckBoxClick(Sender:TObject)
      
      :param TObject Sender: 
    
   .. py:method:: PfkOffCheckBoxClick(Sender:TObject)
      
      :param TObject Sender: 
    
   .. py:method:: Init
      
    
   .. py:method:: HideFrame
      
    
   .. py:method:: FilterUpdate
      
