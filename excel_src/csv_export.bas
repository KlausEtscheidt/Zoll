Attribute VB_Name = "csv_export"
Public Function get_csv_file(filename$) As TextStream
    Dim fso As FileSystemObject
    Dim csv_filename$
       
    csv_filename = ThisWorkbook.Path & "\csv\" & filename$ & ".csv"

    Set fso = New FileSystemObject
    If fso.FileExists(csv_filename) Then
        Set get_csv_file = fso.OpenTextFile(csv_filename, ForAppending)
    Else
        Set get_csv_file = fso.CreateTextFile(csv_filename)
    End If
   
End Function

Public Sub csv_out(rs As Recordset, filename$)
    Dim line$
    Dim i%
    Dim Field As Field
    Set csv_file = get_csv_file(filename)
    Do While Not rs.EOF
        line = ""
        For i = 0 To rs.Fields.Count - 2
            line = line & rs.Fields(i).Value & ";"
        Next
        line = line & rs.Fields(i).Value
        rs.MoveNext
        csv_file.WriteLine line
    Loop
    If rs.RecordCount > 0 Then
        rs.MoveFirst
    End If
End Sub

