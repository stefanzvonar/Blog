Imports System.Xml
Imports System.Data.SqlClient

Partial Class SearchResponse
    Inherits System.Web.UI.Page

    ' Page Load
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim dmlSearchLatitude As Double
        Dim dmlSearchLongitude As Double
        Dim intSearchRadius As Int32

        If Request.QueryString("lat") <> "" Then
            dmlSearchLatitude = CDbl(Request.QueryString("lat"))
        End If
        If Request.QueryString("lng") <> "" Then
            dmlSearchLongitude = CDbl(Request.QueryString("lng"))
        End If
        If Request.QueryString("radius") <> "" Then
            intSearchRadius = CInt(Request.QueryString("radius"))
        End If

        ' Here you make the call to your locations stored procedure (or data layer method, or however you have decided to architect your system)
        Dim connDB = New SqlConnection
        Dim cmd As New SqlCommand
        connDB.ConnectionString = "Server=(local);Database=MapExample;Trusted_Connection=True;" ' Change your database connection string to your own!
        connDB.Open()
        cmd.Connection = connDB
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.CommandTimeout = 20
        cmd.CommandText = "dbo.proc_Location_List_By_Geography"
        cmd.Parameters.AddWithValue("@dmlLat", dmlSearchLatitude)
        cmd.Parameters.AddWithValue("@dmlLng", dmlSearchLongitude)
        cmd.Parameters.AddWithValue("@intRadiusKm", intSearchRadius)


        ' Execute the stored procedure and return the result as plain XML
        Dim rdrXMLLocations As XmlReader = Nothing
        rdrXMLLocations = cmd.ExecuteXmlReader()

        Response.Expires = 0
        Response.ContentType = "text/xml"
        Dim oDocument As New XmlDocument()
        Dim sb As New System.Text.StringBuilder()
        Using rdrXMLLocations
            While Not rdrXMLLocations.EOF
                rdrXMLLocations.MoveToContent()
                sb.Append(rdrXMLLocations.ReadOuterXml())
            End While
            rdrXMLLocations.Close()
        End Using
        If sb.ToString() <> "" Then
            oDocument.LoadXml(sb.ToString())
        End If
        oDocument.Save(Response.Output)
        Response.OutputStream.Flush()
        Response.OutputStream.Close()

    End Sub

End Class
