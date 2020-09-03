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
    session[:trello] = {:oauth_token => access_token.token, :oauth_token_secret => access_token.secret}
    sign_in_and_redirect trello, event: :authentication
  end

  private

  def trello

    data = Trelo::Client.new(self).find(:token, session[:trello][:oauth_token], :member)
    service = Service.where(provider: :trello, uid: data.aaId).first

    if (service.present?)
      user = service.user
    else
      user = User.create!(
          email: data.aaEmail,
          avatar: data.avatarUrl,
          name: data.fullName,
          displayName: data.username,
          password: Devise.friendly_token[0, 20]
      )
      user.services.create!(
          provider: :trello,
          uid: data.aaId,
          access_token: session[:trello][:oauth_token],
          access_token_secret: session[:trello][:oauth_token_secret]
      )
      setting = Setting.create!(
          name: data.fullName,
          consumer_key: data.aaId,
          tokenized: true,
          provider: :trello.to_s,
          site: "https://trello.com",
          debug: true,
          signature_method: Trelo::Client.omniauth.options[:signature_method],
          oauth: false
      )
      Workflow.create_by_setting(setting.id)
      user.save_dependent setting.id,false
      user
    end
  end
end
