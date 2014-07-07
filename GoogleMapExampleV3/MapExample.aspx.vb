
Partial Class MapExample
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Page.ClientScript.RegisterStartupScript(Me.GetType(), "mapLoad", "<script language='javascript'> mapLoad(); </script>")

    End Sub
End Class
