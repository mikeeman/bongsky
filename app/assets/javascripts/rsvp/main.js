jQuery(document).ready(function($){
	$('#guest-name').hide();
    $('#guest-label').hide();

	if( $('.floating-labels').length > 0 ) floatLabels();

    $('#guest-checkbox').change(function(){
            selected_value = $("input[name='guest-checkbox']:checked").val();
            console.log(selected_value);
            if (selected_value) {
            	$('#guest-name').show();
            	$('#guest-label').show();
            }
            else {
            	$('#guest-name').hide();
            	$('#guest-label').hide();
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

});