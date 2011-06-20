function Map (query) {
  this.query = query;
  this.map = null;
  this.current_info = null;
  this.render = function () {
	var self = this;
    /* Geocode our internally stored zipcode so we can center our map when we reset it */
    $.get("/api/geocode", { query: encodeURI(this.query) }, function(data) {
      if(data.results.length > 0) {  
        var mapOptions = {
          zoom: 12,
          center: new google.maps.LatLng(data.results[0].geometry.location.lat, data.results[0].geometry.location.lng),
          mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        /* Reset the map with no markers, centered at the internally stored zipcode */
        map = new google.maps.Map(document.getElementById("content-map"), mapOptions);
      
        /* Now, get our data */
        $.get("/api/locate", { query: query, radius: 5 }, function(data) {
          if(data.results.length > 0) {
          
            /* Add column titles */
            $("#table_columns").html("<td class='listing-header'></td><td class='listing-header'>Address</td><td class='listing-header'>Contact</td>");
          
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
				if(self.current_info) self.current_info.close(); 
				self.current_info = infoWindow;
              });
            });
          } else {
            $("#small-logo").after("<span id='message'>Sorry, we couldn't find any results for your location.</span>");
          }
        }); 
      } else {
        $("#small-logo").after("<span id='message'>Sorry, we couldn't find any results for your location.</span>");
      } 
    });
  };
};

$("input#query").click(function() {
  $("input#query").val("");
});

$("form").submit(function(e) {
  e.preventDefault();
  
  /* Clear the table */
  $("#content-listing-table tr.listing").remove();
  $("#content-listing-table tr.table-columns").remove();
  $("#message").remove();
  new Map($("input#query").val()).render();
});

$(function() {
  var query = geoip_postal_code();
  if(query == null || query == "") {
    query = geoip_city() + " " + geoip_region();
  }
  new Map(query).render();
});
