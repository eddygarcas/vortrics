module SettingsHelper
	include JiraActions

	def jira_field_list project
		field_list(project).invert
	end
end
