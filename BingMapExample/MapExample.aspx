<%@ Page Language="VB" AutoEventWireup="false" CodeFile="MapExample.aspx.vb" Inherits="MapExample" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Map Example</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <!-- Reference to the bing script control (change to https if you require SSL) -->
    <script charset="UTF-8" type="text/javascript" src="http://ecn.dev.virtualearth.net/mapcontrol/mapcontrol.ashx?v=7.0"></script>
    <!-- HTTP Utility functions -->
    <script src="js/Util.js" type="text/javascript"></script>
    <!-- Bing Map Functions for this page -->
    <script src="js/MapExample.js" type="text/javascript"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div style="margin-left:20px;">

            <div style="margin-left: 5px;">
                <span style="font-size: 10px;">Please enter an address, town or post code and click search</span>
                <br />
                Address: <input type="text" id="txtSearchAddress" value="Edward Street, Brisbane" />&nbsp;
                Country: <input type="text" id="txtSearchCountry" value="Australia" />&nbsp;
                Distance:
                <select id="ddlRadius">
                  <option value="5">5 km</option>
                  <option value="10">10 km</option>
                  <option value="25">25 km</option>
                  <option value="50" selected>50 km</option>
                  <option value="100">100 km</option>
                </select>&nbsp;
                <input type="button" onclick="searchLocations()" value="Search"/>
            </div>

            <br />

            <div style="clear:both; margin-left: 5px;">
                <div id="sidebar" style="overflow: auto; height: 400px; width:150px; font-size: 11px; color: #000; float:left; margin-left:5px; padding-left:5px;">Search Results:</div>
                <div style="float:left; margin-left: 5px;">
                    <div id="BingMap_Div_Container">
                        <div id="map" style="position:relative;width:750px;height:400px;"></div>
                    </div>
               </div>
            </div>

            <br style="clear:both;" />

        </div>   
    </form>
</body>
</html>