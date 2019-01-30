class UsersController < ApplicationController
	layout 'sidenav'
	before_action :team_session, :user_session
	before_action :admin_user?

	def index
		@users = User.all - [@current_user]
	end

	def manage_users
		@users = User.all - [@current_user]
		advice_agent
	end

	def group_assigment
		@user = User.find(user_params[:id])
		priority = user_params[:admin] ? 1 : 99
		Access.where(user_id: @user).update_or_create(group_id: Group.find_by_priority(priority.to_i).id)
		render json: { success: :true }
	end

	def destroy
		@user = User.find(params[:id])
		message = "User #{@user.displayName} has been deleted."
		@user.destroy
		if @user.destroy
			redirect_to devise_manage_users_url, notice: message.humanize
		end
	end

	def user_params
		params.permit(:id, :admin, :user)
	end

end
