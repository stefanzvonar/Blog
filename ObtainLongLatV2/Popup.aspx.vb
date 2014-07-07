
Partial Class Popup
    Inherits System.Web.UI.Page

    Protected Sub btnDoStuff_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDoStuff.Click
        ' Do whatever other server-side code you want done here 

        ' Now show the popup overlay  
        ShowPopUpOverlay()
    End Sub

    Private Sub ShowPopUpOverlay()

        'Create the client script 
        Dim sbOverlay As New StringBuilder()
        sbOverlay.Append("$(document).ready(function()" & vbCrLf)
        sbOverlay.Append("{" & vbCrLf)
        sbOverlay.Append("$(""#divPopUp"").overlay({" & vbCrLf)
        sbOverlay.Append("// custom top position" & vbCrLf)
        sbOverlay.Append("top: 272," & vbCrLf)
        sbOverlay.Append("expose: {" & vbCrLf)
        sbOverlay.Append("Color: '#999'," & vbCrLf)
        sbOverlay.Append("loadSpeed: 200," & vbCrLf)
        sbOverlay.Append("// highly transparent" & vbCrLf)
        sbOverlay.Append("opacity: 0.5" & vbCrLf)
        sbOverlay.Append("}," & vbCrLf)
        sbOverlay.Append("closeOnClick: false," & vbCrLf)
        sbOverlay.Append("api: true" & vbCrLf)
        sbOverlay.Append("// load it immediately after the construction" & vbCrLf)
        sbOverlay.Append("}).load();" & vbCrLf)
        sbOverlay.Append("});" & vbCrLf)

        ClientScript.RegisterClientScriptBlock(GetType(Page), Guid.NewGuid().ToString(), sbOverlay.ToString(), True)

    End Sub

End Class
