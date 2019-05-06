FactoryBot.define do
  factory :team do
    id { Faker::Number.between(1,5000)}
    name {Faker::Name::first_name_men}
    project { "MTR"}
    board_id { Faker::Number.between(1,9999)}
    avatar { ""}
    estimated { "Story Points"}
    project_info {FactoryBot.create(:project_info)}
  end

  factory :team_with_advice, parent: :advice do
    ignore do
      advice {FactoryBot.create(:advice)}
    end
    after_create do |team,evaluator|
      team.advices << evaluator.advice
    end
  end
end
