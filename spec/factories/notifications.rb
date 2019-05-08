FactoryBot.define do
  factory :notification do
    recipient_id { 1 }
    actor_id { 1 }
    read_at { "2019-05-08 21:47:30" }
    notifiable_id { 1 }
    notifiable_type { "MyString" }
  end
end
