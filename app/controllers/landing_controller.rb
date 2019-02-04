class LandingController < ApplicationController
	layout 'home'
	before_action :set_request, only: [:register]
	def info
		@user = User.new
	end

	def register
		logger.info "Sending a register email #{params[:user][:email]}"
		@user = User.new
		@user.email = params[:user][:email]
		UserNotifierMailer.send_info_email(@user).deliver
		respond_to do |format|
			format.html { redirect_to landing_info_path, notice: 'Our team will contact you shortly to know your needs and see how we can support your organization on its Agile Tranformation.' }
		end
	end

	def set_request
		params.require(:user).permit(:email)
	end
end
