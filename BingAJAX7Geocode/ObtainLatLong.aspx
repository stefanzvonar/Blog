<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ObtainLatLong.aspx.vb" Inherits="MapExample" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Obtain Latitude / Longitude</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/> 
    <!-- Reference to the bing script control (change to https if you require SSL) -->
    <script charset="UTF-8" type="text/javascript" src="http://ecn.dev.virtualearth.net/mapcontrol/mapcontrol.ashx?v=7.0"></script>

    <script type="text/javascript">

        var credentials = "YabbaDabbaDoo";  // Change this to your Bing API Key

        function calculateCoordinates() {

            var txtAddress1 = document.getElementById('<%= txtAddress1.ClientID%>');
            var txtAddress2 = document.getElementById('<%= txtAddress2.ClientID%>');
            var txtTown = document.getElementById('<%= txtTown.ClientID%>');
            var txtPostcode = document.getElementById('<%= txtPostcode.ClientID%>');
            var txtCountry = document.getElementById('<%= txtCountry.ClientID%>');

            var address = txtAddress1.value + ', ';
            address += txtAddress2.value + ', ';
            address += txtTown.value + ', ';
            address += txtPostcode.value + ', ';
            address += txtCountry.value;

            // Make REST call to get geocoded information (that is, the coordinates for the address)
            // This will use your call back procedure and return result in JSON format
            var geocodeRequest = "http://dev.virtualearth.net/REST/v1/Locations?query=" + encodeURI(address) + "&output=json&jsonp=GeocodeCallback&key=" + credentials;
            CallRestService(geocodeRequest);

        }

        function CallRestService(request) {
            var script = document.createElement("script");
            script.setAttribute("type", "text/javascript");
            script.setAttribute("src", request);
            document.body.appendChild(script);
        }

        function GeocodeCallback(result) {


            var txtLatitude = document.getElementById('<%= txtLatitude.ClientID%>');
            var txtLongitude = document.getElementById('<%= txtLongitude.ClientID%>');

            if (result &&
                   result.resourceSets &&
                   result.resourceSets.length > 0 &&
                   result.resourceSets[0].resources &&
                   result.resourceSets[0].resources.length > 0) {

                txtLatitude.value = result.resourceSets[0].resources[0].point.coordinates[0];
                txtLongitude.value = result.resourceSets[0].resources[0].point.coordinates[1];

            }
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
