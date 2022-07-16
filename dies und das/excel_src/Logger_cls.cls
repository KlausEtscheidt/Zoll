VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Logger_cls"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public batch_modus As Boolean
Private logfile As TextStream
Private fso As FileSystemObject

Public Sub init(batch_mod As Boolean)
    Dim fso As FileSystemObject
    
    Dim logfilename$
    
    batch_modus = batch_mod
    
    logfilename = ThisWorkbook.Path & "\logfile.txt"

    Set fso = New FileSystemObject

    Set logfile = fso.CreateTextFile(logfilename)
   
End Sub

'Ausgabe per Messagebox oder im Batchmode in Datei
Public Sub user_info(msg$, Optional level% = 0)
    If batch_modus Then
        logfile.WriteLine space(level) & msg
    Else
        logfile.WriteLine space(level) & msg
        MsgBox msg
    End If
End Sub

'Ausgabe in Datei (unabhängig vom batchmode)
Public Sub log(msg$, Optional level% = 0)
    logfile.WriteLine space(level) & msg
End Sub

Private Function space(level%) As String
    Dim i
    space = ""
    For i = 1 To level
        space = space + "   "
    Next i
End Function

Private Sub Class_Terminate()
   logfile.Close
   Set logfile = Nothing
   Set fso = Nothing
End Sub


