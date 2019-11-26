module UsersHelper

  def humanize_site setting
    return "No connection defined" if setting.blank?
    "#{setting.site}#{setting.context} #{(setting.oauth? ? :oauth : :basic).to_s.humanize}"
  end

  def provider_icon p
    link_to root_url, class: "btn btn-social-icon btn-md btn-#{p.provider}" do |url|
      content_tag :i, "", class: "fa fa-#{p.provider}-square"
    end
  end

end
