class ContactmailerMailer < ApplicationMailer
	default from: 'bongskyweds@gmail.com'

	def contact_email(email, contents)
		@email    = email
		#@url      = 'http://www.gmail.com'
		@contents = contents
		mail(to: 'bongskyweds@gmail.com', subject: 'New Contact Message!')
	end

end
