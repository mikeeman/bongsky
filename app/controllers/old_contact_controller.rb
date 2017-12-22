class ContactController < ApplicationController

    def send_contact_mail
    	@paramters = Model.get_parameters
    	Contactmailer.contact_email().deliver
    end

end
