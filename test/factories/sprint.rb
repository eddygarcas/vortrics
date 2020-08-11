FactoryBot.define do
  factory :sprint do
    name { Faker::FunnyName.name}
    stories { Faker::Number.between}
    bugs { Faker::Number.between}
    closed_points {Faker::Number.between}
    remaining_points { Faker::Number.between}
    team_id { FactoryBot.create(:team).id }
    start_date { Faker::Date.backward}
    enddate {Faker::Date.forward(days: 23)}
  end
end
