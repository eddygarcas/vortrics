class ApplicationMailer < ActionMailer::Base
  layout 'mailer'

  #default from: 'info@voardtrix.com'

  def send_info_email(user)
    @user = user
    mail(:to => 'edugarcas@gmail.com',
         :subject => "Info to #{user.email}")
  end
end
