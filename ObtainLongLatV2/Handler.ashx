<%@ WebHandler Language="VB" Class="FileHandler" %>

Imports System 
Imports System.Web 
Imports System.Web.Services 
Imports System.Data
Imports System.Data.SqlClient

Public Class FileHandler : Implements IHttpHandler
    
    Private m_strFileContentType As String = String.Empty
    Private m_objFileData As Object
    Private m_intFileID As Integer
    
    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
    
    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        GetData(context)
        ShowFile(context)
    End Sub
        
        
    Private Sub GetData(ByVal context As HttpContext)
        
        If context.Request.QueryString("ID") IsNot Nothing AndAlso context.Request.QueryString("ID").Trim() <> String.Empty AndAlso IsNumeric(context.Request.QueryString("ID").Trim()) Then
            m_intFileID = CInt(context.Request.QueryString("ID").Trim())
            
            Dim conSQL = New SqlClient.SqlConnection
            conSQL.ConnectionString = "Your database connection string"
            conSQL.Open()
            
            Dim comSQL As New SqlCommand("dbo.usp_File_Get")
            comSQL.Connection = conSQL
            comSQL.Parameters.AddWithValue("@FileID", m_intFileID)
            comSQL.CommandType = CommandType.StoredProcedure
            
            'read record from database 
            Dim drdDrillInstructions As SqlDataReader
            drdDrillInstructions = comSQL.ExecuteReader()
            Try
                If (drdDrillInstructions.HasRows) Then
                    While drdDrillInstructions.Read()
                        m_strFileContentType = drdDrillInstructions.Item("FileContentType").ToString()
                        m_objFileData = drdDrillInstructions.Item("FileData")
                    End While
                End If
            Catch ex As Exception
                ' Publish error here 
            Finally
                If Not drdDrillInstructions.IsClosed Then
                    drdDrillInstructions.Close()
                End If
                conSQL.Close()
                conSQL.Dispose()
            End Try

        End If
    End Sub

    Private Sub ShowFile(ByVal context As HttpContext)
        ' Clear out the existing HTTP header information  
        context.Response.Expires = 0
        context.Response.Buffer = True
        context.Response.Clear()

        If m_objFileData IsNot Nothing AndAlso (Not DBNull.Value.Equals(m_objFileData)) Then
            context.Response.ContentType = m_strFileContentType
            context.Response.BinaryWrite(DirectCast(m_objFileData, Byte()))
        Else
            context.Response.Write("<html><body bgcolor='#D6EBFF'><p align='center'><br /><br /><br /><br /><br />")
            context.Response.Write("<font class='text'>(No file available)</font>")
            context.Response.Write("</p></body></html>")
        End If
    End Sub

End Class

