FactoryBot.define do
  factory :workflow do
    name { Faker::Name.name}
    position {Faker::Number.between(1,10)}
    setting
  end

end
