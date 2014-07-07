Imports System.Data

Partial Class _Default
    Inherits System.Web.UI.Page

    Private m_strFileName, m_strFileContentType As String
    Private m_intFileLen As Integer
    Private m_byteFileData As Byte()


    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As EventArgs)
        GetFileData()
        SaveData()
    End Sub

    Private Sub GetFileData()
        Dim myFile As HttpPostedFile = uplFile.PostedFile
        m_strFileName = System.IO.Path.GetFileName(uplFile.FileName)
        m_strFileContentType = myFile.ContentType
        m_intFileLen = myFile.ContentLength
        m_byteFileData = Nothing

        ' make sure the size of the file is > 0 
        If m_intFileLen > 0 Then
            ' Allocate a buffer for reading of the file
            m_byteFileData = New Byte(m_intFileLen - 1) {}
            ' Read uploaded file from the Stream 
            myFile.InputStream.Read(m_byteFileData, 0, m_intFileLen)
        End If
    End Sub

    Private Sub SaveData()
        Dim conSQL = New SqlClient.SqlConnection
        conSQL.ConnectionString = "Your database connection string"
        conSQL.Open()
        Dim comSQL As New SqlClient.SqlCommand()
        With comSQL
            .CommandText = "dbo.usp_File_Insert"
            .Connection = conSQL
            .CommandType = CommandType.StoredProcedure
            .Parameters.AddWithValue("@FileName", m_strFileName)
            .Parameters.Add("@DocData", SqlDbType.VarBinary, -1)
            ' Need to set size to -1 since it is varbinary(max)
            If m_byteFileData Is Nothing Then
                .Parameters("@DocData").Value = System.DBNull.Value
            Else
                .Parameters("@DocData").Value = m_byteFileData
            End If
            .Parameters.AddWithValue("@DocContentType", m_strFileContentType)
            .ExecuteNonQuery()
        End With
        conSQL.Close()
        conSQL.Dispose()
    End Sub

    Private Sub test()

        For Each table As DataTable In myDataSet.Tables()
            ' Loop backwards so that we can remove the column without interfering with our iteration 
            For i As Integer = table.Columns.Count - 1 To 0 Step -1
                ' Enter your own checks here  
                table.Columns.RemoveAt(i)
            Next
        Next



    End Sub


End Class




