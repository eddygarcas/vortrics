json.array! @notifications do |notification|
  json.id notification.id
  json.actor do
    json.avatar notification.actor.avatar
    json.name notification.actor.displayName
  end
  json.action notification.action
  json.notifiable do
    json.type "a #{notification.notifiable_type.to_s.underscore.humanize.downcase}"
  end
  json.advice do
    if notification.notifiable.advice.present?
      json.title "on #{notification.notifiable.advice.advice_type.underscore.humanize}"
    else
      json.title "on Retrospective"
    end
  end
  json.url comment_path(notification.notifiable.advice) if notification.notifiable.advice.present?
  json.url retrospectives_path unless notification.notifiable.advice.present?

end