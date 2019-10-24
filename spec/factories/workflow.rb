FactoryBot.define do
  factory :workflow do
    name { Faker::Name.name}
    position {Faker::Number.between}
    setting
  end

end
