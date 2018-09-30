class PagesController < ActionController::Base
    include HighVoltage::StaticPage

    def show
    	@thumbnail_url_list = []

    	uploads = Upload.
    	               where(public: true).
    	               where.not(thumbnails: [nil, ""]).
    	               order("created_at DESC")
    	
    	uploads.each do |upload|
    		upload.thumbnails.each do |thumbnail|
                @thumbnail_url_list.push( thumbnail.url )
            end
    	end

        render 'uploads'
    end

end