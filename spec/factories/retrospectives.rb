FactoryBot.define do
  factory :retrospective do
    id {Faker::Number.between(from: 1, to:50000)}
    name { Faker::FunnyName.name }
    position { Faker::Number.between }
    team { FactoryBot.create(:team) }
  end
end
