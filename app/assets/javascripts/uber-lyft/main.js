jQuery(document).ready(function($){

    UBER_PICKUP_EXISTS = false;
    UBER_DESTINATION_EXISTS = false;

	if( $('.floating-labels').length > 0 ) floatLabels();

	$("#uberPickup").change(function () {
		console.log($('#uberPickup').val());
        if(($('#uberPickup').val() == 4) && UBER_PICKUP_EXISTS === false) {
        	add_uber_pickup();
            floatLabels();
            UBER_PICKUP_EXISTS = true;
        } else if (($('#uberPickup').val() != 4) && UBER_PICKUP_EXISTS === true) {
        	remove_uber_pickup();
        	UBER_PICKUP_EXISTS = false;
        }
    });

    $("#uberDestination").change(function () {
        console.log($('#uberDestination').val());
        if(($('#uberDestination').val() == 4) && UBER_DESTINATION_EXISTS === false) {
        	add_uber_destination();
            floatLabels();
            UBER_DESTINATION_EXISTS = true;
        } else if (($('#uberDestination').val() != 4) && UBER_DESTINATION_EXISTS === true) {
        	remove_uber_destination();
        	UBER_DESTINATION_EXISTS = false;
        }
    });

	function floatLabels() {
		var inputFields = $('.floating-labels .cd-label').next();
		inputFields.each(function(){
			var singleInput = $(this);
			//check if user is filling one of the form fields 
			checkVal(singleInput);
			singleInput.on('change keyup', function(){
				checkVal(singleInput);
			});
		});
	}

	function checkVal(inputField) {
		( inputField.val() == '' ) ? inputField.prev('.cd-label').removeClass('float') : inputField.prev('.cd-label').addClass('float');
	}

	function add_uber_pickup() {
	    $("#uber-pickup-other").append("<div class='icon'><label class='cd-label' for='uber-pickup' id='uber-pickup-label'>Pickup Address</label> <input class='user' type='text' name='uberPickupOther' id='uber-pickup-input' placeholder=''></div>");
	    $("#uber-pickup-input").geocomplete();
    }

    function add_uber_destination() {
	    $("#uber-destination-other").append("<div class='icon'><label class='cd-label' for='uber-destination-input' id='uber-destination-label'>Destination Address</label> <input class='user' type='text' name='uberDestinationOther' id='uber-destination-input' placeholder=''></div>");
        $("#uber-destination-input").geocomplete();
    }

    function remove_uber_pickup() {
        console.log("remove_uber_pickup()");
        $("#uber-pickup-other").empty();
    }

    function remove_uber_destination() {
        console.log("remove_uber_destination()");
        $("#uber-destination-other").empty();
    }

});