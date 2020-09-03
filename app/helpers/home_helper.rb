module HomeHelper

  def vt_dynamic_link fullpath, id = nil
    link = Rails.application.routes.recognize_path(fullpath)
    link[:id] = id
    return link if link[:controller].eql? 'teams'
    get_dashboard_path(id)
  end

  def puts_non_nill element, method
    element.respond_to?(method) ? element.send(method) : 'n/d'
  end

  def puts_no_defined element = nil
    element.blank? ? 'n/d' : element
  end

  def navbar_visible?
	  return false if @team.blank?
    return (@team.id.present? && projects.present?)
  end
end