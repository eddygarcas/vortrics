FactoryBot.define do
  factory :team_advice do
    advice {FactoryBot.create(:advice)}
    team {FactoryBot.create(:team)}
  end
end
