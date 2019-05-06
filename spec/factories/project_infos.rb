FactoryBot.define do
  factory :project_info do
    key { Faker::Alphanumeric.alpha 4 }
    name { Faker::Name.suffix }
    icon { Faker::Avatar.image }
  end
end
