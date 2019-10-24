FactoryBot.define do
  factory :retrospective do
    name { Faker::FunnyName.name }
    position { Faker::Number.between }
    team { FactoryBot.create(:team) }
  end
end
