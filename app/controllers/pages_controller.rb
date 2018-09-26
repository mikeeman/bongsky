class PagesController < ActionController::Base
    include HighVoltage::StaticPage

    def show
    	@photo_url_list = []

    	uploads = Upload.
    	               where(public: true).
    	               where.not(photos: [nil, ""]).
    	               order("created_at DESC")
    	
    	uploads.each do |upload|
    		upload.photos.each do |photo|
                @photo_url_list.push( photo.url )
            end
    	end

        render 'uploads'
    end

end