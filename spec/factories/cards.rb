FactoryBot.define do
  factory :card do
    id {Faker::Number.between}
    workflow
    name { Faker::FunnyName.name }
    position { Faker::Number.between }
  end
end
