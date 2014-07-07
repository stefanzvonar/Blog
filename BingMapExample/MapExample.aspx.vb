
Partial Class MapExample
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Page.ClientScript.RegisterStartupScript(Me.GetType(), "GetMap", "<script language='javascript'> GetMap(); </script>")

    End Sub
End Class
