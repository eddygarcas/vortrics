FactoryBot.define do
  factory :postit do

    id { Faker::Number.between(from: 1, to: 50000)}
    text { Faker::Name.female_first_name }
    position { Faker::Number.between }
    dots { Faker::Number.between }
    description {Faker::Name.first_name_men}
    retrospective { FactoryBot.create(:retrospective) }
    user {FactoryBot.create(:user)}
  end

end
