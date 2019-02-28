class UserNotifierMailer < ApplicationMailer
	add_template_helper(EmailTemplateHelper)

	default from: 'info@vortrics.com'

	def send_info_email(user)
		@user = user
		mail(to: 'edugarcas@gmail.com',
		     subject: "Grant access to #{user.email}")
	end
end
