<%@ Page Language="VB" AutoEventWireup="false" CodeFile="MapExample.aspx.vb" Inherits="MapExample" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Map Example</title>
    <meta http-equiv="X-UA-Compatible" content="IE=8;FF=3;OtherUA=4" />  <!-- Had to use this cludge fix for IE9 -->
    <!-- Google Map API Key -->
    <script src="http://maps.google.com/maps/api/js?v=3&sensor=false&key=AIzaSyDp9Ckzk9cEtdFSNEsUOH8DEqZEzWi7Dko" type="text/javascript"></script>
    <!-- Link to utility functions -->
    <script src="util.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">

    // Google Map API Javascript

    var map;
    var mapOptions;
    var geocoder;
    var infoWindow;
    
    var http_request = false;
    var lat = 0;
    var lng = 0;
    var startingLat = 54.1509;  // view of england
    var startingLng = -4.4855;  // view of england
    var startingZoom = 5;
    var maximumZoom = 15;


    function mapLoad() {
        // To Do:  Check if user's browser is compatible with Google Maps API v3
        //if (GBrowserIsCompatible()) {

        geocoder = new google.maps.Geocoder();
        infoWindow = new google.maps.InfoWindow();

        mapOptions = {
            center: new google.maps.LatLng(startingLat, startingLng),
            zoom: startingZoom,
            mapTypeId: google.maps.MapTypeId.ROADMAP  // Change this to satellite for something cool, or hybrid, etc
        };

        map = new google.maps.Map(document.getElementById('map'), mapOptions);
              

    }


    function searchLocations() {

        var address = document.getElementById('txtSearchAddress').value;
        var country = document.getElementById('txtSearchCountry').value;
        var searchString = address + ', ' + country;

        geocoder.geocode({address: searchString }, function (results, status) {
              if (status == google.maps.GeocoderStatus.OK) {
                  searchLocationsNear(results[0].geometry.location);
              }
              else
                  alert(searchString + ' - not found');

          });

    }

    function searchLocationsNear(center) {
        var radius = document.getElementById('ddlRadius').value;
        var searchUrl = 'SearchResponse.aspx?lat=' + center.lat() + '&lng=' + center.lng() + '&radius=' + radius;


        downloadUrl(searchUrl, function (data) {

       
            //clear side bar entries
            var sbar = document.getElementById('sidebar');
            sbar.innerHTML = '';

            if (data.documentElement == null) {
                sbar.innerHTML = 'No results found.  Please try widening your search area.';
                map = new google.maps.Map(document.getElementById('map'), mapOptions);
                return;
            }

            var locations = data.documentElement.getElementsByTagName('marker');

            if (locations.length == 0) {
                sbar.innerHTML = 'No results found.  Please try widening your search area.';
                map = new google.maps.Map(document.getElementById('map'), mapOptions);
                return;
            }


            var bounds = new google.maps.LatLngBounds();

            for (var i = 0; i < locations.length; i++) {

                var address1 = locations[i].getAttribute('Address1');
                var address2 = locations[i].getAttribute('Address2');
                var town = locations[i].getAttribute('Town');
                var postcode = locations[i].getAttribute('Postcode');
                var distance = parseFloat(locations[i].getAttribute('distance'));

                var point = new google.maps.LatLng(parseFloat(locations[i].getAttribute('Latitude')), parseFloat(locations[i].getAttribute('Longitude')));
                bounds.extend(point);
                
                var marker = createMarker(point, address1, address2, town, postcode);
                var sidebarEntry = createSidebarEntry(marker, address1, address2, town, distance);
                sbar.appendChild(sidebarEntry);


            }

            var pointCenter = bounds.getCenter();
            var iZoomLevel = map.fitBounds(bounds);
            if (iZoomLevel > maximumZoom) { iZoomLevel = maximumZoom; }
            map.setCenter(pointCenter, iZoomLevel);


        });

        
    }

    // Create the marker with address information
    function createMarker(point, address1, address2, town, postcode) {

        var marker = new google.maps.Marker({
            map: map,
            position: point,
            title: address1,
            animation: google.maps.Animation.DROP
        });

        var html;
        if (address2 == null) {
            html = '<br/>' + address1 + '<br/>' + town + '<br/>' + postcode;
        }
        else {
            html = '<br/>' + address1 + ', ' + address2 + '<br/>' + town + '<br/>' + postcode;
        }

        google.maps.event.addListener(marker, "click", function () {
            infoWindow.setContent(html);
            infoWindow.open(map, marker);
        });


        return marker;
     }

    // Create the side bar entry as a menu item
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
        google.maps.event.addDomListener(div, "click", function() {
            google.maps.event.trigger(marker, "click");
        });
        google.maps.event.addDomListener(div, "mouseover", function() {
            div.style.backgroundColor = '#eee';
        });
        google.maps.event.addDomListener(div, "mouseout", function () {
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
                <div id="sidebar" style="overflow: auto; height: 400px; width:150px; font-size: 11px; color: #000; float:left; margin-left:5px; padding-left:5px;">Search Results:</div>
                <div style="float:left; margin-left: 5px;">
                    <div id="GoogleMap_Div_Container">
                        <div id="map" style="width:750px;height:400px;"></div>
                    </div>
               </div>
            </div>

            <br style="clear:both;" />

        </div>   
    </form>
</body>
</html>
