class JiraSessionsController < ApplicationController
  before_action :get_jira_client

  def new
    request_token = @jira_client.request_token(oauth_callback: callback_url)
    session[:request_token] = request_token.token
    session[:request_secret] = request_token.secret

    redirect_to request_token.authorize_url
  end

  def authorize
    request_token = @jira_client.set_request_token(
        session[:request_token], session[:request_secret]
    )

    access_token = @jira_client.init_access_token(
        :oauth_verifier => params[:oauth_verifier]
    )

    session[:jira_auth] = {
        :access_token => access_token.token,
        :access_key => access_token.secret
    }

    session.delete(:request_token)
    session.delete(:request_secret)

    redirect_to root_url
  end

  def destroy
    session.data.delete(:jira_auth)
  end

  private

  def get_jira_client
    return if current_user&.setting.blank?
    @jira_client = Jira::Client.instance
    update_jira_tokens
    flash[:danger] = Vortrics.config[:messages][:external_service_error] if @jira_client.nil?
  end

  def update_jira_tokens
    service = Service.where(provider: :jira, user_id: current_user.id).first
    if (service.present?)
      service.update(
          access_token: session[:jira_auth]['access_token'],
          access_token_secret: session[:jira_auth]['access_key']
      ) if session[:jira_auth].present?
    else
      current_user.services.create!(provider: :jira)
    end
  end

end
