module HomeHelper

  def vt_dynamic_link fullpath, id = nil
    link = Rails.application.routes.recognize_path(fullpath)
    link[:id] = id
    return link if link[:controller].eql? 'teams'
    get_dashboard_path(id)
  end

  def start_date_validation team
    return 'n/d' if team.blank? || team.sprint.blank? || team.sprint.start_date.blank?
    team.sprint.start_date.strftime("%d/%m/%y")
  end

  def teams_to_be_updated
    Team.where('updated_at < ?', Time.now.strftime("%Y-%m-%d")).count
  end

  def puts_non_nill element, method
    return element.public_send(method) if element.respond_to? method
    "n/d"
  end

  def puts_no_defined element = nil
    element.blank? ? 'n/d' : element
  end

  def navbar_visible?
	  return false if @team.blank?
    return (@team.id.present? && project_list.present?)
  end
end