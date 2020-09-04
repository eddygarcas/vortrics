module Connect
  def self.included(base)
    base.include Trelo
    base.include Jira
  end

  def self.client(_class, _setting = nil)
    case _setting&.provider.presence || _class&.current_user&.setting&.provider
    when 'trello'
      Trelo::Client.new(_class)
    else
      Jira::Client.new(_class, _setting)
    end
  end

  def profile(user)
    return if user.setting.blank?
    usr = Connect.client(self, user.setting).instance.User.singular_path(user.extuser)
    yield JSON.parse(Connect.client(self, user.setting).instance.get(usr).body)
  end

  def projects
    Rails.cache.fetch("#{__method__}_#{current_user&.setting&.site}", expires_in: 7.day) {
      Connect.client(self).projects
    }
  end

  def fields(args)
    Rails.cache.fetch("#{__method__}_#{args.to_s}", expires_in: 7.day) {
      Connect.client(self).fields(args)
    }
  end

  def project_details(args)
    Rails.cache.fetch("#{__method__}_#{args.to_s}", expires_in: 7.day) {
      Connect.client(self).project_details(args)
    }
  end

  def scrum(args)
    Rails.cache.fetch("#{__method__}_#{args.to_s}", expires_in: 1.hour) {
      Connect.client(self).scrum(args)
    }
  end

  def kanban(args)
    Rails.cache.fetch("#{__method__}_#{args.to_s}", expires_in: 1.hour) {
      Connect.client(self).kanban(args)
    }
  end

  def boards_by_project(args)
    Rails.cache.fetch("#{__method__}_#{args.to_s}", expires_in: 7.day) {
      Connect.client(self).boards_by_project(args)
    }
  end

  def boards_by_sprint(args)
    Rails.cache.fetch("#{__method__}_#{args.to_s}", expires_in: 1.day) {
      Connect.client(self).boards_by_sprint(args)
    }
  end

  def sprint_report(args)
    Rails.cache.fetch("#{__method__}_#{args.to_s}", expires_in: 1.day) {
      Connect.client(self).sprint_report(args)
    }
  end

  def issue_by_project(args)
    Rails.cache.fetch("#{__method__}_#{args.to_s}", expires_in: 1.hour) {
      Connect.client(self).issue_by_project(args)
    }
  end

  def issue_attachments(args)
    Connect.client(self).issue_attachments(args)
  end

  def issue_comments(args)
    Rails.cache.fetch("#{__method__}_#{args.to_s}", expires_in: 1.day) {
      Connect.client(self).issue_comments(args)
    }
  end

  def bugs_first_comments(args)
    Connect.client(self).bugs_first_comments(args)
  end

  def bugs_by_board(args)
    Rails.cache.fetch("#{__method__}_#{args.to_s}", expires_in: 1.day) {
      Connect.client(self).bugs_by_board(args)
    }
  end

end
