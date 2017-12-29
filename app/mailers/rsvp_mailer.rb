class RsvpMailer < ApplicationMailer

    default from: 'bongskyweds@gmail.com'

	def rsvp_email(name = 'not provided', email = 'not provided', attending = -1, guests = '', error = '')
		@name      = name
		@email     = email
		@attending = attending
		@guests    = guests
		@error     = error
		if(@attending == true)
			@subjectString = 'RSVP: ' + name + ' is attending!'
		elsif(@attending == false)
		    @subjectString = 'RSVP: ' + name + ' is not attending.'
		else
			@subjectString = 'RSVP: ' + name + ' had trouble filling out the form...'
		end

		mail(to: 'bongskyweds@gmail.com', subject: @subjectString)
	end
	
end
