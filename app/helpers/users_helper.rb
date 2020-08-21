module UsersHelper

  def provider_icon p
    link_to root_url, class: "btn btn-social-icon btn-md btn-#{p.provider.downcase}" do |url|
      content_tag :i, "", class: "fa fa-#{p.provider.downcase}-square"
    end
  end

end
