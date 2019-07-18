FactoryBot.define do
  factory :card do
    id {Faker::Number.between(1,10)}
    workflow
    name { Faker::FunnyName.name }
    position { Faker::Number.between(1,10) }
  end
end
