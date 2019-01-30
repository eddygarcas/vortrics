json.array! @users do |user|
	json.id user.id
	json.displayName user.displayName
	json.group_id user.group
end
