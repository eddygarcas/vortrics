require 'trello'
module Trelo
  class Builder
    include Binky::Struct
  end

  class Client
    @instance

    attr_reader :instance

    def initialize(_class)
      @instance = self.class.instance(_class)
    end

    def self.instance(_class)
      @instance = Trello::Client.new(
          :consumer_key => Rails.application.secrets.trello_consumer_key,
          :consumer_secret => Rails.application.secrets.trello_consumer_secret,
          :oauth_token => _class.session[:trello][:oauth_token],
          :oauth_token_secret => _class.session[:trello][:oauth_token_secret]
      )
    end

    def self.omniauth
      OAuth::Consumer.new(
          Rails.application.secrets.trello_consumer_key,
          Rails.application.secrets.trello_consumer_secret,
          {
              :site => "https://trello.com",
              :http_method => :get,
              :debug_output => false,
              :request_token_path => "/1/OAuthGetRequestToken",
              :access_token_path => "/1/OAuthGetAccessToken",
              :authorize_path => "/1/OAuthAuthorizeToken"
          })
    end

    def find(path, id, type = nil, params = {})
      Builder.new(JSON.parse(@instance.get("/#{path.to_s.pluralize}/#{id}/#{type}", params)))
    end
  end
end
