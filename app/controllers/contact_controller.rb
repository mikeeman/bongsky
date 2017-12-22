class ContactController < ApplicationController
  def send(variable)
  	if(params.has_key?(:email) && params.has_key?(:contents))
  	  @email = params[:email]
  	  @contents = params[:contents]

  	  ContactmailerMailer.contact_email(@email, @contents).deliver
      redirect_to '/pages/contact/#sent', :flash => { :notice => "Message received! We will get back to you shortly!" }
    end
  end
end

