module SprintsHelper
	def sort_link(column, title = nil, param = {})
		title ||= column.titleize
		direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
		icon = sort_direction == "asc" ? "glyphicon glyphicon-chevron-up" : "glyphicon glyphicon-chevron-down"
		icon = column == sort_column ? icon : ""
		link_to "<span class='fa fa-fw fa-sort'> </span> #{title} <span class='#{icon}'></span>".html_safe, param.merge({ column: column, direction: direction })
	end

	def formatDate dateAsString
		return 'n/d' if dateAsString.blank?
		Date.parse(dateAsString).strftime('%A, %d/%b/%Y')
	end

	def tag_info_table value, color = :black, type = :default
		typehash = { default: '', percent: '%', hours: 'h', days: 'Days', bugs: 'Bugs', items: 'Items' }
		content_tag(:span, content_tag(:strong, "#{value} ") << typehash[type], class: "strong", style: "color: #{color}")
	end

end
