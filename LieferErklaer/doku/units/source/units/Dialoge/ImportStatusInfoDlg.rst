ImportStatusInfoDlg
===================


.. py:module:: ImportStatusInfoDlg

.. py:class:: TImportStatusDlg(TForm)
   
   .. py:data:: var Memo1
      
      :type:: TMemo
   
   .. py:data:: var StatusPanel
      
      :type:: TPanel
   
   .. py:data:: var StringGrid1
      
      :type:: TStringGrid
   
   .. py:data:: var Panel1
      
      :type:: TPanel
   
   .. py:data:: var actRecordLbl
      
      :type:: TLabel
   
   .. py:data:: var ImportBtn
      
      :type:: TButton
   
   .. py:data:: var ESCButton
      
      :type:: TButton
   
   .. py:data:: var Start
      
      :type:: TDateTime
    
   .. py:method:: ImportBtnClick(Sender:TObject)
      
      :param TObject Sender: 
    
   .. py:method:: ESCButtonClick(Sender:TObject)
      
      :param TObject Sender: 
    
   .. py:method:: FormShow(Sender:TObject)
      
      :param TObject Sender: 
    
   .. py:method:: AnzeigeNeuerImportSchritt(SchrittNr:Integer;SchrittBenennung:String)
      
      :param Integer SchrittNr: 
      :param String SchrittBenennung: 
    
   .. py:method:: AnzeigeEndeImportSchritt(SchrittNr:Integer)
      
      :param Integer SchrittNr: 
    
   .. py:method:: AnzeigeRecordsGelesen(aktRecord,maxRecord:Integer)
      
      :param Integer aktRecord: 
      :param Integer maxRecord: 
    
   .. py:method:: SetRecordLabelCaption(text:String)
      
      :param String text: 
    
   .. py:method:: ImportEnde
      

.. py:attribute:: var ImportStatusDlg
   
   :type:: TImportStatusDlg
