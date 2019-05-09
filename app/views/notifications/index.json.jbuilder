json.array! @notifications do |notification|
  json.id notification.id
  json.actor do
    json.avatar notification.actor.avatar
    json.name notification.actor.displayName
  end
  json.action notification.action
  json.notifiable do
    json.type "a #{notification.notifiable.class.to_s.underscore.humanize.downcase}"
  end
  json.advice do
    json.title "on #{notification.notifiable.advice.advice_type.underscore.humanize}"
  end
  json.url comment_path(notification.notifiable.advice)
end