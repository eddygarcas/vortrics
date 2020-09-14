class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

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
      user.save_dependent(Setting.find_by_name("Vortrics").id,false) if Setting.find_by_name("Vortrics").present?
    end
    sign_in_and_redirect user, event: :authentication
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end

