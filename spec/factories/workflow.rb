FactoryBot.define do
  factory :workflow do
    id {Faker::Number.between}
    name { Faker::Name.name}
    position {Faker::Number.between}
    setting {FactoryBot.create(:setting)}
  end

end
