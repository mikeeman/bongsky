function createSidebarLi(json){
  return ("<li><a>" + json.name + "</a></li>");
};

function bindLiToMarker($li, marker){
  $li.on('click', function(){
    handler.getMap().setZoom(14);
    marker.setMap(handler.getMap()); //because clusterer removes map property from marker
    marker.panTo();
    google.maps.event.trigger(marker.getServiceObject(), 'click');
  })
};

function createSidebar(json_array){
  _.each(json_array, function(json){
    //var $li = $( createSidebarLi(json) );
    $li = $(churchicon);
    //$li.appendTo('#sidebar_container');
    bindLiToMarker($li, json.marker);
  });
};

handler = Gmaps.build('Google');
handler.buildMap({ internal: {id: 'sidebar_builder'}}, function(){
  var json_array = [
    { lat: 44.0436621, lng: -79.0161336, name: 'Reception', infowindow: "<p class=\"map-icon-link-p\"><u><a href=\"https://www.google.ca/maps/place/12051+Ashburn+Rd,+Port+Perry,+ON+L9L+1Z9/@44.0434385,-79.0188748,17z/data=!3m1!4b1!4m5!3m4!1s0x89d517df26dc4e3b:0x3b9b0f34b1fc2da8!8m2!3d44.0434347!4d-79.0166861\" target=\"_blank\">12051 Ashburn Road, Ashburn, ON</a></u></p><p class=\"map-icon-p\">The reception will take place at The Matkiwsky Farm, 12051 Ashburn Road, Ashburn, ON</p>"},
    { lat: 43.8827943, lng: -78.8546298, name: 'Ceremony', infowindow: "<p class=\"map-icon-link-p\"><u><a href=\"https://www.google.ca/maps/place/Ukrainian+Catholic+Church+of+Saint+George/@43.8824525,-78.8565288,17z/data=!3m1!4b1!4m5!3m4!1s0x89d51d24b2963ce7:0xd0dabbe301bcf8e!8m2!3d43.8824525!4d-78.8543401\" target=\"_blank\">St. George's Ukrainian Catholic Church</a></u></p><p class=\"map-icon-p\">The ceremony will take place at St. George's Ukrainian Catholic Church</p>"},
    { lat: 43.8685806, lng: -78.9312327, name: 'Accomodation', infowindow: "<p class=\"map-icon-link-p\"><u><a href=\"https://www.google.ca/maps/place/Holiday+Inn+Express+Whitby+Oshawa/@43.8839439,-78.9333059,13z/data=!4m8!1m2!2m1!1sholiday+inn+express+oshawa!3m4!1s0x89d51e0702f65bcb:0x6eabf09ce54be19!8m2!3d43.8683646!4d-78.932504\" target=\"_blank\">Holiday Inn Express</a></u></p><p class=\"map-icon-p\">A group rate is available at The Holiday Inn Express, Whitby using code \"bongsky\"</p>"}
  ];

  var markers = handler.addMarkers(json_array);

  _.each(json_array, function(json, index){
    json.marker = markers[index];
  });

  //createSidebar(json_array);

  $church = $(churchicon);
  $reception = $(foodicon);
  $accomodation = $(bedicon);
  $churchtext = $(churchtext);
  $receptiontext = $(receptiontext);
  $accomodationtext = $(accomodationstext);

  bindLiToMarker($church, markers[1]);
  bindLiToMarker($churchtext, markers[1]);
  bindLiToMarker($reception, markers[0]);
  bindLiToMarker($receptiontext, markers[0]);
  bindLiToMarker($accomodation, markers[2]);
  bindLiToMarker($accomodationtext, markers[2]);
  

  handler.bounds.extendWith(markers);
  handler.fitMapToBounds();
  handler.getMap().setZoom(9);
});