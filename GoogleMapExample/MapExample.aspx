<%@ Page Language="VB" AutoEventWireup="false" CodeFile="MapExample.aspx.vb" Inherits="MapExample" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Map Example</title>
    <script language="javascript" type="text/javascript">

        // Google Map API Javascript

        var map;
        var geocoder;
        var http_request = false;
        var lat = 0;
        var lng = 0;
        var startingLat = 54.1509;  // view of england
        var startingLng = -4.4855;  // view of england
        var startingZoom = 5;
        var maximumZoom = 15;

        function mapLoad() {
            if (GBrowserIsCompatible()) {
                geocoder = new GClientGeocoder();
                map = new GMap2(document.getElementById('map'));
                map.addControl(new GSmallMapControl());
                map.addControl(new GMapTypeControl());
                map.enableScrollWheelZoom();
                map.setCenter(new GLatLng(startingLat, startingLng), startingZoom);
            }

        }

        function searchLocations() {

            var address = document.getElementById('txtSearchAddress').value;
            var country = document.getElementById('txtSearchCountry').value;
            var searchString = address + ', ' + country;

            geocoder.getLatLng(searchString, function(latlng) {
                if (!latlng) {
                    alert(searchString + ' - not found');
                } else {
                    searchLocationsNear(latlng);
                }
            });
        }

        function searchLocationsNear(center) {
            var radius = document.getElementById('ddlRadius').value;
            var searchUrl = 'SearchResponse.aspx?lat=' + center.lat() + '&lng=' + center.lng() + '&radius=' + radius;
        
            GDownloadUrl(searchUrl, function(data) {
                var xml = GXml.parse(data);
                var sidebar = document.getElementById('sidebar');
                sidebar.innerHTML = '';
                map.clearOverlays();

                if (xml.documentElement == null) {
                    sidebar.innerHTML = 'No results found.  Please try widening your search area.';
                    map.setCenter(new GLatLng(startingLat, startingLng), startingZoom);
                    return;
                }

                var markers = xml.documentElement.getElementsByTagName('marker');

                if (markers.length == 0) {
                    sidebar.innerHTML = 'No results found.  Please try widening your search area.';
                    map.setCenter(new GLatLng(startingLat, startingLng), startingZoom);
                    return;
                }

                var bounds = new GLatLngBounds();
                for (var i = 0; i < markers.length; i++) {
                    var address1 = markers[i].getAttribute('Address1');
                    var address2 = markers[i].getAttribute('Address2');
                    var town = markers[i].getAttribute('Town');
                    var postcode = markers[i].getAttribute('Postcode');
                    var distance = parseFloat(markers[i].getAttribute('distance'));
                    var point = new GLatLng(parseFloat(markers[i].getAttribute('Latitude')),
                                 parseFloat(markers[i].getAttribute('Longitude')));

                    var marker = createMarker(point, address1, address2, town, postcode);

                    map.addOverlay(marker);
                    var sidebarEntry = createSidebarEntry(marker, address1, address2, town, distance);
                    sidebar.appendChild(sidebarEntry);
                    bounds.extend(point);
                }

                var pointCenter = bounds.getCenter();
                var iZoomLevel = map.getBoundsZoomLevel(bounds);
                if (iZoomLevel > maximumZoom) { iZoomLevel = maximumZoom; }
                map.setCenter(pointCenter, iZoomLevel);

            });
        }

        function createMarker(point, address1, address2, town, postcode) {
            var marker = new GMarker(point);
            var html;
            if (address2 == null) {
                html = '<br/>' + address1 + '<br/>' + town + '<br/>' + postcode;
            }
            else {
                html = '<br/>' + address1 + ', ' + address2 + '<br/>' + town + '<br/>' + postcode;
            }
            GEvent.addListener(marker, 'click', function() {
                marker.openInfoWindowHtml(html);
            });
            return marker;
        }

        function createSidebarEntry(marker, address1, address2, town, distance) {
            var div = document.createElement('div');
            var address;
            if (address2 == '' || address2 == null) {
                address = address1 + '<br/>' + town;
            }
            else {
                address = address1 + '<br/>' + address2 + '<br/>' + town;
            }
            var html = '<b>' + distance.toFixed(2) + ' miles: </b><br/>' + address;
            div.innerHTML = html;
            div.style.cursor = 'pointer';
            div.style.marginBottom = '5px';
            GEvent.addDomListener(div, 'click', function() {
                GEvent.trigger(marker, 'click');
            });
            GEvent.addDomListener(div, 'mouseover', function() {
                div.style.backgroundColor = '#eee';
            });
            GEvent.addDomListener(div, 'mouseout', function() {
                div.style.backgroundColor = '#fff';
            });
            return div;
        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
        
        <div style="margin-left:20px;">

            <div style="margin-left: 5px;">
                <span style="font-size: 10px;">Please enter an address, town or post code and click search</span>
                <br />
                Address: <input type="text" id="txtSearchAddress" value="High Street Kensington" />&nbsp;
                Country: <input type="text" id="txtSearchCountry" value="United Kingdom" />&nbsp;
                Distance:
                <select id="ddlRadius">
                  <option value="5" selected>5 miles</option>
                  <option value="10">10 miles</option>
                  <option value="25">25 miles</option>
                  <option value="50">50 miles</option>
                  <option value="100">100 miles</option>
                </select>&nbsp;
                <input type="button" onclick="searchLocations()" value="Search"/>
            </div>

            <br />

            <div style="clear:both; margin-left: 5px;">
                <div id="sidebar" style="overflow: auto; height: 400px; width:150px; font-size: 11px; color: #000; 
                     float:left; margin-left:5px; padding-left:5px;">Search Results:</div>
                <div style="float:left; margin-left: 5px;">
                    <div id="GoogleMap_Div_Container">
                        <div id="map" style="width:750px;height:400px;"></div>
                    </div>
                    <!-- Google Map API Key -->
                    <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=YabbaDabbaDoo" type="text/javascript"></script>

                </div>

            </div>

            <br style="clear:both;" />

        </div>   

    </form>
</body>
</html>
