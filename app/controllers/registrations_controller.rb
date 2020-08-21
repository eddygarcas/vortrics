class RegistrationsController < Devise::RegistrationsController

  # Overwrite update_resource to let users to update their user without giving their password
  def update_resource(resource, params)
    if current_user&.services&.present?
      params.delete("current_password")
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

  def destroy
    Setting.find(current_user.setting.id).destroy unless current_user.setting.blank?
    super
  end


  private
  def sign_up_params
    params.require(:user).permit(:avatar, :displayName, :email, :password, :password_confirmation)
  end

  def account_update_params
     params.require(:user).permit(:avatar, :displayName,:extuser, :email, :password, :password_confirmation, :current_password)
  end

end
