class UploadMailer < ApplicationMailer

    default from: 'bongskyweds@gmail.com'

	def upload_email(id, publicStatus, ip, count)
		@id            = id.to_s
		@publicStatus  = publicStatus.to_s
		@ip            = ip.to_s
		@count         = count.to_s

		@subjectString = 'Upload#' + @id + ': ' + @ip + ' has uploaded ' + @count + ' photos!'

		mail(to: 'bongskyweds@gmail.com', subject: @subjectString)
	end

	def error_email(ip)
		@ip            = ip

		@subjectString = 'Upload Error: ' + @ip + ' forgot to upload any photos...'
		
		mail(to: 'bongskyweds@gmail.com', subject: @subjectString)
	end
end
