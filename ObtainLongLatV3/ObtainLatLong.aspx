<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ObtainLatLong.aspx.vb" Inherits="MapExample" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Obtain Latitude / Longitude</title>
    <!-- Google Map API Key -->
    <script src="http://maps.google.com/maps/api/js?v=3&sensor=false&key=YabbaDabbaDoo" type="text/javascript"></script>
    

    <script type="text/javascript">

        function calculateCoordinates() {

            var txtAddress1 = document.getElementById('<%= txtAddress1.ClientID%>');
            var txtAddress2 = document.getElementById('<%= txtAddress2.ClientID%>');
            var txtTown = document.getElementById('<%= txtTown.ClientID%>');
            var txtPostcode = document.getElementById('<%= txtPostcode.ClientID%>');
            var txtCountry = document.getElementById('<%= txtCountry.ClientID%>');
            var txtLatitude = document.getElementById('<%= txtLatitude.ClientID%>');
            var txtLongitude = document.getElementById('<%= txtLongitude.ClientID%>');

            var address = txtAddress1.value + ', ';
            address += txtAddress2.value + ', ';
            address += txtTown.value + ', ';
            address += txtPostcode.value + ', ';
            address += txtCountry.value;

            var geocoder;
            geocoder = new google.maps.Geocoder();

            geocoder.geocode({ address: address }, function (results, status) {
                if (status == google.maps.GeocoderStatus.OK) {
                    var location = results[0].geometry.location;
                    txtLatitude.value = location.lat();
                    txtLongitude.value = location.lng();
                }
                else
                    alert(searchString + ' - not found');

            });

        }

    </script> 
</head>
<body>
    <form id="form1" runat="server">
        <div align="left"><b>Address Line 1:</b></div>
        <div><asp:TextBox id="txtAddress1" TextMode="MultiLine" Rows="2" runat="server" MaxLength="50" ></asp:TextBox></div>
        <div align="left"><b>Address Line 2:</b></div>
        <div><asp:TextBox id="txtAddress2" TextMode="MultiLine" Rows="2" runat="server" MaxLength="50" ></asp:TextBox></div>
        <div align="left"><b>Town:</b></div>
        <div><asp:TextBox id="txtTown" runat="server" MaxLength="50"></asp:TextBox></div>
        <div align="left"><b>Postcode:</b></div>
        <div><asp:TextBox id="txtPostcode" runat="server" MaxLength="10"></asp:TextBox></div>
        <div align="left"><b>Country:</b></div>
        <div><asp:TextBox id="txtCountry" runat="server" MaxLength="50"></asp:TextBox></div> 

        <div align="left"></div>
        <div><input id="btnCalculateCoordinates" type="button" value="Calculate Coordinates" onclick="calculateCoordinates();" /></div>
        <div align="left"><b>Latitude:</b></div>
        <div><asp:TextBox id="txtLatitude" runat="server" Width="100px"></asp:TextBox></div>
        <div align="left"><b>Longitude:</b></div>
        <div><asp:TextBox id="txtLongitude" runat="server" Width="100px"></asp:TextBox></div> 
    </form>
</body>
</html>
