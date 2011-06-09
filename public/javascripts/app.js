function Map (zipcode) {
  this.zipcode = zipcode;
  this.map = null;

  this.render = function () {
    /* Clear the table */
    $("#content-listing-table tr.listing").remove();
    
    /* Geocode our internally stored zipcode so we can center our map when we reset it */
    $.get("/api/geocode", { query: zipcode }, function(data) {
      var mapOptions = {
        zoom: 11,
        center: new google.maps.LatLng(data.results[0].geometry.location.lat, data.results[0].geometry.location.lng),
        mapTypeId: google.maps.MapTypeId.ROADMAP
      };
      /* Reset the map with no markers, centered at the internally stored zipcode */
      map = new google.maps.Map(document.getElementById("content-map"), mapOptions);
      
      /* Now, get our data */
      $.get("/api/locate", { query: zipcode, radius: 5 }, function(data) {
        $.each(data.results, function(index, result) {
          /* Format the address */
          var address = result.loc_street_address + ", ";
          var cityStateZip = result.loc_city + ", " + result.loc_state + " " + result.loc_zip;

          /* Add the listing to the table */
          $("#content-listing-table tr:last").after('<tr class="listing" valign="top"><td class="listing-num"><div class="listing-number">' + (index+1) + '</div></td><td class="listing-address"><span class="address-firstline">' + address.toUpperCase() + '</span>' + cityStateZip.toUpperCase() + '</td><td class="listing-address">' + result.phone + '</td></tr>');

          /* Set up the map marker */
          var marker = new google.maps.Marker({
            position: new google.maps.LatLng(result.loc_lat, result.loc_lng),
            map: map,
            title: "McDonald's " + result.natid
          });

          /* Set up the map marker popup content */
          var infoWindow = new google.maps.InfoWindow({
            content: "<div><h3>McDonald's</h3><p>" + result.loc_street_address + "<br />" + cityStateZip + "<br />" + result.phone + "</p></div>"
          });

          /* Set up event handler for the map marker */
          google.maps.event.addListener(marker, 'click', function() {
            infoWindow.open(map, marker);
          });
        });
      });
      
    });
    
  };

};

$("input#query").click(function() {
  $("input#query").val("");
});

$("form").submit(function(e) {
  e.preventDefault();
  var query = $("input#query").val();
  /* Check if we have a zipcode or not */
  if(query.search(/^\d{5}$/) == -1) {
    /* TODO: Geolocate into a zipcode */
    console.log("Not yet implemented.");
  } else {
    new Map(query).render();
  }
});

$(function() {
  var zipcode = geoip_postal_code();
  if(zipcode == null) {
    zipcode = 90015;
  }
  new Map(zipcode).render();
});
