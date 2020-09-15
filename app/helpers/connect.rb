module Connect
  class MethodNotFoundError < StandardError; end
  def self.included(base)
    base.include Trelo
    base.include Jira
  end

  def self.client(_class, _setting = nil)
    case _setting&.service&.provider.presence || _class&.current_user&.setting&.service&.provider
    when :trello.to_s
      Trelo::Client.new(_class)
    else
      Jira::Client.new(_class, _setting)
    end
  end

  def service_method(method,*args)
    begin
      #Rails.cache.fetch("#{__method__}_#{current_user&.displayName}_#{method}_#{args[0].to_s unless args.blank?}", expires_in: 1.day) {
        Connect.client(self).send(method) { args[0] unless args.blank? }
      #}
    rescue IOError
      Connect.client(self).send(method) { args[0] unless args.blank? }
    end
  end
end