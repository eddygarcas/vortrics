require 'digest'
module Connect
  def self.included(base)
    base.include Trelo
    base.include Jira
  end

  class MethodNotFoundError < StandardError
    attr_reader :method,:arguments
    def initialize(method = nil, arguments = nil)
      @method = method
      @arguments = arguments
    end
  end

  class Response
    include Binky::Builder
  end

  class Hashcode
    def self.generate(*args)
       Digest::MD5.hexdigest args.to_s
    end
  end

  def self.setting
    Thread.current[:user]&.setting
  end

  def self.client
    case setting&.service&.provider
    when :trello.to_s
      Trelo::Client.new
    else
      Jira::Client.new
    end
  end

  def service_method(method, *args)
    pp "Method: #{method} Arguments #{args}"
    begin
      Rails.cache.fetch(Hashcode.generate(method,current_user&.displayName,args), expires_in: 1.day) {
        Connect.client.send(method) {args[0] unless args.blank?}
      }
    rescue IOError
      Connect.client.send(method) {args[0] unless args.blank?}
    end
  end

  class Issue
    include Binky::Struct

    def initialize(*args)
      super args[0]
      @estimation_field = args[1].presence || ""
      eigenclass(Connect.setting&.service&.provider.presence || :jira)
    end

    private

    def eigenclass provider = :jira
      singleton_class = class << self; self; end;
      singleton_class.send(:include, Object.const_get("#{provider.to_s.humanize}Issue"))
    end
  end
end