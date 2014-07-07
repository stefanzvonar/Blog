<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Popup.aspx.vb" Inherits="Popup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html> 
    <head> 
        <title></title> 
        <script src="scripts/jquery-1.4.2.min.js" type="text/javascript"></script>
        <script src="scripts/jquery.tools.min.js" type="text/javascript"></script> 
        <style type="text/css">
         .overlay  
         {
             background-color:#fff; 
             display:none; 
             width:350px; 
             padding:15px; 
             text-align:left; 
             border:3px solid #333; 
             -moz-border-radius:6px; 
             -webkit-border-radius:6px; 
             -moz-box-shadow: 00 50px #ccc; 
             -webkit-box-shadow: 00 50px #ccc; 
          } 
         </style> 
    </head>
    <body>
        <form id="form1" runat="server">
            <div>
                <asp:Button ID="btnDoStuff "runat="server" Text="Do Stuff"/>
            </div>
            <div class="overlay" id="divPopUp "style="width:450px">
                <h3>Hello</h3>
                <p> Do you like my pop up? </p>
                <button>Close</button>
            </div>
        </form>
     </body>
 </html>


