class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    service = Service.where(provider: auth.provider, uid: auth.uid).first

    if (service.present?)
      user = service.user
    else
      user = User.create(
          email: auth.info.email,
          avatar: auth.info.image,
          name: auth.info.name,
          displayName: auth.info.name,
          password: Devise.friendly_token[0, 20]
      )

      user.services.create(
          provider: auth.provider,
          uid: auth.uid,
          expires_at: Time.at(auth.credentials.expires_at),
          access_token: auth.credentials.token
      )

    end
    sign_in_and_redirect user, event: :authentication

  end

  def auth
    request.env['omniauth.auth']
  end
end

