module UsersHelper

  def provider_icon p, secondary = nil
    link_to root_url, class: "btn btn-social-icon btn-md btn-#{secondary.presence || p.provider.downcase}",data: { title: p.provider.humanize, toggle: :tooltip } do |url|
      content_tag :i, "", class: "fa fa-#{p.provider.downcase}"
    end
  end

end
