// Bing Map API Javascript, tightly coupled with MapExample.aspx
var credentials = "YabbaDabbaDoo";  // Change this to your Bing API Key
var map;
var mapOptions;
var sbar;
var startingLat = -25;  // view of Australia
var startingLng = 136;  // view of Australia
var startingZoom = 4;


// Function to intialise map and side bar
function GetMap() {
    mapOptions = {
        credentials: credentials,
        mapTypeId: Microsoft.Maps.MapTypeId.road, // try using Microsoft.Maps.MapTypeId.aerial for some cool imagery
        zoom: startingZoom,
        center: new Microsoft.Maps.Location(startingLat, startingLng)
    };
    map = new Microsoft.Maps.Map(document.getElementById('map'), mapOptions);
    sbar = document.getElementById('sidebar');
}



// Function used when search button is clicked
function searchLocations() {

    var address = document.getElementById('txtSearchAddress').value;
    var country = document.getElementById('txtSearchCountry').value;
    var searchString = address + ', ' + country;


    // Make REST call to get geocoded information (that is, the coordinates for the address)
    // This will use your call back procedure and return result in JSON format
    var geocodeRequest = "http://dev.virtualearth.net/REST/v1/Locations?query=" + encodeURI(searchString) + "&output=json&jsonp=searchLocationsCallBack&key=" + credentials;
    CallRestService(geocodeRequest);

}


// Function that clears the map with a message in the sidebar
function clearMap(msg) {
    sbar.innerHTML = msg;
    map = new Microsoft.Maps.Map(document.getElementById('map'), mapOptions);
}


// Callback function from geocoding request
function searchLocationsCallBack(result) {
    // Check result was returned by gecode request
    if (result &&
                   result.resourceSets &&
                   result.resourceSets.length > 0 &&
                   result.resourceSets[0].resources &&
                   result.resourceSets[0].resources.length > 0) {
        searchLocationsNear(result);
    }
    else {
        alert('Address not found');
        clearMap('No results found.  Please try a different address.');
    }
}

// Grunt work function that finds the nearby locations
function searchLocationsNear(result) {
    var lat = result.resourceSets[0].resources[0].point.coordinates[0];
    var lng = result.resourceSets[0].resources[0].point.coordinates[1];
    var radius = document.getElementById('ddlRadius').value;
    var searchUrl = 'SearchResponse.aspx?lat=' + lat + '&lng=' + lng + '&radius=' + radius;

    downloadUrl(searchUrl, function (data) {
        var locationDB;
        var locationAry = [];
        var startRectangle;
        var viewBoundaries;

        //clear side bar entries
        sbar.innerHTML = '';
        if (data.documentElement == null) {
            clearMap('No results found.  Please try widening your search area.');
            return;
        }

        // fetch locations from xml returned by database
        locationDB = data.documentElement.getElementsByTagName('marker');
        if (locationDB.length == 0) {
            clearMap('No results found.  Please try widening your search area.');
            return;
        }

        // loop through found locations in the database
        for (var i = 0; i < locationDB.length; i++) {
            var address1 = locationDB[i].getAttribute('Address1');
            var address2 = locationDB[i].getAttribute('Address2');
            var town = locationDB[i].getAttribute('Town');
            var postcode = locationDB[i].getAttribute('Postcode');
            var distance = parseFloat(locationDB[i].getAttribute('DistanceKm'));
            var location = new Microsoft.Maps.Location(parseFloat(locationDB[i].getAttribute('Latitude')), parseFloat(locationDB[i].getAttribute('Longitude')));

            // push location to array for later use for map viewing
            locationAry.push(location);

            // Create pins on the map and the side bar entries
            createPushPin(location, address1, address2, town, postcode);
            createSidebarEntry(i, address1, address2, town, distance);
        }

        // Let microsoft figure out the viewing boundary to contain all the found locations
        viewBoundaries = Microsoft.Maps.LocationRect.fromLocations(locationAry);
        map.setView({ bounds: viewBoundaries });

    });


}

// Create the pushpin with address information
function createPushPin(location, address1, address2, town, postcode) {
    var content;
    if (address2 == null) {
        content = address1 + '<br/>' + town + '<br/>' + postcode;
    }
    else {
        content = address1 + ', ' + address2 + '<br/>' + town + '<br/>' + postcode;
    }

    var pin = new Microsoft.Maps.Pushpin(location);
    var pinInfoBox = new Microsoft.Maps.Infobox(location, { title: address1, visible: false, showPointer: true, offset: new Microsoft.Maps.Point(0, 20), description: content });

    // Add event handler so that clicking the pin displays information about the location
    Microsoft.Maps.Events.addHandler(pin, "click", function () {
        pinInfoBox.setOptions({ visible: true });
    });

    // Add pins and information boxes to the map entities
    // It is important to note that both pins and infoboxes are stored in the same collection.  Thus, pins and infoboxes alternate in the collection.
    map.entities.push(pin);
    map.entities.push(pinInfoBox);
}


// Create the side bar entry as a menu item
function createSidebarEntry(index, address1, address2, town, distance) {
    var div = document.createElement('div');

    var address;
    if (address2 == '' || address2 == null) {
        address = address1 + '<br/>' + town;
    }
    else {
        address = address1 + '<br/>' + address2 + '<br/>' + town;
    }

    var html = '<b>' + distance.toFixed(2) + ' kms: </b><br/>' + address;
    div.innerHTML = html;
    div.style.cursor = 'pointer';
    div.style.marginBottom = '5px';

    // Add event listeners to sidebar entries
    // Note, pins are every second item in the entities collection, so multiple index by 2 for each pin
    div.addEventListener("click", function () { var i = index * 2; var pin = map.entities.get(i); Microsoft.Maps.Events.invoke(pin, 'click', ''); }, false);
    // Pretty colour events
    div.addEventListener("mouseover", function () { div.style.backgroundColor = '#eee'; }, false);
    div.addEventListener("mouseout", function () { div.style.backgroundColor = '#fff'; }, false);
    sbar.appendChild(div);
}