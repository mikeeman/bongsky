require "google_drive"

class UploadsController < ActionController::Base

    def upload_to_drive(fullpath, file, folder_name)
        folder = @session.collection_by_title(folder_name)
        folder.add(@session.upload_from_file(fullpath, file, convert: false))
        
        remoteFile = @session.file_by_title(file)
        remoteFile.acl.push({type: "user", email_address: "bongskyweds@gmail.com", role: "writer"}, {send_notification_email: true})
        remoteFile.acl.push({type: "user", email_address: "mikee.man@gmail.com", role: "writer"}, {send_notification_email: false})
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
	    	u.thumbnails = params[:photos]
            u.save!

            UploadMailer.upload_email(u.id, u.public, u.ip, u.photos.size).deliver
            
            Rails.logger.info "About to enter thread"

            Thread.new do
            	Rails.logger.info "Entered thread"
                @session = GoogleDrive::Session.from_service_account_key(ENV['GOOGLE_DRIVE_SERVICE_ACCOUNT'])
                Rails.logger.info "Created session"
                lastUpload = Upload.last
                Rails.logger.info "Found last upload: #{lastUpload.id}"
	            lastUpload.photos.each do |photo|
	        	    upload_to_drive(photo.path, File.basename(photo.url), ENV['BONGSKY_UPLOADS_FOLDER_NAME'])
                end
                Rails.logger.info "Finished uploading"
            end

	        if (allowPublic)
	  	        redirect_to '/pages/uploads/#sent', :flash => { :notice => "Thanks for the pics, feel free to upload some more!" } and return
	  	    else
	  	  	    redirect_to '/pages/uploads/#sent', :flash => { :notice => "Thanks a lot!  If you change your mind, upload them again!" } and return
	        end
	    else
	      	Thread.new do
	      	    UploadMailer.error_email(request.remote_ip).deliver
	      	end
	      	redirect_to '/pages/uploads/#error', :flash => { :notice => "No valid images uploaded, try again." } and return
	    end

  end
end
