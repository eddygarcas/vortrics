require 'trello'
module Trelo

  class Client
    @instance

    attr_reader :instance

    def initialize(user, token = nil, secret = nil)
      @instance = Trello::Client.new(
          :consumer_key => Rails.application.secrets.trello_consumer_key,
          :consumer_secret => Rails.application.secrets.trello_consumer_secret,
          :oauth_token => token.presence || user&.services.find_by_provider(:trello).access_token,
          :oauth_token_secret => secret.presence || user&.services.find_by_provider(:trello).access_token_secret
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
      cards = JSON.parse(@instance.get("/boards/#{args[:boardId]}/cards?fields=all", {}))
      #GET /1/cards/{id}/actions
      # JSON.parse(@instance.get("/cards/#{cards.last["id"]}/actions",{filter: :createCard}))
      cards.map do |v|
        v.merge!({log: JSON.parse(@instance.get("/cards/#{v["id"]}/actions", {filter: "commentCard,updateCard:idList,createCard"})) || ""})
            .merge!({status: JSON.parse(@instance.get("/lists/#{v["idList"]}?fields=name")) || {"name" => "open"}})
      end
    end

    def issue_comments
      JSON.parse(@instance.get("/cards/#{yield}/actions", {filter: "commentCard"})).map do |elem|
        {
            "author" => {
                "displayName" => elem&.dig("memberCreator", "fullName"),
                "avatarUrls" => {
                    "48x48" => "#{elem&.dig("memberCreator", "avatarUrl")}/50.png"
                }
            },
            "created" => elem&.dig("date"),
            "body" => elem&.dig("data", "text")
        }
      end
    end

    def issue_attachments
      attachm = JSON.parse(@instance.get("/cards/#{yield}/attachments", {})).map do |elem|
        {
            "author" => {
                "displayName" => elem&.dig("idMember"),
                "avatarUrls" => {
                    "48x48" => "/images/vortrics_icon.svg",
                }
            },
            "created" => elem&.dig("date"),
            "mimeType" => elem&.dig("mimeType") || "image/png",
            "thumbnail" => elem&.dig("previews")&.first&.dig("url"),
            "content" => elem&.dig("url"),
        }
      end
      pp attachm.last
      attachm
    end


    def find(path, id, type = nil, params = {})
      Connect::Response.new(JSON.parse(@instance.get("/#{path.to_s.pluralize}/#{id}/#{type}", params)))
    end

    def projects
      JSON.parse(@instance.get("/members/#{yield[:user]}/organizations", {})).map do |v|
        Connect::Response.new({key: v["id"], name: v["displayName"]})
      end
    end

    def project_details
      resp = JSON.parse(@instance.get("/organizations/#{yield[:key]}", {}))
      Connect::Response.new({key: resp["id"], name: resp["displayName"], icon: resp["logoUrl"]})
    end

    def boards_by_project
      args = yield
      resp = JSON.parse(@instance.get("/organizations/#{args[:keyorid]}/boards", {}))
      args[:board].present? ? resp.find { |board| board['id'].to_s.eql? args[:board] }['name'] : resp
    end

    def bugs_by_board
      []
    end

    def fields
      JSON.parse(@instance.get("/boards/#{yield[:boardid]}/customFields"))&.map { |c| Trelo::Response.new(c) }
    end

    def lists
      Connect::Response.new(JSON.parse(@instance.get("/lists/#{yield[:id]}?fields=name")))
    end

    def members
      Connect::Response.new(JSON.parse(@instance.get("/members/#{yield[:id]}")))
    end


    def method_missing(name, *args)
      raise Connect::MethodNotFoundError.new(name, args)
    end

  end
end
