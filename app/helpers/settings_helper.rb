module SettingsHelper
	include JiraHelper

	def jira_field_list project
		field_list(project).invert
	end
end
