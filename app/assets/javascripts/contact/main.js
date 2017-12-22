jQuery(document).ready(function($){
	if( $('.floating-labels').length > 0 ) floatLabels();

	function floatLabels() {
		var inputFields = $('.floating-labels .cd-label').next();
		inputFields.each(function(){
			var singleInput = $(this);
			//check if user is filling one of the form fields 
			checkVal(singleInput);
			singleInput.on('change keyup', function(){
				checkVal(singleInput);
				if( validateEmail($('#cd-email'))) {
		            $('.error-message').hide();
		            $('#cd-email').css("cssText", "border-color: #cfd9db !important;");
	            }
	            else {
		            $('.error-message').show();
		            $('#cd-email').css("cssText", "border-color: #e94b35 !important;");
	            }
			});
		});
	}

	function checkVal(inputField) {
		( inputField.val() == '' ) ? inputField.prev('.cd-label').removeClass('float') : inputField.prev('.cd-label').addClass('float');
	}

	function validateEmail(inputText) {  
        var mailformat = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i;
        if (mailformat.test(inputText.val())) {
            return true;  
        }
        else {  
            return false;  
        }  
    }
});