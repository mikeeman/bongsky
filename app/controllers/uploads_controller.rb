class UploadsController < ApplicationController
    def send(variable)
      
        @images = ""

	    if(params.has_key?(:public))
	        allowPublic = true
	    else
	        allowPublic = false
	    end

	    if(params.has_key?(:images) && !params[:images].blank?)
	        hasImages = true
	    else
	        hasImages = false
	    end

	    if(hasImages)
	        if (allowPublic)
	  	        redirect_to '/pages/uploads/#sent', :flash => { :notice => "Thanks for the pics, feel free to upload some more!" } and return
	  	    else
	  	  	    redirect_to '/pages/uploads/#sent', :flash => { :notice => "Thanks a lot!  If you change your mind, upload them again!" } and return
	        end
	    else
	      	redirect_to '/pages/uploads/#error', :flash => { :notice => "No valid images uploaded, try again." } and return
	    end

  end
end
