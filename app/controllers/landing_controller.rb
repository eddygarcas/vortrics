class LandingController < ApplicationController
	layout 'landing'
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
			format.html { redirect_to landing_info_path, notice: 'for showing interest on our product, will only contact you to notify new functionality or critical updates.' }
		end
	end

	private

	def set_request
		params.require(:user).permit(:email)
	end
end
