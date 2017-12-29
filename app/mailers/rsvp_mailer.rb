class RsvpMailer < ApplicationMailer

    default from: 'bongskyweds@gmail.com'

	def rsvp_email(name, email, attending, guests)
		@name      = name
		@email     = email
		@attending = attending
		@guests    = guests
		if(@attending)
			@subjectString = 'RSVP: ' + name + ' is attending!'
		else
		    @subjectString = 'RSVP: ' + name + ' is not attending.'
		end

		mail(to: 'bongskyweds@gmail.com', subject: @subjectString)
	end
	
end
