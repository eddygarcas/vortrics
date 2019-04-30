FactoryBot.define do
  factory :advice do
    subject { "MyString" }
    description { "MyString" }
    read { false }
    completed { false }
    type { "" }
  end
end
