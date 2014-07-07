<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="_Default" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <title>Upload file to database</title>
    </head>
    <body>
        <form id="form1" runat="server">
            <div>  File Name: </div>
            <div> <asp:TextBox runat="server" ID="txtFileName"></asp:TextBox> </div>
            <br/>
            <div>  File: </div> 
            <div> <asp:fileupload runat="server" ID="uplFile"/> </div> 
            <br/>
            <div> <asp:button ID="btnSave" runat="server" text="Save" OnClick="btnSave_Click"/> </div>
        </form>
    </body>
</html>

