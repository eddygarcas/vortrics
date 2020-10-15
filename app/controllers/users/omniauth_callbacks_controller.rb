class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  rescue_from ActiveRecord::RecordInvalid, with: :render_omniauth_error

  def github
    service = Service.where(provider: auth.provider, uid: auth.uid).first

    if (service.present?)
      user = service.user
    else
      user = User.create!(
          email: auth.info.email,
          avatar: auth.info.image,
          name: auth.info.name,
          displayName: auth.info.nickname,
          password: Devise.friendly_token[0, 20]
      )

      user.services.create!(
          provider: auth.provider,
          uid: auth.uid,
          access_token: auth.credentials.token
      )
    end
    sign_in_and_redirect user, event: :authentication
  end

  private

  def render_omniauth_error ex
    set_flash_message(:error, :already_authenticated, kind: :github.to_s.humanize)
    redirect_to after_omniauth_failure_path_for(resource_name)
  end

  def auth
    request.env['omniauth.auth']
  end
end

