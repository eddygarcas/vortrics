class TrelloSessionsController < ApplicationController
  include Connect

  before_action :authenticate_user!, except: [:new, :authorize]

  def new
    request_token = Trelo::Client.omniauth.get_request_token(:oauth_callback => oauth_authorize_url)
    session[:token] = request_token.token
    session[:token_secret] = request_token.secret
    redirect_to request_token.authorize_url(:scope => [:read, :account], :name => "Vortrics")
  end

  def authorize
    access_token = Trelo::Client.omniauth.get_request_token.get_access_token(oauth_verifier: params[:oauth_verifier])
    session[:trello] = {:oauth_token.to_s => access_token.token, :oauth_token_secret.to_s => access_token.secret}
    sign_in_and_redirect trello, event: :authentication
  end

  private

  def trello
    data = Trelo::Client.new(
        session[:trello][:oauth_token.to_s],
        session[:trello][:oauth_token_secret.to_s]
    ).find(:token, session[:trello][:oauth_token.to_s], :member)
    service = Service.where(provider: :trello, uid: data.aaId).first

    if (service.present?)
      user = service.user
      service.update(access_token: session[:trello][:oauth_token.to_s],access_token_secret: session[:trello][:oauth_token_secret.to_s])
    else
      user = User.create!(
          email: data.aaEmail,
          avatar: "https://www.gravatar.com/avatar/#{data.gravatarHash}.jpg",
          name: data.fullName,
          displayName: data.username,
          password: Devise.friendly_token[0, 20]
      )
      setting = Setting.new(
          name: data.fullName,
          consumer_key: data.aaId,
          site: "https://trello.com",
          debug: true,
          signature_method: Trelo::Client.omniauth.options[:signature_method],
          oauth: false
      )
      setting.save!(validate: false)
      user.services.create!(
          provider: :trello,
          uid: data.aaId,
          setting_id: setting.id,
          access_token: session[:trello][:oauth_token.to_s],
          access_token_secret: session[:trello][:oauth_token_secret.to_s]
      )

      Workflow.create_by_setting(setting.id)
      user.save_dependent setting.id,false
    end
    user
  end
end
