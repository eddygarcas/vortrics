class UsersController < ApplicationController
	layout 'sidenav'
	before_action :team_session, :user_session
	before_action :admin_user?

	def index
		@users = User.all - [@current_user]
	end

	def manage_users
		@users = User.all - [@current_user]
		@user = User.new
	end

	def new
		@user = User.new
	end

	def show
	end

	def setting_assigment
		@user = User.find(user_params[:user_id])

		if @user.save_dependent user_params[:setting_id]
			render json: { success: :true, message: @user.id }
		else
			render json: { success: :false, message: @user.id }
		end
	end

	def group_assigment
		@user = User.find(user_params[:id])
		if @user.save_dependent nil, user_params[:admin]
			render json: { success: :true, message: @user.id }
		else
			render json: { success: :false, message: @user.id }
		end
	end

	# POST /teams
	# POST /teams.json
	def create
		@user = User.new(user_new_params)
		respond_to do |format|
			if @user.save_dependent params[:setting_id], user_params[:admin]
				format.html { redirect_to users_manage_users_url, notice: 'User was successfully created.' }
				format.json { render :show, status: :created, location: @user }
			else
				format.html { redirect_to users_manage_users_url, warn: 'An error prevented user creation.' }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end

	end

	def destroy
		@user = User.find(params[:id])
		message = "User #{@user.displayName} has been deleted."
		@user.destroy
		if @user.destroy
			redirect_to devise_manage_users_url, notice: message.humanize
		end
	end

	private
	# Never trust parameters from the scary internet, only allow the white list through.
	def user_new_params
		params.require(:user).permit(:email, :displayName, :oauth, :extuser, :password, :setting_id)
	end

	def user_params
		params.permit(:id, :admin, :user, :setting_id, :user_id)
	end

end
