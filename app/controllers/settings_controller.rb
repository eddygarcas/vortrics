class SettingsController < ApplicationController
	layout 'sidenav'

	before_action :set_setting, only: [:edit, :update, :destroy]
	before_action :team_session
	# GET /settings
	# GET /settings.json
	def index
		@settings = current_user.admin? ? Setting.all : [current_user.setting]
		redirect_to new_setting_url unless @settings.any?
	end

	# GET /settings/1
	# GET /settings/1.json
	def show
	end

	# GET /settings/new
	def new
		@setting = Setting.new
		flash.discard
		flash[:default] = Vortrics.config[:messages][:first_steps].html_safe
	end

	# GET /settings/1/edit
	def edit
	end

	# POST /settings
	# POST /settings.json
	def create
		@setting = Setting.new(setting_params)
		unless setting_params[:key_data].blank?
			@setting.key_file = setting_params[:key_data].original_filename
			@setting.key_data = setting_params[:key_data].tempfile.read
		end
		respond_to do |format|
			if @setting.save
				current_user.save_dependent(@setting.id) if current_user.guest?
				Workflow.create_by_setting(@setting.id)
				format.html { redirect_to root_url }
				format.json { render :show, status: :created, location: @setting }
			else
				format.html { render :new }
				format.json { render json: @setting.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /settings/1
	# PATCH/PUT /settings/1.json
	def update
		respond_to do |format|
			unless setting_params[:key_data].blank?
				@setting.key_file = setting_params[:key_data].original_filename
			end
			if @setting.update(setting_params)
				unless setting_params[:key_data].blank?
					@setting.key_data = setting_params[:key_data].tempfile.read
					@setting.save
				end
				format.html { redirect_to settings_url, notice: 'Setting was successfully updated.' }
				format.json { render :show, status: :ok, location: @setting }
			else
				format.html { render :edit }
				format.json { render json: @setting.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /settings/1
	# DELETE /settings/1.json
	def destroy
		@setting.destroy
		respond_to do |format|
			format.html { redirect_to settings_url, notice: 'Setting was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private

	# Use callbacks to share common setup or constraints between actions.
	def set_setting
		@setting = Setting.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def setting_params
		params.require(:setting).permit(:name, :site, :base_path, :debug, :signature_method, :key_file, :key_data, :consumer_key, :oauth, :login, :password)
	end
end
