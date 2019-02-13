module UsersHelper

	def humanize_site setting
		return "No connection defined" if setting.blank?
		"#{setting.site}#{setting.context} #{(setting.oauth? ? :oauth : :basic).to_s.humanize}"
	end

end
