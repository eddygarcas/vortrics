module KanbanHelper
  def set_trello_issues issues
    issues.each do |el|
      ass = service_method(:members, id: el&.idMembers&.first)&.fullName unless el&.idMembers.empty?
      el.assignee = ass&.fullName
      el.assigneeavatar = ass&.avatarUrl
      el.statusname = service_method(:lists, id: el&.idList)&.name
    end unless current_user&.registered?
  end
end
