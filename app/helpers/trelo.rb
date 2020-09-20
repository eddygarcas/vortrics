require 'trello'
module Trelo

  class Response
    include Binky::Builder
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
          :oauth_token => _class.session[:trello.to_s][:oauth_token.to_s],
          :oauth_token_secret => _class.session[:trello.to_s][:oauth_token_secret.to_s]
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

    def kanban
      args = yield
      JSON.parse(@instance.get("/boards/#{args[:boardId]}/cards",{}))
    end

    def find(path, id, type = nil, params = {})
      Trelo::Response.new(JSON.parse(@instance.get("/#{path.to_s.pluralize}/#{id}/#{type}", params)))
    end

    def projects
      JSON.parse(@instance.get("/members/#{yield[:user]}/organizations",{})).map do |v|
        Trelo::Response.new({key: v["id"], name: v["displayName"]})
      end
    end

    def project_details
      resp = JSON.parse(@instance.get("/organizations/#{yield[:key]}",{}))
      Trelo::Response.new({key: resp["id"], name: resp["displayName"],icon: resp["logoUrl"]})
    end


    def boards_by_project
      args = yield
      resp = JSON.parse(@instance.get("/organizations/#{args[:keyorid]}/boards",{}))
      args[:board].present? ? resp.find{|board| board['id'].to_s.eql? args[:board]}['name'] : resp
    end

    def fields
      JSON.parse(@instance.get("/boards/#{yield[:boardid]}/customFields"))&.map {|c| Trelo::Response.new(c)}
    end

    def method_missing(name, *args)
      raise Connect::MethodNotFoundError
    end

  end
end
