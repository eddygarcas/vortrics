FactoryBot.define do
  factory :team do
    id { Faker::Number.between}
    name {Faker::Name::first_name_men}
    project {"MTR"}
    board_id {Faker::Number.between.to_s}
    board_type {"scrum"}
    avatar {""}
    estimated {"Story Points"}
    project_info {FactoryBot.create(:project_info)}
  end

  factory :team_with_advice, parent: :team do
    transient  do
      advice {FactoryBot.create(:advice)}
    end
    after(:create) do |team,evaluator|
      team.advices << evaluator.advice
    end
  end

  factory :team_with_sprint, parent: :team do
    transient  do
      sprint {FactoryBot.create(:sprint)}
    end
    after(:create) do |team,evaluator|
      team.sprints << evaluator.sprint
    end
  end

end
