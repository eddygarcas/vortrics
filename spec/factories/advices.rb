FactoryBot.define do
  factory :advice do
    subject {Faker::Dessert.variety }
    description { Faker::Dessert.flavor }
    read { false }
    completed { false }
    advice_type { Faker::Alphanumeric.alphanumeric }
  end
end
