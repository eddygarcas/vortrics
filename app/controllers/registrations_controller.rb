class RegistrationsController < Devise::RegistrationsController

  def destroy
    Setting.find(current_user.setting.id).destroy unless current_user.setting.blank?
    super
  end


  private
  def sign_up_params
    params.require(:user).permit(:avatar, :displayName, :email, :password, :password_confirmation)
  end

  def account_update_params
     return params.require(:user).permit(:avatar, :displayName,:extuser, :email) unless current_user&.services&.blank?
     params.require(:user).permit(:avatar, :displayName,:extuser, :email, :password, :password_confirmation, :current_password) unless current_user&.services&.present?
  end

end
