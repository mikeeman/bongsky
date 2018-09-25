class PagesController < ActionController::Base
    include HighVoltage::StaticPage

    def show
    	print "-=-=-=-=-=-=-=-=-=-=-=-=-= ENTERING SHOW"
    	@uploads = Upload.
    	               where(public: true).
    	               where.not(photos: [nil, ""]).
    	               order("created_at DESC")
        print @uploads.count
        print "EXITING SHOW-=-=-=-=-=-=-=-=-=-=-=-=-="
        render 'uploads'
    end

end