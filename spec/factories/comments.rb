FactoryBot.define do
  factory :comment do
    advice_id { FactoryBot.create(:advice).id}
    actor_id { FactoryBot.create(:user).id}
    description { Faker::FamousLastWords.last_words }
  end
end
