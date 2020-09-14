require_relative 'logic'
module ApplicationHelper
	include EmailTemplateHelper
	include JiraIssueHelper
	include Connect

	def app_name
		Vortrics.config['name']
	end

	def vt_jira_issue_fields
		Vortrics.config[:jira][:fields] << ",#{@team.estimated}"
	end

	def vt_project_icon style = "img-circle profile-image"
		image_tag @team&.project_info&.icon.presence || "/images/voardtrix_logo.png", class: style, height: '30', width: '30'
	end

	def vt_project_name
		return Vortrics.config['name'].humanize if (@team&.project_info.blank?)
		@team.project_info&.name&.humanize
	end

	def vt_items_text_tag
		return if @team.sprint.blank?
		content_tag(:strong, @team&.sprint&.issues&.count.to_s) <<
				" Items and " <<
				content_tag(:strong, @team&.sprint&.sprint_commitment.to_s) <<
				" Story points"
	end

	def vt_issue_status_tag key, status = ''
		class_options = {
				new: "label label-primary",
				indeterminate: "label label-info",
				done: "label label-success",
				closed: "label label-danger",
				active: "label label-success",
				future: "label label-primary"
		}
		content_tag(:span, status, class: class_options[key.to_sym])
	end

	def vt_trend_tag value = 0, target = 0, icon = :chevon
		class_options = {
				possitive: { p: "text-success", i: "fa fa-chevron-up" },
				negative: { p: "text-red-500", i: "fa fa-chevron-down" },
				success: { p: "text-success", i: "fa fa-thumbs-up" },
				failure: { p: "text-red-500", i: "fa fa-thumbs-down" },
		}
		options = value >= target ? (icon.eql?(:chevon) ? class_options[:possitive] : class_options[:success]) : (icon.eql?(:chevon) ? class_options[:negative] : class_options[:failure])

		content_tag(:p, content_tag(:i, nil, class: options[:i]) << ' ' << value.abs.floor.to_s << '%', class: options[:p])
	end

	def board(team)
		service_method(:boards_by_project,keyorid: team.project_info.key,board: team&.board_id)
	end

	def days_remain(enddate = Time.now.to_datetime)
		(Time.now.to_datetime..enddate).map { |day| (day.sunday?.to_i + day.saturday?.to_i)}.inject(&:+).presence || 0
	end

	def percent(value, total)
		begin
			(((value.to_f - total.to_f) / total.to_f) * 100).round
		rescue FloatDomainError
			return 0
		end
	end

	def percent_num(value, total)
		begin
			(((value.to_f) / total.to_f) * 100).round
		rescue ZeroDivisionError
			return 0
		end
	end

	def summary_trend(value = 0, text = '', percent = true)
		class_options = {
				possitive: { i: "fa fa-caret-up" },
				negative: { i: "fa fa-caret-down" },
				minus: { i: "fa fa-minus" },
				plus: { i: "fa fa-plus" }
		}
		options = value > 0 ? (percent ? class_options[:possitive] : class_options[:plus]) : (percent ? class_options[:negative] : class_options[:minus])

		i_neg_col = "color:#D13B47"
		i_pos_col = "color:#17D111"

		neg_col = " <strong style='color:#D13B47'>"
		pos_col = " <strong style='color:#17D111'>"

		col = value > 0 ? pos_col : neg_col
		i_col = value > 0 ? i_pos_col : i_neg_col

		content_tag(:i, nil, class: options[:i], style: i_col) <<
				col.html_safe <<
				value.abs.floor.to_s <<
				(percent ? '%' : '') <<
				"</strong>".html_safe <<
				text
	end

	def vt_work_time_tag(key, title = '', txt = 'n/d')
		content_tag(:i, nil, class: "fa fa-trophy", style: "color:goldenrod;font-size: 14px;") <<
				title <<
				" shortest " <<
				content_tag(:strong, key) <<
				' ' <<
				text
	end

	def vt_project_tag(project)
		elem = ""
		issue = IssueBuilder.new(service_method(:issue_by_project,key: project, options: { fields: [:project], maxResults: 1 }).first)
		project_name = issue&.fields&.project.blank? ? 'n/d' : issue.fields.project.name
		project_icon = issue&.fields&.project.blank? ? '' : issue.fields.project.avatarUrls._32x32
		elem << image_tag(project_icon.to_s, class: "img-circle profile-image", height: '30', width: '30')
		elem << " #{project_name.to_s}" unless project_name.blank?
		elem.html_safe
	end

	def tmf_badge(size, css_class)
		image_tag @team.project_info.icon, class: css_class, width: size, height: size
	end

	def tmf_elem(team, type = 'name')
		yield team[type.to_sym] unless team.nil?
	end

	def tmf_stars(num, tag = :i, name = 'star')
		elem = ""
		num.times do
			elem << content_tag(tag, nil, class: "fa fa-#{name}", style: "color:goldenrod;font-size: 20px;")
		end
		elem << content_tag(tag, nil, class: "fa fa-#{name}", style: "color:#888888;font-size: 20px;") if num.zero?
		elem.html_safe
	end

	def link_to_ext(key, name = fa_icon_tag("eye"))
		link_to name, "#{current_user.setting.site}/browse/#{key}", rel: 'tooltip', title: 'Show', target: :_blank
	end

end
