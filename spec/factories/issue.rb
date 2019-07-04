FactoryBot.define do
  factory :issue do
    id {Faker::Number.between(1,5000)}
  end
end
