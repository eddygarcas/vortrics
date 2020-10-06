module Connect
  class MethodNotFoundError < StandardError
    attr_reader :method,:arguments
    def initialize(method = nil, arguments = nil)
      @method = method
      @arguments = arguments
    end
  end

  def self.included(base)
    base.include Trelo
    base.include Jira
  end

  def self.setting
    Thread.current[:user]&.setting
  end

  def self.client(_class)
    case setting&.service&.provider
    when :trello.to_s
      Trelo::Client.new(_class)
    else
      Jira::Client.new(_class)
    end
  end

  def service_method(method, *args)
    begin
      Rails.cache.fetch("#{__method__}_#{current_user&.displayName}_#{method}_#{args[0].to_s unless args.blank?}", expires_in: 1.day) {
        Connect.client(self).send(method) {args[0] unless args.blank?}
      }
    rescue IOError
      Connect.client(self).send(method) {args[0] unless args.blank?}
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