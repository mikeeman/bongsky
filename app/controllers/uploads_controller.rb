require "google_drive"

class UploadsController < ApplicationController
    
    def upload_to_drive(id, file, folder_code)
        folder = @session.collection_by_title("#{folder_code}")
        path = Rails.root.join('public', 'uploads', "#{id}", "#{file}")
        print "-=-=-=-=-=-=-=-=-=-=-="
	    print path
	    print file
	    print folder_code
	    print folder
	    print folder
	    print "-=-=-=-=-=-=-=-=-=-=-="
        #folder.add(@session.upload_from_file(path, file, convert: false)) 
    end

    def send(variable)
      
        params.permit(:public, :title, :body, :image, :remove_image, :image_cache, :remote_image_url, photos: [])

	    if(params.has_key?(:public))
	        allowPublic = true
	    else
	        allowPublic = false
	    end

	    if(params.has_key?(:photos) && !params[:photos].blank?)
	        hasImages = true
	    else
	        hasImages = false
	    end

	    if(hasImages)
	    	#u = Upload.new(photos: Hash[params[:photos].map.with_index.to_a])
	    	
	    	#params[:photos].key_value do |key, value|
            #    u = Upload.new
            #    u.public = allowPublic
            #    u.ip = request.remote_ip
                
            #    print "=============="
            #    print key
            #    print value
            #    print u.public
                #u.photos = "{" + photo + "}"
            #    print u.photos
            #    print u.ip
            #    print "=============="
            #    u.save!
            #end	    	


	    	u = Upload.new
	    	u.public = allowPublic
	    	u.ip = request.remote_ip

	        print "======================"
	        print u
	    	print u.public
	    	print u.photos
	        print params[:photos]
	        #print params[:photos].map
	        #print params[:photos].map.with_index
	    	print u.ip

	        u.photos = params[:photos]

	        print u.photos
	        print "======================"

            @session = GoogleDrive::Session.from_service_account_key(ENV['GOOGLE_DRIVE_SERVICE_ACCOUNT'])

	        u.photos.each do |photo|
	        	print "-=-=-=-=-=-=-=-=-=-=-="
	        	print u.id
	            print "-=-=-=-=-=-=-=-=-=-=-="
	            print photo.identifier
	            print "-=-=-=-=-=-=-=-=-=-=-="

	        	upload_to_drive(u.id, photo.identifier, ENV['BONGSKY_UPLOADS_FOLDER_CODE'])
	        	#session.upload_from_file(photo.url, photo.identifier, convert: false)
            end


            u.save!

			


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
