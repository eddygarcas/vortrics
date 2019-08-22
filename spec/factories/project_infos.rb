FactoryBot.define do
  factory :project_info do
    key { Faker::Alphanumeric.alpha }
    name { Faker::Name.suffix }
    icon { Faker::Avatar.image }
  end
end
