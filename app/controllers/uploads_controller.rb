require "google_drive"

class UploadsController < ActionController::Base

    def upload_to_drive(fullpath, file, folder_code)
        #folder = @session.collection_by_title(folder_code) #currently nil
        folder = @session.collection_by_title("bongskywedsuploads")
        #path = Rails.root.join('public', "#{url}")
        #path = Rails.root.join('public', url).to_s
        print "*****-=-=-=-=-=-=-=-=-=-=-="
        print "file: "
        print file
        print ", folder_code: "
        print folder_code
        print ", fullpath: "
	    print fullpath
	    print ", folder: "
	    print folder
	    print "-=-=-=-=-=-=-=-=-=-=-=*****"
	    #currently invalid path, works if use full escaped string
        folder.add(@session.upload_from_file(fullpath, file, convert: false))
        #@session.upload_from_file(fullpath, file, convert: false)
        #cannot add to folder because folder is nil
        
        #remoteFile = @session.file_by_title(file)
        #remoteFile.acl.push({type: "user", email_address: "bongskyweds@gmail.com", role: "writer"}, {send_notification_email: true})
        
        # sends email and shares at root folder (not shared folder)
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
	    	u = Upload.new
	    	u.public = allowPublic
	    	u.ip = request.remote_ip
	    	u.photos = params[:photos]
            u.save!

            Thread.new do

                @session = GoogleDrive::Session.from_service_account_key(ENV['GOOGLE_DRIVE_SERVICE_ACCOUNT'])

                lastUpload = Upload.last

	            lastUpload.photos.each do |photo|
	        	    print "-=-=-=-=-=-=-=-=-=-=-="
	        	    print lastUpload.id
	                print "-=-=-=-=-=-=-=-=-=-=-="
	                print photo.path
	                print "-=-=-=-=-=-=-=-=-=-=-="

	        	    upload_to_drive(photo.path, File.basename(photo.url), ENV['BONGSKY_UPLOADS_FOLDER_CODE'])
	        	    #session.upload_from_file(photo.url, photo.identifier, convert: false)
                end
                
            end

			


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
