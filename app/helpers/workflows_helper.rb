module WorkflowsHelper

	def workflow_tag statusArray, type = :default
		result = ""
		statusArray.split(',').each do |elem|
			result += content_tag(:span, elem.to_s.upcase, class: "label label-#{type}", style: "font-size:14px;") << content_tag(:br)
		end
		result.html_safe
	end
end
