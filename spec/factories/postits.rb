FactoryBot.define do
  factory :postit do
    text { Faker::Name.female_first_name }
    position { Faker::Number.between(1,200) }
    dots { Faker::Number.between(1,4) }
    comments { Faker::Number.between(1,4) }
    retrospective { FactoryBot.create(:retrospective) }
    user {FactoryBot.create(:user)}
  end
end
