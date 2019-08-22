FactoryBot.define do
  factory :postit do
    text { Faker::Name.female_first_name }
    position { Faker::Number.between }
    dots { Faker::Number.between }
    comments { Faker::Number.between }
    retrospective { FactoryBot.create(:retrospective) }
    user {FactoryBot.create(:user)}
  end
end
