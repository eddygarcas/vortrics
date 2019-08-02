FactoryBot.define do
  factory :retrospective do
    name { Faker::FunnyName.name }
    position { Faker::Number.between(1,200) }
    team { FactoryBot.create(:team) }
  end
end
