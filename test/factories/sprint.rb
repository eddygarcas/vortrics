FactoryBot.define do
  factory :sprint do
    name { Faker::FunnyName.name}
    stories { Faker::Number.between(1,30)}
    bugs { Faker::Number.between(1,10)}
    closed_points {Faker::Number.between(1,100)}
    remaining_points { Faker::Number.between(1,20)}
    team_id { FactoryBot.create(:team).id }
    start_date { Faker::Date.backward(10)}
  end
end
