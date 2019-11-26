class UserNotifierMailer < ApplicationMailer
	add_template_helper(EmailTemplateHelper)

	default from: 'info@vortrics.com'

	def send_info_email(user)
		@user = user
		mail(to: 'vortrics@gmail.com',
		     subject: "Add #{user.email} to the newsletter")
	end
end
